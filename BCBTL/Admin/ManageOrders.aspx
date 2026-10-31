<%@ Page Title="Quản Lý Đơn Đặt Hàng" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageOrders.aspx.cs" Inherits="BCBTL.Admin.ManageOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headAdmin" runat="server">
    <style>
        .order-detail-box { background: #f8fafc; border: 1px solid #cbd5e0; border-radius: 8px; padding: 20px; margin-top: 20px; }
        .order-meta-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 20px; }
        .order-meta-item small { display: block; color: #718096; font-size: 12px; margin-bottom: 4px; text-transform: uppercase; font-weight: 600; }
        .order-meta-item strong { font-size: 14.5px; color: #1a365d; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AdminMainContent" runat="server">
    <!-- ORDER DETAIL MODAL / PANEL -->
    <asp:Panel ID="pnlOrderDetail" runat="server" Visible="false" CssClass="card-box" style="border: 2px solid #3182ce;">
        <div class="card-header-flex">
            <h3>Chi Tiết Đơn Hàng #<asp:Literal ID="litDetailOrderId" runat="server"></asp:Literal></h3>
            <asp:Button ID="btnCloseDetail" runat="server" Text="Đóng [✖]" CssClass="btn btn-secondary btn-sm" OnClick="btnCloseDetail_Click" />
        </div>

        <asp:Label ID="lblDetailMsg" runat="server" Visible="false" CssClass="alert-msg alert-success"></asp:Label>

        <div class="order-meta-grid">
            <div class="order-meta-item">
                <small>Khách Hàng</small>
                <strong><asp:Literal ID="litDetailCustomerName" runat="server"></asp:Literal></strong>
            </div>
            <div class="order-meta-item">
                <small>Số Điện Thoại</small>
                <strong><asp:Literal ID="litDetailPhone" runat="server"></asp:Literal></strong>
            </div>
            <div class="order-meta-item">
                <small>Email</small>
                <strong><asp:Literal ID="litDetailEmail" runat="server"></asp:Literal></strong>
            </div>
            <div class="order-meta-item">
                <small>Ngày Đặt Hàng</small>
                <strong><asp:Literal ID="litDetailDate" runat="server"></asp:Literal></strong>
            </div>
        </div>

        <div style="margin-bottom: 20px; background: #fff; padding: 12px; border-radius: 6px; border: 1px solid #e2e8f0;">
            <div style="font-weight: 600; margin-bottom: 4px;">Địa chỉ giao hàng:</div>
            <div><asp:Literal ID="litDetailAddress" runat="server"></asp:Literal></div>
            <div style="font-style: italic; color: #718096; margin-top: 4px;">Ghi chú: <asp:Literal ID="litDetailNotes" runat="server">Không có</asp:Literal></div>
        </div>

        <!-- ITEMS IN ORDER -->
        <h4 style="margin-bottom: 10px; color: #1a365d;">Sản Phẩm Đã Đặt Trong Đơn:</h4>
        <asp:GridView ID="gvOrderItems" runat="server" AutoGenerateColumns="False" CssClass="admin-table" GridLines="None">
            <Columns>
                <asp:TemplateField HeaderText="Hình Ảnh" ItemStyle-Width="60px">
                    <ItemTemplate>
                        <img src='<%# ResolveUrl("~/Assets/images/products/" + (string.IsNullOrEmpty(Eval("Image") as string) ? "default-watch.jpg" : Eval("Image"))) %>' class="table-img" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Title" HeaderText="Tên Đồng Hồ" />
                <asp:BoundField DataField="Quantity" HeaderText="Số Lượng" ItemStyle-HorizontalAlign="Center" />
                <asp:TemplateField HeaderText="Đơn Giá">
                    <ItemTemplate><%# string.Format("{0:N0} đ", Eval("UnitPrice")) %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Thành Tiền">
                    <ItemTemplate><strong><%# string.Format("{0:N0} đ", Eval("LineTotal")) %></strong></ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        <div style="text-align: right; margin-top: 15px; font-size: 16px;">
            Tổng thanh toán: <strong style="color: #9e0b0f; font-size: 20px;"><asp:Literal ID="litDetailTotal" runat="server"></asp:Literal></strong>
        </div>

        <!-- UPDATE STATUS -->
        <div style="margin-top: 20px; padding-top: 15px; border-top: 1px solid #cbd5e0; display: flex; align-items: center; gap: 14px;">
            <label style="font-weight: 700;">Cập nhật trạng thái đơn hàng:</label>
            <asp:DropDownList ID="ddlUpdateStatus" runat="server" CssClass="form-control" Width="200px">
                <asp:ListItem Value="Chờ xử lý">Chờ xử lý</asp:ListItem>
                <asp:ListItem Value="Đã xác nhận">Đã xác nhận</asp:ListItem>
                <asp:ListItem Value="Đang giao">Đang giao</asp:ListItem>
                <asp:ListItem Value="Đã hoàn tất">Đã hoàn tất</asp:ListItem>
                <asp:ListItem Value="Đã hủy">Đã hủy</asp:ListItem>
            </asp:DropDownList>
            <asp:Button ID="btnUpdateStatus" runat="server" Text="CẬP NHẬT TRẠNG THÁI" CssClass="btn btn-primary" OnClick="btnUpdateStatus_Click" />
        </div>
    </asp:Panel>

    <!-- ORDERS LIST -->
    <div class="card-box">
        <div class="card-header-flex">
            <h3>Danh Sách Đơn Đặt Hàng</h3>
            <div>
                Lọc trạng thái:
                <asp:DropDownList ID="ddlFilterStatus" runat="server" CssClass="form-control" Width="180px" style="display:inline-block;" AutoPostBack="true" OnSelectedIndexChanged="ddlFilterStatus_SelectedIndexChanged">
                    <asp:ListItem Value="ALL">-- Tất cả trạng thái --</asp:ListItem>
                    <asp:ListItem Value="Chờ xử lý">Chờ xử lý</asp:ListItem>
                    <asp:ListItem Value="Đã xác nhận">Đã xác nhận</asp:ListItem>
                    <asp:ListItem Value="Đang giao">Đang giao</asp:ListItem>
                    <asp:ListItem Value="Đã hoàn tất">Đã hoàn tất</asp:ListItem>
                    <asp:ListItem Value="Đã hủy">Đã hủy</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" DataKeyNames="OrderID"
            CssClass="admin-table" AllowPaging="True" PageSize="10" GridLines="None"
            OnPageIndexChanging="gvOrders_PageIndexChanging" OnRowCommand="gvOrders_RowCommand">
            <Columns>
                <asp:BoundField DataField="OrderID" HeaderText="Mã Đơn" ItemStyle-Width="60px" />
                <asp:BoundField DataField="CustomerName" HeaderText="Khách Hàng" />
                <asp:BoundField DataField="CustomerPhone" HeaderText="Số ĐT" />
                <asp:BoundField DataField="DeliveryAddress" HeaderText="Địa Chỉ Nhận Hàng" />
                <asp:TemplateField HeaderText="Ngày Đặt">
                    <ItemTemplate><%# string.Format("{0:dd/MM/yyyy HH:mm}", Eval("OrderDate")) %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Tổng Tiền">
                    <ItemTemplate>
                        <strong style="color: #9e0b0f;"><%# string.Format("{0:N0} đ", Eval("TotalAmount")) %></strong>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Trạng Thái">
                    <ItemTemplate>
                        <span class='status-badge <%# GetStatusClass(Eval("Status") as string) %>'>
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Thao Tác" ItemStyle-Width="120px">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnView" runat="server" CommandName="ViewOrder" CommandArgument='<%# Eval("OrderID") %>' CssClass="btn btn-primary btn-sm">Xem Chi Tiết</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <PagerStyle CssClass="pagination-row" />
            <EmptyDataTemplate>
                <div style="padding: 30px; text-align: center; color: #a0aec0;">Không có đơn hàng nào theo bộ lọc này.</div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>
