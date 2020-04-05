using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VacationReport
{
    public partial class ehome : Page
    {
        securityController sec = new securityController();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (sec.isLoggedIn())
                {
                    populateData();
                    initialiseDataGridViews();
                }
                else
                {
                    Response.Redirect("~/login");
                }
            }

            
        }
        private void populateData()
        {
            DataTable dt = new DataTable();
            DataTable dt1 = new DataTable();
            DataTable dt2 = new DataTable();
            DataTable dt3 = new DataTable();
            
            //SqlDataReader reader;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("sp_employee_balance", connection))
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@empid", sec.getempid());
                    try
                    {
                        connection.Open();
                        SqlDataReader reader = command.ExecuteReader();
                        dt.Load(reader);
                        dt1.Load(reader);
                        dt2.Load(reader);
                        dt3.Load(reader);
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
                Lbl_leaveTaken.Text = dt.Rows[0][2].ToString();
            }
            if(dt1.Rows.Count > 0)
            {      
                GV_LeaveDetails.DataSource = dt1;
                GV_LeaveDetails.DataBind();
                GV_LeaveDetails.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
            if(dt2.Rows.Count > 0)
            {
                
                GV_leaveTaken.DataSource = dt2;
                GV_leaveTaken.DataBind();
                GV_leaveTaken.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
            if (dt3.Rows.Count > 0)
            {
                GV_yearBalence.DataSource = dt3;
                GV_yearBalence.DataBind();
                GV_yearBalence.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        private void initialiseDataGridViews()
        {
            GV_LeaveDetails.ShowHeaderWhenEmpty = true;           

            GV_leaveTaken.ShowHeaderWhenEmpty = true;            
            

            GV_yearBalence.ShowHeaderWhenEmpty = true;
                        
        }
    }
}