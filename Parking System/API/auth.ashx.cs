using System;
using System.Web;
using System.Data.SqlClient;
using System.Web.SessionState;

public class Auth : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        try
        {
            string staffId = context.Request.Form["staffId"];
            string passCode = context.Request.Form["passCode"];

            if (string.IsNullOrWhiteSpace(staffId) || string.IsNullOrWhiteSpace(passCode))
            {
                Write(context, false, "Missing credentials");
                return;
            }

            string connStr =
                @"Data Source=(localdb)\MSSQLLocalDB;
                  Initial Catalog=ParkingSystemDB;
                  Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT Role FROM Staff
                               WHERE StaffId=@StaffId AND PassCode=@PassCode";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@StaffId", staffId);
                cmd.Parameters.AddWithValue("@PassCode", passCode);

                conn.Open();
                var role = cmd.ExecuteScalar();

                if (role != null)
                {
                    context.Session["StaffId"] = staffId;
                    context.Session["Role"] = role.ToString();
                    Write(context, true, "Login successful");
                }
                else
                {
                    Write(context, false, "Invalid Staff ID or Password");
                }
            }
        }
        catch (Exception ex)
        {
            Write(context, false, ex.Message);
        }
    }

    private void Write(HttpContext ctx, bool success, string message)
    {
        ctx.Response.Write(
            $"{{\"success\":{success.ToString().ToLower()},\"message\":\"{message}\"}}"
        );
    }

    public bool IsReusable => false;
}
