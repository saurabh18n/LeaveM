using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LeaveM
{
    public partial class _Default : Page
    {
        securityController sec = new securityController();
        protected void Page_Load(object sender, EventArgs e)
        {
            #region
            //if (!IsPostBack)
            //{

            //    if (sec.isLoggedIn())
            //    {
            //        populateData();
            //    }
            //    else
            //    {
            //        Response.Redirect("~/login");
            //    }

            //}
            #endregion

            populateData();
        }
        private void populateData()
        {
            SqlDataReader reader;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("sp_employee_balance", connection))
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    int empid = 1;
                    command.Parameters.AddWithValue("@empid", empid);
                    try
                    {
                        connection.Open();                        
                        reader = command.ExecuteReader();                      

                    }
                    catch (SqlException ex)
                    {
                        System.Diagnostics.Debug.WriteLine(ex.Message);
                    }

                }
            }

            reader.Read();
            Lbl_empWin.Text = reader.GetString(0);
            Lbl_empName.Text = reader.GetString(1);
            Lbl_leaveBalance.Text = reader.GetInt32(3).ToString();
            Lbl_leaveExpiring.Text = reader.GetInt32(4).ToString();
            Lbl_leaveTaken.Text = reader.GetInt32(2).ToString();
            reader.NextResult();
        }
    }
}