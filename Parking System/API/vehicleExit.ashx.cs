using System;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;

namespace Parking_System.API
{
    public class vehicleExit : IHttpHandler, IRequiresSessionState
    {
        private const decimal TwoWheelerRatePerHour = 30m;
        private const decimal FourWheelerRatePerHour = 100m;

        private const string UpiId = "parking@upi";
        private const string UpiName = "Parking Fees";

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            if (context.Session["StaffId"] == null)
            {
                context.Response.StatusCode = 401;
                Write(context, false, "Not authenticated", null);
                return;
            }

            string action = (context.Request["action"] ?? string.Empty).Trim().ToLowerInvariant();

            if (action == "fetch")
            {
                HandleFetch(context);
                return;
            }

            if (action == "exit")
            {
                HandleExit(context);
                return;
            }

            Write(context, false, "Invalid action", null);
        }

        private void HandleFetch(HttpContext context)
        {
            string vehicleNumber = (context.Request["vehicleNumber"] ?? string.Empty).Trim().ToUpperInvariant();

            if (string.IsNullOrWhiteSpace(vehicleNumber))
            {
                Write(context, false, "Vehicle number is required", null);
                return;
            }

            string connStr = @"Data Source=(localdb)\MSSQLLocalDB;
                              Initial Catalog=ParkingSystemDB;
                              Integrated Security=True;
                              Connect Timeout=30;
                              Encrypt=False;";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string sql = @"
                    SELECT TOP 1
                        t.TransactionId,
                        t.EntryTime,
                        v.OwnerName,
                        v.PhoneNumber,
                        v.VehicleNumber,
                        v.VehicleType,
                        ps.SlotNumber,
                        ps.SlotId
                    FROM Transactions t
                    INNER JOIN Vehicles v ON t.VehicleId = v.VehicleId
                    INNER JOIN ParkingSlots ps ON t.SlotId = ps.SlotId
                    WHERE v.VehicleNumber = @VehicleNumber
                      AND t.ExitTime IS NULL
                    ORDER BY t.EntryTime DESC";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@VehicleNumber", vehicleNumber);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            Write(context, false, "Vehicle not found or already exited", null);
                            return;
                        }

                        var data = new
                        {
                            transactionId = Convert.ToInt32(reader["TransactionId"]),
                            ownerName = reader["OwnerName"].ToString(),
                            phoneNumber = reader["PhoneNumber"].ToString(),
                            vehicleNumber = reader["VehicleNumber"].ToString(),
                            vehicleType = reader["VehicleType"].ToString(),
                            entryTime = Convert.ToDateTime(reader["EntryTime"]).ToString("yyyy-MM-dd HH:mm:ss"),
                            slotNumber = reader["SlotNumber"].ToString(),
                            slotId = Convert.ToInt32(reader["SlotId"])
                        };

                        Write(context, true, "ok", data);
                    }
                }
            }
        }

        private void HandleExit(HttpContext context)
        {
            string vehicleNumber = (context.Request["vehicleNumber"] ?? string.Empty).Trim().ToUpperInvariant();
            string exitTimeInput = (context.Request["exitTime"] ?? string.Empty).Trim();

            if (string.IsNullOrWhiteSpace(vehicleNumber))
            {
                Write(context, false, "Vehicle number is required", null);
                return;
            }

            DateTime exitTime = string.IsNullOrWhiteSpace(exitTimeInput)
                ? DateTime.Now
                : DateTime.Parse(exitTimeInput);

            string connStr = @"Data Source=(localdb)\MSSQLLocalDB;
                              Initial Catalog=ParkingSystemDB;
                              Integrated Security=True;
                              Connect Timeout=30;
                              Encrypt=False;";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string sql = @"
                    SELECT TOP 1
                        t.TransactionId,
                        t.EntryTime,
                        v.VehicleType,
                        ps.SlotId,
                        ps.SlotNumber
                    FROM Transactions t
                    INNER JOIN Vehicles v ON t.VehicleId = v.VehicleId
                    INNER JOIN ParkingSlots ps ON t.SlotId = ps.SlotId
                    WHERE v.VehicleNumber = @VehicleNumber
                      AND t.ExitTime IS NULL
                    ORDER BY t.EntryTime DESC";

                int transactionId;
                int slotId;
                string slotNumber;
                DateTime entryTime;
                string vehicleType;

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@VehicleNumber", vehicleNumber);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            Write(context, false, "Vehicle not found or already exited", null);
                            return;
                        }

                        transactionId = Convert.ToInt32(reader["TransactionId"]);
                        slotId = Convert.ToInt32(reader["SlotId"]);
                        slotNumber = reader["SlotNumber"].ToString();
                        entryTime = Convert.ToDateTime(reader["EntryTime"]);
                        vehicleType = reader["VehicleType"].ToString();
                    }
                }

                using (SqlTransaction tx = conn.BeginTransaction())
                {
                    try
                    {
                        string updateTxnSql = "UPDATE Transactions SET ExitTime=@ExitTime WHERE TransactionId=@TransactionId";
                        using (SqlCommand cmd = new SqlCommand(updateTxnSql, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@ExitTime", exitTime);
                            cmd.Parameters.AddWithValue("@TransactionId", transactionId);
                            cmd.ExecuteNonQuery();
                        }

                        string updateSlotSql = "UPDATE ParkingSlots SET IsOccupied=0 WHERE SlotId=@SlotId";
                        using (SqlCommand cmd = new SqlCommand(updateSlotSql, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@SlotId", slotId);
                            cmd.ExecuteNonQuery();
                        }

                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }

                decimal amount = CalculateCharge(NormalizeType(vehicleType), entryTime, exitTime);
                string upiUri = BuildUpiUri(amount, vehicleNumber);

                var data = new
                {
                    vehicleNumber = vehicleNumber,
                    slotNumber = slotNumber,
                    entryTime = entryTime.ToString("yyyy-MM-dd HH:mm:ss"),
                    exitTime = exitTime.ToString("yyyy-MM-dd HH:mm:ss"),
                    amount = amount,
                    upiUri = upiUri
                };

                Write(context, true, "Exit processed", data);
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

        private string BuildUpiUri(decimal amount, string vehicleNumber)
        {
            string note = "Parking Fee - " + vehicleNumber;
            return "upi://pay?pa=" + HttpUtility.UrlEncode(UpiId) +
                   "&pn=" + HttpUtility.UrlEncode(UpiName) +
                   "&am=" + amount.ToString("0.00") +
                   "&cu=INR" +
                   "&tn=" + HttpUtility.UrlEncode(note);
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

        private void Write(HttpContext ctx, bool success, string message, object data)
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
    }
}