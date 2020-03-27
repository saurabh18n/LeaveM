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
            initialiseDataGridViews();
        }
        private void populateData()
        {
            DataTable dt = new DataTable();
            DataTable dt1 = new DataTable();
            DataTable dt2 = new DataTable();
            //SqlDataReader reader;
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
                        SqlDataReader reader = command.ExecuteReader();
                        dt.Load(reader);
                        dt1.Load(reader);
                        dt2.Load(reader);
                    }
                    catch (SqlException ex)
                    {
                        System.Diagnostics.Debug.WriteLine(ex.Message);
                    }

                }
            }
            if(dt.Rows.Count > 0)
            {
                Lbl_empWin.Text = dt.Rows[0][0].ToString();
                Lbl_empName.Text = (string)dt.Rows[0][1];
                Lbl_leaveBalance.Text = dt.Rows[0][3].ToString();
                Lbl_leaveExpiring.Text = dt.Rows[0][4].ToString();
                Lbl_leaveTaken.Text = dt.Rows[0][2].ToString();
            } //Populate Emp Name Info
            if(dt1.Rows.Count > 0)
            {
                GV_LeaveDetails.DataSource = dt1;
                GV_LeaveDetails.DataBind();
            }
            if(dt2.Rows.Count > 0)
            {
                GV_leaveTaken.DataSource = dt2;
                GV_leaveTaken.DataBind();
            }
        }

        private void initialiseDataGridViews()
        {
            GV_LeaveDetails.ShowHeaderWhenEmpty = true;
            GV_LeaveDetails.HeaderRow.TableSection = TableRowSection.TableHeader;
            GV_leaveTaken.ShowHeaderWhenEmpty = true;
            GV_leaveTaken.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
}