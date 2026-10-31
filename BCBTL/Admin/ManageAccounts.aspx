<%@ Page Title="Quản Lý Tài Khoản & Phân Quyền" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageAccounts.aspx.cs" Inherits="BCBTL.Admin.ManageAccounts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headAdmin" runat="server">
    <style>
        .account-layout {
            display: grid;
            grid-template-columns: 360px 1fr;
            gap: 24px;
        }
        @media (max-width: 992px) {
            .account-layout {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AdminMainContent" runat="server">
    <!-- THÔNG BÁO HỆ THỐNG -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert">
        <asp:Label ID="lblAlertMsg" runat="server"></asp:Label>
    </asp:Panel>

    <div class="account-layout">
        <!-- FORM THÊM TÀI KHOẢN MỚI -->
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">👤 Thêm Tài Khoản Mới</div>
            </div>
            <div class="content-card-body">
                <div class="form-group">
                    <label>Tên đăng nhập <span class="required">(*)</span>:</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Ví dụ: nhanvien1, admin2..."></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Mật khẩu khởi tạo <span class="required">(*)</span>:</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Nhập mật khẩu..."></asp:TextBox>
                    <small style="color:#64748b; font-size:11px;">Mật khẩu sẽ được tự động băm chuẩn SHA-256 an toàn.</small>
                </div>

                <div class="form-group">
                    <label>Họ và tên đầy đủ <span class="required">(*)</span>:</label>
                    <asp:TextBox ID="txtFullname" runat="server" CssClass="form-control" placeholder="Ví dụ: Nguyễn Văn An"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Email liên hệ:</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="email@gmail.com" TextMode="Email"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Quyền hạn tài khoản <span class="required">(*)</span>:</label>
                    <asp:DropDownList ID="ddlPermission" runat="server" CssClass="form-control">
                        <asp:ListItem Value="1" Selected="True">1 - Quản Trị Viên (Admin toàn quyền)</asp:ListItem>
                        <asp:ListItem Value="2">2 - Khách Hàng Thành Viên (Member)</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group" style="margin-top:16px;">
                    <label style="display:flex; align-items:center; gap:8px; cursor:pointer; margin-bottom:8px;">
                        <asp:CheckBox ID="chkActive" runat="server" Checked="true" />
                        <span>Kích hoạt tài khoản ngay (Active = 1)</span>
                    </label>
                    <label style="display:flex; align-items:center; gap:8px; cursor:pointer;">
                        <asp:CheckBox ID="chkLock" runat="server" Checked="false" />
                        <span>Khóa tài khoản này (Lock = 1)</span>
                    </label>
                </div>

                <div style="margin-top:20px;">
                    <asp:Button ID="btnAddAccount" runat="server" Text="Tạo Tài Khoản Mới" CssClass="btn btn-primary" style="width:100%;" OnClick="btnAddAccount_Click" />
                </div>
            </div>
        </div>

        <!-- BẢNG DANH SÁCH TÀI KHOẢN -->
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">👥 Danh Sách Tài Khoản Người Dùng</div>
                <span class="badge badge-info">
                    Tổng: <asp:Label ID="lblTotalAccounts" runat="server" Text="0"></asp:Label> tài khoản
                </span>
            </div>
            <div class="content-card-body" style="padding:0;">
                <div class="table-responsive">
                    <asp:GridView ID="gvAccounts" runat="server" AutoGenerateColumns="False" 
                        CssClass="admin-grid" GridLines="None" DataKeyNames="Username"
                        OnRowCommand="gvAccounts_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="Username" HeaderText="Tên Đăng Nhập" ItemStyle-Font-Bold="true" />
                            <asp:BoundField DataField="Fullname" HeaderText="Họ và Tên" />
                            <asp:BoundField DataField="Email" HeaderText="Email" />
                            <asp:TemplateField HeaderText="Quyền Hạn" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <%# Convert.ToInt32(Eval("Permission")) == 1 ? 
                                        "<span class='badge badge-danger'>Quản trị viên (Admin)</span>" : 
                                        "<span class='badge badge-secondary'>Khách hàng (Member)</span>" %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Khóa (Lock)" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <%# Convert.ToBoolean(Eval("Lock")) ? 
                                        "<span class='badge badge-danger'>Đang bị khóa</span>" : 
                                        "<span class='badge badge-success'>Hoạt động</span>" %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Kích Hoạt" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <%# Convert.ToBoolean(Eval("Active")) ? 
                                        "<span class='badge badge-success'>Đã kích hoạt</span>" : 
                                        "<span class='badge badge-warning'>Chưa kích hoạt</span>" %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Thao Tác" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnToggleLock" runat="server" CommandName="ToggleLock" CommandArgument='<%# Eval("Username") %>' 
                                        CssClass='<%# Convert.ToBoolean(Eval("Lock")) ? "btn btn-sm btn-success" : "btn btn-sm btn-warning" %>'
                                        Text='<%# Convert.ToBoolean(Eval("Lock")) ? "Mở Khóa" : "Khóa" %>'>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteAccount" CommandArgument='<%# Eval("Username") %>' 
                                        CssClass="btn btn-sm btn-danger"
                                        OnClientClick="return confirm('Bạn có chắc chắn muốn xóa tài khoản này?');"
                                        Text="Xóa">
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
