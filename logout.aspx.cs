using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LeaveM
{
    public partial class logout : System.Web.UI.Page
    {
        securityController securityController = new securityController();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (securityController.isLoggedIn())
            {
                securityController.logout();
                Response.Redirect("~/login");
            }
            else
            {
                Response.Redirect("~/login");
            }

        }
    }
}