<%@ Page Title="Tin Tức & Đánh Giá" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NewsList.aspx.cs" Inherits="BCBTL.NewsList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <!-- BREADCRUMB -->
        <div class="breadcrumb-wrap">
            <div class="breadcrumb-list">
                <span class="breadcrumb-item"><a href="Default.aspx">Trang chủ</a></span>
                <span class="breadcrumb-separator">/</span>
                <span class="breadcrumb-item active">Tin tức & Đánh giá</span>
            </div>
        </div>

        <div class="catalog-banner" style="background: linear-gradient(rgba(17, 24, 39, 0.9), rgba(15, 23, 42, 0.9)), url('Assets/images/products/news_phanbiet.jpg') center/cover;">
            <h2>TIN TỨC & KIẾN THỨC ĐỒNG HỒ</h2>
            <p>Khám phá thế giới thời gian cùng các chuyên gia KevLouis. Cập nhật xu hướng đồng hồ mới nhất, mẹo phân biệt thật giả và cẩm nang sử dụng, bảo dưỡng chuẩn Thụy Sĩ.</p>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 25px; margin-bottom: 40px;">
            <asp:Repeater ID="rptNews" runat="server">
                <ItemTemplate>
                    <div style="background:#ffffff; border:1px solid var(--border-color); border-radius:6px; overflow:hidden; display:flex; flex-direction:column; box-shadow:var(--shadow-sm); transition:var(--transition);">
                        <a href='<%# "NewsDetail.aspx?id=" + Eval("ID_P") %>'>
                            <img src='<%# ResolveUrl("~/Assets/images/products/" + (string.IsNullOrEmpty(Eval("Image") as string) ? "news_phanbiet.jpg" : Eval("Image"))) %>' 
                                 alt='<%# Eval("Title") %>' style="width:100%; height:220px; object-fit:cover;" />
                        </a>
                        <div style="padding:20px; flex:1; display:flex; flex-direction:column;">
                            <span style="font-size:12px; color:#888888; margin-bottom:6px;">
                                📅 <%# string.Format("{0:dd/MM/yyyy}", Eval("CreaDate")) %> • Người đăng: <%# Eval("UserAdd") ?? "KevLouis" %>
                            </span>
                            <h3 style="font-size:16px; font-weight:700; margin-bottom:10px; line-height:1.4;">
                                <a href='<%# "NewsDetail.aspx?id=" + Eval("ID_P") %>' style="color:var(--dark-color);">
                                    <%# Eval("Title") %>
                                </a>
                            </h3>
                            <p style="font-size:13px; color:#666666; line-height:1.7; margin-bottom:15px;">
                                <%# Eval("Sumary") %>
                            </p>
                            <a href='<%# "NewsDetail.aspx?id=" + Eval("ID_P") %>' style="color:var(--primary-color); font-weight:700; font-size:13px; margin-top:auto; display:inline-flex; align-items:center; gap:4px;">
                                Đọc toàn bộ bài viết ▶
                            </a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>
