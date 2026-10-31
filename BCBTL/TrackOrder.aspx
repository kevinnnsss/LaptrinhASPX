<%@ Page Title="Tra Cứu Tiến Độ Đơn Hàng" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TrackOrder.aspx.cs" Inherits="BCBTL.TrackOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .track-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 30px 15px 50px;
        }
        .track-search-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 30px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 30px;
            text-align: center;
        }
        .track-search-title {
            font-size: 22px;
            font-weight: 800;
            color: var(--primary-color);
            margin-bottom: 8px;
            text-transform: uppercase;
        }
        .track-search-sub {
            color: var(--gray-text);
            font-size: 13px;
            margin-bottom: 20px;
        }
        .track-form-box {
            display: flex;
            gap: 10px;
            max-width: 600px;
            margin: 0 auto;
        }
        .track-input {
            flex: 1;
            padding: 12px 16px;
            border: 2px solid var(--border-color);
            border-radius: 6px;
            font-size: 14px;
            outline: none;
            transition: var(--transition);
        }
        .track-input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(158, 11, 15, 0.1);
        }
        .btn-track {
            background: var(--primary-color);
            color: #ffffff;
            border: none;
            padding: 12px 24px;
            font-weight: 700;
            font-size: 14px;
            border-radius: 6px;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 6px;
            white-space: nowrap;
        }
        .btn-track:hover {
            background: var(--primary-hover);
        }

        /* STEPPER TIMELINE */
        .stepper-wrap {
            margin: 30px 0 25px;
            padding: 20px 15px;
            background: #fafafa;
            border-radius: 8px;
            border: 1px solid var(--border-color);
        }
        .stepper-list {
            display: flex;
            justify-content: space-between;
            position: relative;
            list-style: none;
            margin: 0;
            padding: 0;
        }
        .stepper-list::before {
            content: "";
            position: absolute;
            top: 24px;
            left: 50px;
            right: 50px;
            height: 4px;
            background: #e5e7eb;
            z-index: 1;
        }
        .stepper-step {
            position: relative;
            z-index: 2;
            text-align: center;
            flex: 1;
        }
        .step-circle {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: #ffffff;
            border: 3px solid #cbd5e1;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 10px;
            font-size: 20px;
            font-weight: 700;
            color: #94a3b8;
            transition: var(--transition);
        }
        .step-label {
            font-size: 13px;
            font-weight: 700;
            color: #64748b;
        }
        .step-desc {
            font-size: 11px;
            color: #94a3b8;
            margin-top: 2px;
        }

        /* ACTIVE / COMPLETED STEPS */
        .stepper-step.completed .step-circle {
            background: #16a34a;
            border-color: #16a34a;
            color: #ffffff;
        }
        .stepper-step.completed .step-label {
            color: #16a34a;
        }

        .stepper-step.current .step-circle {
            background: #ffffff;
            border-color: var(--primary-color);
            color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(158, 11, 15, 0.2);
            animation: pulse-ring 1.8s infinite;
        }
        .stepper-step.current .step-label {
            color: var(--primary-color);
            font-weight: 800;
        }

        @keyframes pulse-ring {
            0% { box-shadow: 0 0 0 0 rgba(158, 11, 15, 0.4); }
            70% { box-shadow: 0 0 0 8px rgba(158, 11, 15, 0); }
            100% { box-shadow: 0 0 0 0 rgba(158, 11, 15, 0); }
        }

        /* Order Details Card */
        .order-result-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            margin-bottom: 30px;
        }
        .order-result-header {
            padding: 18px 24px;
            background: #f8fafc;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }
        .order-result-body {
            padding: 24px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
            margin-bottom: 24px;
            padding: 16px;
            background: #fdfdfd;
            border: 1px solid #f1f5f9;
            border-radius: 6px;
        }
        .info-cell {
            font-size: 13px;
        }
        .info-cell b {
            color: #475569;
            display: inline-block;
            width: 130px;
        }
        .info-cell span {
            color: #1e293b;
            font-weight: 600;
        }

        /* Table */
        .order-items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            font-size: 13px;
        }
        .order-items-table th {
            background: #f1f5f9;
            padding: 10px 14px;
            text-align: left;
            font-weight: 700;
            color: #334155;
            border-bottom: 1px solid var(--border-color);
        }
        .order-items-table td {
            padding: 12px 14px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }
        .item-thumb {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid #e2e8f0;
        }

        .cancelled-box {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
            border-radius: 6px;
            padding: 16px;
            margin: 20px 0;
            text-align: center;
            font-weight: 700;
        }

        @media (max-width: 768px) {
            .track-form-box {
                flex-direction: column;
            }
            .info-grid {
                grid-template-columns: 1fr;
            }
            .stepper-list::before {
                display: none;
            }
            .stepper-list {
                flex-direction: column;
                gap: 15px;
            }
            .stepper-step {
                display: flex;
                align-items: center;
                gap: 12px;
                text-align: left;
            }
            .step-circle {
                margin: 0;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="track-container">
        <!-- BREADCRUMB -->
        <div class="breadcrumb-wrap">
            <div class="breadcrumb-list">
                <span class="breadcrumb-item"><a href="Default.aspx">Trang chủ</a></span>
                <span class="breadcrumb-separator">/</span>
                <span class="breadcrumb-item active">Tra cứu đơn hàng</span>
            </div>
        </div>

        <asp:UpdateProgress ID="upProgTrack" runat="server" AssociatedUpdatePanelID="upTrackOrder">
            <ProgressTemplate>
                <div class="cart-loading-overlay">
                    <div class="cart-spinner-box">
                        <div class="cart-spinner"></div>
                        <span style="font-weight:700; color:var(--primary-color); font-size:14px;">Đang tìm kiếm thông tin đơn hàng...</span>
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

        <asp:UpdatePanel ID="upTrackOrder" runat="server">
            <ContentTemplate>
                <!-- FORM TRA CỨU -->
        <div class="track-search-card">
            <h1 class="track-search-title">🔍 Tra Cứu Tiến Độ Đơn Hàng</h1>
            <p class="track-search-sub">
                Nhập <b>Số điện thoại đặt hàng</b> hoặc <b>Mã đơn hàng</b> (ví dụ: 0943735437 hoặc mã số 5) để kiểm tra tình trạng xác nhận và lộ trình vận chuyển đồng hồ của bạn.
            </p>

            <div class="track-form-box">
                <asp:TextBox ID="txtKeyword" runat="server" CssClass="track-input" 
                    placeholder="Nhập số điện thoại (vd: 0943735437) hoặc mã đơn hàng..."></asp:TextBox>
                <asp:Button ID="btnTrack" runat="server" Text="Tra Cứu Ngay" CssClass="btn-track" OnClick="btnTrack_Click" />
            </div>

            <asp:Label ID="lblTrackMsg" runat="server" Visible="false" 
                style="display:inline-block; margin-top:15px; padding:8px 16px; border-radius:4px; font-size:13px; font-weight:700;"></asp:Label>
        </div>

        <!-- KẾT QUẢ TRA CỨU ĐƠN HÀNG -->
        <asp:Panel ID="pnlResult" runat="server" Visible="false" CssClass="order-result-card">
            <div class="order-result-header">
                <div>
                    <span style="font-size:12px; color:#64748b; text-transform:uppercase; font-weight:700;">ĐƠN ĐẶT HÀNG:</span>
                    <h3 style="font-size:18px; font-weight:800; color:var(--primary-color); margin:0;">
                        #<asp:Label ID="lblOrderID" runat="server"></asp:Label>
                    </h3>
                </div>
                <div>
                    <span style="font-size:12px; color:#64748b; display:block;">Ngày đặt:</span>
                    <strong style="color:#1e293b;"><asp:Label ID="lblOrderDate" runat="server"></asp:Label></strong>
                </div>
                <div>
                    <span style="font-size:12px; color:#64748b; display:block;">Trạng thái hiện tại:</span>
                    <asp:Label ID="lblStatusBadge" runat="server"></asp:Label>
                </div>
            </div>

            <div class="order-result-body">
                <!-- 1. THANH TIẾN TRÌNH TRẠNG THÁI (STEPPER) -->
                <asp:Panel ID="pnlCancelled" runat="server" Visible="false" CssClass="cancelled-box">
                    ❌ ĐƠN HÀNG NÀY ĐÃ ĐƯỢC HỦY THEO YÊU CẦU HOẶC KHÔNG THỂ LIÊN HỆ ĐƯỢC VỚI KHÁCH HÀNG.
                </asp:Panel>

                <asp:Panel ID="pnlStepper" runat="server" CssClass="stepper-wrap">
                    <ul class="stepper-list">
                        <!-- BƯỚC 1: CHỜ XỬ LÝ -->
                        <li id="step1" runat="server" class="stepper-step">
                            <div class="step-circle">1</div>
                            <div class="step-label">Chờ xử lý</div>
                            <div class="step-desc">Đơn hàng vừa tạo</div>
                        </li>

                        <!-- BƯỚC 2: ĐÃ XÁC NHẬN -->
                        <li id="step2" runat="server" class="stepper-step">
                            <div class="step-circle">2</div>
                            <div class="step-label">Đã xác nhận</div>
                            <div class="step-desc">Nhân viên đã duyệt đơn</div>
                        </li>

                        <!-- BƯỚC 3: ĐANG GIAO -->
                        <li id="step3" runat="server" class="stepper-step">
                            <div class="step-circle">3</div>
                            <div class="step-label">Đang giao hàng</div>
                            <div class="step-desc">Đang vận chuyển đến bạn</div>
                        </li>

                        <!-- BƯỚC 4: ĐÃ HOÀN TẤT -->
                        <li id="step4" runat="server" class="stepper-step">
                            <div class="step-circle">4</div>
                            <div class="step-label">Đã hoàn tất</div>
                            <div class="step-desc">Đã giao & thanh toán</div>
                        </li>
                    </ul>
                </asp:Panel>

                <!-- 2. THÔNG TIN KHÁCH HÀNG & GIAO HÀNG -->
                <h4 style="margin-bottom:12px; color:#1e293b; font-size:15px;">👤 Thông Tin Nhận Hàng</h4>
                <div class="info-grid">
                    <div class="info-cell">
                        <b>Người nhận:</b>
                        <asp:Label ID="lblCustomerName" runat="server"></asp:Label>
                    </div>
                    <div class="info-cell">
                        <b>Số điện thoại:</b>
                        <asp:Label ID="lblCustomerPhone" runat="server"></asp:Label>
                    </div>
                    <div class="info-cell">
                        <b>Email:</b>
                        <asp:Label ID="lblCustomerEmail" runat="server"></asp:Label>
                    </div>
                    <div class="info-cell">
                        <b>Phương thức:</b>
                        <span>Thanh toán khi nhận hàng (COD)</span>
                    </div>
                    <div class="info-cell" style="grid-column: span 2;">
                        <b>Địa chỉ giao hàng:</b>
                        <asp:Label ID="lblDeliveryAddress" runat="server"></asp:Label>
                    </div>
                    <div class="info-cell" style="grid-column: span 2;">
                        <b>Ghi chú đơn hàng:</b>
                        <asp:Label ID="lblOrderNotes" runat="server" Font-Italic="true"></asp:Label>
                    </div>
                </div>

                <!-- 3. DANH SÁCH SẢN PHẨM MUA -->
                <h4 style="margin-bottom:12px; color:#1e293b; font-size:15px;">⌚ Danh Sách Đồng Hồ Đã Đặt</h4>
                <div style="overflow-x:auto;">
                    <asp:GridView ID="gvItems" runat="server" AutoGenerateColumns="False" 
                        CssClass="order-items-table" GridLines="None">
                        <Columns>
                            <asp:TemplateField HeaderText="Ảnh" ItemStyle-Width="60px" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <img src='<%# ResolveUrl("~/Assets/images/products/" + (string.IsNullOrEmpty(Eval("Image") as string) ? "default-watch.jpg" : Eval("Image"))) %>' 
                                         alt="" class="item-thumb" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Tên Đồng Hồ">
                                <ItemTemplate>
                                    <a href='<%# "ProductDetail.aspx?id=" + Eval("ID_P") %>' style="font-weight:700; color:#1e293b;" target="_blank">
                                        <%# Eval("Title") %>
                                    </a>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Đơn Giá" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                                <ItemTemplate>
                                    <%# string.Format("{0:N0} đ", Eval("UnitPrice")) %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Quantity" HeaderText="Số Lượng" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                            <asp:TemplateField HeaderText="Thành Tiền" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                                <ItemTemplate>
                                    <strong style="color:var(--primary-color);"><%# string.Format("{0:N0} đ", Eval("LineTotal")) %></strong>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- TỔNG TIỀN -->
                <div style="text-align:right; margin-top:15px; padding-top:15px; border-top:2px solid #e2e8f0;">
                    <span style="font-size:14px; font-weight:700; color:#475569;">TỔNG TIỀN THANH TOÁN: </span>
                    <span style="font-size:22px; font-weight:900; color:var(--primary-color);">
                        <asp:Label ID="lblTotalAmount" runat="server"></asp:Label>
                    </span>
                </div>
            </div>
        </asp:Panel>

        <!-- KHÔNG TÌM THẤY KẾT QUẢ -->
        <asp:Panel ID="pnlNotFound" runat="server" Visible="false" CssClass="empty-results">
            <div class="empty-icon">🔎</div>
            <h3>Không tìm thấy đơn hàng nào!</h3>
            <p>
                Rất tiếc, hệ thống không tìm thấy đơn hàng nào khớp với thông tin bạn vừa nhập. Bạn vui lòng kiểm tra lại chính xác <b>Số điện thoại</b> hoặc <b>Mã đơn hàng</b> khi đặt hàng.
            </p>
            <p style="font-size:12px; color:#64748b;">
                Cần hỗ trợ gấp? Gọi ngay Hotline CSKH: <b style="color:var(--primary-color);">1900 2117</b> (8h00 - 21h30).
            </p>
        </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
