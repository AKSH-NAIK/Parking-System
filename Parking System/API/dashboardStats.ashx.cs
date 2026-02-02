using System;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;

public class dashboardStats : IHttpHandler, IRequiresSessionState
{
    private const decimal TwoWheelerRatePerHour = 30m;
    private const decimal FourWheelerRatePerHour = 100m;

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
            FourWheeler = new SlotStats(),
            RevenueToday = 0m,
            RevenueMonth = 0m
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

                LoadSlotStats(conn, data);
                LoadRevenue(conn, data);
            }

            Write(context, true, "ok", data);
        }
        catch (Exception ex)
        {
            Write(context, false, "Error: " + ex.Message, null);
        }
    }

    private void LoadSlotStats(SqlConnection conn, StatsContainer data)
    {
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

    private void LoadRevenue(SqlConnection conn, StatsContainer data)
    {
        DateTime now = DateTime.Now;
        DateTime startOfDay = now.Date;
        DateTime startOfMonth = new DateTime(now.Year, now.Month, 1);

        string sql = @"
            SELECT v.VehicleType, t.EntryTime, t.ExitTime
            FROM Transactions t
            INNER JOIN Vehicles v ON t.VehicleId = v.VehicleId
            WHERE t.ExitTime IS NOT NULL
              AND t.ExitTime >= @StartOfMonth";

        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.AddWithValue("@StartOfMonth", startOfMonth);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    string type = NormalizeType(reader["VehicleType"].ToString());
                    DateTime entryTime = Convert.ToDateTime(reader["EntryTime"]);
                    DateTime exitTime = Convert.ToDateTime(reader["ExitTime"]);

                    decimal charge = CalculateCharge(type, entryTime, exitTime);

                    data.RevenueMonth += charge;

                    if (exitTime >= startOfDay)
                    {
                        data.RevenueToday += charge;
                    }
                }
            }
        }
    }

    private decimal CalculateCharge(string type, DateTime entryTime, DateTime exitTime)
    {
        if (exitTime <= entryTime)
        {
            return 0m;
        }

        double totalMinutes = Math.Floor((exitTime - entryTime).TotalMinutes);
        int fullHours = (int)(totalMinutes / 60);
        int extraMinutes = (int)(totalMinutes % 60);

        decimal billableHours = fullHours;

        if (extraMinutes >= 1 && extraMinutes <= 30)
        {
            billableHours += 0.5m;
        }
        else if (extraMinutes >= 31)
        {
            billableHours += 1m;
        }

        decimal rate = type == "4wheeler" ? FourWheelerRatePerHour : TwoWheelerRatePerHour;
        return billableHours * rate;
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
        public decimal RevenueToday { get; set; }
        public decimal RevenueMonth { get; set; }
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