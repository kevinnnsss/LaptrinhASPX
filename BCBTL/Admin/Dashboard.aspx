<%@ Page Title="Bảng Điều Khiển Tổng Quan" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="BCBTL.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headAdmin" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AdminMainContent" runat="server">
    <!-- STAT CARDS -->
    <div class="stat-grid">
        <div class="stat-card">
            <div class="stat-info">
                <h3>Tổng Sản Phẩm</h3>
                <div class="stat-number"><asp:Literal ID="litTotalProducts" runat="server">0</asp:Literal></div>
            </div>
            <div class="stat-icon stat-blue">⌚</div>
        </div>

        <div class="stat-card">
            <div class="stat-info">
                <h3>Thương Hiệu / Menu</h3>
                <div class="stat-number"><asp:Literal ID="litTotalBrands" runat="server">0</asp:Literal></div>
            </div>
            <div class="stat-icon stat-gold">📑</div>
        </div>

        <div class="stat-card">
            <div class="stat-info">
                <h3>Tổng Đơn Hàng</h3>
                <div class="stat-number"><asp:Literal ID="litTotalOrders" runat="server">0</asp:Literal></div>
            </div>
            <div class="stat-icon stat-red">🛒</div>
        </div>

        <div class="stat-card">
            <div class="stat-info">
                <h3>Doanh Số Ước Tính</h3>
                <div class="stat-number"><asp:Literal ID="litTotalRevenue" runat="server">0 đ</asp:Literal></div>
            </div>
            <div class="stat-icon stat-green">💰</div>
        </div>
    </div>

    <!-- RECENT ORDERS & LOW STOCK ALERTS -->
    <div style="display: grid; grid-template-columns: 2fr 1.2fr; gap: 24px;">
        <!-- RECENT ORDERS -->
        <div class="card-box">
            <div class="card-header-flex">
                <h3>Đơn Hàng Mới Nhận Gần Đây</h3>
                <a href="ManageOrders.aspx" class="btn btn-secondary btn-sm">Xem tất cả đơn hàng ▶</a>
            </div>

            <asp:GridView ID="gvRecentOrders" runat="server" AutoGenerateColumns="False" CssClass="admin-table" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="OrderID" HeaderText="Mã Đơn" />
                    <asp:BoundField DataField="CustomerName" HeaderText="Khách Hàng" />
                    <asp:BoundField DataField="CustomerPhone" HeaderText="Số ĐT" />
                    <asp:TemplateField HeaderText="Tổng Tiền">
                        <ItemTemplate>
                            <strong><%# string.Format("{0:N0} đ", Eval("TotalAmount")) %></strong>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Trạng Thái">
                        <ItemTemplate>
                            <span class='status-badge <%# GetStatusClass(Eval("Status") as string) %>'>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Thao tác">
                        <ItemTemplate>
                            <a href='ManageOrders.aspx?viewId=<%# Eval("OrderID") %>' class="btn btn-primary btn-sm">Chi tiết</a>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div style="padding: 20px; text-align: center; color: #a0aec0;">Chưa có đơn đặt hàng nào gần đây.</div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>

        <!-- LOW STOCK WARNING -->
        <div class="card-box">
            <div class="card-header-flex">
                <h3>⚠️ Cảnh Báo Tồn Kho Sắp Hết</h3>
                <a href="ManageProducts.aspx" class="btn btn-secondary btn-sm">Quản lý kho</a>
            </div>

            <asp:GridView ID="gvLowStock" runat="server" AutoGenerateColumns="False" CssClass="admin-table" GridLines="None">
                <Columns>
                    <asp:TemplateField HeaderText="Sản phẩm">
                        <ItemTemplate>
                            <div style="font-weight: 600;"><%# Eval("Title") %></div>
                            <small style="color: #718096;"><%# Eval("CategoryName") %></small>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Còn Lại" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <span style="font-weight: 700; color: #e53e3e; background: #fff5f5; padding: 3px 8px; border-radius: 4px;">
                                <%# Eval("StockQuantity") %> chiếc
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div style="padding: 20px; text-align: center; color: #38a169;">✅ Tất cả sản phẩm đều đảm bảo tồn kho dồi dào.</div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
