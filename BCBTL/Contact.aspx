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
            <h2>HỆ THỐNG SHOWROOM & LIÊN HỆ DUY ANH WATCH</h2>
            <p>Khách hàng có thể đến trực tiếp hệ thống cửa hàng Duy Anh Watch tại Hà Nội và TP. Hồ Chí Minh để trải nghiệm và được chuyên viên tư vấn chi tiết từng dòng đồng hồ.</p>
        </div>

        <div style="display:grid; grid-template-columns: 1.2fr 1fr; gap: 30px; margin-bottom: 40px;">
            <!-- Left: Showroom List -->
            <div style="background:#ffffff; border:1px solid var(--border-color); border-radius:6px; padding:25px; box-shadow:var(--shadow-sm);">
                <h3 style="font-size:18px; font-weight:800; color:var(--primary-color); margin-bottom:18px; padding-bottom:10px; border-bottom:2px solid var(--primary-color);">
                    🏢 HỆ THỐNG SHOWROOM CHÍNH THỨC
                </h3>

                <div style="margin-bottom:20px; padding-bottom:15px; border-bottom:1px solid #eeeeee;">
                    <h4 style="font-size:15px; font-weight:700; color:var(--dark-color); margin-bottom:6px;">
                        1. Showroom Phố Huế (Hà Nội)
                    </h4>
                    <p style="font-size:13px; color:#555555; margin-bottom:4px;">📍 <b>Địa chỉ:</b> 200A Phố Huế, Quận Hai Bà Trưng, Hà Nội</p>
                    <p style="font-size:13px; color:#555555; margin-bottom:4px;">📞 <b>Điện thoại:</b> (024) 3991 8668 - Hotline: 1800 0091</p>
                    <p style="font-size:13px; color:#555555;">🕒 <b>Giờ mở cửa:</b> 08:30 - 21:30 (Tất cả các ngày trong tuần)</p>
                </div>

                <div style="margin-bottom:20px; padding-bottom:15px; border-bottom:1px solid #eeeeee;">
                    <h4 style="font-size:15px; font-weight:700; color:var(--dark-color); margin-bottom:6px;">
                        2. Showroom Trần Hưng Đạo (Hà Nội)
                    </h4>
                    <p style="font-size:13px; color:#555555; margin-bottom:4px;">📍 <b>Địa chỉ:</b> 205 Trần Hưng Đạo, Quận Hoàn Kiếm, Hà Nội</p>
                    <p style="font-size:13px; color:#555555; margin-bottom:4px;">📞 <b>Điện thoại:</b> (024) 3933 6688</p>
                    <p style="font-size:13px; color:#555555;">🕒 <b>Giờ mở cửa:</b> 08:30 - 21:30</p>
                </div>

                <div style="margin-bottom:20px; padding-bottom:15px; border-bottom:1px solid #eeeeee;">
                    <h4 style="font-size:15px; font-weight:700; color:var(--dark-color); margin-bottom:6px;">
                        3. Showroom Hai Bà Trưng (TP. Hồ Chí Minh)
                    </h4>
                    <p style="font-size:13px; color:#555555; margin-bottom:4px;">📍 <b>Địa chỉ:</b> 300 Hai Bà Trưng, Phường 8, Quận 3, TP. Hồ Chí Minh</p>
                    <p style="font-size:13px; color:#555555; margin-bottom:4px;">📞 <b>Điện thoại:</b> (028) 3820 6688</p>
                    <p style="font-size:13px; color:#555555;">🕒 <b>Giờ mở cửa:</b> 09:00 - 22:00</p>
                </div>

                <div>
                    <h4 style="font-size:15px; font-weight:700; color:var(--dark-color); margin-bottom:6px;">
                        4. Showroom Diamond Plaza (TP. Hồ Chí Minh)
                    </h4>
                    <p style="font-size:13px; color:#555555; margin-bottom:4px;">📍 <b>Địa chỉ:</b> Tầng 3, TTTM Diamond Plaza, 34 Lê Duẩn, Quận 1, TP.HCM</p>
                    <p style="font-size:13px; color:#555555;">🕒 <b>Giờ mở cửa:</b> 09:30 - 22:00</p>
                </div>
            </div>

            <!-- Right: Contact Form -->
            <div style="background:#ffffff; border:1px solid var(--border-color); border-radius:6px; padding:25px; box-shadow:var(--shadow-sm);">
                <h3 style="font-size:18px; font-weight:800; color:var(--dark-color); margin-bottom:18px; padding-bottom:10px; border-bottom:2px solid var(--primary-color);">
                    ✉️ GỬI THÔNG ĐIỆP CHO CHÚNG TÔI
                </h3>

                <p style="font-size:13px; color:#666666; margin-bottom:15px;">
                    Nếu bạn có bất kỳ câu hỏi nào về sản phẩm, chính sách bảo hành hoặc yêu cầu đặt mẫu đồng hồ đặc biệt, xin vui lòng để lại thông tin:
                </p>

                <div style="margin-bottom:12px;">
                    <label style="display:block; font-size:12px; font-weight:700; margin-bottom:4px;">Họ và tên (*):</label>
                    <asp:TextBox ID="txtContactName" runat="server" CssClass="search-input" style="border:1px solid var(--border-color); border-radius:4px;"></asp:TextBox>
                </div>

                <div style="margin-bottom:12px;">
                    <label style="display:block; font-size:12px; font-weight:700; margin-bottom:4px;">Số điện thoại (*):</label>
                    <asp:TextBox ID="txtContactPhone" runat="server" CssClass="search-input" style="border:1px solid var(--border-color); border-radius:4px;"></asp:TextBox>
                </div>

                <div style="margin-bottom:12px;">
                    <label style="display:block; font-size:12px; font-weight:700; margin-bottom:4px;">Email:</label>
                    <asp:TextBox ID="txtContactEmail" runat="server" CssClass="search-input" style="border:1px solid var(--border-color); border-radius:4px;"></asp:TextBox>
                </div>

                <div style="margin-bottom:15px;">
                    <label style="display:block; font-size:12px; font-weight:700; margin-bottom:4px;">Nội dung tin nhắn:</label>
                    <asp:TextBox ID="txtContactMessage" runat="server" TextMode="MultiLine" Rows="4" 
                        CssClass="search-input" style="border:1px solid var(--border-color); border-radius:4px; height:auto;"></asp:TextBox>
                </div>

                <asp:Button ID="btnSendContact" runat="server" Text="GỬI YÊU CẦU TƯ VẤN" 
                    CssClass="btn-detail-buy" style="width:100%; border:none;" OnClick="btnSendContact_Click" />

                <asp:Label ID="lblContactMsg" runat="server" Visible="false" 
                    style="display:block; margin-top:12px; font-weight:700; font-size:13px; text-align:center;"></asp:Label>
            </div>
        </div>
    </div>
</asp:Content>
