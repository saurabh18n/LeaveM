<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ehome.aspx.cs" Inherits="LeaveM._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server" cssClass="testborder">
    <div class="row row-cols-md-2">
        <div class=" col col-md">

            <div class="card mb-2">
                <div class="card-header">
                    <P>Hello <asp:Label ID="Lbl_empName" runat="server" Text="Employee Name"></asp:Label></P>
                 </div>
                <div class="card-body">
                    <p>Greetings</p>
                </div>
            </div>

            <div class="card mb-2">
                <div class="card-header">Balance</div>
                <div class="card-body">
                    <div class="row row-cols-3">
                        <div class="card text-center">
                            <div class="card-header text-white bg-success">Balance</div>
                            <div class="card-body">
                                <h5 class="card-text">
                                    <asp:Label ID="Lbl_leaveBalance" runat="server" Text="9"></asp:Label></h5>
                            </div>
                        </div>

                        <div class="card text-center">
                            <div class="card-header text-white bg-warning">Expiring</div>
                            <div class="card-body">
                                <h5 class="card-text">
                                    <asp:Label ID="Lbl_leaveExpiring" runat="server" Text="9"></asp:Label>
                                </h5>
                            </div>
                        </div>

                        <div class="card text-center ">
                            <div class="card-header text-white bg-primary">Taken</div>
                            <div class="card-body">
                                <h5 class="card-text">
                                    <asp:Label ID="Lbl_leaveTaken" runat="server" Text="10"></asp:Label>
                                </h5>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            

        </div>

        <div class="col-sm">

            <div class="card mb-3">
                <div class="card-header">Expiring</div>
                <div class="card-body" style="padding: 5px;">
                    <table class="table-bordered table-hover" style="width: 100%; margin: 0px">
                        <tr>
                            <th>Days</th>
                            <th>Date of Expiry</th>
                        </tr>
                        <tr>
                            <td>5</td>
                            <td>10-12-2020</td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="card mb-3">
                <div class="card-header">Availed</div>
                <div class="card-body" style="padding:5px;">
                    <table class="table-bordered table-hover" style="width: 100%; margin: 0px">
                        <tr>
                            <th>From</th>
                            <th>To</th>
                            <th>Days</th>
                        </tr>
                        <tr>
                            <td>10-12-2020</td>
                            <td>10-12-2020</td>
                            <td>5</td>                            
                        </tr>
                        <tr>
                            <td>10-12-2020</td>
                            <td>10-12-2020</td>
                            <td>5</td>                            
                        </tr>
                        <tr>
                            <td>10-12-2020</td>
                            <td>10-12-2020</td>
                            <td>5</td>                            
                        </tr>
                    </table>

                </div>
            </div>
        </div>
    </div>

</asp:Content>
