using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VacationReport
{
    public partial class SiteMaster : MasterPage
    {
        securityController securityController = new securityController();
        protected void Page_Load(object sender, EventArgs e)
        {
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