<%@ Page Title="Chi Tiết Đồng Hồ" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductDetail.aspx.cs" Inherits="BCBTL.ProductDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <!-- 1. DYNAMIC BREADCRUMB -->
        <div class="breadcrumb-wrap">
            <div class="breadcrumb-list">
                <span class="breadcrumb-item"><a href="Default.aspx">Trang chủ</a></span>
                <span class="breadcrumb-separator">/</span>
                <span class="breadcrumb-item">
                    <asp:HyperLink ID="lnkBreadcrumbCategory" runat="server" NavigateUrl="ProductList.aspx">Đồng hồ</asp:HyperLink>
                </span>
                <span class="breadcrumb-separator">/</span>
                <span class="breadcrumb-item active">
                    <asp:Literal ID="litBreadcrumbTitle" runat="server"></asp:Literal>
                </span>
            </div>
        </div>

        <!-- 2. PRODUCT DETAIL MAIN CARD -->
        <asp:Panel ID="pnlProductDetail" runat="server" CssClass="product-detail-wrap">
            <div class="detail-main-grid">
                <!-- CỘT TRÁI: HÌNH ẢNH & CAM KẾT -->
                <div class="detail-gallery">
                    <div class="detail-main-img-wrap">
                        <asp:Literal ID="litBadgeDiscount" runat="server"></asp:Literal>
                        <span class="badge-auth-tag">Chính Hãng 100%</span>
                        <asp:Image ID="imgMainProduct" runat="server" CssClass="detail-main-img" />
                    </div>

                    <!-- Cam kết KevLouis -->
                    <div class="detail-commit-box">
                        <div class="detail-commit-title">
                            <span>🛡️</span> Cam Kết Vàng Từ KevLouis
                        </div>
                        <ul class="detail-commit-list">
                            <li>✔ Đền tiền gấp 10 lần nếu phát hiện hàng giả, hàng nhái</li>
                            <li>✔ Bảo hành máy 5 năm độc quyền RED GUARANTEE</li>
                            <li>✔ Miễn phí thay pin trọn đời cho toàn bộ đồng hồ Quartz</li>
                            <li>✔ 1 đổi 1 trong 7 ngày nếu phát sinh lỗi kỹ thuật</li>
                            <li>✔ Miễn phí vận chuyển COD toàn quốc - Kiểm tra trước khi trả tiền</li>
                        </ul>
                    </div>
                </div>

                <!-- CỘT PHẢI: THÔNG TIN CHI TIẾT & ĐẶT MUA -->
                <div class="detail-info">
                    <div class="detail-brand">
                        <asp:Literal ID="litBrandName" runat="server"></asp:Literal>
                    </div>

                    <h1 class="detail-title">
                        <asp:Literal ID="litProductTitle" runat="server"></asp:Literal>
                    </h1>

                    <div class="detail-meta-row">
                        <span>Mã SP: <b><asp:Literal ID="litProductSku" runat="server"></asp:Literal></b></span>
                        <span>•</span>
                        <span>Giới tính: <b><asp:Literal ID="litProductGender" runat="server"></asp:Literal></b></span>
                        <span>•</span>
                        <span>Tình trạng: <asp:Literal ID="litProductStock" runat="server"></asp:Literal></span>
                    </div>

                    <!-- Price Box -->
                    <div class="detail-price-box">
                        <div>
                            <div class="detail-price-current">
                                <asp:Literal ID="litCurrentPrice" runat="server"></asp:Literal>
                            </div>
                            <asp:Literal ID="litOriginalPrice" runat="server"></asp:Literal>
                        </div>
                        <asp:Literal ID="litSavingBadge" runat="server"></asp:Literal>
                    </div>

                    <!-- Summary Description -->
                    <div class="detail-summary">
                        <asp:Literal ID="litSummary" runat="server"></asp:Literal>
                    </div>

                    <!-- Exclusive Gifts Box -->
                    <div class="detail-gifts-box">
                        <div class="gifts-header">
                            <span>🎁</span> Ưu Đãi & Quà Tặng Độc Quyền
                        </div>
                        <ul class="gifts-list">
                            <li>• Tặng gói dịch vụ bảo dưỡng & đánh bóng miễn phí trong 5 năm</li>
                            <li>• Tặng khăn lau đồng hồ chuyên dụng cao cấp microfiber</li>
                            <li>• Tặng voucher 200.000 đ cho lần mua sắm tiếp theo</li>
                            <li>• Hỗ trợ cắt mắt dây kim loại miễn phí tại hệ thống showroom</li>
                        </ul>
                    </div>

                    <!-- Quantity & Action Buttons with AJAX -->
                    <asp:UpdatePanel ID="upOrderActions" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="detail-order-actions">
                                <div style="display:flex; align-items:center; gap:15px;">
                                    <label style="font-weight:700; font-size:13px; text-transform:uppercase;">Số lượng:</label>
                                    <div class="qty-selector">
                                        <button type="button" id="btnQtyMinus" class="qty-btn">-</button>
                                        <asp:TextBox ID="txtQuantity" runat="server" Text="1" CssClass="qty-input" ClientIDMode="Static"></asp:TextBox>
                                        <button type="button" id="btnQtyPlus" class="qty-btn">+</button>
                                    </div>
                                    <span style="font-size:12px; color:#888888;">
                                        (Còn <asp:Literal ID="litAvailableStock" runat="server"></asp:Literal> sản phẩm)
                                    </span>
                                </div>

                                <div class="buttons-row">
                                    <asp:Button ID="btnAddToCart" runat="server" Text="THÊM VÀO GIỎ HÀNG" 
                                        CssClass="btn-detail-cart" OnClick="btnAddToCart_Click" />
                                    <asp:Button ID="btnBuyNow" runat="server" Text="MUA NGAY (GIAO TẬN NƠI)" 
                                        CssClass="btn-detail-buy" OnClick="btnBuyNow_Click" />
                                </div>

                                <asp:Label ID="lblActionMsg" runat="server" Visible="false" 
                                    style="padding:10px 14px; border-radius:4px; font-weight:700; margin-top:8px; display:block;"></asp:Label>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                    <!-- Showrooms Available -->
                    <div style="border-top:1px solid #f0f0f0; padding-top:15px; font-size:12px; color:#555555;">
                        <b style="color:var(--dark-color);">Có sẵn tại Showroom:</b>
                        <span>TP. Cao Lãnh, TP. Sa Đéc, Lai Vung (Đồng Tháp), TP. Mỹ Tho</span>
                    </div>
                </div>
            </div>

            <!-- 3. TABS: CONTENTS / SPECS / WARRANTY -->
            <div class="detail-tabs-wrap">
                <ul class="tabs-nav">
                    <li><button type="button" class="tab-nav-btn active" data-tab="tab-desc">Đặc Điểm Nổi Bật</button></li>
                    <li><button type="button" class="tab-nav-btn" data-tab="tab-specs">Thông Số Kỹ Thuật</button></li>
                    <li><button type="button" class="tab-nav-btn" data-tab="tab-warranty">Chính Sách Bảo Hành</button></li>
                </ul>

                <!-- Tab 1: Contents -->
                <div id="tab-desc" class="tab-panel active">
                    <div class="article-content" style="line-height:1.8;">
                        <asp:Literal ID="litContents" runat="server"></asp:Literal>
                    </div>
                </div>

                <!-- Tab 2: Specs -->
                <div id="tab-specs" class="tab-panel">
                    <table class="specs-table">
                        <tbody>
                            <tr>
                                <td class="spec-name">Thương hiệu:</td>
                                <td><asp:Literal ID="litSpecBrand" runat="server"></asp:Literal></td>
                            </tr>
                            <tr>
                                <td class="spec-name">Dành cho:</td>
                                <td><asp:Literal ID="litSpecGender" runat="server"></asp:Literal></td>
                            </tr>
                            <tr>
                                <td class="spec-name">Loại máy:</td>
                                <td>Máy Quartz / Automatic chính hãng</td>
                            </tr>
                            <tr>
                                <td class="spec-name">Chất liệu kính:</td>
                                <td>Kính Sapphire chống trầy xước / Kính khoáng chịu lực</td>
                            </tr>
                            <tr>
                                <td class="spec-name">Chất liệu vỏ & dây:</td>
                                <td>Thép không gỉ 316L cao cấp</td>
                            </tr>
                            <tr>
                                <td class="spec-name">Độ chịu nước:</td>
                                <td>100M / 10 ATM (Bơi lội, rửa tay, đi mưa an toàn)</td>
                            </tr>
                            <tr>
                                <td class="spec-name">Xuất xứ thương hiệu:</td>
                                <td>Nhật Bản / Thụy Sĩ</td>
                            </tr>
                            <tr>
                                <td class="spec-name">Chế độ bảo hành:</td>
                                <td>Quốc tế 1-2 năm + 5 năm tại KevLouis</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Tab 3: Warranty Policy -->
                <div id="tab-warranty" class="tab-panel">
                    <h3 style="font-size:16px; font-weight:700; color:var(--primary-color); margin-bottom:12px;">
                        GÓI BẢO HÀNH ĐỘC QUYỀN "RED GUARANTEE" 5 NĂM TẠI KEVLOUIS
                    </h3>
                    <p style="margin-bottom:10px;">Khi mua sản phẩm tại KevLouis, khách hàng không chỉ nhận được chế độ bảo hành toàn cầu từ chính hãng mà còn được tặng thêm gói bảo hành mở rộng RED GUARANTEE 5 năm với các đặc quyền vượt trội:</p>
                    <ul style="padding-left:20px; line-height:1.8; margin-bottom:15px;">
                        <li>Miễn phí thay pin trọn đời cho toàn bộ đồng hồ máy Quartz.</li>
                        <li>Miễn phí công bảo dưỡng, tra dầu, cân chỉnh độ chính xác máy cơ định kỳ.</li>
                        <li>Hỗ trợ 50% chi phí linh kiện nếu đồng hồ gặp sự cố rơi vỡ ngoài phạm vi bảo hành.</li>
                        <li>Được kiểm tra độ chịu nước bằng thiết bị áp suất chân không Thụy Sĩ trước và sau khi sửa chữa.</li>
                    </ul>
                </div>
            </div>
        </asp:Panel>

        <!-- 4. RELATED PRODUCTS -->
        <section class="section-wrap" style="margin-top:40px;">
            <div class="section-header">
                <h2 class="section-title">
                    <span>🔥</span> SẢN PHẨM CÙNG THƯƠNG HIỆU & PHÂN KHÚC
                </h2>
                <asp:HyperLink ID="lnkViewMoreRelated" runat="server" CssClass="section-view-all">Xem thêm ▶</asp:HyperLink>
            </div>

            <div class="product-grid">
                <asp:Repeater ID="rptRelatedProducts" runat="server">
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

                                <div class="product-actions">
                                    <a href='<%# "ProductDetail.aspx?id=" + Eval("ID_P") %>' class="btn-view-detail" style="grid-column: span 2;">Xem chi tiết</a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </section>

        <!-- Product Not Found Panel -->
        <asp:Panel ID="pnlNotFound" runat="server" Visible="false" CssClass="empty-results">
            <div class="empty-icon">⚠️</div>
            <h3>Không tìm thấy chiếc đồng hồ này</h3>
            <p>Sản phẩm bạn đang tìm kiếm không tồn tại hoặc đã ngừng kinh doanh trên hệ thống.</p>
            <a href="ProductList.aspx" class="btn-add-cart" style="display:inline-block; padding:10px 24px; font-size:13px;">
                Quay lại danh sách đồng hồ
            </a>
        </asp:Panel>
    </div>
</asp:Content>
