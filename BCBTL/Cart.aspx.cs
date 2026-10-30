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
                decimal totalAmount = cart.Sum(c => c.TotalPrice);

                litCartCountHeader.Text = totalCount.ToString();
                litCartGrandTotal.Text = string.Format("{0:N0} đ", totalAmount);
            }
            else
            {
                pnlCartTable.Visible = false;
                pnlEmptyCart.Visible = true;
                litCartCountHeader.Text = "0";
                litCartGrandTotal.Text = "0 đ";
            }

            // Update Master preview
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

            if (e.CommandName == "DeleteItem")
            {
                if (item != null)
                {
                    cart.Remove(item);
                    Session["Cart"] = cart;
                    ShowMsg("Đã xóa sản phẩm khỏi giỏ hàng thành công!", true);
                    BindCart();
                }
            }
            else if (e.CommandName == "UpdateQty")
            {
                TextBox txtQty = e.Item.FindControl("txtItemQty") as TextBox;
                if (txtQty != null && item != null)
                {
                    if (int.TryParse(txtQty.Text.Trim(), out int newQty) && newQty > 0)
                    {
                        if (newQty <= item.StockQuantity)
                        {
                            item.Quantity = newQty;
                            Session["Cart"] = cart;
                            ShowMsg("Đã cập nhật số lượng thành công!", true);
                        }
                        else
                        {
                            item.Quantity = item.StockQuantity;
                            Session["Cart"] = cart;
                            ShowMsg($"Số lượng vượt quá tồn kho! Đã đặt về mức tối đa {item.StockQuantity} chiếc.", false);
                        }
                    }
                    else
                    {
                        ShowMsg("Số lượng phải là số nguyên dương lớn hơn 0!", false);
                    }
                    BindCart();
                }
            }
        }

        protected void btnClearAllCart_Click(object sender, EventArgs e)
        {
            Session["Cart"] = new List<CartItem>();
            ShowMsg("Đã làm trống giỏ hàng!", true);
            BindCart();
        }

        private void ShowMsg(string msg, bool isSuccess)
        {
            lblCartMsg.Visible = true;
            lblCartMsg.Text = msg;
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
    }
}
