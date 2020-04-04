using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

namespace VacationReport
{
    
    public partial class changePassword : System.Web.UI.Page
    {
        securityController security = new securityController();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (security.isLoggedIn())
                {

                }
                else
                {
                    Response.Redirect("/login");
                }
            }
            

        }

        protected void tbn_changepass_Click(object sender, EventArgs e)
        {
            if (security.isLoggedIn())
            {
                if(textnewpassword.Text != text_retypepassword.Text)
                {
                    string message = "alert('Password and retype password do not match');";
                    ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
                }
                else
                {
                    byte status;
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
                    {
                        using (SqlCommand command = new SqlCommand("sp_changepassword", conn))
                        {
                            command.CommandType = System.Data.CommandType.StoredProcedure;
                            command.Parameters.AddWithValue("@empid", security.getempid());
                            command.Parameters.AddWithValue("@oldpw", text_oldpass.Text);
                            command.Parameters.AddWithValue("@newpw", textnewpassword.Text);
                            command.Parameters.Add("@status", SqlDbType.TinyInt).Direction = ParameterDirection.Output;
                            try
                            {
                                conn.Open();
                                command.ExecuteNonQuery();
                                status = (byte)command.Parameters["@status"].Value;
                            }
                            catch (SqlException ex)
                            {
                                string message = "alert('SQL Error "+ ex.Message+"');";
                                ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
                                status = 2;
                            }

                        }

                        }
                    switch (status)
                    {
                        case 0:
                            {
                                string message = "alert('Password Updated Successfully');window.location.replace('/logout')";
                                ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
                             
                                break;
                            }
                        default:
                            {
                                string message = "alert('Some Error Please Try Again.');";
                                ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
                                break;
                            }
                            
                    }


                }

            }
            else
            {
                string message = "alert('Please Login First to continue');window.location.replace('/login')";
                ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
                Response.Redirect("/login");
            }
        }
    }
}