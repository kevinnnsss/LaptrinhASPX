<%@ Page Title="Quản Lý Đơn Đặt Hàng" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageOrders.aspx.cs" Inherits="BCBTL.Admin.ManageOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headAdmin" runat="server">
    <style>
        .order-detail-card {
            background-color: #ffffff;
            border: 2px solid var(--admin-primary);
            border-radius: var(--admin-radius);
            box-shadow: var(--admin-shadow-lg);
            margin-bottom: 24px;
        }
        .order-info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
            padding: 16px;
            background-color: #f8fafc;
            border-radius: 6px;
        }
        .info-item {
            margin-bottom: 8px;
            font-size: 13px;
        }
        .info-label {
            font-weight: 700;
            color: #64748b;
            display: inline-block;
            width: 130px;
        }
        .info-val {
            color: #1e293b;
            font-weight: 600;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AdminMainContent" runat="server">
    <!-- THÔNG BÁO HỆ THỐNG -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert">
        <asp:Label ID="lblAlertMsg" runat="server"></asp:Label>
    </asp:Panel>

    <!-- PANEL CHI TIẾT ĐƠN HÀNG (KHI CHỌN XEM) -->
    <asp:Panel ID="pnlOrderDetail" runat="server" Visible="false" CssClass="order-detail-card">
        <div class="content-card-header" style="background-color: #fbebed;">
            <div class="content-card-title" style="color:var(--admin-primary);">
                📦 CHI TIẾT ĐƠN HÀNG #<asp:Label ID="lblDetailOrderId" runat="server" Font-Bold="true"></asp:Label>
            </div>
            <asp:Button ID="btnCloseDetail" runat="server" Text="✖ Đóng chi tiết" CssClass="btn btn-sm btn-secondary" OnClick="btnCloseDetail_Click" />
        </div>
        <div class="content-card-body">
            <div class="order-info-grid">
                <!-- CỘT 1: THÔNG TIN KHÁCH HÀNG & GIAO HÀNG -->
                <div>
                    <h4 style="margin-bottom:12px; color:#1e293b; border-bottom:1px solid #e2e8f0; padding-bottom:6px;">👤 Thông Tin Khách Hàng</h4>
                    <div class="info-item">
                        <span class="info-label">Họ và tên:</span>
                        <asp:Label ID="lblDetailCustomerName" runat="server" CssClass="info-val"></asp:Label>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Số điện thoại:</span>
                        <asp:Label ID="lblDetailPhone" runat="server" CssClass="info-val"></asp:Label>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Email:</span>
                        <asp:Label ID="lblDetailEmail" runat="server" CssClass="info-val"></asp:Label>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Địa chỉ nhận hàng:</span>
                        <asp:Label ID="lblDetailAddress" runat="server" CssClass="info-val"></asp:Label>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Ghi chú đơn hàng:</span>
                        <asp:Label ID="lblDetailNotes" runat="server" CssClass="info-val" Font-Italic="true"></asp:Label>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Loại tài khoản:</span>
                        <asp:Label ID="lblDetailAccount" runat="server" CssClass="info-val"></asp:Label>
                    </div>
                </div>

                <!-- CỘT 2: TRẠNG THÁI & CẬP NHẬT -->
                <div>
                    <h4 style="margin-bottom:12px; color:#1e293b; border-bottom:1px solid #e2e8f0; padding-bottom:6px;">🔄 Cập Nhật Trạng Thái Đơn Hàng</h4>
                    <div class="info-item">
                        <span class="info-label">Ngày đặt hàng:</span>
                        <asp:Label ID="lblDetailOrderDate" runat="server" CssClass="info-val"></asp:Label>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Trạng thái hiện tại:</span>
                        <asp:Label ID="lblDetailCurrentStatus" runat="server"></asp:Label>
                    </div>
                    <div class="info-item" style="margin-top:14px;">
                        <label style="display:block; margin-bottom:6px; font-weight:700;">Đổi trạng thái mới:</label>
                        <div style="display:flex; gap:10px;">
                            <asp:DropDownList ID="ddlUpdateStatus" runat="server" CssClass="form-control" style="max-width:240px;">
                                <asp:ListItem Value="Chờ xử lý">Chờ xử lý</asp:ListItem>
                                <asp:ListItem Value="Đã xác nhận">Đã xác nhận</asp:ListItem>
                                <asp:ListItem Value="Đang giao">Đang giao</asp:ListItem>
                                <asp:ListItem Value="Đã hoàn tất">Đã hoàn tất</asp:ListItem>
                                <asp:ListItem Value="Đã hủy">Đã hủy</asp:ListItem>
                            </asp:DropDownList>
                            <asp:Button ID="btnUpdateStatus" runat="server" Text="Lưu Trạng Thái" CssClass="btn btn-primary" OnClick="btnUpdateStatus_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- BẢNG SẢN PHẨM TRONG ĐƠN -->
            <h4 style="margin-bottom:10px; color:#1e293b;">⌚ Danh Sách Đồng Hồ Đặt Mua</h4>
            <div class="table-responsive">
                <asp:GridView ID="gvOrderItems" runat="server" AutoGenerateColumns="False" 
                    CssClass="admin-grid" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="ID_P" HeaderText="Mã SP" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center" />
                        <asp:TemplateField HeaderText="Ảnh" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                            <ItemTemplate>
                                <img src='<%# ResolveUrl("~/Assets/images/products/" + (string.IsNullOrEmpty(Eval("Image") as string) ? "default-watch.jpg" : Eval("Image"))) %>' 
                                     alt="" class="grid-thumb" style="width:40px;height:40px;" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Title" HeaderText="Tên Đồng Hồ" />
                        <asp:TemplateField HeaderText="Đơn Giá Lúc Mua" ItemStyle-CssClass="text-right" HeaderStyle-CssClass="text-right">
                            <ItemTemplate>
                                <%# string.Format("{0:N0} đ", Eval("UnitPrice")) %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Quantity" HeaderText="Số Lượng" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center" />
                        <asp:TemplateField HeaderText="Thành Tiền" ItemStyle-CssClass="text-right" HeaderStyle-CssClass="text-right">
                            <ItemTemplate>
                                <strong style="color:var(--admin-primary);"><%# string.Format("{0:N0} đ", Eval("LineTotal")) %></strong>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <div style="text-align:right; margin-top:16px; padding:12px 16px; background:#fff; border:1px solid #e2e8f0; border-radius:6px;">
                <span style="font-size:15px; font-weight:700;">TỔNG GIÁ TRỊ ĐƠN HÀNG: </span>
                <span style="font-size:20px; font-weight:900; color:var(--admin-primary);">
                    <asp:Label ID="lblDetailTotalAmount" runat="server"></asp:Label>
                </span>
            </div>
        </div>
    </asp:Panel>

    <!-- DANH SÁCH ĐƠN HÀNG TOÀN HỆ THỐNG -->
    <div class="content-card">
        <div class="content-card-header">
            <div class="content-card-title">📦 Quản Lý Tất Cả Đơn Đặt Hàng</div>
            <span class="badge badge-info">
                Tổng: <asp:Label ID="lblTotalOrdersCount" runat="server" Text="0"></asp:Label> đơn hàng
            </span>
        </div>
        <div class="content-card-body">
            <!-- BỘ LỌC ĐƠN HÀNG -->
            <div class="filter-bar">
                <asp:TextBox ID="txtSearchCustomer" runat="server" CssClass="form-control" placeholder="Tìm tên khách hoặc số điện thoại..." style="min-width:240px;"></asp:TextBox>
                <asp:DropDownList ID="ddlFilterStatus" runat="server" CssClass="form-control">
                    <asp:ListItem Value="">-- Mọi trạng thái --</asp:ListItem>
                    <asp:ListItem Value="Chờ xử lý">Chờ xử lý</asp:ListItem>
                    <asp:ListItem Value="Đã xác nhận">Đã xác nhận</asp:ListItem>
                    <asp:ListItem Value="Đang giao">Đang giao</asp:ListItem>
                    <asp:ListItem Value="Đã hoàn tất">Đã hoàn tất</asp:ListItem>
                    <asp:ListItem Value="Đã hủy">Đã hủy</asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="btnFilter" runat="server" Text="🔍 Lọc Đơn Hàng" CssClass="btn btn-primary btn-sm" OnClick="btnFilter_Click" />
                <asp:Button ID="btnResetFilter" runat="server" Text="↺ Tất Cả" CssClass="btn btn-secondary btn-sm" OnClick="btnResetFilter_Click" />
            </div>

            <!-- BẢNG GRIDVIEW ĐƠN HÀNG -->
            <div class="table-responsive">
                <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" 
                    CssClass="admin-grid" GridLines="None" DataKeyNames="OrderID"
                    AllowPaging="True" PageSize="10" 
                    OnPageIndexChanging="gvOrders_PageIndexChanging" 
                    OnRowCommand="gvOrders_RowCommand"
                    EmptyDataText="Chưa có đơn đặt hàng nào trong hệ thống.">
                    <PagerStyle CssClass="grid-pager" HorizontalAlign="Center" />
                    <Columns>
                        <asp:BoundField DataField="OrderID" HeaderText="Mã Đơn" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center" />
                        <asp:TemplateField HeaderText="Khách Hàng">
                            <ItemTemplate>
                                <div style="font-weight:700; color:#1e293b;"><%# Eval("CustomerName") %></div>
                                <small style="color:#64748b;"><%# Eval("CustomerEmail") %></small>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="CustomerPhone" HeaderText="Điện Thoại" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center" />
                        <asp:BoundField DataField="DeliveryAddress" HeaderText="Địa Chỉ Nhận Hàng" />
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
                                <asp:LinkButton ID="btnViewDetail" runat="server" CommandName="ViewOrder" CommandArgument='<%# Eval("OrderID") %>' CssClass="btn btn-sm btn-primary">Xem Chi Tiết</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
