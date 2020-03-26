using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace LeaveM
{
    public partial class login : System.Web.UI.Page
    {
        securityController securityController = new securityController();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void loginBtn_Click(object sender, EventArgs e)
        {

            if (securityController.login(TextUserName.Value, textPassword.Value))
            {
                Response.Redirect("~/ehome");
            }
            else
            {
                ErrorLabel.Text = "User Name or Password Not Correct";
            }
            
        }
    }
}