<%@ Page Title="Liên Hệ & Showroom" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="BCBTL.Contact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <!-- BREADCRUMB -->
        <div class="breadcrumb-wrap">
            <div class="breadcrumb-list">
                <span class="breadcrumb-item"><a href="Default.aspx">Trang chủ</a></span>
                <span class="breadcrumb-separator">/</span>
                <span class="breadcrumb-item active">Liên hệ & Hệ thống Showroom</span>
            </div>
        </div>

        <div class="catalog-banner" style="background: linear-gradient(rgba(158, 11, 15, 0.9), rgba(40, 5, 8, 0.9)), url('Assets/images/banners/banner2.jpg') center/cover;">
            <h2>HỆ THỐNG SHOWROOM & LIÊN HỆ KEVLOUIS</h2>
            <p>Khách hàng có thể đến trực tiếp hệ thống cửa hàng KevLouis tại TP. Cao Lãnh, Sa Đéc, Lai Vung và TP. Mỹ Tho để trải nghiệm và được chuyên viên tư vấn chi tiết từng dòng đồng hồ.</p>
        </div>

        <div style="display:grid; grid-template-columns: 1.2fr 1fr; gap: 30px; margin-bottom: 40px;">
            <!-- Left: Showroom List -->
            <div style="background:#ffffff; border:1px solid var(--border-color); border-radius:6px; padding:25px; box-shadow:var(--shadow-sm);">
                <h3 style="font-size:18px; font-weight:800; color:var(--primary-color); margin-bottom:18px; padding-bottom:10px; border-bottom:2px solid var(--primary-color);">
                    🏢 HỆ THỐNG SHOWROOM CHÍNH THỨC
                </h3>

                <div style="margin-bottom:20px; padding-bottom:15px; border-bottom:1px solid #eeeeee;">
                    <h4 style="font-size:15px; font-weight:700; color:var(--dark-color); margin-bottom:6px;">
                        1. Showroom TP. Cao Lãnh (Đồng Tháp)
                    </h4>
                    <p style="font-size:13px; color:#555555; margin-bottom:4px;">📍 <b>Địa chỉ:</b> 78 Nguyễn Huệ, Phường 2, TP. Cao Lãnh, Đồng Tháp</p>
                    <p style="font-size:13px; color:#555555; margin-bottom:4px;">📞 <b>Điện thoại:</b> (0277) 385 2117 - Hotline: 1900 2117</p>
                    <p style="font-size:13px; color:#555555;">🕒 <b>Giờ mở cửa:</b> 08:00 - 21:30 (Tất cả các ngày trong tuần)</p>
                </div>

                <div style="margin-bottom:20px; padding-bottom:15px; border-bottom:1px solid #eeeeee;">
                    <h4 style="font-size:15px; font-weight:700; color:var(--dark-color); margin-bottom:6px;">
                        2. Showroom TP. Sa Đéc (Đồng Tháp)
                    </h4>
                    <p style="font-size:13px; color:#555555; margin-bottom:4px;">📍 <b>Địa chỉ:</b> 125 Hùng Vương, Phường 2, TP. Sa Đéc, Đồng Tháp</p>
                    <p style="font-size:13px; color:#555555; margin-bottom:4px;">📞 <b>Điện thoại:</b> (0277) 376 2117</p>
                    <p style="font-size:13px; color:#555555;">🕒 <b>Giờ mở cửa:</b> 08:00 - 21:30</p>
                </div>

                <div style="margin-bottom:20px; padding-bottom:15px; border-bottom:1px solid #eeeeee;">
                    <h4 style="font-size:15px; font-weight:700; color:var(--dark-color); margin-bottom:6px;">
                        3. Showroom Lai Vung (Đồng Tháp)
                    </h4>
                    <p style="font-size:13px; color:#555555; margin-bottom:4px;">📍 <b>Địa chỉ:</b> 45 Quốc Lộ 54, TT. Lai Vung, Huyện Lai Vung, Đồng Tháp</p>
                    <p style="font-size:13px; color:#555555; margin-bottom:4px;">📞 <b>Điện thoại:</b> (0277) 368 2117</p>
                    <p style="font-size:13px; color:#555555;">🕒 <b>Giờ mở cửa:</b> 08:00 - 21:00</p>
                </div>

                <div>
                    <h4 style="font-size:15px; font-weight:700; color:var(--dark-color); margin-bottom:6px;">
                        4. Showroom TP. Mỹ Tho (Tiền Giang)
                    </h4>
                    <p style="font-size:13px; color:#555555; margin-bottom:4px;">📍 <b>Địa chỉ:</b> 186 Ấp Bắc, Phường 5, TP. Mỹ Tho, Tiền Giang</p>
                    <p style="font-size:13px; color:#555555; margin-bottom:4px;">📞 <b>Điện thoại:</b> (0273) 388 2117</p>
                    <p style="font-size:13px; color:#555555;">🕒 <b>Giờ mở cửa:</b> 08:00 - 21:30</p>
                </div>
            </div>

            <!-- Right: Contact Form -->
            <div style="background:#ffffff; border:1px solid var(--border-color); border-radius:6px; padding:25px; box-shadow:var(--shadow-sm);">
                <asp:UpdatePanel ID="upContact" runat="server">
                    <ContentTemplate>
                        <h3 style="font-size:18px; font-weight:800; color:var(--dark-color); margin-bottom:18px; padding-bottom:10px; border-bottom:2px solid var(--primary-color);">
                            ✉️ GỬI THÔNG ĐIỆP CHO CHÚNG TÔI
                        </h3>

                        <p style="font-size:13px; color:#666666; margin-bottom:15px;">
                            Nếu bạn có bất kỳ câu hỏi nào về sản phẩm, chính sách bảo hành hoặc yêu cầu đặt mẫu đồng hồ đặc biệt, xin vui lòng để lại thông tin:
                        </p>

                        <div style="margin-bottom:12px;">
                            <label style="display:block; font-size:12px; font-weight:700; margin-bottom:4px;">Họ và tên (*):</label>
                            <asp:TextBox ID="txtContactName" runat="server" CssClass="search-input" style="border:1px solid var(--border-color); border-radius:4px;"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvContactName" runat="server" ControlToValidate="txtContactName" 
                                ErrorMessage="Vui lòng nhập họ và tên!" ForeColor="#dc2626" Font-Size="11px" Display="Dynamic" Font-Bold="true"></asp:RequiredFieldValidator>
                        </div>

                        <div style="margin-bottom:12px;">
                            <label style="display:block; font-size:12px; font-weight:700; margin-bottom:4px;">Số điện thoại (*):</label>
                            <asp:TextBox ID="txtContactPhone" runat="server" CssClass="search-input" style="border:1px solid var(--border-color); border-radius:4px;" 
                                onkeypress="return event.charCode >= 48 && event.charCode <= 57"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvContactPhone" runat="server" ControlToValidate="txtContactPhone" 
                                ErrorMessage="Vui lòng nhập số điện thoại!" ForeColor="#dc2626" Font-Size="11px" Display="Dynamic" Font-Bold="true"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revContactPhone" runat="server" ControlToValidate="txtContactPhone" 
                                ValidationExpression="^(0|\+84)[0-9]{9,10}$" ErrorMessage="Số điện thoại chưa đúng định dạng (10 số)!" ForeColor="#dc2626" Font-Size="11px" Display="Dynamic" Font-Bold="true"></asp:RegularExpressionValidator>
                        </div>

                        <div style="margin-bottom:12px;">
                            <label style="display:block; font-size:12px; font-weight:700; margin-bottom:4px;">Email:</label>
                            <asp:TextBox ID="txtContactEmail" runat="server" CssClass="search-input" style="border:1px solid var(--border-color); border-radius:4px;"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="revContactEmail" runat="server" ControlToValidate="txtContactEmail" 
                                ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" ErrorMessage="Định dạng email chưa chính xác!" ForeColor="#dc2626" Font-Size="11px" Display="Dynamic" Font-Bold="true"></asp:RegularExpressionValidator>
                        </div>

                        <div style="margin-bottom:15px;">
                            <label style="display:block; font-size:12px; font-weight:700; margin-bottom:4px;">Nội dung tin nhắn:</label>
                            <asp:TextBox ID="txtContactMessage" runat="server" TextMode="MultiLine" Rows="4" 
                                CssClass="search-input" style="border:1px solid var(--border-color); border-radius:4px; height:auto;"></asp:TextBox>
                        </div>

                        <asp:Button ID="btnSendContact" runat="server" Text="GỬI YÊU CẦU TƯ VẤN" 
                            CssClass="btn-detail-buy" style="width:100%; border:none; cursor:pointer;" OnClick="btnSendContact_Click" />

                        <asp:Label ID="lblContactMsg" runat="server" Visible="false" 
                            style="display:block; margin-top:12px; font-weight:700; font-size:13px; text-align:center; padding:10px; border-radius:4px;"></asp:Label>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
</asp:Content>
