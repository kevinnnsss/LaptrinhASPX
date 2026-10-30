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

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <asp:UpdatePanel ID="upCart" runat="server">
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
                                    <th style="width:45%;">Sản phẩm đồng hồ</th>
                                    <th style="width:15%; text-align:center;">Đơn giá</th>
                                    <th style="width:15%; text-align:center;">Số lượng</th>
                                    <th style="width:15%; text-align:center;">Thành tiền</th>
                                    <th style="width:10%; text-align:center;">Thao tác</th>
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
                                                <div style="display:inline-flex; align-items:center; gap:5px;">
                                                    <asp:TextBox ID="txtItemQty" runat="server" Text='<%# Eval("Quantity") %>' 
                                                        Width="45px" Height="30px" Style="text-align:center; font-weight:700; border:1px solid #ccc; border-radius:4px;"></asp:TextBox>
                                                    <asp:LinkButton ID="btnUpdateQty" runat="server" CommandName="UpdateQty" CommandArgument='<%# Eval("ProductID") %>' 
                                                        Text="Cập nhật" ForeColor="#007bff" Font-Size="11px" Font-Bold="true"></asp:LinkButton>
                                                </div>
                                            </td>
                                            <td style="text-align:center;">
                                                <span style="font-weight:800; color:var(--primary-color);">
                                                    <%# string.Format("{0:N0} đ", Eval("TotalPrice")) %>
                                                </span>
                                            </td>
                                            <td style="text-align:center;">
                                                <asp:LinkButton ID="btnDeleteItem" runat="server" CommandName="DeleteItem" CommandArgument='<%# Eval("ProductID") %>' 
                                                    Text="Xóa ✕" ForeColor="#dc2626" Font-Bold="true" Font-Size="12px" 
                                                    OnClientClick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?');"></asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>

                        <div class="cart-total-bar">
                            <div style="text-align:right;">
                                <div style="font-size:13px; color:#777777;">Tổng tiền thanh toán (Đã bao gồm VAT):</div>
                                <div class="cart-grand-total">
                                    <asp:Literal ID="litCartGrandTotal" runat="server">0 đ</asp:Literal>
                                </div>
                            </div>
                        </div>

                        <div style="display:flex; justify-content:space-between; align-items:center; margin-top:20px; flex-wrap:wrap; gap:15px;">
                            <div style="display:flex; gap:10px;">
                                <a href="ProductList.aspx" class="btn-view-detail" style="padding:12px 20px; font-weight:700; font-size:13px;">
                                    ◀ Tiếp tục chọn đồng hồ
                                </a>
                                <asp:Button ID="btnClearAllCart" runat="server" Text="Xóa hết giỏ hàng" 
                                    CssClass="btn-view-detail" Style="color:#dc2626; border-color:#fca5a5; font-weight:700;" 
                                    OnClick="btnClearAllCart_Click" 
                                    OnClientClick="return confirm('Bạn có chắc chắn muốn xóa toàn bộ giỏ hàng?');" />
                            </div>

                            <a href="Checkout.aspx" class="btn-detail-buy" style="display:inline-block; padding:12px 30px; font-size:14px;">
                                TIẾN HÀNH ĐẶT HÀNG ▶
                            </a>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlEmptyCart" runat="server" Visible="false" CssClass="empty-results">
                        <div class="empty-icon">🛒</div>
                        <h3>Giỏ hàng của bạn đang trống</h3>
                        <p>Bạn chưa thêm chiếc đồng hồ nào vào giỏ hàng. Hãy khám phá ngay các bộ sưu tập đồng hồ nam, nữ và thương hiệu chính hãng tại Duy Anh Watch!</p>
                        <a href="ProductList.aspx" class="btn-add-cart" style="display:inline-block; padding:12px 28px; font-size:14px;">
                            Khám phá đồng hồ ngay
                        </a>
                    </asp:Panel>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
