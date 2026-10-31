<%@ Page Title="Quản Lý Danh Mục & Thương Hiệu" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageMenus.aspx.cs" Inherits="BCBTL.Admin.ManageMenus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headAdmin" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AdminMainContent" runat="server">
    <!-- FORM ADD / EDIT MENU -->
    <div class="card-box">
        <div class="card-header-flex">
            <h3><asp:Literal ID="litFormTitle" runat="server">Thêm Danh Mục / Thương Hiệu Mới</asp:Literal></h3>
            <asp:Button ID="btnCancelEdit" runat="server" Text="Hủy Sửa [✖]" CssClass="btn btn-secondary btn-sm" Visible="false" OnClick="btnCancelEdit_Click" />
        </div>

        <asp:HiddenField ID="hfEditMenuId" runat="server" Value="" />
        <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="alert-msg alert-success"></asp:Label>

        <div class="form-grid-3">
            <div class="form-group">
                <label>Tên Menu / Nhãn (*):</label>
                <asp:TextBox ID="txtLable" runat="server" CssClass="form-control" placeholder="VD: CASIO, SEIKO, ĐỒNG HỒ NAM..."></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Cấp Menu (Menu Cha):</label>
                <asp:DropDownList ID="ddlParentMenu" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>

            <div class="form-group">
                <label>Thứ Tự Sắp Xếp (OrderKey):</label>
                <asp:TextBox ID="txtOrderKey" runat="server" CssClass="form-control" Text="1"></asp:TextBox>
            </div>
        </div>

        <div class="form-grid-2">
            <div class="form-group">
                <label>Đường dẫn liên kết (URL):</label>
                <asp:TextBox ID="txtLink" runat="server" CssClass="form-control" placeholder="VD: ProductList.aspx?idmn=7 hoặc #"></asp:TextBox>
            </div>

            <div class="form-group" style="display: flex; align-items: center; gap: 10px; margin-top: 28px;">
                <asp:CheckBox ID="chkHide" runat="server" Text=" Tạm ẩn khỏi website" />
            </div>
        </div>

        <asp:Button ID="btnSaveMenu" runat="server" Text="LƯU DANH MỤC" CssClass="btn btn-success" OnClick="btnSaveMenu_Click" />
    </div>

    <!-- LIST OF MENUS -->
    <div class="card-box">
        <div class="card-header-flex">
            <h3>Cây Danh Mục & Thương Hiệu Trên Website</h3>
        </div>

        <asp:GridView ID="gvMenus" runat="server" AutoGenerateColumns="False" DataKeyNames="ID_MN"
            CssClass="admin-table" AllowPaging="True" PageSize="10" GridLines="None"
            OnPageIndexChanging="gvMenus_PageIndexChanging" OnRowCommand="gvMenus_RowCommand">
            <Columns>
                <asp:BoundField DataField="ID_MN" HeaderText="Mã ID" ItemStyle-Width="60px" />
                <asp:TemplateField HeaderText="Tên Danh Mục / Nhãn">
                    <ItemTemplate>
                        <strong style='<%# Convert.ToInt32(Eval("Parent")) == 0 ? "color:#1a365d;font-size:14px;" : "padding-left:20px;color:#4a5568;" %>'>
                            <%# Convert.ToInt32(Eval("Parent")) == 0 ? "📁 " : "↳ 🏷️ " %><%# Eval("Lable") %>
                        </strong>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="ParentName" HeaderText="Cấp Trực Thuộc" />
                <asp:BoundField DataField="UrlLink" HeaderText="Liên Kết (URL)" />
                <asp:BoundField DataField="OrderKey" HeaderText="Thứ Tự" ItemStyle-HorizontalAlign="Center" />
                <asp:TemplateField HeaderText="Trạng Thái">
                    <ItemTemplate>
                        <span class='status-badge <%# Convert.ToBoolean(Eval("Hide")) ? "status-cancelled" : "status-completed" %>'>
                            <%# Convert.ToBoolean(Eval("Hide")) ? "Đang ẩn" : "Hiển thị" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Thao Tác" ItemStyle-Width="140px">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditMenu" CommandArgument='<%# Eval("ID_MN") %>' CssClass="btn btn-primary btn-sm">Sửa</asp:LinkButton>
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteMenu" CommandArgument='<%# Eval("ID_MN") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Bạn có chắc chắn muốn xóa danh mục này?');">Xóa</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <PagerStyle CssClass="pagination-row" />
        </asp:GridView>
    </div>
</asp:Content>
