using System;

namespace ParkingSystem
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is authenticated
            if (Session["StaffId"] == null)
            {
                // Redirect to login page if not authenticated
                Response.Redirect("~/UI/Login.aspx");
                return;
            }
        }
    }
}
