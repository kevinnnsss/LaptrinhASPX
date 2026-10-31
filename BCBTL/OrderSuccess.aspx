<%@ Page Title="Đặt Hàng Thành Công" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderSuccess.aspx.cs" Inherits="BCBTL.OrderSuccess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="max-width:800px; padding:30px 15px;">
        <asp:Panel ID="pnlSuccess" runat="server" CssClass="checkout-box" style="text-align:center; padding:40px 30px;">
            <div style="font-size:60px; color:var(--green-stock); margin-bottom:15px;">🎉</div>
            <h1 style="font-size:24px; font-weight:800; color:var(--primary-color); margin-bottom:10px; text-transform:uppercase;">
                ĐẶT HÀNG THÀNH CÔNG!
            </h1>
            <p style="font-size:14px; color:#555555; margin-bottom:25px;">
                Cảm ơn quý khách đã tin tưởng và mua sắm tại <b>KevLouis</b>. Chuyên viên chăm sóc khách hàng của chúng tôi sẽ liên hệ qua điện thoại để xác nhận đơn hàng trong ít phút.
            </p>

            <div style="background:#f9fafb; border:1px solid var(--border-color); border-radius:6px; padding:20px; text-align:left; margin-bottom:25px;">
                <h3 style="font-size:15px; font-weight:700; color:var(--dark-color); margin-bottom:12px; padding-bottom:8px; border-bottom:1px solid #eee;">
                    📋 THÔNG TIN ĐƠN HÀNG #<asp:Literal ID="litOrderId" runat="server"></asp:Literal>
                </h3>
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px; font-size:13px;">
                    <div><b>Người nhận:</b> <asp:Literal ID="litCustomerName" runat="server"></asp:Literal></div>
                    <div><b>Số điện thoại:</b> <asp:Literal ID="litCustomerPhone" runat="server"></asp:Literal></div>
                    <div><b>Ngày đặt:</b> <asp:Literal ID="litOrderDate" runat="server"></asp:Literal></div>
                    <div><b>Trạng thái:</b> <span style="color:#d97706; font-weight:700;"><asp:Literal ID="litOrderStatus" runat="server"></asp:Literal></span></div>
                    <div style="grid-column:span 2;"><b>Địa chỉ giao hàng:</b> <asp:Literal ID="litDeliveryAddress" runat="server"></asp:Literal></div>
                </div>

                <div style="margin-top:15px; padding-top:12px; border-top:1px dashed #ddd; display:flex; justify-content:space-between; align-items:center;">
                    <span style="font-weight:700; font-size:14px;">TỔNG TIỀN THANH TOÁN (COD):</span>
                    <span style="font-size:20px; font-weight:800; color:var(--primary-color);">
                        <asp:Literal ID="litTotalAmount" runat="server"></asp:Literal>
                    </span>
                </div>
            </div>

            <div style="display:flex; justify-content:center; gap:12px; flex-wrap:wrap;">
                <asp:HyperLink ID="lnkTrackThisOrder" runat="server" CssClass="btn-view-detail" 
                    style="display:inline-block; padding:12px 24px; font-size:14px; font-weight:700; color:var(--primary-color); border:2px solid var(--primary-color);">
                    📦 THEO DÕI TIẾN ĐỘ ĐƠN HÀNG
                </asp:HyperLink>
                <a href="Default.aspx" class="btn-detail-buy" style="display:inline-block; padding:12px 24px; font-size:14px;">
                    VỀ TRANG CHỦ
                </a>
                <a href="ProductList.aspx" class="btn-view-detail" style="display:inline-block; padding:12px 24px; font-size:14px; font-weight:700;">
                    TIẾP TỤC XEM ĐỒNG HỒ
                </a>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlInvalid" runat="server" Visible="false" CssClass="empty-results">
            <div class="empty-icon">⚠️</div>
            <h3>Yêu cầu không hợp lệ</h3>
            <p>Không tìm thấy thông tin đơn hàng vừa thực hiện. Vui lòng kiểm tra lại hoặc liên hệ hotline 1900 2117 để được hỗ trợ.</p>
            <a href="Default.aspx" class="btn-add-cart" style="display:inline-block; padding:10px 24px;">Về trang chủ</a>
        </asp:Panel>
    </div>
</asp:Content>
