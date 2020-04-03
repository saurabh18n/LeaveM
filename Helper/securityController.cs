using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Configuration;

namespace LeaveM
{
    public class securityController
    {
       class employee
        {
            public int userID { get; set; }
            public string userName { get; set; }
            public string userFullName { get; set; }
            //Role 1 Employee 2- Aprover 3- Admin 
            public int userRole { get; set;}
        } 

        public string getUserName()
        {
            if (isLoggedIn())
            {
                return ((employee)HttpContext.Current.Session["Employee"]).userFullName;
            }
            else
            {
                return "NotLoggedIn";
            }
           
        }
        public bool login(string Username, string Password)
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString))
            {
                using (SqlCommand command = new SqlCommand("sp_checkLogin",connection))
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@username", Username);
                    command.Parameters.AddWithValue("@password", Password);
                    command.Parameters.Add("@loginsuccess", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    command.Parameters.Add("@empid", SqlDbType.Int).Direction = ParameterDirection.Output;
                    command.Parameters.Add("@empRole", SqlDbType.TinyInt).Direction = ParameterDirection.Output;
                    command.Parameters.Add("@empfullname", SqlDbType.NVarChar, 100).Direction = ParameterDirection.Output;
                    try
                    {
                        connection.Open();
                        command.ExecuteNonQuery();
                        if ((bool)command.Parameters["@loginsuccess"].Value)
                        {
                            HttpContext.Current.Session.Add("Employee", new employee()
                            {
                                userID = (int)command.Parameters["@empid"].Value,
                                userFullName = (string)command.Parameters["@empfullname"].Value,
                                userRole = (byte)command.Parameters["@empRole"].Value,
                            });
                            return true;
                        }
                        else
                        {
                            return false;
                        }
                    }
                    catch (SqlException ex)
                    {
                        //System.Diagnostics.Debug.WriteLine(ex.Message);
                        return false;
                    }

                }
            }
        }
        public void logout()
        {
            if (isLoggedIn())
            {
                HttpContext.Current.Session.Abandon();
            }

        }
        public bool isLoggedIn()
        {
            if (HttpContext.Current.Session["Employee"] == null)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
        public bool isAdmin()
        {
            if (isLoggedIn())
            {
                if(((employee)HttpContext.Current.Session["Employee"]).userRole > 1)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }
        public int getempid()
        {
            if (isLoggedIn())
            {
                return ((employee)HttpContext.Current.Session["Employee"]).userID;
            }
            else
            {
                return 0;
            }
        }
    }
}