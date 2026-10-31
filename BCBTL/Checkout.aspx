<%@ Page Title="Đặt Hàng & Thanh Toán" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="BCBTL.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .checkout-grid {
            display: grid;
            grid-template-columns: 1.25fr 1fr;
            gap: 30px;
            margin-bottom: 40px;
            align-items: start;
        }
        .checkout-box {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 25px;
            box-shadow: var(--shadow-sm);
        }
        .form-row {
            margin-bottom: 16px;
        }
        .form-row label {
            display: block;
            margin-bottom: 6px;
            font-weight: 700;
            font-size: 13px;
            color: var(--dark-color);
        }
        .val-error {
            color: #dc2626;
            font-size: 12px;
            display: block;
            margin-top: 4px;
            font-weight: 600;
        }
        .val-summary-alert {
            background: #fee2e2;
            border: 1px solid #f87171;
            color: #991b1b;
            padding: 12px 18px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .val-summary-alert ul {
            margin: 6px 0 0 18px;
            padding: 0;
        }
        .order-summary-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
            font-size: 13px;
        }
        .payment-method-card {
            border: 1px solid #e5e7eb;
            border-radius: 6px;
            padding: 12px 15px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .payment-method-card:hover, .payment-method-card.selected {
            border-color: var(--primary-color);
            background: #fffafa;
        }
        .bank-details-box {
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 6px;
            padding: 14px;
            margin-top: 10px;
            font-size: 12px;
            line-height: 1.6;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <!-- BREADCRUMB -->
        <div class="breadcrumb-wrap">
            <div class="breadcrumb-list">
                <span class="breadcrumb-item"><a href="Default.aspx">Trang chủ</a></span>
                <span class="breadcrumb-separator">/</span>
                <span class="breadcrumb-item"><a href="Cart.aspx">Giỏ hàng</a></span>
                <span class="breadcrumb-separator">/</span>
                <span class="breadcrumb-item active">Đặt hàng & Thanh toán</span>
            </div>
        </div>

        <h2 style="font-size:22px; font-weight:800; color:var(--dark-color); margin-bottom:20px; padding-bottom:10px; border-bottom:2px solid var(--primary-color);">
            🛍️ THÔNG TIN GIAO HÀNG & XÁC NHẬN ĐƠN HÀNG
        </h2>

        <asp:ValidationSummary ID="valSummary" runat="server" CssClass="val-summary-alert" 
            HeaderText="⚠ Quý khách vui lòng hoàn thiện các thông tin hợp lệ sau:" />

        <asp:Label ID="lblCheckoutError" runat="server" Visible="false" 
            style="display:block; padding:12px; margin-bottom:20px; background:#fee2e2; color:#dc2626; border-radius:4px; font-weight:700;"></asp:Label>

        <div class="checkout-grid">
            <!-- Left: Customer Delivery Form -->
            <div class="checkout-box">
                <h3 style="font-size:16px; font-weight:800; color:var(--primary-color); margin-bottom:18px; text-transform:uppercase;">
                    1. Địa Chỉ Nhận Hàng & Người Nhận
                </h3>

                <div class="form-row">
                    <label>Họ và tên người nhận (*):</label>
                    <asp:TextBox ID="txtCustomerName" runat="server" CssClass="search-input" 
                        style="border:1px solid var(--border-color); border-radius:4px;" placeholder="Ví dụ: Nguyễn Văn An"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtCustomerName" 
                        ErrorMessage="Họ và tên người nhận không được để trống!" CssClass="val-error" Display="Dynamic"></asp:RequiredFieldValidator>
                </div>

                <div class="form-row">
                    <label>Số điện thoại liên hệ (*):</label>
                    <asp:TextBox ID="txtCustomerPhone" runat="server" CssClass="search-input" 
                        style="border:1px solid var(--border-color); border-radius:4px;" placeholder="Ví dụ: 0912345678" 
                        onkeypress="return event.charCode >= 48 && event.charCode <= 57"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtCustomerPhone" 
                        ErrorMessage="Số điện thoại nhận hàng là bắt buộc!" CssClass="val-error" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtCustomerPhone" 
                        ValidationExpression="^(0|\+84)[0-9]{9,10}$" ErrorMessage="Số điện thoại không đúng định dạng (10 số)!" CssClass="val-error" Display="Dynamic"></asp:RegularExpressionValidator>
                </div>

                <div class="form-row">
                    <label>Địa chỉ Email (Nhận thông báo cập nhật đơn hàng):</label>
                    <asp:TextBox ID="txtCustomerEmail" runat="server" CssClass="search-input" 
                        style="border:1px solid var(--border-color); border-radius:4px;" placeholder="example@gmail.com"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtCustomerEmail" 
                        ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" ErrorMessage="Định dạng email chưa hợp lệ!" CssClass="val-error" Display="Dynamic"></asp:RegularExpressionValidator>
                </div>

                <div class="form-row">
                    <label>Địa chỉ giao hàng chi tiết (*):</label>
                    <asp:TextBox ID="txtDeliveryAddress" runat="server" TextMode="MultiLine" Rows="3" 
                        CssClass="search-input" style="border:1px solid var(--border-color); border-radius:4px; height:auto;" 
                        placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtDeliveryAddress" 
                        ErrorMessage="Địa chỉ giao hàng chi tiết là bắt buộc!" CssClass="val-error" Display="Dynamic"></asp:RequiredFieldValidator>
                </div>

                <div class="form-row">
                    <label>Ghi chú đơn hàng (Thời gian nhận, yêu cầu đóng hộp quà...):</label>
                    <asp:TextBox ID="txtOrderNotes" runat="server" TextMode="MultiLine" Rows="2" 
                        CssClass="search-input" style="border:1px solid var(--border-color); border-radius:4px; height:auto;"></asp:TextBox>
                </div>

                <!-- Payment Methods -->
                <div style="margin-top:20px; padding-top:15px; border-top:1px solid #eeeeee;">
                    <label style="font-weight:700; font-size:14px; color:var(--dark-color); display:block; margin-bottom:10px;">
                        💳 Phương thức thanh toán:
                    </label>

                    <div class="payment-method-card selected">
                        <input type="radio" id="payCOD" name="payMethod" value="COD" checked="checked" onclick="togglePaymentMethod('COD')" />
                        <label for="payCOD" style="cursor:pointer; margin:0; font-weight:700;">
                            💵 Thanh toán khi nhận hàng (COD)
                            <span style="display:block; font-size:11px; color:#666; font-weight:normal;">Quý khách được mở hộp đồng kiểm tra hàng trước khi thanh toán.</span>
                        </label>
                    </div>

                    <div class="payment-method-card">
                        <input type="radio" id="payBank" name="payMethod" value="BANK" onclick="togglePaymentMethod('BANK')" />
                        <label for="payBank" style="cursor:pointer; margin:0; font-weight:700;">
                            🏦 Chuyển khoản Ngân hàng (VietQR / Internet Banking)
                            <span style="display:block; font-size:11px; color:#666; font-weight:normal;">Xác nhận tự động trong 30 giây qua mã QR nhanh.</span>
                        </label>
                    </div>

                    <div id="bankDetailsBox" class="bank-details-box" style="display:none;">
                        <b style="color:var(--primary-color); display:block; margin-bottom:4px;">THÔNG TIN CHUYỂN KHOẢN KEVLOUIS WATCH:</b>
                        <div>• Ngân hàng: <b>Vietcombank (Chi nhánh Đồng Tháp)</b></div>
                        <div>• Số tài khoản: <b>1900 2117 8888</b></div>
                        <div>• Chủ tài khoản: <b>CONG TY TNHH DONG HO KEVLOUIS</b></div>
                        <div>• Nội dung chuyển khoản: <b style="color:var(--primary-color);">[Số điện thoại của bạn] - Dong ho</b></div>
                    </div>
                </div>
            </div>

            <!-- Right: Order Summary -->
            <div class="checkout-box">
                <h3 style="font-size:16px; font-weight:800; color:var(--dark-color); margin-bottom:18px; text-transform:uppercase;">
                    2. Tóm Tắt Đơn Hàng
                </h3>

                <div style="max-height:350px; overflow-y:auto; margin-bottom:15px; padding-right:5px;">
                    <asp:Repeater ID="rptSummaryItems" runat="server">
                        <ItemTemplate>
                            <div class="order-summary-item">
                                <div style="display:flex; align-items:center; gap:10px;">
                                    <img src='<%# ResolveUrl("~/Assets/images/products/" + (string.IsNullOrEmpty(Eval("Image") as string) ? "default-watch.jpg" : Eval("Image"))) %>' 
                                         alt='<%# Eval("Title") %>' style="width:48px; height:48px; object-fit:cover; border-radius:4px; border:1px solid #ddd;" />
                                    <div>
                                        <b style="color:var(--dark-color);"><%# Eval("Title") %></b>
                                        <div style="font-size:11px; color:#777;">
                                            <%# Eval("Quantity") %> chiếc x <%# string.Format("{0:N0} đ", Eval("Price")) %>
                                        </div>
                                    </div>
                                </div>
                                <span style="font-weight:700; color:var(--primary-color);">
                                    <%# string.Format("{0:N0} đ", Eval("TotalPrice")) %>
                                </span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div style="border-top:1px solid var(--border-color); padding-top:15px; margin-bottom:20px;">
                    <div style="display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px;">
                        <span>Tạm tính tiền hàng:</span>
                        <b><asp:Literal ID="litSubTotal" runat="server">0 đ</asp:Literal></b>
                    </div>
                    <asp:Panel ID="pnlCheckoutDiscount" runat="server" Visible="false" 
                        style="display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px; color:#16a34a; font-weight:700;">
                        <span>Voucher giảm giá (<asp:Literal ID="litDiscountPercent" runat="server">10</asp:Literal>%):</span>
                        <span>-<asp:Literal ID="litDiscountAmount" runat="server">0 đ</asp:Literal></span>
                    </asp:Panel>
                    <div style="display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px;">
                        <span>Phí vận chuyển toàn quốc:</span>
                        <span style="color:var(--green-stock); font-weight:700;">MIỄN PHÍ</span>
                    </div>
                    <div style="display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px;">
                        <span>Bảo hiểm & Gói quà cao cấp:</span>
                        <span style="color:var(--green-stock); font-weight:700;">MIỄN PHÍ</span>
                    </div>
                    <div style="display:flex; justify-content:space-between; align-items:baseline; padding-top:12px; border-top:2px dashed var(--border-color); font-size:16px;">
                        <span style="font-weight:700;">TỔNG CỘNG:</span>
                        <span style="font-size:22px; font-weight:800; color:var(--primary-color);">
                            <asp:Literal ID="litGrandTotal" runat="server">0 đ</asp:Literal>
                        </span>
                    </div>
                </div>

                <asp:Button ID="btnPlaceOrder" runat="server" Text="XÁC NHẬN & ĐẶT HÀNG NGAY" 
                    CssClass="btn-detail-buy" style="width:100%; padding:15px; font-size:15px; border:none; cursor:pointer;" 
                    OnClick="btnPlaceOrder_Click" />

                <div style="text-align:center; margin-top:15px;">
                    <a href="Cart.aspx" style="color:#777; font-size:12px;">◀ Quay lại chỉnh sửa giỏ hàng</a>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function togglePaymentMethod(method) {
            var box = document.getElementById('bankDetailsBox');
            if (method === 'BANK') {
                box.style.display = 'block';
            } else {
                box.style.display = 'none';
            }
        }
    </script>
</asp:Content>
