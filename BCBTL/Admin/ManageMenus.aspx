<%@ Page Title="Quản Lý Danh Mục Menu" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageMenus.aspx.cs" Inherits="BCBTL.Admin.ManageMenus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headAdmin" runat="server">
    <style>
        .menu-layout {
            display: grid;
            grid-template-columns: 380px 1fr;
            gap: 24px;
        }
        @media (max-width: 992px) {
            .menu-layout {
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

    <div class="menu-layout">
        <!-- FORM THÊM / SỬA DANH MỤC -->
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">
                    <asp:Literal ID="litFormTitle" runat="server">➕ Thêm Danh Mục Mới</asp:Literal>
                </div>
            </div>
            <div class="content-card-body">
                <asp:HiddenField ID="hfMenuId" runat="server" Value="0" />

                <div class="form-group">
                    <label>Tên / Tiêu đề hiển thị <span class="required">(*)</span>:</label>
                    <asp:TextBox ID="txtLable" runat="server" CssClass="form-control" placeholder="Ví dụ: Casio, Seiko, Đồng hồ Nam..."></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Danh mục cha (Cấp trên):</label>
                    <asp:DropDownList ID="ddlParent" runat="server" CssClass="form-control">
                    </asp:DropDownList>
                    <small style="color:#64748b; font-size:11px;">Chọn "Danh mục gốc" nếu là mục menu cấp 1 trên thanh điều hướng.</small>
                </div>

                <div class="form-group">
                    <label>Vị trí hiển thị (Pos):</label>
                    <asp:DropDownList ID="ddlPos" runat="server" CssClass="form-control">
                        <asp:ListItem Value="1" Selected="True">1 - Menu ngang Header chính</asp:ListItem>
                        <asp:ListItem Value="2">2 - Menu Sidebar / Danh mục hãng</asp:ListItem>
                        <asp:ListItem Value="3">3 - Menu chân trang (Footer)</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label>Đường dẫn liên kết (URL):</label>
                    <asp:TextBox ID="txtUrlLink" runat="server" CssClass="form-control" placeholder="Ví dụ: ProductList.aspx?idmn=7 hoặc #"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Thứ tự hiển thị (OrderKey):</label>
                    <asp:TextBox ID="txtOrderKey" runat="server" CssClass="form-control" Text="1" TextMode="Number"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label style="display:flex; align-items:center; gap:8px; cursor:pointer;">
                        <asp:CheckBox ID="chkHide" runat="server" />
                        <span>Ẩn danh mục này khỏi website (Hide = 1)</span>
                    </label>
                </div>

                <div style="display:flex; gap:10px; margin-top:20px;">
                    <asp:Button ID="btnSaveMenu" runat="server" Text="Lưu Danh Mục" CssClass="btn btn-primary" style="flex:1;" OnClick="btnSaveMenu_Click" />
                    <asp:Button ID="btnCancelEdit" runat="server" Text="Hủy / Làm Mới" CssClass="btn btn-secondary" OnClick="btnCancelEdit_Click" />
                </div>
            </div>
        </div>

        <!-- BẢNG DANH SÁCH MENU HIỆN TẠI -->
        <div class="content-card">
            <div class="content-card-header">
                <div class="content-card-title">🏷️ Danh Sách Menu & Phân Cấp Cây Thư Mục</div>
                <span class="badge badge-info">
                    Tổng: <asp:Label ID="lblTotalMenus" runat="server" Text="0"></asp:Label> danh mục
                </span>
            </div>
            <div class="content-card-body" style="padding:0;">
                <div class="table-responsive">
                    <asp:GridView ID="gvMenus" runat="server" AutoGenerateColumns="False" 
                        CssClass="admin-grid" GridLines="None" DataKeyNames="ID_MN" 
                        OnRowCommand="gvMenus_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="ID_MN" HeaderText="ID" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center" />
                            <asp:TemplateField HeaderText="Tên Danh Mục">
                                <ItemTemplate>
                                    <div style='<%# Convert.ToInt32(Eval("Parent")) > 0 ? "padding-left: 20px; font-weight: 500;" : "font-weight: 700; color: #1e293b;" %>'>
                                        <%# Convert.ToInt32(Eval("Parent")) > 0 ? "↳ " : "📁 " %>
                                        <%# Eval("Lable") %>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Cấp Cha">
                                <ItemTemplate>
                                    <%# Convert.ToInt32(Eval("Parent")) == 0 ? "<span class='badge badge-secondary'>Danh mục gốc</span>" : Eval("ParentName") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Vị Trí" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <span class="badge badge-info"><%# GetPosName(Convert.ToInt32(Eval("Pos"))) %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="UrlLink" HeaderText="Liên Kết" />
                            <asp:BoundField DataField="OrderKey" HeaderText="Thứ Tự" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center" />
                            <asp:TemplateField HeaderText="Trạng Thái" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <%# Convert.ToBoolean(Eval("Hide")) ? "<span class='badge badge-danger'>Đang ẩn</span>" : "<span class='badge badge-success'>Hiển thị</span>" %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Thao Tác" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditMenu" CommandArgument='<%# Eval("ID_MN") %>' CssClass="btn btn-sm btn-warning">Sửa</asp:LinkButton>
                                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteMenu" CommandArgument='<%# Eval("ID_MN") %>' CssClass="btn btn-sm btn-danger"
                                        OnClientClick="return confirm('Bạn có chắc chắn muốn xóa/ẩn danh mục này không?');">Xóa</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
