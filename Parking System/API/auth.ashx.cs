using System;
using System.Data.SqlClient;
using System.Web;

namespace Parking_System.Api
{
    public class Auth : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            // Read values sent from Auth.js
            string staffId = context.Request.Form["staffId"];
            string passCode = context.Request.Form["passCode"];

            // Basic validation
            if (string.IsNullOrWhiteSpace(staffId) || string.IsNullOrWhiteSpace(passCode))
            {
                WriteJson(context, false, "Missing credentials");
                return;
            }

            // Connection string (LOCALDB)
            string connStr = @"Data Source=(localdb)\MSSQLLocalDB;
                               Initial Catalog=ParkingSystemDB;
                               Integrated Security=True";

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = @"
                        SELECT StaffId, FullName, Role
                        FROM Staff
                        WHERE StaffId = @StaffId AND PassCode = @PassCode
                    ";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@StaffId", staffId);
                    cmd.Parameters.AddWithValue("@PassCode", passCode);

                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // OPTIONAL: store session (good for demo)
                            context.Session["StaffId"] = reader["StaffId"].ToString();
                            context.Session["FullName"] = reader["FullName"].ToString();
                            context.Session["Role"] = reader["Role"].ToString();

                            WriteJson(context, true, "Login successful");
                        }
                        else
                        {
                            WriteJson(context, false, "Invalid Staff ID or Password");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // NEVER expose raw errors in real systems
                WriteJson(context, false, "Server error");
            }
        }

        private void WriteJson(HttpContext context, bool success, string message)
        {
            context.Response.Write(
                $"{{\"success\":{success.ToString().ToLower()},\"message\":\"{message}\"}}"
            );
        }

        public bool IsReusable => false;
    }
}
