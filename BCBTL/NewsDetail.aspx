<%@ Page Title="Chi Tiết Bài Viết" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NewsDetail.aspx.cs" Inherits="BCBTL.NewsDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <!-- BREADCRUMB -->
        <div class="breadcrumb-wrap">
            <div class="breadcrumb-list">
                <span class="breadcrumb-item"><a href="Default.aspx">Trang chủ</a></span>
                <span class="breadcrumb-separator">/</span>
                <span class="breadcrumb-item"><a href="NewsList.aspx">Tin tức</a></span>
                <span class="breadcrumb-separator">/</span>
                <span class="breadcrumb-item active">
                    <asp:Literal ID="litBreadcrumbTitle" runat="server"></asp:Literal>
                </span>
            </div>
        </div>

        <div style="background:#ffffff; border:1px solid var(--border-color); border-radius:6px; padding:35px; margin-bottom:40px; box-shadow:var(--shadow-sm); max-width:900px; margin-left:auto; margin-right:auto;">
            <asp:Panel ID="pnlContent" runat="server">
                <span style="font-size:12px; color:var(--primary-color); font-weight:700; text-transform:uppercase;">
                    Kiến thức & Cẩm nang đồng hồ
                </span>
                <h1 style="font-size:26px; font-weight:800; color:var(--dark-color); line-height:1.4; margin:10px 0 15px;">
                    <asp:Literal ID="litTitle" runat="server"></asp:Literal>
                </h1>
                <div style="font-size:12px; color:#888888; padding-bottom:15px; border-bottom:1px solid #eeeeee; margin-bottom:20px;">
                    <span>📅 Ngày đăng: <asp:Literal ID="litDate" runat="server"></asp:Literal></span>
                    <span style="margin:0 10px;">•</span>
                    <span>Tác giả: <asp:Literal ID="litAuthor" runat="server"></asp:Literal></span>
                </div>

                <div style="font-size:15px; font-weight:600; color:#444444; line-height:1.7; margin-bottom:25px; background:#f9fafb; padding:15px 20px; border-left:4px solid var(--primary-color); border-radius:0 4px 4px 0;">
                    <asp:Literal ID="litSummary" runat="server"></asp:Literal>
                </div>

                <div style="margin-bottom:25px; text-align:center;">
                    <asp:Image ID="imgArticle" runat="server" style="max-height:420px; border-radius:6px; box-shadow:var(--shadow-sm); margin:0 auto;" />
                </div>

                <div class="article-body" style="font-size:15px; line-height:1.9; color:#333333;">
                    <asp:Literal ID="litContents" runat="server"></asp:Literal>
                </div>

                <div style="margin-top:35px; padding-top:20px; border-top:1px solid #eeeeee; display:flex; justify-content:space-between; align-items:center;">
                    <a href="NewsList.aspx" class="btn-view-detail" style="display:inline-block; padding:10px 20px; font-weight:700;">
                        ◀ Quay lại danh sách tin tức
                    </a>
                    <a href="ProductList.aspx" class="btn-add-cart" style="display:inline-block; padding:10px 20px; font-weight:700;">
                        Xem bộ sưu tập đồng hồ ▶
                    </a>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlNotFound" runat="server" Visible="false" CssClass="empty-results">
                <h3>Không tìm thấy bài viết</h3>
                <p>Bài viết bạn tìm kiếm không tồn tại hoặc đã bị ẩn.</p>
                <a href="NewsList.aspx" class="btn-add-cart" style="display:inline-block; padding:10px 20px;">Quay lại danh mục tin tức</a>
            </asp:Panel>
        </div>
    </div>
</asp:Content>
