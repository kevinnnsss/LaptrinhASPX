<%@ Page Title="Trang Chủ" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BCBTL.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <!-- 1. HERO TRAILER VIDEO BANNER -->
        <div class="hero-trailer-container">
            <div class="hero-trailer-wrapper">
                <video id="heroTrailerVideo" class="hero-trailer-player" autoplay="autoplay" muted="muted" loop="loop" playsinline="playsinline" controls="controls" poster="Assets/images/banners/banner1.jpg">
                    <source src="trailer/trailer.mp4" type="video/mp4" />
                    Trình duyệt của bạn không hỗ trợ thẻ video HTML5.
                </video>
                <div class="hero-trailer-overlay">
                    <div class="hero-trailer-tag">
                        <span class="trailer-live-dot"></span> 🎬 TRAILER BỘ SƯU TẬP ĐỒNG HỒ 2026
                    </div>
                    <div class="hero-trailer-controls">
                        <button type="button" id="btnToggleSound" class="btn-trailer-sound" title="Bật / Tắt âm thanh">
                            <span id="soundIcon">🔇</span> <span id="soundText">Bật âm thanh</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2. BRAND BAR (THƯƠNG HIỆU HÀNG ĐẦU) -->
        <div class="brand-bar">
            <div class="brand-bar-title">
                <span>Thương hiệu phân phối ủy quyền chính hãng</span>
                <a href="ProductList.aspx" style="color:var(--primary-color); font-weight:700;">Xem tất cả ▶</a>
            </div>
            <div class="brand-bar-grid">
                <a href="ProductList.aspx?idmn=7" class="brand-bar-item">CASIO NHẬT BẢN</a>
                <a href="ProductList.aspx?idmn=8" class="brand-bar-item">SEIKO HUYỀN THOẠI</a>
                <a href="ProductList.aspx?idmn=9" class="brand-bar-item">CITIZEN ECO-DRIVE</a>
                <a href="ProductList.aspx?idmn=10" class="brand-bar-item">ROLEX THỤY SĨ</a>
            </div>
        </div>

        <!-- 3. SECTION: ĐỒNG HỒ NAM NỔI BẬT (GENDER = 1) -->
        <section class="section-wrap">
            <div class="section-header">
                <h2 class="section-title">
                    <span>👑</span> ĐỒNG HỒ NAM BÁN CHẠY NHẤT
                </h2>
                <a href="ProductList.aspx?gender=1" class="section-view-all">Xem tất cả đồng hồ nam ▶</a>
            </div>

            <div class="product-grid">
                <asp:Repeater ID="rptMenWatches" runat="server" OnItemCommand="rptProducts_ItemCommand">
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
        </section>

        <!-- 4. SECTION: BỘ SƯU TẬP MỚI NHẤT (6 MẪU MỚI NHẤT ITEMTYPE = 1) -->
        <section class="section-wrap">
            <div class="section-header">
                <h2 class="section-title">
                    <span>✨</span> SẢN PHẨM MỚI VỀ
                </h2>
                <a href="ProductList.aspx" class="section-view-all">Xem toàn bộ bộ sưu tập ▶</a>
            </div>

            <div class="product-grid">
                <asp:Repeater ID="rptNewWatches" runat="server" OnItemCommand="rptProducts_ItemCommand">
                    <ItemTemplate>
                        <div class="product-card">
                            <div class="product-thumb-wrap">
                                <%# Convert.ToInt32(Eval("DiscountPercent")) > 0 ? "<span class='badge-discount'>-" + Eval("DiscountPercent") + "%</span>" : "" %>
                                <span class="badge-auth-tag">New 2026</span>
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
        </section>

        <!-- 5. SECTION: ĐỒNG HỒ NỮ QUYẾN RŨ (GENDER = 2) -->
        <section class="section-wrap">
            <div class="section-header">
                <h2 class="section-title">
                    <span>💎</span> ĐỒNG HỒ NỮ CAO CẤP & QUYẾN RŨ
                </h2>
                <a href="ProductList.aspx?gender=2" class="section-view-all">Xem tất cả đồng hồ nữ ▶</a>
            </div>

            <div class="product-grid">
                <asp:Repeater ID="rptWomenWatches" runat="server" OnItemCommand="rptProducts_ItemCommand">
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
        </section>

        <!-- 6. SECTION: TIN TỨC & KIẾN THỨC ĐỒNG HỒ (ITEMTYPE = 2, HIDE = 0, NO PRICE) -->
        <section class="section-wrap">
            <div class="section-header">
                <h2 class="section-title">
                    <span>📰</span> TIN TỨC & KIẾN THỨC ĐỒNG HỒ
                </h2>
                <a href="NewsList.aspx" class="section-view-all">Xem tất cả bài viết ▶</a>
            </div>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 20px;">
                <asp:Repeater ID="rptNews" runat="server">
                    <ItemTemplate>
                        <div style="background:#ffffff; border:1px solid var(--border-color); border-radius:6px; overflow:hidden; display:flex; flex-direction:column;">
                            <a href='<%# "NewsDetail.aspx?id=" + Eval("ID_P") %>'>
                                <img src='<%# ResolveUrl("~/Assets/images/products/" + (string.IsNullOrEmpty(Eval("Image") as string) ? "news_phanbiet.jpg" : Eval("Image"))) %>' 
                                     alt='<%# Eval("Title") %>' style="width:100%; height:200px; object-fit:cover;" />
                            </a>
                            <div style="padding:15px; flex:1; display:flex; flex-direction:column;">
                                <span style="font-size:11px; color:#888888; margin-bottom:4px;">
                                    📅 <%# string.Format("{0:dd/MM/yyyy}", Eval("CreaDate")) %> • Tác giả: <%# Eval("UserAdd") ?? "Ban Biên Tập" %>
                                </span>
                                <h3 style="font-size:14px; font-weight:700; margin-bottom:8px; line-height:1.4;">
                                    <a href='<%# "NewsDetail.aspx?id=" + Eval("ID_P") %>' style="color:var(--dark-color);">
                                        <%# Eval("Title") %>
                                    </a>
                                </h3>
                                <p style="font-size:12px; color:#666666; line-height:1.6; margin-bottom:12px;">
                                    <%# Eval("Sumary") %>
                                </p>
                                <a href='<%# "NewsDetail.aspx?id=" + Eval("ID_P") %>' style="color:var(--primary-color); font-weight:700; font-size:12px; margin-top:auto;">
                                    Đọc tiếp bài viết ▶
                                </a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </section>
    </div>
</asp:Content>
