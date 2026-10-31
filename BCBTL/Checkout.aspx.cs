using System;
using System.Collections.Generic;
using System.Linq;
using System.Transactions;
using System.Web.UI;

namespace BCBTL
{
    public partial class Checkout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var cart = Session["Cart"] as List<CartItem>;
            if (cart == null || cart.Count == 0)
            {
                Response.Redirect("~/Cart.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Auto-fill customer info if logged in
                if (Session["Username"] != null)
                {
                    using (var db = DbContextHelper.GetContext())
                    {
                        string user = Session["Username"].ToString();
                        var acc = db.Acounts.FirstOrDefault(a => a.Username == user);
                        if (acc != null)
                        {
                            txtCustomerName.Text = acc.Fullname ?? "";
                            txtCustomerEmail.Text = acc.Email ?? "";
                        }
                    }
                }

                BindSummary();
            }
        }

        private void BindSummary()
        {
            var cart = Session["Cart"] as List<CartItem>;
            if (cart != null)
            {
                rptSummaryItems.DataSource = cart;
                rptSummaryItems.DataBind();

                decimal subTotal = cart.Sum(c => c.TotalPrice);
                litSubTotal.Text = string.Format("{0:N0} đ", subTotal);

                int discountPercent = 0;
                if (Session["DiscountPercent"] != null)
                {
                    int.TryParse(Session["DiscountPercent"].ToString(), out discountPercent);
                }

                if (discountPercent > 0)
                {
                    decimal discountAmount = Math.Round(subTotal * discountPercent / 100m);
                    decimal grandTotal = Math.Max(0, subTotal - discountAmount);

                    pnlCheckoutDiscount.Visible = true;
                    litDiscountPercent.Text = discountPercent.ToString();
                    litDiscountAmount.Text = string.Format("{0:N0} đ", discountAmount);
                    litGrandTotal.Text = string.Format("{0:N0} đ", grandTotal);
                }
                else
                {
                    pnlCheckoutDiscount.Visible = false;
                    litGrandTotal.Text = string.Format("{0:N0} đ", subTotal);
                }
            }
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            var cart = Session["Cart"] as List<CartItem>;
            if (cart == null || cart.Count == 0)
            {
                Response.Redirect("~/Cart.aspx");
                return;
            }

            string name = txtCustomerName.Text.Trim();
            string phone = txtCustomerPhone.Text.Trim();
            string email = txtCustomerEmail.Text.Trim();
            string address = txtDeliveryAddress.Text.Trim();
            string notes = txtOrderNotes.Text.Trim();
            string username = Session["Username"]?.ToString(); // Guest = null

            using (var db = DbContextHelper.GetContext())
            {
                // 1. Server-side validation of products, current prices and inventory
                decimal calculatedTotal = 0;
                var verifiedItems = new List<(int ProductId, int Qty, decimal Price, ProductPrice PriceRecord)>();

                foreach (var item in cart)
                {
                    var product = (from p in db.PageItems
                                   join pr in db.ProductPrices on p.ID_P equals pr.ID_P
                                   where p.ID_P == item.ProductID && p.ItemType == 1 && p.Hide == false
                                   select new { p.ID_P, p.Title, pr }).FirstOrDefault();

                    if (product == null)
                    {
                        ShowError($"Sản phẩm '{item.Title}' hiện không còn khả dụng trên hệ thống. Vui lòng cập nhật giỏ hàng!");
                        return;
                    }

                    if (product.pr.StockQuantity < item.Quantity)
                    {
                        ShowError($"Sản phẩm '{product.Title}' chỉ còn {product.pr.StockQuantity} chiếc trong kho (bạn đặt {item.Quantity} chiếc). Vui lòng điều chỉnh lại số lượng!");
                        return;
                    }

                    decimal lineTotal = item.Quantity * product.pr.Price;
                    calculatedTotal += lineTotal;
                    verifiedItems.Add((product.ID_P, item.Quantity, product.pr.Price, product.pr));
                }

                // 2. Transactional save of Order, OrderDetails, and stock update
                int discountPercent = 0;
                if (Session["DiscountPercent"] != null)
                {
                    int.TryParse(Session["DiscountPercent"].ToString(), out discountPercent);
                }
                decimal discountAmount = 0m;
                if (discountPercent > 0)
                {
                    discountAmount = Math.Round(calculatedTotal * discountPercent / 100m);
                }
                decimal finalTotal = Math.Max(0, calculatedTotal - discountAmount);

                string payMethod = Request.Form["payMethod"] ?? "COD";
                string fullNotes = notes;
                if (discountPercent > 0)
                {
                    string coupon = Session["CouponCode"]?.ToString() ?? "VOUCHER";
                    fullNotes = $"[Mã: {coupon} -{discountPercent}% (-{discountAmount:N0}đ)] " + fullNotes;
                }
                if (payMethod == "BANK")
                {
                    fullNotes = "[Thanh toán: Chuyển khoản VietQR] " + fullNotes;
                }

                db.Connection.Open();
                using (var trans = db.Connection.BeginTransaction())
                {
                    db.Transaction = trans;
                    try
                    {
                        Order order = new Order
                        {
                            CustomerName = name,
                            CustomerPhone = phone,
                            CustomerEmail = string.IsNullOrEmpty(email) ? null : email,
                            DeliveryAddress = address,
                            OrderNotes = string.IsNullOrEmpty(fullNotes) ? null : fullNotes.Trim(),
                            TotalAmount = finalTotal,
                            OrderDate = DateTime.Now,
                            Status = "Chờ xử lý",
                            Username = string.IsNullOrEmpty(username) ? null : username
                        };

                        db.Orders.InsertOnSubmit(order);
                        db.SubmitChanges(); // Generates OrderID

                        foreach (var v in verifiedItems)
                        {
                            OrderDetail detail = new OrderDetail
                            {
                                OrderID = order.OrderID,
                                ID_P = v.ProductId,
                                Quantity = v.Qty,
                                UnitPrice = v.Price
                            };
                            db.OrderDetails.InsertOnSubmit(detail);

                            // Deduct stock quantity
                            v.PriceRecord.StockQuantity -= v.Qty;
                        }

                        db.SubmitChanges();
                        trans.Commit(); // Commit transaction

                        // 3. Clear cart session and redirect
                        Session["Cart"] = null;
                        Session["DiscountPercent"] = 0;
                        Session["CouponCode"] = null;
                        Session["DiscountAmount"] = 0m;
                        Session["GrandTotal"] = 0m;
                        Session["LastOrderID"] = order.OrderID;

                        if (Master is Site siteMaster)
                        {
                            siteMaster.UpdateCartPreview();
                        }

                        Response.Redirect("~/OrderSuccess.aspx?orderid=" + order.OrderID);
                    }
                    catch (Exception ex)
                    {
                        try { trans.Rollback(); } catch { }
                        ShowError("Đã xảy ra lỗi trong quá trình lưu đơn hàng: " + ex.Message);
                    }
                }
            }
        }

        private void ShowError(string msg)
        {
            lblCheckoutError.Visible = true;
            lblCheckoutError.Text = "✖ " + msg;
        }
    }
}
