<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ehome.aspx.cs" Inherits="LeaveM._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row row-cols-md-2">
        <div class=" col col-md">
            <div class="card mb-2">
                <div class="card-header">
                    Hello <strong>
                        <asp:Label ID="Lbl_empName" runat="server" Text="Employee Name"></asp:Label></strong>
                </div>
                <div class="card-body">
                    WIN#
                    <asp:Label ID="Lbl_empWin" runat="server" Text="98"></asp:Label>
                </div>
            </div>
            <div class="card mb-2">
                <div class="card-header">Available</div>
                <div class="card-body">
                    <div class="row row-cols-2">
                        <div class="card text-center">
                            <div class="card-header text-white bg-success">Available</div>
                            <div class="card-body">
                                <h5 class="card-text">
                                    <asp:Label ID="Lbl_leaveBalance" runat="server" Text="9"></asp:Label></h5>
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

            <div class="card mb-3">
                <div class="card-header">Details</div>
                <div class="card-body" style="padding: 5px;">
                    <asp:GridView ID="GV_yearBalence" runat="server" ClientIDMode="Static" AutoGenerateColumns="False" CssClass="table-bordered table-hover w-100 text-center">
                        <Columns>
                            <asp:BoundField DataField="year" HeaderText="Year" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </asp:BoundField>
                            <asp:BoundField DataField="accumulate" HeaderText="Accumulated" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:d}">
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </asp:BoundField>
                            <asp:BoundField DataField="available" HeaderText="Available Days">
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </asp:BoundField>

                            <asp:BoundField DataField="taken" HeaderText="Taken Days">
                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </asp:BoundField>

                            <asp:BoundField DataField="expired" HeaderText="expired">
                                <HeaderStyle CssClass="d-none" />
                                <ItemStyle CssClass="d-none" />
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>

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
                <div class="card-header">Taken</div>
                <div class="card-body" style="padding: 5px;">
                    <asp:GridView ID="GV_leaveTaken" runat="server" AutoGenerateColumns="False" class="table-bordered table-hover table-striped w-100 text-center">
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
                            <asp:BoundField HeaderText="Year Taken" DataField="vaca_year" HeaderStyle-HorizontalAlign="Center">
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
            $("#GV_yearBalence tbody tr:contains('True') :nth-child(3)").addClass('bg-danger text-white')

        });
    </script>

</asp:Content>
