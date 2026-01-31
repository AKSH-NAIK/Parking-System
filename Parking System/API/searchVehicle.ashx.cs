using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.SessionState;

public class searchVehicle : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        if (context.Session["StaffId"] == null)
        {
            context.Response.StatusCode = 401;
            Write(context, false, "Not authenticated", new List<SearchResult>());
            return;
        }

        string query = (context.Request.Form["query"] ?? string.Empty).Trim().ToUpperInvariant();

        try
        {
            var results = new List<SearchResult>();

            if (!string.IsNullOrWhiteSpace(query))
            {
                string connStr = @"Data Source=(localdb)\MSSQLLocalDB;
                                  Initial Catalog=ParkingSystemDB;
                                  Integrated Security=True;
                                  Connect Timeout=30;
                                  Encrypt=False;";

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string sql = @"
                        SELECT TOP 10
                            v.OwnerName,
                            v.PhoneNumber,
                            v.VehicleNumber,
                            v.VehicleType,
                            t.EntryTime,
                            ps.SlotNumber,
                            t.StaffId
                        FROM Transactions t
                        INNER JOIN Vehicles v ON t.VehicleId = v.VehicleId
                        INNER JOIN ParkingSlots ps ON t.SlotId = ps.SlotId
                        WHERE t.ExitTime IS NULL
                          AND v.VehicleNumber LIKE @Query + '%'
                        ORDER BY v.VehicleNumber";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@Query", query);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            results.Add(new SearchResult
                            {
                                OwnerName = reader["OwnerName"].ToString(),
                                PhoneNumber = reader["PhoneNumber"].ToString(),
                                VehicleNumber = reader["VehicleNumber"].ToString(),
                                VehicleType = reader["VehicleType"].ToString(),
                                EntryTime = Convert.ToDateTime(reader["EntryTime"]).ToString("yyyy-MM-dd HH:mm:ss"),
                                SlotNumber = reader["SlotNumber"].ToString(),
                                StaffId = reader["StaffId"]?.ToString()
                            });
                        }
                    }
                }
            }

            Write(context, true, "ok", results);
        }
        catch (Exception ex)
        {
            Write(context, false, "Error: " + ex.Message, new List<SearchResult>());
        }
    }

    private void Write(HttpContext ctx, bool success, string message, List<SearchResult> items)
    {
        var sb = new StringBuilder();
        sb.Append("{\"success\":").Append(success.ToString().ToLower())
          .Append(",\"message\":\"").Append(Escape(message)).Append("\",\"items\":[");

        for (int i = 0; i < items.Count; i++)
        {
            if (i > 0) sb.Append(",");
            var item = items[i];
            sb.Append("{")
              .Append("\"ownerName\":\"").Append(Escape(item.OwnerName)).Append("\",")
              .Append("\"phoneNumber\":\"").Append(Escape(item.PhoneNumber)).Append("\",")
              .Append("\"vehicleNumber\":\"").Append(Escape(item.VehicleNumber)).Append("\",")
              .Append("\"vehicleType\":\"").Append(Escape(item.VehicleType)).Append("\",")
              .Append("\"entryTime\":\"").Append(Escape(item.EntryTime)).Append("\",")
              .Append("\"slotNumber\":\"").Append(Escape(item.SlotNumber)).Append("\",")
              .Append("\"staffId\":\"").Append(Escape(item.StaffId ?? string.Empty)).Append("\"")
              .Append("}");
        }

        sb.Append("]}");
        ctx.Response.Write(sb.ToString());
    }

    private string Escape(string value)
    {
        return (value ?? string.Empty).Replace("\\", "\\\\").Replace("\"", "\\\"");
    }

    private class SearchResult
    {
        public string OwnerName { get; set; }
        public string PhoneNumber { get; set; }
        public string VehicleNumber { get; set; }
        public string VehicleType { get; set; }
        public string EntryTime { get; set; }
        public string SlotNumber { get; set; }
        public string StaffId { get; set; }
    }

    public bool IsReusable
    {
        get { return false; }
    }
}