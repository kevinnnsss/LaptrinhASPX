<%@ Page Title="Quản Lý Tài Khoản & Phân Quyền" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageAccounts.aspx.cs" Inherits="BCBTL.Admin.ManageAccounts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headAdmin" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AdminMainContent" runat="server">
    <!-- FORM ADD NEW ACCOUNT -->
    <div class="card-box">
        <div class="card-header-flex">
            <h3>Tạo Tài Khoản Mới</h3>
        </div>

        <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="alert-msg alert-success"></asp:Label>

        <div class="form-grid-3">
            <div class="form-group">
                <label>Tên đăng nhập (Username) (*):</label>
                <asp:TextBox ID="txtNewUsername" runat="server" CssClass="form-control" placeholder="Viết liền không dấu..."></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Mật khẩu (*):</label>
                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Nhập mật khẩu..."></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Phân quyền hệ thống:</label>
                <asp:DropDownList ID="ddlNewRole" runat="server" CssClass="form-control">
                    <asp:ListItem Value="2" Selected="True">Khách Hàng (Thành viên - Permission = 2)</asp:ListItem>
                    <asp:ListItem Value="1">Quản Trị Viên (Admin - Permission = 1)</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <div class="form-grid-2">
            <div class="form-group">
                <label>Họ và tên đầy đủ (*):</label>
                <asp:TextBox ID="txtNewFullname" runat="server" CssClass="form-control" placeholder="VD: Nguyễn Văn A..."></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Email liên hệ:</label>
                <asp:TextBox ID="txtNewEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="email@gmail.com..."></asp:TextBox>
            </div>
        </div>

        <asp:Button ID="btnCreateAccount" runat="server" Text="TẠO TÀI KHOẢN MỚI" CssClass="btn btn-success" OnClick="btnCreateAccount_Click" />
    </div>

    <!-- LIST OF ACCOUNTS -->
    <div class="card-box">
        <div class="card-header-flex">
            <h3>Danh Sách Tài Khoản Trong CSDL</h3>
        </div>

        <asp:GridView ID="gvAccounts" runat="server" AutoGenerateColumns="False" DataKeyNames="Username"
            CssClass="admin-table" AllowPaging="True" PageSize="10" GridLines="None"
            OnPageIndexChanging="gvAccounts_PageIndexChanging" OnRowCommand="gvAccounts_RowCommand">
            <Columns>
                <asp:BoundField DataField="Username" HeaderText="Tên Đăng Nhập" />
                <asp:BoundField DataField="Fullname" HeaderText="Họ và Tên" />
                <asp:BoundField DataField="Email" HeaderText="Email" />
                <asp:TemplateField HeaderText="Quyền Hạn">
                    <ItemTemplate>
                        <span class='status-badge <%# Convert.ToInt32(Eval("Permission")) == 1 ? "status-confirmed" : "status-completed" %>'>
                            <%# Convert.ToInt32(Eval("Permission")) == 1 ? "👑 Quản Trị Viên" : "👤 Khách Hàng" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Trạng Thái">
                    <ItemTemplate>
                        <span class='status-badge <%# Convert.ToBoolean(Eval("Lock")) ? "status-cancelled" : "status-completed" %>'>
                            <%# Convert.ToBoolean(Eval("Lock")) ? "Đang Bị Khóa" : "Hoạt Động" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Thao Tác" ItemStyle-Width="220px">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnToggleLock" runat="server" CommandName="ToggleLock" CommandArgument='<%# Eval("Username") %>' 
                            CssClass='<%# Convert.ToBoolean(Eval("Lock")) ? "btn btn-success btn-sm" : "btn btn-danger btn-sm" %>'>
                            <%# Convert.ToBoolean(Eval("Lock")) ? "Mở Khóa" : "Khóa Lại" %>
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnResetPass" runat="server" CommandName="ResetPassword" CommandArgument='<%# Eval("Username") %>' 
                            CssClass="btn btn-secondary btn-sm" OnClientClick="return confirm('Đặt lại mật khẩu tài khoản này về 123456?');">
                            Reset Pass
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <PagerStyle CssClass="pagination-row" />
        </asp:GridView>
    </div>
</asp:Content>
