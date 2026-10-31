<%@ Page Title="Tra Cứu Đơn Hàng" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TrackOrder.aspx.cs" Inherits="BCBTL.TrackOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .track-container { max-width: 860px; margin: 30px auto; }
        .track-card { background: #fff; border-radius: 8px; border: 1px solid #e2e8f0; padding: 28px; box-shadow: 0 4px 12px rgba(0,0,0,0.03); margin-bottom: 24px; }
        .track-header { text-align: center; margin-bottom: 24px; }
        .track-header h1 { font-size: 24px; color: var(--primary-color); font-weight: 700; margin-bottom: 8px; }
        .track-header p { color: #718096; font-size: 14px; }

        .search-box-wrap { display: flex; gap: 12px; max-width: 550px; margin: 0 auto 10px; }
        .track-input { flex-grow: 1; padding: 12px 16px; border: 2px solid #e2e8f0; border-radius: 6px; font-size: 15px; outline: none; transition: border-color 0.2s; }
        .track-input:focus { border-color: var(--primary-color); }
        .btn-track { background: var(--primary-color); color: #fff; padding: 12px 24px; border: none; border-radius: 6px; font-weight: 700; font-size: 15px; cursor: pointer; transition: background 0.2s; }
        .btn-track:hover { background: var(--primary-dark); }

        /* STEPPER TIMELINE */
        .stepper-wrap { display: flex; justify-content: space-between; position: relative; margin: 40px 20px 30px; }
        .stepper-wrap::before { content: ''; position: absolute; top: 18px; left: 40px; right: 40px; height: 4px; background: #e2e8f0; z-index: 1; }
        .stepper-progress { position: absolute; top: 18px; left: 40px; height: 4px; background: var(--primary-color); z-index: 1; transition: width 0.4s ease; }
        .step-item { position: relative; z-index: 2; text-align: center; width: 100px; }
        .step-circle { width: 40px; height: 40px; border-radius: 50%; background: #e2e8f0; color: #718096; display: flex; align-items: center; justify-content: center; margin: 0 auto 10px; font-weight: 700; font-size: 14px; transition: all 0.3s; }
        .step-item.active .step-circle { background: var(--primary-color); color: #fff; box-shadow: 0 0 0 4px rgba(158,11,15,0.15); }
        .step-item.completed .step-circle { background: #28a745; color: #fff; }
        .step-title { font-size: 13px; font-weight: 600; color: #4a5568; }
        .step-item.active .step-title { color: var(--primary-color); font-weight: 700; }

        .order-info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 16px; background: #f8fafc; padding: 16px; border-radius: 6px; margin: 20px 0; border: 1px solid #edf2f7; }
        .order-info-item small { display: block; color: #718096; font-size: 12px; margin-bottom: 4px; text-transform: uppercase; }
        .order-info-item strong { color: #1a202c; font-size: 14px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container track-container">
        <asp:UpdatePanel ID="upTrackOrder" runat="server">
            <ContentTemplate>
                <div class="track-card">
                    <div class="track-header">
                        <h1>TRA CỨU TIẾN ĐỘ ĐƠN HÀNG</h1>
                        <p>Nhập số điện thoại người nhận hoặc mã số đơn hàng để kiểm tra lộ trình vận chuyển</p>
                    </div>

                    <div class="search-box-wrap">
                        <asp:TextBox ID="txtTrackQuery" runat="server" CssClass="track-input" placeholder="Ví dụ: 0912345678 hoặc Mã đơn..."></asp:TextBox>
                        <asp:Button ID="btnSearchTrack" runat="server" Text="Tra Cứu" CssClass="btn-track" OnClick="btnSearchTrack_Click" />
                    </div>

                    <asp:Label ID="lblTrackMsg" runat="server" Visible="false" style="display:block; text-align:center; margin-top:12px; font-weight:600; color:#e53e3e;"></asp:Label>
                </div>

                <!-- ORDER TRACKING RESULT -->
                <asp:Panel ID="pnlResult" runat="server" Visible="false" CssClass="track-card">
                    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid #e2e8f0; padding-bottom:12px; margin-bottom:20px;">
                        <div>
                            <h2 style="font-size:18px; color:var(--primary-color);">Đơn Hàng #<asp:Literal ID="litOrderId" runat="server"></asp:Literal></h2>
                            <small style="color:#718096;">Đặt lúc: <asp:Literal ID="litOrderDate" runat="server"></asp:Literal></small>
                        </div>
                        <div>
                            <span class="badge-auth-tag" style="position:static; font-size:13px; padding:6px 12px;">
                                <asp:Literal ID="litOrderStatus" runat="server"></asp:Literal>
                            </span>
                        </div>
                    </div>

                    <!-- STEPPER -->
                    <div class="stepper-wrap">
                        <div class="stepper-progress" id="stepperProgress" runat="server" style="width: 0%;"></div>

                        <div class="step-item" id="step1" runat="server">
                            <div class="step-circle">1</div>
                            <div class="step-title">Chờ Xử Lý</div>
                        </div>

                        <div class="step-item" id="step2" runat="server">
                            <div class="step-circle">2</div>
                            <div class="step-title">Đã Xác Nhận</div>
                        </div>

                        <div class="step-item" id="step3" runat="server">
                            <div class="step-circle">3</div>
                            <div class="step-title">Đang Giao</div>
                        </div>

                        <div class="step-item" id="step4" runat="server">
                            <div class="step-circle">4</div>
                            <div class="step-title">Đã Hoàn Tất</div>
                        </div>
                    </div>

                    <!-- RECIPIENT INFO -->
                    <div class="order-info-grid">
                        <div class="order-info-item">
                            <small>Người nhận hàng</small>
                            <strong><asp:Literal ID="litCustomerName" runat="server"></asp:Literal></strong>
                        </div>
                        <div class="order-info-item">
                            <small>Số điện thoại</small>
                            <strong><asp:Literal ID="litCustomerPhone" runat="server"></asp:Literal></strong>
                        </div>
                        <div class="order-info-item">
                            <small>Địa chỉ nhận</small>
                            <strong><asp:Literal ID="litDeliveryAddress" runat="server"></asp:Literal></strong>
                        </div>
                        <div class="order-info-item">
                            <small>Tổng thanh toán</small>
                            <strong style="color:var(--primary-color); font-size:16px;"><asp:Literal ID="litTotalAmount" runat="server"></asp:Literal></strong>
                        </div>
                    </div>

                    <!-- PRODUCT ITEMS -->
                    <h3 style="font-size:15px; margin: 20px 0 10px; color:#1a202c;">Sản Phẩm Trong Đơn Hàng:</h3>
                    <asp:Repeater ID="rptTrackItems" runat="server">
                        <HeaderTemplate>
                            <table style="width:100%; border-collapse:collapse;">
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr style="border-bottom:1px solid #edf2f7;">
                                <td style="padding:10px 0; width:60px;">
                                    <img src='<%# ResolveUrl("~/Assets/images/products/" + (string.IsNullOrEmpty(Eval("Image") as string) ? "default-watch.jpg" : Eval("Image"))) %>' 
                                         style="width:50px; height:50px; border-radius:4px; object-fit:cover; border:1px solid #e2e8f0;" />
                                </td>
                                <td style="padding:10px 15px;">
                                    <div style="font-weight:600; color:#2d3748;"><%# Eval("Title") %></div>
                                    <small style="color:#718096;">Số lượng: <%# Eval("Quantity") %> chiếc</small>
                                </td>
                                <td style="padding:10px 0; text-align:right; font-weight:700; color:var(--primary-color);">
                                    <%# string.Format("{0:N0} đ", Eval("TotalPrice")) %>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
