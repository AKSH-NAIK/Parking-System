using System;
using System.Web;
using System.Web.SessionState;

public class Logout : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        try
        {
            // Clear the session
            context.Session.Clear();
            context.Session.Abandon();

            // Return success response
            context.Response.Write("{\"success\":true,\"message\":\"Logged out successfully\"}");
        }
        catch (Exception ex)
        {
            context.Response.Write($"{{\"success\":false,\"message\":\"{ex.Message}\"}}");
        }
    }

    public bool IsReusable => false;
}
