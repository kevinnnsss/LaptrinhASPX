using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BCBTL
{
    public partial class Cart : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCart();
            }
        }

        private List<CartItem> GetCart()
        {
            var cart = Session["Cart"] as List<CartItem>;
            if (cart == null)
            {
                cart = new List<CartItem>();
                Session["Cart"] = cart;
            }
            return cart;
        }

        private void BindCart()
        {
            var cart = GetCart();

            // Synchronize price and stock with database to ensure data integrity
            using (var db = DbContextHelper.GetContext())
            {
                for (int i = cart.Count - 1; i >= 0; i--)
                {
                    var item = cart[i];
                    var product = (from p in db.PageItems
                                   join pr in db.ProductPrices on p.ID_P equals pr.ID_P
                                   where p.ID_P == item.ProductID && p.Hide == false && p.ItemType == 1
                                   select new { pr.Price, pr.OriginalPrice, pr.StockQuantity }).FirstOrDefault();

                    if (product == null || product.StockQuantity <= 0)
                    {
                        // Product is no longer active or out of stock
                        cart.RemoveAt(i);
                    }
                    else
                    {
                        item.Price = product.Price;
                        item.OriginalPrice = product.OriginalPrice ?? product.Price;
                        item.StockQuantity = product.StockQuantity;
                        if (item.Quantity > product.StockQuantity)
                        {
                            item.Quantity = product.StockQuantity;
                        }
                    }
                }
            }

            Session["Cart"] = cart;

            if (cart.Count > 0)
            {
                pnlCartTable.Visible = true;
                pnlEmptyCart.Visible = false;

                rptCartItems.DataSource = cart;
                rptCartItems.DataBind();

                int totalCount = cart.Sum(c => c.Quantity);
                decimal subTotal = cart.Sum(c => c.TotalPrice);

                litCartCountHeader.Text = totalCount.ToString();
                litCartSubTotal.Text = string.Format("{0:N0} đ", subTotal);

                // Kiểm tra voucher giảm giá
                int discountPercent = 0;
                if (Session["DiscountPercent"] != null)
                {
                    int.TryParse(Session["DiscountPercent"].ToString(), out discountPercent);
                }

                if (discountPercent > 0)
                {
                    decimal discountAmount = Math.Round(subTotal * discountPercent / 100m);
                    decimal grandTotal = Math.Max(0, subTotal - discountAmount);

                    pnlDiscountRow.Visible = true;
                    litDiscountPercent.Text = discountPercent.ToString();
                    litDiscountAmount.Text = string.Format("{0:N0} đ", discountAmount);
                    litCartGrandTotal.Text = string.Format("{0:N0} đ", grandTotal);

                    Session["DiscountAmount"] = discountAmount;
                    Session["GrandTotal"] = grandTotal;

                    txtCouponCode.Text = Session["CouponCode"] != null ? Session["CouponCode"].ToString() : "";
                    txtCouponCode.Enabled = false;
                    btnApplyCoupon.Visible = false;
                    btnClearCoupon.Visible = true;
                }
                else
                {
                    pnlDiscountRow.Visible = false;
                    litCartGrandTotal.Text = string.Format("{0:N0} đ", subTotal);

                    Session["DiscountAmount"] = 0m;
                    Session["GrandTotal"] = subTotal;

                    txtCouponCode.Enabled = true;
                    btnApplyCoupon.Visible = true;
                    btnClearCoupon.Visible = false;
                }
            }
            else
            {
                pnlCartTable.Visible = false;
                pnlEmptyCart.Visible = true;
                litCartCountHeader.Text = "0";
                litCartGrandTotal.Text = "0 đ";
                Session["DiscountPercent"] = 0;
                Session["DiscountAmount"] = 0m;
                Session["GrandTotal"] = 0m;
            }

            // Đồng bộ giỏ hàng trên MasterPage (Live AJAX Sync)
            if (Master is Site siteMaster)
            {
                siteMaster.UpdateCartPreview();
            }
        }

        protected void rptCartItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);
            var cart = GetCart();
            var item = cart.FirstOrDefault(c => c.ProductID == productId);

            if (item == null) return;

            if (e.CommandName == "DeleteItem")
            {
                cart.Remove(item);
                Session["Cart"] = cart;
                ShowMsg($"Đã xóa đồng hồ [{item.Title}] khỏi giỏ hàng thành công!", true);
                BindCart();
            }
            else if (e.CommandName == "IncreaseQty")
            {
                if (item.Quantity < item.StockQuantity)
                {
                    item.Quantity++;
                    Session["Cart"] = cart;
                    ShowMsg($"Đã tăng số lượng [{item.Title}] lên {item.Quantity} chiếc.", true);
                }
                else
                {
                    ShowMsg($"Kho chỉ còn tối đa {item.StockQuantity} chiếc chiếc đồng hồ này!", false);
                }
                BindCart();
            }
            else if (e.CommandName == "DecreaseQty")
            {
                if (item.Quantity > 1)
                {
                    item.Quantity--;
                    Session["Cart"] = cart;
                    ShowMsg($"Đã giảm số lượng [{item.Title}] còn {item.Quantity} chiếc.", true);
                }
                else
                {
                    // Nếu số lượng là 1 mà bấm trừ thì hỏi hoặc giữ nguyên 1
                    ShowMsg("Số lượng tối thiểu là 1 chiếc. Nếu muốn xóa món này, vui lòng bấm nút [✕] bên cạnh.", false);
                }
                BindCart();
            }
        }

        protected void txtItemQty_TextChanged(object sender, EventArgs e)
        {
            TextBox txtQty = sender as TextBox;
            if (txtQty == null) return;

            RepeaterItem item = txtQty.NamingContainer as RepeaterItem;
            if (item == null) return;

            LinkButton btnDelete = item.FindControl("btnDeleteItem") as LinkButton;
            if (btnDelete == null) return;

            int productId = Convert.ToInt32(btnDelete.CommandArgument);
            var cart = GetCart();
            var cartItem = cart.FirstOrDefault(c => c.ProductID == productId);

            if (cartItem != null)
            {
                if (int.TryParse(txtQty.Text.Trim(), out int newQty) && newQty > 0)
                {
                    if (newQty <= cartItem.StockQuantity)
                    {
                        cartItem.Quantity = newQty;
                        Session["Cart"] = cart;
                        ShowMsg($"Đã cập nhật số lượng [{cartItem.Title}] thành {newQty} chiếc thành công!", true);
                    }
                    else
                    {
                        cartItem.Quantity = cartItem.StockQuantity;
                        Session["Cart"] = cart;
                        ShowMsg($"Số lượng vượt quá tồn kho ({cartItem.StockQuantity} chiếc)! Đã điều chỉnh về mức tối đa.", false);
                    }
                }
                else
                {
                    ShowMsg("Số lượng sản phẩm phải là số nguyên dương lớn hơn 0!", false);
                }
                BindCart();
            }
        }

        protected void btnApplyCoupon_Click(object sender, EventArgs e)
        {
            string code = txtCouponCode.Text.Trim().ToUpper();
            if (string.IsNullOrEmpty(code))
            {
                ShowCouponMsg("Vui lòng nhập mã giảm giá!", false);
                return;
            }

            var validCodes = new HashSet<string> { "KEV10", "CHAOBAN", "GIAM10", "VIP10", "SALE2026" };
            if (validCodes.Contains(code))
            {
                Session["DiscountPercent"] = 10;
                Session["CouponCode"] = code;
                ShowCouponMsg($"Áp dụng thành công mã [{code}]! Quý khách được giảm 10% trên tổng đơn hàng.", true);
                BindCart();
            }
            else
            {
                ShowCouponMsg($"Mã ưu đãi [{code}] không tồn tại hoặc đã hết hạn áp dụng!", false);
            }
        }

        protected void btnClearCoupon_Click(object sender, EventArgs e)
        {
            Session["DiscountPercent"] = 0;
            Session["CouponCode"] = null;
            Session["DiscountAmount"] = 0m;
            txtCouponCode.Text = "";
            ShowCouponMsg("Đã hủy áp dụng mã giảm giá.", true);
            BindCart();
        }

        protected void btnClearAllCart_Click(object sender, EventArgs e)
        {
            Session["Cart"] = new List<CartItem>();
            Session["DiscountPercent"] = 0;
            Session["CouponCode"] = null;
            Session["DiscountAmount"] = 0m;
            Session["GrandTotal"] = 0m;
            ShowMsg("Đã làm trống giỏ hàng thành công!", true);
            BindCart();
        }

        private void ShowMsg(string msg, bool isSuccess)
        {
            lblCartMsg.Visible = true;
            lblCartMsg.Text = (isSuccess ? "✔ " : "✖ ") + msg;
            if (isSuccess)
            {
                lblCartMsg.BackColor = System.Drawing.Color.FromArgb(230, 248, 235);
                lblCartMsg.ForeColor = System.Drawing.Color.FromArgb(22, 163, 74);
            }
            else
            {
                lblCartMsg.BackColor = System.Drawing.Color.FromArgb(254, 235, 235);
                lblCartMsg.ForeColor = System.Drawing.Color.FromArgb(220, 38, 38);
            }
        }

        private void ShowCouponMsg(string msg, bool isSuccess)
        {
            lblCouponMsg.Visible = true;
            lblCouponMsg.Text = (isSuccess ? "✔ " : "✖ ") + msg;
            lblCouponMsg.ForeColor = isSuccess 
                ? System.Drawing.Color.FromArgb(22, 163, 74) 
                : System.Drawing.Color.FromArgb(220, 38, 38);
        }
    }
}
