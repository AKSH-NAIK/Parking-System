using System;

namespace ParkingSystem
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["StaffId"] == null)
            {
                Response.Redirect("~/Pages/Login.aspx");
                return;
            }

            lblUser.Text = "Logged in as: " + Session["StaffId"];
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Pages/Login.aspx");
        }
    }
}
