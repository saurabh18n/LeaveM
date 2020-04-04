<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="changepassword.aspx.cs" Inherits="VacationReport.changePassword" %>
<html>
<head>
<meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Change Password</title>

    <asp:PlaceHolder runat="server">
        <%: Scripts.Render("~/bundles/modernizr") %>
    </asp:PlaceHolder>

    <webopt:BundleReference runat="server" Path="~/Content/css" />
    <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" />

</head>
<body>
    <form id="form1" runat="server" class="container align-contant-center">
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

        <div class="col col-sm-4 mx-auto">
            <h3>Change Password</h3>
            <div class="form-group">
                <label for="exampleInputEmail1">Old password</label>
                <asp:TextBox ID="text_oldpass" runat="server" class="form-control" TextMode="Password"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="exampleInputEmail1">New password</label>
                <asp:TextBox ID="textnewpassword" runat="server" class="form-control" TextMode="Password"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="exampleInputEmail1">Re Type password</label>
                <asp:TextBox ID="text_retypepassword" runat="server" class="form-control" TextMode="Password"></asp:TextBox>
            </div>
            <div class="form-row">
                <a class="btn btn-secondary" href="/login">Back</a>
                <asp:Button ID="tbn_changepass" runat="server" Text="Save" CssClass="btn btn-primary ml-auto" OnClick="tbn_changepass_Click" />
            </div>
        </div>
        
    </form>
</body>
</html>
