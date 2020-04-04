<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="VacationReport.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login to Vacation Report</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <webopt:BundleReference runat="server" Path="~/Content/css" />
    <script src="Scripts/bootstrap.min.js"></script>
    <link href="Content/bootstrap.css" rel="stylesheet" />
</head>
<body style="height: 100vh;">
    <div style="width:100%;height:100%;" class="align-items-center justify-content-center row">
        <div class="col-4 align-self-center">
            <form runat="server" class="" style="text-align:center">
                <div class="form-group">
                    <strong><label>Login</label></strong>
                </div>
                <div class="form-group">
                    <input type="text" class="form-control" id="TextUserName" placeholder="Username" runat="server" />
                </div>
                <div class="form-group">
                    <input type="password" class="form-control" id="textPassword" placeholder="Password" runat="server" />
                </div>
                <%--<div class="form-group form-check">
                    <input type="checkbox" class="form-check-input" id="exampleCheck1" />
                    <label class="form-check-label" for="exampleCheck1">Remember Login</label>
                </div>--%>
                <asp:Button ID="loginBtn" runat="server" Text="Login" CssClass="btn btn-primary w-100" OnClick="loginBtn_Click" />
                <asp:Label ID="ErrorLabel" runat="server" Text=""/>
            </form>
        </div>
    </div>
</body>
</html>
