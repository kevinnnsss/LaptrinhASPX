<%@ Page Title="Quản Lý Sản Phẩm Đồng Hồ" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageProducts.aspx.cs" Inherits="BCBTL.Admin.ManageProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headAdmin" runat="server">
    <style>
        .filter-bar { display: flex; gap: 12px; margin-bottom: 18px; align-items: center; }
        .current-img-box { margin-top: 8px; display: flex; align-items: center; gap: 10px; }
        .current-img-box img { width: 45px; height: 45px; border-radius: 4px; border: 1px solid #cbd5e0; object-fit: cover; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AdminMainContent" runat="server">
    <!-- FORM ADD / EDIT PRODUCT -->
    <div class="card-box">
        <div class="card-header-flex">
            <h3><asp:Literal ID="litFormTitle" runat="server">Thêm Đồng Hồ Mới</asp:Literal></h3>
            <asp:Button ID="btnCancelEdit" runat="server" Text="Hủy Sửa [✖]" CssClass="btn btn-secondary btn-sm" Visible="false" OnClick="btnCancelEdit_Click" />
        </div>

        <asp:HiddenField ID="hfEditProductId" runat="server" Value="" />
        <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="alert-msg alert-success"></asp:Label>

        <div class="form-grid-3">
            <div class="form-group">
                <label>Tên đồng hồ (*):</label>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="VD: Seiko Presage Cocktail Time..."></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Thương hiệu (Hãng sản xuất):</label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>

            <div class="form-group">
                <label>Phân loại Giới tính:</label>
                <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control">
                    <asp:ListItem Value="1" Selected="True">Đồng hồ Nam</asp:ListItem>
                    <asp:ListItem Value="2">Đồng hồ Nữ</asp:ListItem>
                    <asp:ListItem Value="0">Đôi / Unisex</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <div class="form-grid-3">
            <div class="form-group">
                <label>Giá bán thực tế (VNĐ) (*):</label>
                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Giá niêm yết ban đầu (VNĐ):</label>
                <asp:TextBox ID="txtOriginalPrice" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Số lượng tồn kho (Chiếc):</label>
                <asp:TextBox ID="txtStockQuantity" runat="server" CssClass="form-control" Text="20"></asp:TextBox>
            </div>
        </div>

        <div class="form-grid-2">
            <div class="form-group">
                <label>Ảnh đại diện sản phẩm:</label>
                <asp:FileUpload ID="fuProductImage" runat="server" CssClass="form-control" />
                <asp:Panel ID="pnlCurrentImg" runat="server" Visible="false" CssClass="current-img-box">
                    <asp:Image ID="imgCurrentPreview" runat="server" />
                    <span style="font-size: 12px; color: #718096;">(Để trống nếu giữ nguyên ảnh cũ)</span>
                </asp:Panel>
            </div>

            <div class="form-group">
                <label>Phần trăm giảm giá (%):</label>
                <asp:TextBox ID="txtDiscountPercent" runat="server" CssClass="form-control" Text="0"></asp:TextBox>
            </div>
        </div>

        <div class="form-group">
            <label>Mô tả tóm tắt ngắn:</label>
            <asp:TextBox ID="txtSummary" runat="server" CssClass="form-control" placeholder="Mô tả ngắn hiển thị ở card sản phẩm..."></asp:TextBox>
        </div>

        <div class="form-group">
            <label>Thông số kỹ thuật & Mô tả chi tiết (HTML):</label>
            <asp:TextBox ID="txtContents" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" placeholder="Đường kính mặt 40mm, Kính Sapphire, Chịu nước 10ATM..."></asp:TextBox>
        </div>

        <asp:Button ID="btnSaveProduct" runat="server" Text="LƯU SẢN PHẨM" CssClass="btn btn-success" OnClick="btnSaveProduct_Click" />
    </div>

    <!-- LIST OF PRODUCTS -->
    <div class="card-box">
        <div class="card-header-flex">
            <h3>Danh Sách Sản Phẩm Trong CSDL</h3>
            <div>
                <asp:Literal ID="litProductCount" runat="server">0</asp:Literal> sản phẩm
            </div>
        </div>

        <!-- SEARCH & FILTER BAR -->
        <div class="filter-bar">
            <asp:TextBox ID="txtSearchKey" runat="server" CssClass="form-control" placeholder="Tìm theo tên đồng hồ..." Width="280px"></asp:TextBox>
            <asp:DropDownList ID="ddlFilterCategory" runat="server" CssClass="form-control" Width="200px" AutoPostBack="true" OnSelectedIndexChanged="ddlFilterCategory_SelectedIndexChanged"></asp:DropDownList>
            <asp:Button ID="btnSearch" runat="server" Text="Tìm kiếm" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
            <asp:Button ID="btnResetFilter" runat="server" Text="Làm mới" CssClass="btn btn-secondary" OnClick="btnResetFilter_Click" />
        </div>

        <!-- GRIDVIEW -->
        <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" DataKeyNames="ID_P"
            CssClass="admin-table" AllowPaging="True" PageSize="8" GridLines="None"
            OnPageIndexChanging="gvProducts_PageIndexChanging" OnRowCommand="gvProducts_RowCommand">
            <Columns>
                <asp:BoundField DataField="ID_P" HeaderText="Mã" ItemStyle-Width="50px" />
                <asp:TemplateField HeaderText="Hình Ảnh" ItemStyle-Width="70px">
                    <ItemTemplate>
                        <img src='<%# ResolveUrl("~/Assets/images/products/" + (string.IsNullOrEmpty(Eval("Image") as string) ? "default-watch.jpg" : Eval("Image"))) %>' class="table-img" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Title" HeaderText="Tên Đồng Hồ" />
                <asp:BoundField DataField="CategoryName" HeaderText="Hãng" />
                <asp:TemplateField HeaderText="Giới Tính">
                    <ItemTemplate>
                        <%# Convert.ToInt32(Eval("Gender")) == 1 ? "Nam" : (Convert.ToInt32(Eval("Gender")) == 2 ? "Nữ" : "Unisex") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Giá Bán">
                    <ItemTemplate>
                        <strong style="color: #9e0b0f;"><%# string.Format("{0:N0} đ", Eval("Price")) %></strong>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Tồn Kho">
                    <ItemTemplate>
                        <span style='<%# Convert.ToInt32(Eval("StockQuantity")) <= 5 ? "color:#e53e3e;font-weight:700;" : "color:#28a745;" %>'>
                            <%# Eval("StockQuantity") %> chiếc
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Thao Tác" ItemStyle-Width="140px">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditItem" CommandArgument='<%# Eval("ID_P") %>' CssClass="btn btn-primary btn-sm">Sửa</asp:LinkButton>
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteItem" CommandArgument='<%# Eval("ID_P") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Bạn có chắc chắn muốn xóa chiếc đồng hồ này không?');">Xóa</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <PagerStyle CssClass="pagination-row" />
            <EmptyDataTemplate>
                <div style="padding: 30px; text-align: center; color: #a0aec0;">Không tìm thấy sản phẩm nào phù hợp với bộ lọc.</div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>
