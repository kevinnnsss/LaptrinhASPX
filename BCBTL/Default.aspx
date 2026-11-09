<%@ Page Title="Trang Chủ" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BCBTL.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

        <!-- 1. HERO TRAILER CINEMATIC BANNER (CHUẨN CINEMA VỚI CHỮ & NÚT TRÊN VIDEO) -->
        <div class="hero-trailer-container">
            <div class="hero-trailer-wrapper">
                <!-- Video chạy ngầm tự động lặp lại, không hiện thanh tua/điều khiển -->
                <video id="heroTrailerVideo" class="hero-trailer-player" autoplay="autoplay" muted="muted" loop="loop" playsinline="playsinline" poster="Assets/images/banners/banner1.jpg">
                    <source src="trailer/trailerdonghorollex.mp4" type="video/mp4" />
                    Trình duyệt của bạn không hỗ trợ thẻ video HTML5.
                </video>

                <!-- Lớp phủ Cinematic Gradient & Chữ nội dung đè lên Video -->
                <div class="hero-trailer-overlay">
                    <!-- Thanh trên: Nhãn Trailer và Nút Bật/Tắt âm thanh -->
                    <div class="hero-trailer-top-bar">
                        <div class="hero-trailer-tag">
                            <span class="trailer-live-dot"></span>
                        </div>

                    </div>

                    <!-- Khối chữ tiêu đề & CTA chính giữa bên trái chuẩn Cinema -->
                    <div class="hero-trailer-content">
                        <div class="hero-trailer-presents">
                            <span class="presents-line"></span> KEVLOUIS PRESENTS
                        </div>
                        <h1 class="hero-trailer-heading">
                            TRẢI NGHIỆM<br />
                            ĐẲNG CẤP<br />
                            <span class="hero-heading-highlight">ĐỈNH CAO</span>
                        </h1>
                        <p class="hero-trailer-desc">
                            Khám phá những kiệt tác đồng hồ chính hãng mới nhất tại KevLouis.
                        </p>
                        <div class="hero-trailer-actions">
                            <a href="ProductList.aspx" class="btn-hero-cta btn-hero-primary">
                                XEM BỘ SƯU TẬP
                            </a>
                            <a href="ProductList.aspx?gender=1" class="btn-hero-cta btn-hero-secondary">
                                ĐỒNG HỒ NAM
                            </a>
                        </div>
                    </div>

                    <!-- Nút cuộn xuống khám phá sản phẩm (↓ KHÁM PHÁ) -->
                    <div class="hero-trailer-bottom">
                        <a href="#section-brands" class="hero-scroll-btn" id="btnScrollExplore">
                            <span class="scroll-arrow">↓</span> KHÁM PHÁ
                        </a>
                    </div>
                </div>
            </div>
        </div>

            <!-- 2. TRUST COMMITMENT STRIP (4 CAM KẾT CHÍNH HÃNG) -->
    <div class="trust-strip">
        <div class="container">
            <div class="trust-grid">
                <div class="trust-item">
                    <div class="trust-icon">
                        <svg width="28" height="28" fill="currentColor" viewBox="0 0 16 16"><path d="M5.338 1.59a61.44 61.44 0 0 0-2.837.856.481.481 0 0 0-.328.39c-.554 4.157.726 7.19 2.253 9.188a10.725 10.725 0 0 0 2.287 2.233c.346.244.652.42.893.533.12.057.218.095.293.118a.55.55 0 0 0 .101.02.515.515 0 0 0 .1-.02c.076-.023.174-.061.294-.118.24-.113.547-.29.893-.533a10.726 10.726 0 0 0 2.287-2.233c1.527-1.997 2.807-5.031 2.253-9.188a.48.48 0 0 0-.328-.39c-.651-.213-1.75-.56-2.837-.855C9.552 1.29 8.531 1.067 8 1.067c-.53 0-1.552.223-2.662.524zM5.072.56C6.157.265 7.31 0 8 0s1.843.265 2.928.56c1.11.3 2.229.655 2.887.87a1.54 1.54 0 0 1 1.044 1.262c.599 4.491-.71 7.776-2.383 9.992a11.722 11.722 0 0 1-2.528 2.457 12.04 12.04 0 0 1-.986.586c-.255.132-.516.236-.78.29-.265-.054-.526-.158-.78-.29a12.041 12.041 0 0 1-.987-.586 11.722 11.722 0 0 1-2.527-2.457c-1.674-2.216-2.983-5.501-2.383-9.992A1.54 1.54 0 0 1 1.14 1.43c.658-.215 1.777-.57 2.887-.87z"/><path d="M10.854 5.146a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708 0l-1.5-1.5a.5.5 0 1 1 .708-.708L7.5 7.793l2.646-2.647a.5.5 0 0 1 .708 0z"/></svg>
                    </div>
                    <div class="trust-text">
                        <h4>100% Chính Hãng</h4>
                        <p>Đại lý ủy quyền chính thức</p>
                    </div>
                </div>
                <div class="trust-item">
                    <div class="trust-icon">
                        <svg width="28" height="28" fill="currentColor" viewBox="0 0 16 16"><path d="M0 3.5A1.5 1.5 0 0 1 1.5 2h9A1.5 1.5 0 0 1 12 3.5V5h1.02a1.5 1.5 0 0 1 1.17.563l1.481 1.85a1.5 1.5 0 0 1 .329.938V10.5a1.5 1.5 0 0 1-1.5 1.5H14a2 2 0 1 1-4 0H5a2 2 0 1 1-4 0H.5A.5.5 0 0 1 0 11.5v-8zm1 0v7h.08a2 2 0 0 1 3.84 0h5.16a2 2 0 0 1 3.84 0H14v-1.5a.5.5 0 0 0-.5-.5h-2a.5.5 0 0 1-.5-.5V4a.5.5 0 0 0-.5-.5h-9a.5.5 0 0 0-.5.5zm11 3.5h2.368l-1.2-1.5H12V7z"/></svg>
                    </div>
                    <div class="trust-text">
                        <h4>Miễn Phí Vận Chuyển</h4>
                        <p>Giao hàng toàn quốc - Kiểm tra hàng</p>
                    </div>
                </div>
                <div class="trust-item">
                    <div class="trust-icon">
                        <svg width="28" height="28" fill="currentColor" viewBox="0 0 16 16"><path d="M2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v13.5a.5.5 0 0 1-.777.416L8 13.101l-5.223 2.815A.5.5 0 0 1 2 15.5V2zm2-1a1 1 0 0 0-1 1v12.566l4.723-2.482a.5.5 0 0 1 .554 0L13 14.566V2a1 1 0 0 0-1-1H4z"/><path d="M8 4a.5.5 0 0 1 .5.5V6H10a.5.5 0 0 1 0 1H8.5v1.5a.5.5 0 0 1-1 0V7H6a.5.5 0 0 1 0-1h1.5V4.5A.5.5 0 0 1 8 4z"/></svg>
                    </div>
                    <div class="trust-text">
                        <h4>Bảo Hành 5 Năm</h4>
                        <p>Red Guarantee độc quyền KevLouis</p>
                    </div>
                </div>
                <div class="trust-item">
                    <div class="trust-icon">
                        <svg width="28" height="28" fill="currentColor" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2v1z"/><path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466z"/></svg>
                    </div>
                    <div class="trust-text">
                        <h4>Đổi Mới Trong 7 Ngày</h4>
                        <p>Nếu có lỗi kỹ thuật từ nhà sản xuất</p>
                    </div>
                </div>
            </div>
        </div>
    </div>



    <div class="container">

        <!-- 2. BRAND BAR (THƯƠNG HIỆU HÀNG ĐẦU) -->
        <div class="brand-bar" id="section-brands">
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
