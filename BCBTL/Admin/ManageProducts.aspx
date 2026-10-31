<%@ Page Title="Quản Lý Sản Phẩm Đồng Hồ" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageProducts.aspx.cs" Inherits="BCBTL.Admin.ManageProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headAdmin" runat="server">
    <style>
        .form-section {
            background-color: #ffffff;
            border: 1px solid var(--admin-border);
            border-radius: var(--admin-radius);
            box-shadow: var(--admin-shadow);
            margin-bottom: 24px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AdminMainContent" runat="server">
    <!-- THÔNG BÁO HỆ THỐNG -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert">
        <asp:Label ID="lblAlertMsg" runat="server"></asp:Label>
    </asp:Panel>

    <!-- FORM THÊM MỚI / CHỈNH SỬA SẢN PHẨM -->
    <div class="form-section">
        <div class="content-card-header">
            <div class="content-card-title">
                <asp:Literal ID="litFormTitle" runat="server">➕ Thêm Sản Phẩm Đồng Hồ Mới</asp:Literal>
            </div>
            <asp:Label ID="lblEditModeNotice" runat="server" CssClass="badge badge-warning" Visible="false">Đang ở chế độ chỉnh sửa</asp:Label>
        </div>
        <div class="content-card-body">
            <asp:HiddenField ID="hfProductId" runat="server" Value="0" />
            <asp:HiddenField ID="hfCurrentImage" runat="server" Value="" />

            <!-- Dòng 1: Tên sản phẩm, Thương hiệu, Giới tính, Loại -->
            <div class="form-grid-4">
                <div class="form-group" style="grid-column: span 2;">
                    <label>Tên đồng hồ <span class="required">(*)</span>:</label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Ví dụ: Đồng hồ Nam Casio Edifice EFR-539D-1AV"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Thương hiệu (Hãng) <span class="required">(*)</span>:</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Phân loại giới tính:</label>
                    <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control">
                        <asp:ListItem Value="1" Selected="True">Đồng hồ Nam (1)</asp:ListItem>
                        <asp:ListItem Value="2">Đồng hồ Nữ (2)</asp:ListItem>
                        <asp:ListItem Value="0">Unisex / Đôi (0)</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <!-- Dòng 2: Giá bán, Giá gốc, % Giảm, Số lượng tồn kho -->
            <div class="form-grid-4">
                <div class="form-group">
                    <label>Giá bán thực tế (VNĐ) <span class="required">(*)</span>:</label>
                    <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" Text="0" TextMode="Number"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Giá niêm yết gốc (VNĐ):</label>
                    <asp:TextBox ID="txtOriginalPrice" runat="server" CssClass="form-control" Text="0" TextMode="Number"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Giảm giá (%):</label>
                    <asp:TextBox ID="txtDiscountPercent" runat="server" CssClass="form-control" Text="0" TextMode="Number"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Số lượng tồn kho <span class="required">(*)</span>:</label>
                    <asp:TextBox ID="txtStockQuantity" runat="server" CssClass="form-control" Text="20" TextMode="Number"></asp:TextBox>
                </div>
            </div>

            <!-- Dòng 3: Upload ảnh & Trạng thái ẩn -->
            <div class="form-grid-2">
                <div class="form-group">
                    <label>Hình ảnh đại diện sản phẩm:</label>
                    <asp:FileUpload ID="fuProductImage" runat="server" CssClass="form-control" />
                    <small style="color:#64748b; font-size:11px;">Hỗ trợ: .jpg, .png, .jpeg, .webp. Ảnh sẽ lưu vào thư mục <code>/Assets/images/products/</code>.</small>
                    
                    <asp:Panel ID="pnlCurrentPreview" runat="server" Visible="false" CssClass="image-preview-box">
                        <span>Ảnh hiện tại:</span>
                        <asp:Image ID="imgCurrentPreview" runat="server" CssClass="image-preview-thumb" />
                        <asp:Label ID="lblCurrentImgName" runat="server" Font-Size="11px" ForeColor="#64748b"></asp:Label>
                    </asp:Panel>
                </div>

                <div class="form-group">
                    <label>Cài đặt hiển thị & Loại nội dung:</label>
                    <div style="margin-bottom:10px;">
                        <label style="display:inline-flex; align-items:center; gap:8px; cursor:pointer;">
                            <asp:CheckBox ID="chkHide" runat="server" />
                            <span>Ẩn sản phẩm này khỏi website (Hide = 1)</span>
                        </label>
                    </div>
                    <div>
                        <label>Loại mục (ItemType):</label>
                        <asp:DropDownList ID="ddlItemType" runat="server" CssClass="form-control" style="width:220px; display:inline-block;">
                            <asp:ListItem Value="1" Selected="True">1 - Sản phẩm Đồng Hồ</asp:ListItem>
                            <asp:ListItem Value="2">2 - Tin tức / Bài viết</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <!-- Dòng 4: Mô tả ngắn (Summary) & Thông số kỹ thuật (Contents) -->
            <div class="form-group">
                <label>Mô tả ngắn / Tóm tắt sản phẩm <small style="color:#64748b;">(Quy chuẩn v2: CHỈ chứa mô tả, không chứa giá)</small>:</label>
                <asp:TextBox ID="txtSummary" runat="server" CssClass="form-control" placeholder="Mô tả tóm tắt nổi bật của chiếc đồng hồ..."></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Thông số kỹ thuật / Nội dung chi tiết:</label>
                <asp:TextBox ID="txtContents" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" 
                    placeholder="Đường kính mặt, Loại máy Quartz/Automatic, Chất liệu vỏ thép không gỉ 316L, Kính Sapphire, Kháng nước..."></asp:TextBox>
            </div>

            <div style="display:flex; gap:12px; margin-top:16px;">
                <asp:Button ID="btnSaveProduct" runat="server" Text="Lưu Sản Phẩm" CssClass="btn btn-primary" OnClick="btnSaveProduct_Click" />
                <asp:Button ID="btnCancelEdit" runat="server" Text="Hủy / Làm Mới Form" CssClass="btn btn-secondary" OnClick="btnCancelEdit_Click" />
            </div>
        </div>
    </div>

    <!-- DANH SÁCH SẢN PHẨM & BỘ LỌC TÌM KIẾM -->
    <div class="content-card">
        <div class="content-card-header">
            <div class="content-card-title">⌚ Danh Sách Đồng Hồ Trong Hệ Thống</div>
            <span class="badge badge-info">
                Tổng: <asp:Label ID="lblTotalCount" runat="server" Text="0"></asp:Label> sản phẩm
            </span>
        </div>
        <div class="content-card-body">
            <!-- BỘ LỌC TÌM KIẾM -->
            <div class="filter-bar">
                <asp:TextBox ID="txtSearchKeyword" runat="server" CssClass="form-control" placeholder="Tìm theo tên đồng hồ..." style="min-width:220px;"></asp:TextBox>
                <asp:DropDownList ID="ddlFilterBrand" runat="server" CssClass="form-control">
                </asp:DropDownList>
                <asp:DropDownList ID="ddlFilterGender" runat="server" CssClass="form-control">
                    <asp:ListItem Value="-1">-- Mọi giới tính --</asp:ListItem>
                    <asp:ListItem Value="1">Nam</asp:ListItem>
                    <asp:ListItem Value="2">Nữ</asp:ListItem>
                    <asp:ListItem Value="0">Unisex</asp:ListItem>
                </asp:DropDownList>
                <asp:DropDownList ID="ddlFilterStatus" runat="server" CssClass="form-control">
                    <asp:ListItem Value="-1">-- Mọi trạng thái --</asp:ListItem>
                    <asp:ListItem Value="0">Đang hiển thị</asp:ListItem>
                    <asp:ListItem Value="1">Đang ẩn</asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="btnFilter" runat="server" Text="🔍 Lọc Dữ Liệu" CssClass="btn btn-primary btn-sm" OnClick="btnFilter_Click" />
                <asp:Button ID="btnResetFilter" runat="server" Text="↺ Làm Mới Bộ Lọc" CssClass="btn btn-secondary btn-sm" OnClick="btnResetFilter_Click" />
            </div>

            <!-- BẢNG GRIDVIEW SẢN PHẨM -->
            <div class="table-responsive">
                <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" 
                    CssClass="admin-grid" GridLines="None" DataKeyNames="ID_P"
                    AllowPaging="True" PageSize="8" 
                    OnPageIndexChanging="gvProducts_PageIndexChanging" 
                    OnRowCommand="gvProducts_RowCommand"
                    EmptyDataText="Không tìm thấy sản phẩm nào phù hợp với điều kiện tìm kiếm.">
                    <PagerStyle CssClass="grid-pager" HorizontalAlign="Center" />
                    <Columns>
                        <asp:BoundField DataField="ID_P" HeaderText="Mã ID" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center" />
                        <asp:TemplateField HeaderText="Ảnh" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                            <ItemTemplate>
                                <img src='<%# ResolveUrl("~/Assets/images/products/" + (string.IsNullOrEmpty(Eval("Image") as string) ? "default-watch.jpg" : Eval("Image"))) %>' 
                                     alt='<%# Eval("Title") %>' class="grid-thumb" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tên Đồng Hồ & Thương Hiệu">
                            <ItemTemplate>
                                <div style="font-weight:700; color:#1e293b; margin-bottom:4px;"><%# Eval("Title") %></div>
                                <div style="display:flex; gap:6px; align-items:center;">
                                    <span class="badge badge-info"><%# Eval("CategoryName") %></span>
                                    <span class='<%# GetGenderBadgeClass(Convert.ToInt32(Eval("Gender"))) %>'>
                                        <%# GetGenderName(Convert.ToInt32(Eval("Gender"))) %>
                                    </span>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Giá Bán (VNĐ)" ItemStyle-CssClass="text-right" HeaderStyle-CssClass="text-right">
                            <ItemTemplate>
                                <div style="font-weight:800; color:var(--admin-primary);">
                                    <%# string.Format("{0:N0} đ", Eval("Price")) %>
                                </div>
                                <%# Convert.ToDecimal(Eval("OriginalPrice")) > Convert.ToDecimal(Eval("Price")) ? 
                                    "<small style='color:#94a3b8; text-decoration:line-through;'>" + string.Format("{0:N0} đ", Eval("OriginalPrice")) + "</small>" : "" %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tồn Kho" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                            <ItemTemplate>
                                <span class='<%# Convert.ToInt32(Eval("StockQuantity")) > 5 ? "badge badge-success" : (Convert.ToInt32(Eval("StockQuantity")) > 0 ? "badge badge-warning" : "badge badge-danger") %>'>
                                    <%# Convert.ToInt32(Eval("StockQuantity")) > 0 ? Eval("StockQuantity") + " chiếc" : "Hết hàng" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Trạng Thái" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                            <ItemTemplate>
                                <%# Convert.ToBoolean(Eval("Hide")) ? 
                                    "<span class='badge badge-danger'>Đang ẩn</span>" : 
                                    "<span class='badge badge-success'>Đang bán</span>" %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Thao Tác" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditProduct" CommandArgument='<%# Eval("ID_P") %>' CssClass="btn btn-sm btn-warning">Sửa</asp:LinkButton>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteProduct" CommandArgument='<%# Eval("ID_P") %>' CssClass="btn btn-sm btn-danger"
                                    OnClientClick="return confirm('Bạn có chắc chắn muốn xóa/ẩn sản phẩm này khỏi hệ thống không?');">Xóa / Ẩn</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
