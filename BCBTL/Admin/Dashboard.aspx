<%@ Page Title="Bảng Điều Khiển" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="BCBTL.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headAdmin" runat="server">
    <style>
        .dashboard-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
            margin-bottom: 24px;
        }
        @media (max-width: 1024px) {
            .dashboard-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AdminMainContent" runat="server">
    <!-- 1. THẺ THỐNG KÊ KPI -->
    <div class="stats-grid">
        <div class="stat-card card-primary">
            <div class="stat-info">
                <h4>Sản Phẩm Đang Bán</h4>
                <div class="stat-number">
                    <asp:Label ID="lblTotalProducts" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-sub">Đồng hồ chính hãng đang hiển thị</div>
            </div>
            <div class="stat-icon">⌚</div>
        </div>

        <div class="stat-card card-warning">
            <div class="stat-info">
                <h4>Đơn Chờ Xử Lý</h4>
                <div class="stat-number">
                    <asp:Label ID="lblPendingOrders" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-sub">Cần liên hệ khách xác nhận</div>
            </div>
            <div class="stat-icon">⏳</div>
        </div>

        <div class="stat-card card-success">
            <div class="stat-info">
                <h4>Doanh Thu Thực Tế</h4>
                <div class="stat-number">
                    <asp:Label ID="lblTotalRevenue" runat="server" Text="0 đ"></asp:Label>
                </div>
                <div class="stat-sub">Tổng giá trị đơn hàng hợp lệ</div>
            </div>
            <div class="stat-icon">💰</div>
        </div>

        <div class="stat-card card-gold">
            <div class="stat-info">
                <h4>Tổng Đơn Đặt Hàng</h4>
                <div class="stat-number">
                    <asp:Label ID="lblTotalOrders" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-sub">Ghi nhận qua hệ thống</div>
            </div>
            <div class="stat-icon">📦</div>
        </div>

        <div class="stat-card card-info">
            <div class="stat-info">
                <h4>Cảnh Báo Tồn Kho</h4>
                <div class="stat-number">
                    <asp:Label ID="lblLowStock" runat="server" Text="0"></asp:Label>
                </div>
                <div class="stat-sub">Sản phẩm còn ≤ 5 chiếc</div>
            </div>
            <div class="stat-icon">⚠️</div>
        </div>
    </div>

    <!-- 2. PHÍM TẮT NHANH -->
    <div class="content-card">
        <div class="content-card-header">
            <div class="content-card-title">⚡ Thao Tác Quản Trị Nhanh</div>
        </div>
        <div class="content-card-body">
            <div class="quick-action-grid">
                <a href="ManageProducts.aspx" class="quick-action-btn">
                    <span class="quick-action-icon">➕</span>
                    <span class="quick-action-title">Thêm Đồng Hồ Mới</span>
                </a>
                <a href="ManageOrders.aspx" class="quick-action-btn">
                    <span class="quick-action-icon">📋</span>
                    <span class="quick-action-title">Duyệt Đơn Hàng</span>
                </a>
                <a href="ManageMenus.aspx" class="quick-action-btn">
                    <span class="quick-action-icon">🏷️</span>
                    <span class="quick-action-title">Thêm Danh Mục Hãng</span>
                </a>
                <a href="ManageAccounts.aspx" class="quick-action-btn">
                    <span class="quick-action-icon">👤</span>
                    <span class="quick-action-title">Quản Lý Nhân Viên</span>
                </a>
                <a href="../Default.aspx" target="_blank" class="quick-action-btn">
                    <span class="quick-action-icon">🌐</span>
                    <span class="quick-action-title">Xem Trang Khách Hàng</span>
                </a>
            </div>
        </div>
    </div>

    <!-- 3. BẢNG DỮ LIỆU TỔNG QUAN -->
    <div class="dashboard-row">
        <!-- ĐƠN HÀNG MỚI NHẤT -->
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">📦 Đơn Đặt Hàng Mới Nhất</div>
                <a href="ManageOrders.aspx" class="btn btn-sm btn-secondary">Xem tất cả →</a>
            </div>
            <div class="content-card-body" style="padding:0;">
                <div class="table-responsive">
                    <asp:GridView ID="gvRecentOrders" runat="server" AutoGenerateColumns="False" 
                        CssClass="admin-grid" GridLines="None" EmptyDataText="Chưa có đơn hàng nào được ghi nhận.">
                        <Columns>
                            <asp:BoundField DataField="OrderID" HeaderText="Mã Đơn" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center" />
                            <asp:BoundField DataField="CustomerName" HeaderText="Khách Hàng" />
                            <asp:BoundField DataField="CustomerPhone" HeaderText="Điện Thoại" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center" />
                            <asp:TemplateField HeaderText="Ngày Đặt" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <%# Eval("OrderDate", "{0:dd/MM/yyyy HH:mm}") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Tổng Tiền" ItemStyle-CssClass="text-right" HeaderStyle-CssClass="text-right">
                                <ItemTemplate>
                                    <strong style="color:var(--admin-primary);"><%# string.Format("{0:N0} đ", Eval("TotalAmount")) %></strong>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Trạng Thái" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <span class='<%# GetStatusBadgeClass(Eval("Status").ToString()) %>'>
                                        <%# Eval("Status") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Thao Tác" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <a href='<%# "ManageOrders.aspx?id=" + Eval("OrderID") %>' class="btn btn-sm btn-primary">Chi tiết</a>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- CẢNH BÁO TỒN KHO THẤP -->
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">⚠️ Đồng Hồ Sắp Hết Hàng</div>
                <a href="ManageProducts.aspx" class="btn btn-sm btn-secondary">Quản lý kho →</a>
            </div>
            <div class="content-card-body" style="padding:0;">
                <div class="table-responsive">
                    <asp:GridView ID="gvLowStockProducts" runat="server" AutoGenerateColumns="False" 
                        CssClass="admin-grid" GridLines="None" EmptyDataText="Kho hàng đầy đủ, không có sản phẩm nào sắp hết.">
                        <Columns>
                            <asp:TemplateField HeaderText="Ảnh" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <img src='<%# ResolveUrl("~/Assets/images/products/" + (string.IsNullOrEmpty(Eval("Image") as string) ? "default-watch.jpg" : Eval("Image"))) %>' class="grid-thumb" style="width:40px;height:40px;" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Tên Đồng Hồ">
                                <ItemTemplate>
                                    <div style="font-weight:600; font-size:12px; line-height:1.3;"><%# Eval("Title") %></div>
                                    <small style="color:#64748b;"><%# Eval("BrandName") %></small>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Tồn" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <span class="badge badge-danger"><%# Eval("StockQuantity") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
