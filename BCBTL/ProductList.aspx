<%@ Page Title="Danh Sách Đồng Hồ" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductList.aspx.cs" Inherits="BCBTL.ProductList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <!-- 1. BREADCRUMB -->
        <div class="breadcrumb-wrap">
            <div class="breadcrumb-list">
                <span class="breadcrumb-item"><a href="Default.aspx">Trang chủ</a></span>
                <span class="breadcrumb-separator">/</span>
                <span class="breadcrumb-item"><a href="ProductList.aspx">Đồng hồ</a></span>
                <span class="breadcrumb-separator">/</span>
                <span class="breadcrumb-item active">
                    <asp:Literal ID="litBreadcrumbCategory" runat="server">Tất cả sản phẩm</asp:Literal>
                </span>
            </div>
        </div>

        <!-- 2. CATEGORY BANNER (GIỐNG DONGHODUYANH.COM) -->
        <div class="catalog-banner">
            <h2>
                <asp:Literal ID="litCategoryTitle" runat="server">Đồng Hồ Chính Hãng Cao Cấp</asp:Literal>
            </h2>
            <p>
                <asp:Literal ID="litCategoryDescription" runat="server">
                    Hệ thống phân phối đồng hồ chính hãng hàng đầu Việt Nam. Duy Anh Watch cam kết 100% sản phẩm có nguồn gốc xuất xứ rõ ràng từ các thương hiệu danh tiếng Nhật Bản và Thụy Sĩ, bảo hành 5 năm độc quyền.
                </asp:Literal>
            </p>
        </div>

        <!-- 3. MAIN CATALOG LAYOUT (SIDEBAR FILTER + PRODUCT GRID) -->
        <div class="catalog-layout">
            <!-- LEFT SIDEBAR: BỘ LỌC SẢN PHẨM THÔNG MINH -->
            <aside class="catalog-sidebar">
                <div class="sidebar-heading">
                    <span>Bộ Lọc Sản Phẩm</span>
                    <asp:HyperLink ID="lnkClearFilters" runat="server" NavigateUrl="ProductList.aspx" Visible="false" 
                        CssClass="filter-clear-btn" style="font-size:11px; color:#990000; text-transform:none; font-weight:600;">
                        [Xóa lọc ✕]
                    </asp:HyperLink>
                </div>

                <!-- Lọc theo Giới tính -->
                <div class="filter-group">
                    <div class="filter-title">Giới Tính</div>
                    <ul class="filter-list">
                        <li class="filter-item">
                            <asp:HyperLink ID="lnkGenderAll" runat="server" CssClass="filter-link">
                                <span>Tất cả</span>
                                <span class="filter-count"><asp:Literal ID="litCountAll" runat="server">0</asp:Literal></span>
                            </asp:HyperLink>
                        </li>
                        <li class="filter-item">
                            <asp:HyperLink ID="lnkGenderMen" runat="server" CssClass="filter-link">
                                <span>Đồng hồ Nam</span>
                                <span class="filter-count"><asp:Literal ID="litCountMen" runat="server">0</asp:Literal></span>
                            </asp:HyperLink>
                        </li>
                        <li class="filter-item">
                            <asp:HyperLink ID="lnkGenderWomen" runat="server" CssClass="filter-link">
                                <span>Đồng hồ Nữ</span>
                                <span class="filter-count"><asp:Literal ID="litCountWomen" runat="server">0</asp:Literal></span>
                            </asp:HyperLink>
                        </li>
                        <li class="filter-item">
                            <asp:HyperLink ID="lnkGenderUnisex" runat="server" CssClass="filter-link">
                                <span>Unisex / Cặp đôi</span>
                                <span class="filter-count"><asp:Literal ID="litCountUnisex" runat="server">0</asp:Literal></span>
                            </asp:HyperLink>
                        </li>
                    </ul>
                </div>

                <!-- Lọc theo Thương hiệu -->
                <div class="filter-group">
                    <div class="filter-title">Thương Hiệu</div>
                    <ul class="filter-list">
                        <asp:Repeater ID="rptBrandFilter" runat="server">
                            <ItemTemplate>
                                <li class="filter-item">
                                    <a href='<%# GetFilterUrl("idmn", Eval("ID_MN").ToString()) %>' 
                                       class='<%# "filter-link " + (CurrentBrandId == Convert.ToInt32(Eval("ID_MN")) ? "active" : "") %>'>
                                        <span><%# Eval("Lable") %></span>
                                        <span class="filter-count"><%# Eval("ProductCount") %></span>
                                    </a>
                                </li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                </div>

                <!-- Lọc theo Mức giá -->
                <div class="filter-group">
                    <div class="filter-title">Mức Giá (VNĐ)</div>
                    <ul class="filter-list">
                        <li class="filter-item">
                            <a href='<%# GetFilterUrl("price", "") %>' class='<%# "filter-link " + (string.IsNullOrEmpty(CurrentPriceRange) ? "active" : "") %>'>
                                <span>Tất cả mức giá</span>
                            </a>
                        </li>
                        <li class="filter-item">
                            <a href='<%# GetFilterUrl("price", "under3") %>' class='<%# "filter-link " + (CurrentPriceRange == "under3" ? "active" : "") %>'>
                                <span>Dưới 3.000.000 đ</span>
                            </a>
                        </li>
                        <li class="filter-item">
                            <a href='<%# GetFilterUrl("price", "3to5") %>' class='<%# "filter-link " + (CurrentPriceRange == "3to5" ? "active" : "") %>'>
                                <span>3.000.000 - 5.000.000 đ</span>
                            </a>
                        </li>
                        <li class="filter-item">
                            <a href='<%# GetFilterUrl("price", "5to10") %>' class='<%# "filter-link " + (CurrentPriceRange == "5to10" ? "active" : "") %>'>
                                <span>5.000.000 - 10.000.000 đ</span>
                            </a>
                        </li>
                        <li class="filter-item">
                            <a href='<%# GetFilterUrl("price", "over10") %>' class='<%# "filter-link " + (CurrentPriceRange == "over10" ? "active" : "") %>'>
                                <span>Trên 10.000.000 đ</span>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- Advisor Support Box -->
                <div class="sidebar-advisor-box">
                    <h5>Tư Vấn Chọn Mua</h5>
                    <p>Chuyên gia Duy Anh Watch sẵn sàng hỗ trợ bạn chọn mẫu đồng hồ phù hợp với cổ tay và phong cách.</p>
                    <a href="tel:18000091" class="advisor-btn">📞 1800 0091 (Miễn phí)</a>
                </div>
            </aside>

            <!-- RIGHT: CATALOG MAIN CONTENT -->
            <section class="catalog-content">
                <!-- Toolbar: Results Count & Sort Dropdown -->
                <div class="catalog-toolbar">
                    <div class="results-count">
                        Hiển thị <b><asp:Literal ID="litResultCount" runat="server">0</asp:Literal></b> mẫu đồng hồ chính hãng
                    </div>

                    <div class="sort-group">
                        <label for="ddlSort" class="sort-label">Sắp xếp theo:</label>
                        <asp:DropDownList ID="ddlSort" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSort_SelectedIndexChanged" CssClass="sort-select">
                            <asp:ListItem Value="newest" Text="Mới nhất"></asp:ListItem>
                            <asp:ListItem Value="price-asc" Text="Giá: Thấp đến Cao"></asp:ListItem>
                            <asp:ListItem Value="price-desc" Text="Giá: Cao xuống Thấp"></asp:ListItem>
                            <asp:ListItem Value="name-asc" Text="Tên: A - Z"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <!-- Product Grid -->
                <div class="product-grid" id="pnlProductGrid" runat="server">
                    <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
                        <ItemTemplate>
                            <div class="product-card">
                                <div class="product-thumb-wrap">
                                    <%# Convert.ToInt32(Eval("DiscountPercent")) > 0 ? "<span class='badge-discount'>-" + Eval("DiscountPercent") + "%</span>" : "" %>
                                    <span class="badge-auth-tag">Chính Hãng</span>
                                    <a href='<%# "ProductDetail.aspx?id=" + Eval("ID_P") %>'>
                                        <img src='<%# ResolveUrl("~/Assets/images/products/" + (string.IsNullOrEmpty(Eval("Image") as string) ? "default-watch.jpg" : Eval("Image"))) %>' 
                                             alt='<%# Eval("Title") %>' class="product-thumb" />
                                    </a>
                                </div>

                                <div class="product-info">
                                    <span class="product-brand"><%# Eval("BrandName") %></span>
                                    <h3 class="product-title">
                                        <a href='<%# "ProductDetail.aspx?id=" + Eval("ID_P") %>' title='<%# Eval("Title") %>'>
                                            <%# Eval("Title") %>
                                        </a>
                                    </h3>

                                    <div class="product-rating">
                                        ★★★★★ <span class="rating-count">(5.0)</span>
                                    </div>

                                    <div class="product-price-box">
                                        <span class="price-current"><%# string.Format("{0:N0} đ", Eval("Price")) %></span>
                                        <%# Convert.ToDecimal(Eval("OriginalPrice")) > Convert.ToDecimal(Eval("Price")) ? "<span class='price-original'>" + string.Format("{0:N0} đ", Eval("OriginalPrice")) + "</span>" : "" %>
                                    </div>

                                    <div class='<%# "stock-status " + (Convert.ToInt32(Eval("StockQuantity")) > 0 ? "in-stock" : "out-of-stock") %>'>
                                        <%# Convert.ToInt32(Eval("StockQuantity")) > 0 ? "✔ Còn hàng (" + Eval("StockQuantity") + " chiếc)" : "✖ Tạm hết hàng" %>
                                    </div>

                                    <div class="product-actions">
                                        <a href='<%# "ProductDetail.aspx?id=" + Eval("ID_P") %>' class="btn-view-detail">Chi tiết</a>
                                        <asp:Button ID="btnAddToCart" runat="server" Text="Thêm giỏ" CssClass="btn-add-cart" 
                                            CommandName="AddToCart" CommandArgument='<%# Eval("ID_P") %>' 
                                            Enabled='<%# Convert.ToInt32(Eval("StockQuantity")) > 0 %>' />
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <!-- Empty State -->
                <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-results">
                    <div class="empty-icon">🔍</div>
                    <h3>Không tìm thấy sản phẩm phù hợp</h3>
                    <p>Rất tiếc, hiện tại không có mẫu đồng hồ nào thỏa mãn tất cả tiêu chí bộ lọc của bạn. Bạn vui lòng thử xóa bớt bộ lọc hoặc tìm kiếm với từ khóa khác.</p>
                    <a href="ProductList.aspx" class="btn-add-cart" style="display:inline-block; padding:10px 24px; font-size:13px;">
                        Xem tất cả đồng hồ
                    </a>
                </asp:Panel>
            </section>
        </div>
    </div>
</asp:Content>
