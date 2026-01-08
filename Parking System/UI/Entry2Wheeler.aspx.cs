using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Parking_System.UI
{
    public partial class Entry2Wheeler : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["StaffId"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }
    }
}