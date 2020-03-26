using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;

namespace LeaveM
{
    public partial class adminMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            securityController securityController = new securityController();
            if (!IsPostBack)
            {
                if (securityController.isLoggedIn())
                {
                    TextInfo ti = new CultureInfo("en-US", false).TextInfo;
                    LabelName.Text = "Hello " + ti.ToTitleCase(securityController.getUserName());
                    switchtoadmin.Visible = securityController.isAdmin();
                }
                else
                {
                    Response.Redirect("~/login");
                }
            }

        }
    }
}