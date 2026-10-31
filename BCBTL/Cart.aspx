<%@ Page Title="Giỏ Hàng Của Bạn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="BCBTL.Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <!-- BREADCRUMB -->
        <div class="breadcrumb-wrap">
            <div class="breadcrumb-list">
                <span class="breadcrumb-item"><a href="Default.aspx">Trang chủ</a></span>
                <span class="breadcrumb-separator">/</span>
                <span class="breadcrumb-item active">Giỏ hàng của bạn</span>
            </div>
        </div>

        <!-- AJAX UPDATE PROGRESS -->
        <asp:UpdateProgress ID="upProgressCart" runat="server" AssociatedUpdatePanelID="upCart">
            <ProgressTemplate>
                <div class="cart-loading-overlay">
                    <div class="cart-spinner-box">
                        <div class="cart-spinner"></div>
                        <span style="font-weight:700; color:var(--primary-color); font-size:14px;">Đang cập nhật giỏ hàng...</span>
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

        <asp:UpdatePanel ID="upCart" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="cart-wrap">
                    <h2 style="font-size:20px; font-weight:800; color:var(--dark-color); margin-bottom:20px; padding-bottom:12px; border-bottom:2px solid var(--primary-color);">
                        🛒 GIỎ HÀNG CỦA BẠN (<asp:Literal ID="litCartCountHeader" runat="server">0</asp:Literal> SẢN PHẨM)
                    </h2>

                    <asp:Label ID="lblCartMsg" runat="server" Visible="false" 
                        style="display:block; padding:10px 15px; margin-bottom:15px; border-radius:4px; font-weight:700;"></asp:Label>

                    <asp:Panel ID="pnlCartTable" runat="server">
                        <table class="cart-table">
                            <thead>
                                <tr>
                                    <th style="width:42%;">Sản phẩm đồng hồ</th>
                                    <th style="width:16%; text-align:center;">Đơn giá</th>
                                    <th style="width:18%; text-align:center;">Số lượng</th>
                                    <th style="width:16%; text-align:center;">Thành tiền</th>
                                    <th style="width:8%; text-align:center;">Xóa</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptCartItems" runat="server" OnItemCommand="rptCartItems_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <div class="cart-product-cell">
                                                    <img src='<%# ResolveUrl("~/Assets/images/products/" + (string.IsNullOrEmpty(Eval("Image") as string) ? "default-watch.jpg" : Eval("Image"))) %>' 
                                                         alt='<%# Eval("Title") %>' class="cart-product-img" />
                                                    <div>
                                                        <a href='<%# "ProductDetail.aspx?id=" + Eval("ProductID") %>' class="cart-product-name">
                                                            <%# Eval("Title") %>
                                                        </a>
                                                        <div style="font-size:11px; color:#888888; margin-top:3px;">
                                                            Mã SP: W<%# Convert.ToInt32(Eval("ProductID")).ToString("D5") %>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td style="text-align:center;">
                                                <span class="cart-price"><%# string.Format("{0:N0} đ", Eval("Price")) %></span>
                                            </td>
                                            <td style="text-align:center;">
                                                <div class="cart-qty-ctrl">
                                                    <asp:LinkButton ID="btnMinus" runat="server" CommandName="DecreaseQty" CommandArgument='<%# Eval("ProductID") %>' 
                                                        CssClass="cart-qty-btn" ToolTip="Giảm 1 số lượng">-</asp:LinkButton>
                                                    <asp:TextBox ID="txtItemQty" runat="server" Text='<%# Eval("Quantity") %>' 
                                                        CssClass="cart-qty-val" AutoPostBack="true" OnTextChanged="txtItemQty_TextChanged" 
                                                        onkeypress="return event.charCode >= 48 && event.charCode <= 57"></asp:TextBox>
                                                    <asp:LinkButton ID="btnPlus" runat="server" CommandName="IncreaseQty" CommandArgument='<%# Eval("ProductID") %>' 
                                                        CssClass="cart-qty-btn" ToolTip="Tăng 1 số lượng">+</asp:LinkButton>
                                                </div>
                                            </td>
                                            <td style="text-align:center;">
                                                <span style="font-weight:800; color:var(--primary-color);">
                                                    <%# string.Format("{0:N0} đ", Eval("TotalPrice")) %>
                                                </span>
                                            </td>
                                            <td style="text-align:center;">
                                                <asp:LinkButton ID="btnDeleteItem" runat="server" CommandName="DeleteItem" CommandArgument='<%# Eval("ProductID") %>' 
                                                    Text="✕" ForeColor="#dc2626" Font-Bold="true" Font-Size="15px" 
                                                    ToolTip="Xóa sản phẩm này" 
                                                    OnClientClick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?');"></asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>

                        <!-- COUPON & TOTAL SUMMARY -->
                        <div class="cart-summary-grid" style="display:grid; grid-template-columns: 1fr 1fr; gap:25px; margin-top:25px; align-items:start;">
                            <!-- Promo Voucher Box -->
                            <div class="cart-coupon-card" style="background:#f9fafb; border:1px solid #e5e7eb; border-radius:6px; padding:18px;">
                                <h4 style="font-size:14px; font-weight:700; color:var(--dark-color); margin-bottom:6px;">
                                    🎟️ MÃ GIẢM GIÁ / VOUCHER ƯU ĐÃI
                                </h4>
                                <p style="font-size:12px; color:#666; margin-bottom:12px;">
                                    Nhập mã ưu đãi (ví dụ: <b style="color:var(--primary-color);">KEV10</b> hoặc <b style="color:var(--primary-color);">CHAOBAN</b> để giảm 10% tổng đơn):
                                </p>
                                <div style="display:flex; gap:8px;">
                                    <asp:TextBox ID="txtCouponCode" runat="server" 
                                        style="flex:1; padding:10px 12px; border:1px solid #ccc; border-radius:4px; text-transform:uppercase; font-weight:700; font-size:13px;" 
                                        placeholder="Mã ưu đãi..."></asp:TextBox>
                                    <asp:Button ID="btnApplyCoupon" runat="server" Text="ÁP DỤNG" 
                                        style="background:var(--primary-color); color:#fff; border:none; padding:10px 18px; border-radius:4px; font-weight:700; cursor:pointer;" 
                                        OnClick="btnApplyCoupon_Click" />
                                    <asp:Button ID="btnClearCoupon" runat="server" Text="HỦY" 
                                        style="background:#fee2e2; color:#dc2626; border:1px solid #fca5a5; padding:10px 14px; border-radius:4px; font-weight:700; cursor:pointer;" 
                                        Visible="false" OnClick="btnClearCoupon_Click" />
                                </div>
                                <asp:Label ID="lblCouponMsg" runat="server" Visible="false" 
                                    style="display:block; margin-top:8px; font-size:12px; font-weight:700;"></asp:Label>
                            </div>

                            <!-- Total Summary Box -->
                            <div class="cart-total-bar" style="background:#ffffff; border:1px solid var(--border-color); border-radius:6px; padding:20px; box-shadow:var(--shadow-sm);">
                                <div style="display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px; color:#666;">
                                    <span>Tạm tính tiền hàng:</span>
                                    <b style="color:var(--dark-color);"><asp:Literal ID="litCartSubTotal" runat="server">0 đ</asp:Literal></b>
                                </div>
                                <asp:Panel ID="pnlDiscountRow" runat="server" Visible="false" 
                                    style="display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px; color:#16a34a; font-weight:700;">
                                    <span>Voucher giảm giá (<asp:Literal ID="litDiscountPercent" runat="server">10</asp:Literal>%):</span>
                                    <span>-<asp:Literal ID="litDiscountAmount" runat="server">0 đ</asp:Literal></span>
                                </asp:Panel>
                                <div style="display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px; color:#666;">
                                    <span>Phí giao hàng toàn quốc:</span>
                                    <span style="color:#16a34a; font-weight:700;">MIỄN PHÍ</span>
                                </div>
                                <div style="display:flex; justify-content:space-between; align-items:baseline; padding-top:12px; border-top:2px dashed var(--border-color); margin-top:10px;">
                                    <span style="font-size:14px; font-weight:800; color:var(--dark-color); text-transform:uppercase;">Tổng thanh toán:</span>
                                    <span class="cart-grand-total">
                                        <asp:Literal ID="litCartGrandTotal" runat="server">0 đ</asp:Literal>
                                    </span>
                                </div>
                                <div style="font-size:11px; color:#888; text-align:right; margin-top:4px;">(Giá đã bao gồm thuế VAT & bảo hiểm vận chuyển)</div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-top:25px; flex-wrap:wrap; gap:15px;">
                            <div style="display:flex; gap:10px;">
                                <a href="ProductList.aspx" class="btn-view-detail" style="padding:12px 20px; font-weight:700; font-size:13px;">
                                    ◀ Tiếp tục chọn đồng hồ
                                </a>
                                <asp:Button ID="btnClearAllCart" runat="server" Text="Xóa hết giỏ hàng" 
                                    CssClass="btn-view-detail" Style="color:#dc2626; border-color:#fca5a5; font-weight:700;" 
                                    OnClick="btnClearAllCart_Click" 
                                    OnClientClick="return confirm('Bạn có chắc chắn muốn xóa toàn bộ giỏ hàng?');" />
                            </div>

                            <a href="Checkout.aspx" class="btn-detail-buy" style="display:inline-block; padding:14px 35px; font-size:15px;">
                                TIẾN HÀNH ĐẶT HÀNG ▶
                            </a>
                        </div>
                    </asp:Panel>

                    <!-- Empty Cart Panel -->
                    <asp:Panel ID="pnlEmptyCart" runat="server" Visible="false" CssClass="empty-results">
                        <div class="empty-icon">🛒</div>
                        <h3>Giỏ hàng của bạn đang trống</h3>
                        <p>Bạn chưa thêm chiếc đồng hồ nào vào giỏ hàng. Hãy khám phá ngay các bộ sưu tập đồng hồ nam, nữ và thương hiệu chính hãng tại KevLouis!</p>
                        <a href="ProductList.aspx" class="btn-add-cart" style="display:inline-block; padding:12px 28px; font-size:14px;">
                            Khám phá đồng hồ ngay
                        </a>
                    </asp:Panel>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
