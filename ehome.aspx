<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ehome.aspx.cs" Inherits="LeaveM._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row row-cols-md-2">
        <div class=" col col-md">
            <div class="card mb-2">
                <div class="card-header">
                    <p>Hello
                        <asp:Label ID="Lbl_empName" runat="server" Text="Employee Name"></asp:Label></p>
                </div>
                <div class="card-body">
                    <p>WIN#
                        <asp:Label ID="Lbl_empWin" runat="server" Text="98"></asp:Label>
                    </p>
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
                            <div class="card-header text-white bg-danger">Expiring</div>
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
                <div class="card-header">Balance Details</div>
                <div class="card-body" style="padding: 5px;">
                    <asp:GridView ID="GV_LeaveDetails" runat="server" ClientIDMode="Static" AutoGenerateColumns="False" CssClass="table-bordered table-hover w-100 text-center">
                        <Columns>
                            <asp:BoundField DataField="vac_balance" HeaderText="Leave Days" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </asp:BoundField>
                            <asp:BoundField DataField="vac_expirydate" HeaderText="Expiring on" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:d}">
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Expiring" HeaderText="expiring">
                                <HeaderStyle CssClass="d-none" />
                                <ItemStyle CssClass="d-none" />
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>

                </div>
            </div>

            <div class="card mb-3">
                <div class="card-header">Availed</div>
                <div class="card-body" style="padding: 5px;">
                    <asp:GridView ID="GV_leaveTaken" runat="server" AutoGenerateColumns="False" class="table-bordered table-hover w-100 text-center">
                        <Columns>
                            <asp:BoundField HeaderText="Start" DataField="vaca_start" DataFormatString="{0:d}" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="End" DataField="vaca_end" DataFormatString="{0:d}" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Days" DataField="vaca_days" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </asp:BoundField>
                        </Columns>

                    </asp:GridView>


                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            $('#GV_LeaveDetails tbody tr').filter(":contains('True')").addClass('bg-danger text-white')
        });

    </script>

</asp:Content>
