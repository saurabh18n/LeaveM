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
    public partial class admin : System.Web.UI.Page
    {
        string constring = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        securityController securityController = new securityController();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (securityController.isLoggedIn() & securityController.isAdmin())
                {
                    employeeSelect.Visible = false;
                    employeeDetails.Visible = false;
                    AccumulateModel.Visible = false;
                    TakenModel.Visible = false;
                    accumulateDeleteVacTaken.Visible = false;
                    addEmployee.Visible = false;
                    initialiseComponents(sender);
                }
                else
                {
                    Response.Redirect("~/ehome");
                }
            }

        }

        private void initialiseComponents(object sender)
        {
            GV_employee.ShowHeaderWhenEmpty = true;
            //GV_employee.HeaderRow.TableSection = TableRowSection.TableHeader;
            GV_Accumulate.ShowHeaderWhenEmpty = true;
            //GV_Accumulate.HeaderRow.TableSection = TableRowSection.TableHeader;

            text_taken_dateto.Attributes.Add("onchange", "updateTakenDays();");
            text_taken_datefrom.Attributes.Add("onchange", "updateTakenDays();");
            text_addemp_fname.Attributes.Add("onkeyup", "genrateUdername();");
            text_addemp_lname.Attributes.Add("onkeyup", "genrateUdername();");
            PopulateEmployeeDD(sender);
        }

        protected void btn_search_Click(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("sp_search_employee", conn))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@searchterm", text_SearchTerm.Text);
                    try
                    {
                        conn.Open();
                        dt.Load(command.ExecuteReader());

                    }
                    catch (SqlException ex)
                    {
                        System.Diagnostics.Debug.WriteLine(ex.Message);
                    }

                }
              
            }
            if (dt.Rows.Count > 0)
            {
                if(dt.Rows.Count > 1)
                {
                    GV_employee.DataSource = dt;
                    GV_employee.DataBind();
                    load.Visible = false;
                    employeeSelect.Visible = true;
                    hideAllModel();
                    Taken.Visible = true;
                    Accumulate.Visible = true;
                    employeeDetails.Visible = false;
                 
                }
                else
                {
                    populateEmployeeDetails((int)dt.Rows[0][0]);
                }
                
            }            
        }

        private void hideAllModel()
        {
            AccumulateModel.Visible = false;
            TakenModel.Visible = false;
            Taken.Visible = false;
            Accumulate.Visible = false;
        }

        void populateEmployeeDetails(int empid)
        {
            ViewState.Add("empid", empid);
            DataTable dt_accumulate = new DataTable();
            DataTable dt_taken = new DataTable();
            DataTable dt_employee = new DataTable();
            DataTable dt_balance = new DataTable();
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("sp_get_emp_balance_admin", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@empid", empid);
                    try
                    {
                        connection.Open();
                        SqlDataReader reader = command.ExecuteReader();
                        dt_accumulate.Load(reader);
                        dt_taken.Load(reader);
                        dt_employee.Load(reader);
                        dt_balance.Load(reader);
                    }
                    catch (SqlException ex)
                    {
                        System.Diagnostics.Debug.WriteLine(ex.Message);
                    }
                }
            }
                GV_Accumulate.DataSource = dt_accumulate;
                GV_Accumulate.DataBind();     
                GV_leaveTaken.DataSource = dt_taken;
                GV_leaveTaken.DataBind();
                GV_balance.DataSource = dt_balance;
                GV_balance.DataBind();
            Lbl_empName.Text = (string)dt_employee.Rows[0][0];
            Lbl_empWin.Text = (string)dt_employee.Rows[0][1];
            lbl_empusername.Text = (string)dt_employee.Rows[0][3];
            lbl_empaccountstatus.Text = (bool)dt_employee.Rows[0][2] ? "Locked" : "Unlocked";
            lbl_emplastlogin.Text = ((DateTime)dt_employee.Rows[0][4]).ToString("MM-dd-yyyy hh:mm:ss");
            load.Visible = false;
            addEmployee.Visible = false;
            employeeSelect.Visible = false;
            employeeDetails.Visible = true;
        }

        protected void GV_Accumulate_SelectedIndexChanged(object sender, EventArgs e)
        {
            foreach (GridViewRow Row in GV_Accumulate.Rows)
            {
                Row.Attributes["class"] = "";
            }
            GV_Accumulate.Rows[GV_Accumulate.SelectedIndex].Attributes["class"] = "bg-primary text-white";
            System.Diagnostics.Debug.WriteLine("Hello");
        }

        protected void GV_Accumulate_RowCreated(object sender, GridViewRowEventArgs e)
        {
            if(e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes["onclick"] = this.Page.ClientScript.GetPostBackEventReference(this.GV_Accumulate, "Select$" + e.Row.RowIndex);
            }

        }

        protected void btn_accumulate_add_save_Click(object sender, EventArgs e)
        {
            if (AccumulateModel_headerlab.Text == "Add")
            {
                bool saved = false;
                using (SqlConnection connection = new SqlConnection(constring))
                {
                    using (SqlCommand command = new SqlCommand("sp_leave_add", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@empid", (int)ViewState["empid"]);
                        command.Parameters.AddWithValue("@craditdate", (Convert.ToDateTime(text_accumulate_add_date.Text).Date).ToString("yyyy-MM-dd"));
                        command.Parameters.AddWithValue("@days", text_accumulate_add_days.Text);
                        command.Parameters.AddWithValue("@remarks", text_accumulate_add_remark.Text);

                        try
                        {
                            connection.Open();
                            command.ExecuteNonQuery();
                            saved = true;
                        }
                        catch (SqlException ex)
                        {
                            string message = "alert('Error " + ex.Message +  "')";
                            ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);

                        }
                    }
                }
                if (saved)
                {
                    populateEmployeeDetails((int)ViewState["empid"]);
                    accumulateBack_Click(null, null);
                    string message = "alert('Saved Successfully')";
                    ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
                    clearform();
                }
                else
                {
                    string message = "alert('Error Please try Again')";
                    ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
                }
            }
            else if(AccumulateModel_headerlab.Text == "Update")
            {
                {
                    bool saved = false;
                    using (SqlConnection connection = new SqlConnection(constring))
                    {
                        using (SqlCommand command = new SqlCommand("sp_leave_update", connection))
                        {
                            command.CommandType = CommandType.StoredProcedure;
                            command.Parameters.AddWithValue("@vacid", (int)ViewState["vacid"]);
                            command.Parameters.AddWithValue("@craditdate", (Convert.ToDateTime(text_accumulate_add_date.Text).Date).ToString("yyyy-MM-dd"));
                            command.Parameters.AddWithValue("@days", text_accumulate_add_days.Text);
                            command.Parameters.AddWithValue("@remarks", text_accumulate_add_remark.Text);

                            try
                            {
                                connection.Open();
                                command.ExecuteNonQuery();
                                saved = true;
                            }
                            catch (SqlException ex)
                            {
                                string message = "alert('Ssql Error " + ex.Message + "')";
                                ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);

                            }
                        }
                    }
                    if (saved)
                    {
                        populateEmployeeDetails(1);
                        accumulateBack_Click(null, null);
                        string message = "alert('Saved Successfully')";
                        ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
                        clearform();
                    }
                    else
                    {
                        string message = "alert('Error Please try Again')";
                        ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
                    }
                }                
            }
            else if(AccumulateModel_headerlab.Text == "Delete")
            {
                string status;
                using (SqlConnection connectioin = new SqlConnection(constring))
                {
                    using(SqlCommand command = new SqlCommand("sp_leave_delete", connectioin))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@vacid",(int)ViewState["vacid"]);
                        command.Parameters.Add("@status", SqlDbType.NVarChar, 100).Direction = ParameterDirection.Output;
                        try
                        {
                            connectioin.Open();
                            command.ExecuteNonQuery();
                            status = (string)command.Parameters["@status"].Value;

                        }
                        catch (SqlException ex)
                        {
                            status = ex.Message;
                        }

                    }

                }                
                string message = "alert('" + status + "' )";
                ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
                populateEmployeeDetails((int)ViewState["empid"]);
                accumulateBack_Click(null, null);
                clearform();
            }
        }        

        protected void btnAccuAdd_Click(object sender, EventArgs e)
        {
            hideAllModel();
            AccumulateModel_headerlab.Text = "Add";
            AccumulateModel.Visible = true;

        }

        protected void btnAccuEdit_Click(object sender, EventArgs e)
        {

            if (GV_Accumulate.SelectedIndex == -1)
            {
                string message = "alert('Please select a row to update')";
                ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
            }
            else
            {
                hideAllModel();
                AccumulateModel_headerlab.Text = "Update";
                GridViewRow Row = GV_Accumulate.SelectedRow;
                text_accumulate_add_date.Text = Convert.ToDateTime(Row.Cells[1].Text).Date.ToString("yyyy-MM-dd");
                text_accumulate_add_days.Text = Row.Cells[2].Text;
                AccumulateModel.Visible = true;

            }
            
        }

        protected void accumulateBack_Click(object sender, EventArgs e)
        {
            hideAllModel();
            Accumulate.Visible = true;
            Taken.Visible = true;
        }

        protected void btnAccuDelete_Click(object sender, EventArgs e)
        {

            if (GV_Accumulate.SelectedIndex == -1)
            {
                string message = "alert('Please select a row to update')";
                ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
            }
            else
            {
                hideAllModel();
                AccumulateModel_headerlab.Text = "Delete";
                PopulateleaveDelete(sender, Convert.ToInt32(GV_Accumulate.SelectedRow.Cells[0].Text));
                GridViewRow Row = GV_Accumulate.SelectedRow;
                text_accumulate_add_date.Text = Convert.ToDateTime(Row.Cells[1].Text).Date.ToString("yyyy-MM-dd");
                text_accumulate_add_days.Text = Row.Cells[2].Text;




                AccumulateModel.Visible = true;
            }
        }

        private void PopulateleaveDelete(Object sender, int vacid)
        {
            ViewState.Add("vacid", vacid);
            int rows;
            DataTable dt = new DataTable();
            using (SqlConnection connection = new SqlConnection(constring))
            {
                using (SqlCommand command = new SqlCommand("sp_leave_delete_check", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@vacid", vacid);
                    command.Parameters.Add("@takenvac", SqlDbType.Int).Direction = ParameterDirection.Output;
                    try
                    {
                        connection.Open();
                        dt.Load(command.ExecuteReader());
                        rows = (int)command.Parameters["@takenvac"].Value;
                    }
                    catch (SqlException ex)
                    {
                        rows = -1;
                        System.Diagnostics.Debug.WriteLine(ex.Message);
                    }
                }
            }
            if (rows == -1)
            {
                populateEmployeeDetails((int)ViewState["empid"]);
                accumulateBack_Click(null, null);
                string message = "alert('Error Please try again')";
                ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
            }
            else if(rows == 0)
            {
            }
            else
            {
                accumulateDeleteVacTaken.Visible = true;
                GV_VacaTakenToDelete.DataSource = dt;
                GV_VacaTakenToDelete.DataBind();
            }

        }

        protected void GV_leaveTaken_SelectedIndexChanged(object sender, EventArgs e)
        {
            foreach (GridViewRow Row in GV_leaveTaken.Rows)
            {
                Row.Attributes["class"] = "";
            }
            GV_leaveTaken.SelectedRow.Attributes["class"] = "bg-primary text-white";
        }

        protected void GV_leaveTaken_RowCreated(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes["onclick"] = this.Page.ClientScript.GetPostBackEventReference(this.GV_leaveTaken, "Select$" + e.Row.RowIndex);
            }

        }

        protected void Btn_accumulateDeleteVacTakenDelete_Click(object sender, EventArgs e)
        {
            bool done;
            using (SqlConnection connection = new SqlConnection(constring))
            {
                using (SqlCommand command = new SqlCommand("sp_delete_vacaonvacbalance", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@vacid", (int)ViewState["vacid"]);
                    try
                    {
                        connection.Open();
                        command.ExecuteNonQuery();
                        done = true;
                    }
                    catch (SqlException ex)
                    {
                        done = false;
                    }
                      
                }
            }
            if (done)
            {
                accumulateDeleteVacTaken.Visible = false;
                PopulateleaveDelete(sender, (int)ViewState["vacid"]);
            }
            else
            {
                string message = "alert('Some Error Please try again')";
                ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
            }

        }

        protected void btnTakenAdd_Click(object sender, EventArgs e)
        {
            hideAllModel();
            lbl_TakenModelHeader.Text = "Add Leave Taken";
            TakenModel.Visible = true;

        }

        protected void btn_taken_save_Click(object sender, EventArgs e)
        {
            if(lbl_TakenModelHeader.Text == "Add Leave Taken")
            {
                bool status;
                string statusText = "";
                using (SqlConnection connection = new SqlConnection(constring)) {
                    using (SqlCommand command = new SqlCommand("sp_taken_add", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@empid", ViewState["empid"]);
                        command.Parameters.AddWithValue("@datefrom", Convert.ToDateTime(text_taken_datefrom.Text).Date.ToString("yyyy-MM-dd"));
                        command.Parameters.AddWithValue("@dateto", Convert.ToDateTime(text_taken_dateto.Text).Date.ToString("yyyy-MM-dd"));
                        command.Parameters.AddWithValue("@leavedays", Convert.ToInt32(text_taken_days.Text));
                        command.Parameters.AddWithValue("@remark", text_taken_remark.Text);
                        command.Parameters.Add("@status", SqlDbType.Bit).Direction = ParameterDirection.Output;
                        command.Parameters.Add("@satatustext", SqlDbType.NVarChar,300).Direction = ParameterDirection.Output;
                        try
                        {
                            connection.Open();
                            command.ExecuteNonQuery();
                            status = (bool)command.Parameters["@status"].Value;
                            statusText = (string)command.Parameters["@satatustext"].Value;
                        }
                        catch (SqlException ex)
                        {
                            status = false;
                            statusText = ex.Message;
                            System.Diagnostics.Debug.WriteLine(ex.Message);
                        }
                    } 
                }
                if (status)
                {
                    string message = "alert('Saved Successfully " + statusText +"' )";
                    ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);

                }
                else
                {
                    string message = "alert('Error " + statusText + "' )";
                    ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
                }
                populateEmployeeDetails((int)ViewState["empid"]);
                accumulateBack_Click(null, null);


            }
            else if (lbl_TakenModelHeader.Text == "Update Leave Taken")
            {
                bool status;
                string stmessage;
                using (SqlConnection connection = new SqlConnection(constring))
                {
                    using (SqlCommand command = new SqlCommand("sp_taken_update", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@vaca", (int)ViewState["vacaid"]);
                        command.Parameters.AddWithValue("@empid", ViewState["empid"]);                        
                        command.Parameters.AddWithValue("@datefrom", Convert.ToDateTime(text_taken_datefrom.Text).Date.ToString("yyyy-MM-dd"));
                        command.Parameters.AddWithValue("@dateto", Convert.ToDateTime(text_taken_dateto.Text).Date.ToString("yyyy-MM-dd"));
                        command.Parameters.AddWithValue("@leavedays", Convert.ToInt32(text_taken_days.Text));
                        command.Parameters.AddWithValue("@remark", text_taken_remark.Text);
                        command.Parameters.Add("@status", SqlDbType.Bit).Direction = ParameterDirection.Output;
                        command.Parameters.Add("@satatustext", SqlDbType.NVarChar, 300).Direction = ParameterDirection.Output;
                        try
                        {
                            connection.Open();
                            command.ExecuteNonQuery();
                            status = (bool)command.Parameters["@status"].Value;
                            stmessage = (string)command.Parameters["@satatustext"].Value;
                        }
                        catch (SqlException ex)
                        {
                            status = false;
                            stmessage = ex.Message;
                        }
                    }
                }
                if (status)
                {
                    string message = "alert('Updated Successfully " + stmessage + "')";
                    ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
                    populateEmployeeDetails((int)ViewState["empid"]);
                    accumulateBack_Click(null, null);

                }
                else
                {
                    string message = "alert('Some Error " + stmessage + "')";
                    ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
                    populateEmployeeDetails((int)ViewState["empid"]);
                    accumulateBack_Click(null, null);
                }

            }
            else
            {
                bool status;
                using (SqlConnection connection = new SqlConnection(constring))
                {
                    using (SqlCommand command = new SqlCommand("sp_taken_delete", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@vaca", (int)ViewState["vacaid"]);
                        command.Parameters.Add("@status", SqlDbType.Bit).Direction = ParameterDirection.Output;
                        try
                        {
                            connection.Open();
                            command.ExecuteNonQuery();
                            status = (bool)command.Parameters["@status"].Value;
                        }
                        catch (SqlException ex)
                        {
                            status = false;

                        }
                    }
                }
                if (status)
                {
                    string message = "alert('Deleted Successfully')";
                    ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
                    populateEmployeeDetails((int)ViewState["empid"]);
                    accumulateBack_Click(null, null);

                }
                else
                {
                    string message = "alert('Some Error')";
                    ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
                    populateEmployeeDetails((int)ViewState["empid"]);
                    accumulateBack_Click(null, null);
                }

            }

        }

        protected void btnTakenDelete_Click(object sender, EventArgs e)
        {
            if (GV_leaveTaken.SelectedIndex == -1)
            {

                string message = "alert('Please Select leave to delete')";
                ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
            }
            else
            {
                hideAllModel();                
                lbl_TakenModelHeader.Text = "Delete Leave Taken";
                text_taken_datefrom.Text = Convert.ToDateTime(GV_leaveTaken.SelectedRow.Cells[1].Text).Date.ToString("yyyy-MM-dd");
                text_taken_datefrom.Enabled = false;
                text_taken_dateto.Text = Convert.ToDateTime(GV_leaveTaken.SelectedRow.Cells[2].Text).Date.ToString("yyyy-MM-dd");
                text_taken_dateto.Enabled = false;
                text_taken_days.Text = GV_leaveTaken.SelectedRow.Cells[3].Text;
                text_taken_days.Enabled = false;
                ViewState.Add("vacaid", Convert.ToInt32(GV_leaveTaken.SelectedRow.Cells[0].Text));
                TakenModel.Visible = true;
            }
        }

        protected void btnTakenEdit_Click(object sender, EventArgs e)
        {
            if (GV_leaveTaken.SelectedIndex == -1)
            {

                string message = "alert('Please Select leave to Update')";
                ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
            }
            else
            {
                hideAllModel();
                lbl_TakenModelHeader.Text = "Update Leave Taken";
                text_taken_datefrom.Text = Convert.ToDateTime(GV_leaveTaken.SelectedRow.Cells[1].Text).Date.ToString("yyyy-MM-dd");
                text_taken_dateto.Text = Convert.ToDateTime(GV_leaveTaken.SelectedRow.Cells[2].Text).Date.ToString("yyyy-MM-dd");
                text_taken_days.Text = GV_leaveTaken.SelectedRow.Cells[3].Text;
                ViewState.Add("vacaid", Convert.ToInt32(GV_leaveTaken.SelectedRow.Cells[0].Text));
                TakenModel.Visible = true;
            }

        }

        protected void GV_employee_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            populateEmployeeDetails(Convert.ToInt32(GV_employee.Rows[Convert.ToInt32(e.CommandArgument)].Cells[0].Text));
            employeeSelect.Visible = false;
            employeeDetails.Visible = true;
        }

        private void clearform()
        {
            text_accumulate_add_date.Text = "";
            text_accumulate_add_days.Text = "";
            text_accumulate_add_remark.Text = "";
            text_taken_datefrom.Text = "";
            text_taken_dateto.Text = "";
            text_taken_days.Text = "";
            text_taken_remark.Text = "";
        }

        private void PopulateEmployeeDD(object sender)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(constring))
            {
                using (SqlCommand command = new SqlCommand("SELECT emp_id,emp_name from tab_employee",con))
                {
                    command.CommandType = CommandType.Text;
                    try
                    {
                        con.Open();
                        dt.Load(command.ExecuteReader());
                    }
                    catch (SqlException Ex)
                    {
                        string message = "alert('Error " + Ex.Message + "' )";
                        ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", message, true);
                    }

                }
            }
            if(dt.Rows.Count > 0)
            {
                dd_employee.DataSource = dt;
                dd_employee.DataValueField = "emp_id";
                dd_employee.DataTextField = "emp_name";
                dd_employee.DataBind();
            } 
        }

        protected void dd_employee_SelectedIndexChanged(object sender, EventArgs e)
        {
            populateEmployeeDetails(Convert.ToInt32(dd_employee.SelectedValue));

        }

        protected void btn_addEmployee_Click(object sender, EventArgs e)
        {
            employeeDetails.Visible = false;
            load.Visible = false;
            addEmployee.Visible = true;
        }

        protected void btn_unlockAccount_Click(object sender, EventArgs e)
        {
            string message;
            using(SqlConnection con = new SqlConnection(constring))
            {
                using (SqlCommand command = new SqlCommand("sp_unlockuser", con))
                {
                    command.Parameters.AddWithValue("@empid", (int)ViewState["empid"]);
                    try
                    {
                        con.Open();
                        command.ExecuteNonQuery();
                        message = "Unlocked Successfully";                      

                    }
                    catch (SqlException Ex)
                    {
                        message = Ex.Message;
                       
                    }
                }
            }
            string messagex = "alert('"+ message+"')";
            ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", messagex, true);
        }

        protected void btn_resetPassword_Click(object sender, EventArgs e)
        {
            string message;
            using (SqlConnection con = new SqlConnection(constring))
            {
                using (SqlCommand command = new SqlCommand("sp_resetuserpassword", con))
                {
                    command.Parameters.AddWithValue("@empid", (int)ViewState["empid"]);
                    try
                    {
                        con.Open();
                        command.ExecuteNonQuery();
                        message = "Password Reseted to employee Win Successfully";

                    }
                    catch (SqlException Ex)
                    {
                        message = Ex.Message;
                    }
                }
            }
            string messagex = "alert('" + message + "')";
            ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", messagex, true);

        }

        protected void btn_addemp_save_Click(object sender, EventArgs e)
        {
            byte status;
            using (SqlConnection con = new SqlConnection(constring))
            {
                using (SqlCommand command = new SqlCommand("sp_addemployee", con))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@empwin", text_addemp_win.Text);
                    command.Parameters.AddWithValue("@empname", text_addemp_fname.Text + " " + text_addemp_lname.Text);
                    command.Parameters.AddWithValue("@empusername", text_addemp_uname.Text);
                    command.Parameters.AddWithValue("@empdepart", text_addemp_department.Text);
                    command.Parameters.Add("@status", SqlDbType.TinyInt).Direction = ParameterDirection.Output;
                    try
                    {
                        con.Open();
                        command.ExecuteNonQuery();
                        status = (byte)command.Parameters["@status"].Value;
                    }
                    catch (SqlException Ex)
                    {
                        string messagex = "alert('Sql Error " + Ex.Message + "')";
                        ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", messagex, true);
                        status = 4;
                    }

                }

            }
            switch (status)
            {
                case 1:
                    {
                        string messagex = "alert('Employee WIN already Exists')";
                        ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", messagex, true);
                        break;
                    }
                case 2:
                    {
                        string messagex = "alert('Employee username already Exists')";
                        ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", messagex, true);
                        break;
                    }
                case 0:
                    {
                        string messagex = "alert('Employee Saved Successfully')";
                        ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", messagex, true);
                        addEmployee.Visible = false;
                        load.Visible = true;
                        break;
                    }
                default:
                    {
                        string messagex = "alert('Unknown Error')";
                        ScriptManager.RegisterStartupScript(sender as Control, GetType(), "alert", messagex, true);
                        break;
                    }

            }
        }

        protected void btn_addemp_back_Click(object sender, EventArgs e)
        {
            addEmployee.Visible = false;
            load.Visible = true;
        }
    }
 
}