<%@ Page Language="C#" Title="Admin" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="admin.aspx.cs" Inherits="VacationReport.admin" %>

<!DOCTYPE html>

<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title></title>

    <asp:PlaceHolder runat="server">
        <%: Scripts.Render("~/bundles/modernizr") %>
    </asp:PlaceHolder>

    <webopt:BundleReference runat="server" Path="~/Content/css" />
    <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" />
</head>
<body>


    <form runat="server" id="adminForm">
        <asp:ScriptManager runat="server">
            <Scripts>
                <%--To learn more about bundling scripts in ScriptManager see https://go.microsoft.com/fwlink/?LinkID=301884 --%>
                <%--Framework Scripts--%>
                <asp:ScriptReference Name="MsAjaxBundle" />
                <asp:ScriptReference Name="jquery" />
                <asp:ScriptReference Name="bootstrap" />
                <asp:ScriptReference Name="WebForms.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebForms.js" />
                <asp:ScriptReference Name="WebUIValidation.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebUIValidation.js" />
                <asp:ScriptReference Name="MenuStandards.js" Assembly="System.Web" Path="~/Scripts/WebForms/MenuStandards.js" />
                <asp:ScriptReference Name="GridView.js" Assembly="System.Web" Path="~/Scripts/WebForms/GridView.js" />
                <asp:ScriptReference Name="DetailsView.js" Assembly="System.Web" Path="~/Scripts/WebForms/DetailsView.js" />
                <asp:ScriptReference Name="TreeView.js" Assembly="System.Web" Path="~/Scripts/WebForms/TreeView.js" />
                <asp:ScriptReference Name="WebParts.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebParts.js" />
                <asp:ScriptReference Name="Focus.js" Assembly="System.Web" Path="~/Scripts/WebForms/Focus.js" />
                <asp:ScriptReference Name="WebFormsBundle" />
                <%--Site Scripts--%>
                <asp:ScriptReference Path="~/Scripts/siteScript/admin.js" />


            </Scripts>
        </asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="" style="top: 0; left: 0; width: 100%">
                    <nav class="navbar navbar-expand-lg navbar-light" style="background-color: #e3f2fd;">
                        Vacation report
                        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                            <span class="navbar-toggler-icon"></span>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarSupportedContent">
                            <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
                                <li class="nav-item active">
                                    <asp:LinkButton ID="btn_addEmployee" runat="server" OnClick="btn_addEmployee_Click" cssClass="btn btn-success mx-3">Add Employee</asp:LinkButton>
                                </li>
                            </ul>
                            
                            <div class="form-inline">
                                <asp:TextBox ID="text_SearchTerm" runat="server" ClientIDMode="Static" CssClass="form-control mr-sm-2"></asp:TextBox>
                                <asp:Button ID="btn_search" runat="server" CssClass="btn btn-outline-success my-2 my-sm-0" Text="Search" OnClick="btn_search_Click" OnClientClick="return checkTearchTerm();" />
                            </div>
                            <div class="form-inline">
                                <asp:DropDownList ID="dd_employee" runat="server" CssClass="btn dropdown-toggle" OnSelectedIndexChanged="dd_employee_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                            </div>
                            <div class="form-inline my-2 my-lg-0 dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <asp:Label ID="lbl_adminName" runat="server" Text=""></asp:Label>
                                </a>
                                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <a class="dropdown-item" href="~/ehome" runat="server" id="switchtoadmin">Switch View</a>
                                    <a class="dropdown-item" href="#">Change Password</a>
                                    <div class="dropdown-divider"></div>
                                    <a class="dropdown-item" href="/logout">Logout</a>
                                </div>
                            </div>
                        </div>
                    </nav>
                </div>
                <div class="container-fluid" style="width: 100%">
                    <div id="employeeSelect" runat="server" class="row row-cols-1 mt-2 align-content-center">
                        <div class="col-md-7 align-self-center mx-auto">
                            <asp:GridView ID="GV_employee" runat="server" AutoGenerateColumns="False"
                                CssClass=" table table-bordered table-hover text-center" RowStyle-CssClass="selectRow" OnRowCommand="GV_employee_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="emp_id" HeaderText="eid" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderStyle CssClass="d-none" />
                                        <ItemStyle CssClass="d-none" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="emp_win" HeaderText="Win#">
                                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="emp_name" HeaderText="Name" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:d}">
                                        <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                                        <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                                    </asp:BoundField>
                                    <asp:ButtonField HeaderText="Select" ButtonType="Button" Text="Select" ControlStyle-CssClass="btn btn-primary" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>

                    <div id="load" runat="server" class="row row-cols-1 mt-2 align-content-center">
                        <div class="col-md-3 align-self-center mx-auto">
                            <p class="text-center">Please search an employee to get details</p>
                        </div>
                    </div>

                    <div id="employeeDetails" runat="server" class="row row-cols-2 mt-2 align-content-center">                       
                        <div class="col col-md-3">
                            <div class="card mb-2">
                                <div class="card-header">
                                    <strong>
                                        <asp:Label ID="Lbl_empName" runat="server" Text="Employee Name"></asp:Label></strong>
                                </div>
                                <div class="card-body">
                                    <ul class="list-group list-group-flush">
                                        <li class="list-group-item">
                                            WIN# <asp:Label ID="Lbl_empWin" runat="server" Text="98"></asp:Label>
                                        </li>
                                        <li class="list-group-item">
                                           Username <asp:Label ID="lbl_empusername" runat="server" Text="98"></asp:Label>
                                        </li>
                                        <li class="list-group-item">
                                            Last Login <asp:Label ID="lbl_emplastlogin" runat="server" Text="98"></asp:Label>
                                        </li>
                                        <li class="list-group-item">
                                            Account Status <asp:Label ID="lbl_empaccountstatus" runat="server" Text="98"></asp:Label>                                     
                                        </li>
                                        <li class="list-group-item">
                                            <asp:Button ID="btn_unlockAccount" runat="server" cssClass="btn btn-primary" Text="Unlock A/c" OnClick="btn_unlockAccount_Click" />
                                            <asp:Button ID="btn_resetPassword" runat="server" cssClass="btn btn-primary" Text="Reset Pass" OnClick="btn_resetPassword_Click" />
                                        </li>
                                    </ul> 
                                </div>
                            </div>

                            <div class="card mb-2">
                                <div class="card-header">
                                    Balance
                                </div>
                                <div class="card-body">
                                    <asp:GridView ID="GV_balance" runat="server" ClientIDMode="Static" AutoGenerateColumns="False" CssClass="table-bordered w-100 text-center">
                                        <Columns>
                                            <asp:BoundField DataField="vac_expirydate" HeaderText="Expiration Date" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:d}">
                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                            </asp:BoundField>                                           
                                            <asp:BoundField DataField="vac_balance" HeaderText="Balance" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                            </asp:BoundField>                                           
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>

                        <div class="col-md">
                            <div class="card mb-3" runat="server" id="Accumulate">
                                <div class="card-header">Accumulate</div>
                                <div class="card-body" style="padding: 5px;">
                                    <asp:GridView ID="GV_Accumulate" runat="server" ClientIDMode="Static" AutoGenerateColumns="False" CssClass="table-bordered table-hover w-100 text-center"
                                        OnSelectedIndexChanged="GV_Accumulate_SelectedIndexChanged"
                                        EnablePersistedSelection="True" DataKeyNames="vac_id" OnRowCreated="GV_Accumulate_RowCreated">
                                        <Columns>
                                            <asp:BoundField DataField="vac_id" HeaderText="vac_id">
                                                <HeaderStyle CssClass="d-none" />
                                                <ItemStyle CssClass="d-none" />
                                            </asp:BoundField>

                                            <asp:BoundField DataField="vac_createdate" HeaderText="Date" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:d}">
                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="vac_credit" HeaderText="Cradit" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="vac_balance" HeaderText="Balance" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="vac_remark" HeaderText="Note">
                                                <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                                            </asp:BoundField>
                                        </Columns>
                                    </asp:GridView>

                                    <div style="float: right">
                                        <asp:Button ID="btnAccuAdd" runat="server" CssClass="btn btn-primary" Text="Add" data-toggle="modal" data-target="#AccumulateAddModel" 
                                            OnClick="btnAccuAdd_Click" />
                                        <asp:Button ID="btnAccuEdit" runat="server" CssClass="btn btn-primary" Text="Update" OnClick="btnAccuEdit_Click" />
                                        <asp:Button ID="btnAccuDelete" runat="server" CssClass="btn btn-primary" Text="Delete" OnClick="btnAccuDelete_Click" />
                                    </div>

                                </div>
                            </div>

                            <div class="card mb-3" runat="server" id="Taken">
                                <div class="card-header">Taken</div>
                                <div class="card-body" style="padding: 5px;">
                                    <asp:GridView ID="GV_leaveTaken" runat="server" AutoGenerateColumns="False"
                                        class="table-bordered table-hover table-striped w-100 text-center"
                                        OnRowCreated="GV_leaveTaken_RowCreated" OnSelectedIndexChanged="GV_leaveTaken_SelectedIndexChanged" 
                                        EnablePersistedSelection="True" DataKeyNames="vaca_id"
                                        >
                                        <Columns>
                                            <asp:BoundField DataField="vaca_id" HeaderText="vaca_id">
                                                <HeaderStyle CssClass="d-none" />
                                                <ItemStyle CssClass="d-none" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="vaca_start" HeaderText="Start" DataFormatString="{0:d}" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="vaca_end" HeaderText="End" DataFormatString="{0:d}" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                            </asp:BoundField>

                                            <asp:BoundField DataField="vaca_days" HeaderText="Days" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="vaca_remark" HeaderText="Note" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                                                <ItemStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                                            </asp:BoundField>
                                        </Columns>
                                    </asp:GridView>
                                    <div style="float: right">

                                        <asp:Button ID="btnTakenAdd" runat="server" CssClass="btn btn-primary" Text="Add" OnClick="btnTakenAdd_Click" />
                                        <asp:Button ID="btnTakenEdit" runat="server" CssClass="btn btn-primary" Text="Update" OnClick="btnTakenEdit_Click" />
                                        <asp:Button ID="btnTakenDelete" runat="server" CssClass="btn btn-primary" Text="Delete" OnClick="btnTakenDelete_Click" />
                                    </div>
                                </div>
                            </div>

                            <div class="card mb-3" runat="server" id="AccumulateModel">
                            <div class="card-header">
                                <asp:Label ID="AccumulateModel_headerlab" runat="server" Text="Label"></asp:Label> </div>                        
                            
                            <div class="card-body p-3">
                                <div class="form-group row">
                                    <label for="colFormLabel" class="col-sm-2 col-form-label">Date</label>
                                    <div class="col-sm-10">
                                        <asp:TextBox ID="text_accumulate_add_date" runat="server" ClientIDMode="Static" TextMode="Date" CssClass="form-control form-control-md" placeholder="Date" />
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label for="colFormLabel" class="col-sm-2 col-form-label">Days</label>
                                    <div class="col-sm-10">
                                        <asp:TextBox ID="text_accumulate_add_days" runat="server" ClientIDMode="Static" TextMode="Number" CssClass="form-control form-control-md" placeholder="Days"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label class="col-sm-2 col-form-label">Note</label>
                                    <div class="col-sm-10">
                                        <asp:TextBox ID="text_accumulate_add_remark" runat="server" ClientIDMode="Static" CssClass="form-control form-control-md" TextMode="MultiLine" placeholder="Note"></asp:TextBox>
                                    </div>
                                </div>

                                <div runat="server" id="accumulateDeleteVacTaken" class="">
                                    <p>Employee Already taken these leave(s) from balance. Please delete taken leave first.</p>
                                    <asp:GridView ID="GV_VacaTakenToDelete" runat="server" CssClass="table border-primary" AutoGenerateColumns="false">
                                        <Columns>                                            
                                            <asp:BoundField DataField="vaca_start" HeaderText="Start" DataFormatString="{0:d}" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="vaca_end" HeaderText="End" DataFormatString="{0:d}" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                            </asp:BoundField>

                                            <asp:BoundField DataField="vaca_days" HeaderText="Days" HeaderStyle-HorizontalAlign="Center">
                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                            </asp:BoundField>                                           
                                        </Columns>
                                    </asp:GridView>
                                    <asp:Button ID="Btn_accumulateDeleteVacTakenDelete"
                                    runat="server" Text="Delete All"
                                    CssClass="btn btn-danger float-right" OnClick="Btn_accumulateDeleteVacTakenDelete_Click"/>
                                </div>
                            </div>


                            <div class="modal-footer">
                                <asp:Button ID="accumulateBack" runat="server" cssClass="btn btn-secondary"  Text="Close" OnClick="accumulateBack_Click"/>
                                <asp:Button ID="btn_accumulate_add_save"
                                    runat="server" Text="Save"
                                    CssClass="btn btn-primary"
                                    OnClick="btn_accumulate_add_save_Click"
                                    OnClientClick="return validate_Accumulate();"/>
                            </div>
                        </div>

                            <div class="card mb-3" runat="server" id="TakenModel">
                            <div class="card-header">
                                <asp:Label ID="lbl_TakenModelHeader" runat="server" Text=""></asp:Label> </div>                        
                            
                            <div class="card-body p-3">
                                <div class="form-group row">
                                    <label for="colFormLabel" class="col-sm-2 col-form-label">From</label>
                                    <div class="col-sm-10">
                                        <asp:TextBox ID="text_taken_datefrom" runat="server" ClientIDMode="Static" TextMode="Date" CssClass="form-control form-control-md" placeholder="Date"/>
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label for="colFormLabel" class="col-sm-2 col-form-label">To</label>
                                    <div class="col-sm-10">
                                        <asp:TextBox ID="text_taken_dateto" runat="server" ClientIDMode="Static" TextMode="Date" CssClass="form-control form-control-md" placeholder="Date"/>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="colFormLabel" class="col-sm-2 col-form-label">Days</label>
                                    <div class="col-sm-10">
                                        <asp:TextBox ID="text_taken_days" runat="server" ClientIDMode="Static" TextMode="Number" CssClass="form-control form-control-md" placeholder="Days"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label class="col-sm-2 col-form-label">Note</label>
                                    <div class="col-sm-10">
                                        <asp:TextBox ID="text_taken_remark" runat="server" ClientIDMode="Static" CssClass="form-control form-control-md" TextMode="MultiLine" placeholder="Remarks"></asp:TextBox>
                                    </div>
                                </div>                                
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="btn_taken_back" runat="server" cssClass="btn btn-secondary"  Text="Close" OnClick="accumulateBack_Click"/>
                                <asp:Button ID="btn_taken_save"
                                    runat="server" Text="Save"
                                    CssClass="btn btn-primary"                                    
                                    OnClientClick="return validate_taken()" OnClick="btn_taken_save_Click"/>
                            </div>
                        </div>

                        </div>
                        
                    </div>


                    <div id="addEmployee" runat="server" class="row row-cols-1 mt-2 align-content-center">
                        <div class="col-md-3 align-self-center mx-auto">
                            <div class="form-row mb-2">
                                <label>Win</label>
                                <asp:TextBox ID="text_addemp_win" runat="server" 
                                    ClientIDMode="Static" cssClass="form-control" required="true"></asp:TextBox>                            </div>
                            
                            <div class="form-row mb-2">
                                <label>First Name</label>
                                <asp:TextBox ID="text_addemp_fname" runat="server" 
                                    cssClass="form-control" required="true" AutoPostBack="false"
                                    ></asp:TextBox>                            

                            </div>
                            
                            <div class="form-row mb-2">
                                <label>Last Name</label>
                                <asp:TextBox ID="text_addemp_lname" runat="server" 
                                    cssClass="form-control" required="true" 
                                    AutoPostBack="false"></asp:TextBox>
                            </div>
                            
                            <div class="form-row mb-2">
                                <label>Username</label>
                                <asp:TextBox ID="text_addemp_uname" runat="server" cssClass="form-control" required="true"></asp:TextBox>                            

                            </div>
                            
                            <div class="form-row mb-2">
                                <label>Department</label>
                                <asp:TextBox ID="text_addemp_department" runat="server" cssClass="form-control" required="true"></asp:TextBox>                            </div>

                            <div class="form-row mb-2">
                                <asp:Button ID="btn_addemp_back" runat="server" Text="Back" CssClass="btn btn-secondary float-left" OnClick="btn_addemp_back_Click" />
                                <asp:Button ID="btn_addemp_save" runat="server" Text="Save" CssClass="btn btn-primary ml-auto" OnClick="btn_addemp_save_Click" OnClientClick="validateAddemployee()" />                                
                            </div>
                        </div>
                    </div>

                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>
