using System;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;

public class dashboardStats : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        if (context.Session["StaffId"] == null)
        {
            context.Response.StatusCode = 401;
            Write(context, false, "Not authenticated", null);
            return;
        }

        var data = new StatsContainer
        {
            TwoWheeler = new SlotStats(),
            FourWheeler = new SlotStats()
        };

        string connStr = @"Data Source=(localdb)\MSSQLLocalDB;
                          Initial Catalog=ParkingSystemDB;
                          Integrated Security=True;
                          Connect Timeout=30;
                          Encrypt=False;";

        try
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string sql = @"
                    SELECT ps.VehicleType,
                           COUNT(ps.SlotId) AS Total,
                           SUM(CASE WHEN t.SlotId IS NULL THEN 0 ELSE 1 END) AS Occupied
                    FROM ParkingSlots ps
                    LEFT JOIN Transactions t ON t.SlotId = ps.SlotId AND t.ExitTime IS NULL
                    GROUP BY ps.VehicleType";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        string type = NormalizeType(reader["VehicleType"].ToString());
                        int total = Convert.ToInt32(reader["Total"]);
                        int occupied = Convert.ToInt32(reader["Occupied"]);
                        int available = Math.Max(0, total - occupied);

                        var stats = new SlotStats
                        {
                            Total = total,
                            Occupied = occupied,
                            Available = available,
                            OccupiedPercent = total == 0 ? 0 : (int)Math.Round((occupied * 100.0) / total),
                            AvailablePercent = total == 0 ? 0 : (int)Math.Round((available * 100.0) / total)
                        };

                        if (type == "2wheeler")
                        {
                            data.TwoWheeler = stats;
                        }
                        else if (type == "4wheeler")
                        {
                            data.FourWheeler = stats;
                        }
                    }
                }
            }

            Write(context, true, "ok", data);
        }
        catch (Exception ex)
        {
            Write(context, false, "Error: " + ex.Message, null);
        }
    }

    private string NormalizeType(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return string.Empty;
        }

        var sb = new StringBuilder();
        foreach (char ch in value.ToLowerInvariant())
        {
            if (char.IsLetterOrDigit(ch))
            {
                sb.Append(ch);
            }
        }

        return sb.ToString();
    }

    private void Write(HttpContext ctx, bool success, string message, StatsContainer data)
    {
        var payload = new
        {
            success = success,
            message = message,
            data = data
        };

        var serializer = new JavaScriptSerializer();
        ctx.Response.Write(serializer.Serialize(payload));
    }

    public bool IsReusable
    {
        get { return false; }
    }

    private class StatsContainer
    {
        public SlotStats TwoWheeler { get; set; }
        public SlotStats FourWheeler { get; set; }
    }

    private class SlotStats
    {
        public int Total { get; set; }
        public int Occupied { get; set; }
        public int Available { get; set; }
        public int OccupiedPercent { get; set; }
        public int AvailablePercent { get; set; }
    }
}