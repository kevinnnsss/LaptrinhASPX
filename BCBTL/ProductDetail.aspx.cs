using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;

namespace BCBTL
{
    public partial class ProductDetail : System.Web.UI.Page
    {
        private int _productId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (int.TryParse(Request.QueryString["id"], out int pid))
            {
                _productId = pid;
            }

            if (!IsPostBack)
            {
                if (_productId > 0)
                {
                    LoadProductDetail(_productId);
                }
                else
                {
                    ShowNotFound();
                }
            }
        }

        private void LoadProductDetail(int productId)
        {
            using (var db = DbContextHelper.GetContext())
            {
                // Must be ItemType == 1 (Watch), Hide == false
                var watch = (from p in db.PageItems
                             join m in db.Menus on p.ID_MN equals m.ID_MN
                             join pr in db.ProductPrices on p.ID_P equals pr.ID_P
                             where p.ID_P == productId && p.ItemType == 1 && p.Hide == false
                             select new
                             {
                                 p.ID_P,
                                 p.ID_MN,
                                 p.Title,
                                 p.Sumary,
                                 p.Contents,
                                 p.Image,
                                 p.Gender,
                                 BrandName = m.Lable,
                                 pr.Price,
                                 pr.OriginalPrice,
                                 pr.StockQuantity,
                                 pr.DiscountPercent
                             }).FirstOrDefault();

                if (watch == null)
                {
                    ShowNotFound();
                    return;
                }

                pnlProductDetail.Visible = true;
                pnlNotFound.Visible = false;

                // Page Title & Breadcrumbs
                Page.Title = watch.Title + " - KevLouis";
                litBreadcrumbTitle.Text = Server.HtmlEncode(watch.Title);
                lnkBreadcrumbCategory.Text = Server.HtmlEncode(watch.BrandName);
                lnkBreadcrumbCategory.NavigateUrl = "ProductList.aspx?idmn=" + watch.ID_MN;

                // Brand & Title
                litBrandName.Text = Server.HtmlEncode(watch.BrandName.ToUpper());
                litProductTitle.Text = Server.HtmlEncode(watch.Title);
                litProductSku.Text = "W" + watch.ID_P.ToString("D5");

                // Gender display
                string genderText = "Unisex / Cặp đôi";
                if (watch.Gender == 1) genderText = "Nam (Men)";
                if (watch.Gender == 2) genderText = "Nữ (Women)";
                litProductGender.Text = genderText;
                litSpecGender.Text = genderText;
                litSpecBrand.Text = Server.HtmlEncode(watch.BrandName);

                // Image
                string imgFile = string.IsNullOrEmpty(watch.Image) ? "default-watch.jpg" : watch.Image;
                imgMainProduct.ImageUrl = "~/Assets/images/products/" + imgFile;
                imgMainProduct.AlternateText = watch.Title;

                // Prices
                litCurrentPrice.Text = string.Format("{0:N0} đ", watch.Price);

                if (watch.OriginalPrice.HasValue && watch.OriginalPrice.Value > watch.Price)
                {
                    litOriginalPrice.Text = string.Format("<div class='detail-price-original'>{0:N0} đ</div>", watch.OriginalPrice.Value);
                    decimal saved = watch.OriginalPrice.Value - watch.Price;
                    int percent = watch.DiscountPercent ?? (int)Math.Round((saved / watch.OriginalPrice.Value) * 100);

                    litSavingBadge.Text = string.Format(
                        "<div class='detail-price-saving'>Tiết kiệm: {0:N0} đ (-{1}%)</div>",
                        saved,
                        percent
                    );

                    litBadgeDiscount.Text = string.Format("<span class='badge-discount'>-{0}%</span>", percent);
                }
                else
                {
                    litOriginalPrice.Text = "";
                    litSavingBadge.Text = "";
                    litBadgeDiscount.Text = "";
                }

                // Stock & Status
                litAvailableStock.Text = watch.StockQuantity.ToString();
                txtQuantity.Attributes["max"] = watch.StockQuantity.ToString();

                if (watch.StockQuantity > 0)
                {
                    litProductStock.Text = $"<b class='stock-status in-stock'>✔ Còn hàng ({watch.StockQuantity} chiếc)</b>";
                    btnAddToCart.Enabled = true;
                    btnBuyNow.Enabled = true;
                }
                else
                {
                    litProductStock.Text = "<b class='stock-status out-of-stock'>✖ Tạm hết hàng</b>";
                    btnAddToCart.Enabled = false;
                    btnAddToCart.CssClass = "btn-detail-cart disabled";
                    btnBuyNow.Enabled = false;
                    btnBuyNow.CssClass = "btn-detail-buy disabled";
                }

                // Summary & Contents
                litSummary.Text = string.IsNullOrEmpty(watch.Sumary) 
                    ? "Đồng hồ chính hãng phân phối bởi KevLouis, bảo hành 5 năm toàn diện." 
                    : Server.HtmlEncode(watch.Sumary);

                litContents.Text = string.IsNullOrEmpty(watch.Contents)
                    ? "<p>Thông tin chi tiết về sản phẩm đang được cập nhật.</p>"
                    : watch.Contents;

                // Load Related Products
                LoadRelatedProducts(db, watch.ID_MN, watch.ID_P);
            }
        }

        private void LoadRelatedProducts(WatchStoreDataContext db, int brandId, int currentProductId)
        {
            var related = (from p in db.PageItems
                           join m in db.Menus on p.ID_MN equals m.ID_MN
                           join pr in db.ProductPrices on p.ID_P equals pr.ID_P
                           where p.ItemType == 1 && p.Hide == false && p.ID_P != currentProductId
                           orderby (p.ID_MN == brandId ? 0 : 1), p.ID_P descending
                           select new
                           {
                               p.ID_P,
                               p.Title,
                               p.Image,
                               BrandName = m.Lable,
                               pr.Price,
                               pr.OriginalPrice,
                               pr.DiscountPercent,
                               pr.StockQuantity
                           }).Take(4).ToList();

            rptRelatedProducts.DataSource = related;
            rptRelatedProducts.DataBind();

            lnkViewMoreRelated.NavigateUrl = "ProductList.aspx?idmn=" + brandId;
        }

        private void ShowNotFound()
        {
            pnlProductDetail.Visible = false;
            pnlNotFound.Visible = true;
            Page.Title = "Không tìm thấy đồng hồ - KevLouis";
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            if (ExecuteAddToCart(out string msg, out bool isSuccess))
            {
                lblActionMsg.Visible = true;
                lblActionMsg.Text = "✔ " + msg;
                lblActionMsg.BackColor = System.Drawing.Color.FromArgb(230, 248, 235);
                lblActionMsg.ForeColor = System.Drawing.Color.FromArgb(22, 163, 74);
            }
            else
            {
                lblActionMsg.Visible = true;
                lblActionMsg.Text = "✖ " + msg;
                lblActionMsg.BackColor = System.Drawing.Color.FromArgb(254, 235, 235);
                lblActionMsg.ForeColor = System.Drawing.Color.FromArgb(220, 38, 38);
            }
            upOrderActions.Update();
        }

        protected void btnBuyNow_Click(object sender, EventArgs e)
        {
            if (ExecuteAddToCart(out string msg, out bool isSuccess))
            {
                Response.Redirect("~/Cart.aspx");
            }
            else
            {
                lblActionMsg.Visible = true;
                lblActionMsg.Text = "✖ " + msg;
                lblActionMsg.BackColor = System.Drawing.Color.FromArgb(254, 235, 235);
                lblActionMsg.ForeColor = System.Drawing.Color.FromArgb(220, 38, 38);
            }
            upOrderActions.Update();
        }

        private bool ExecuteAddToCart(out string message, out bool isSuccess)
        {
            message = "";
            isSuccess = false;

            if (_productId <= 0)
            {
                message = "Sản phẩm không hợp lệ!";
                return false;
            }

            int qty = 1;
            if (!int.TryParse(txtQuantity.Text.Trim(), out qty) || qty <= 0)
            {
                message = "Số lượng mua phải là số nguyên dương lớn hơn 0!";
                return false;
            }

            using (var db = DbContextHelper.GetContext())
            {
                // Re-verify product status, ItemType, and price from database (Never trust browser data)
                var product = (from p in db.PageItems
                               join pr in db.ProductPrices on p.ID_P equals pr.ID_P
                               where p.ID_P == _productId && p.ItemType == 1 && p.Hide == false
                               select new
                               {
                                   p.ID_P,
                                   p.Title,
                                   p.Image,
                                   pr.Price,
                                   pr.OriginalPrice,
                                   pr.StockQuantity
                               }).FirstOrDefault();

                if (product == null)
                {
                    message = "Sản phẩm không tồn tại hoặc đã ngừng kinh doanh!";
                    return false;
                }

                if (product.StockQuantity <= 0)
                {
                    message = "Rất tiếc, sản phẩm này hiện đã hết hàng!";
                    return false;
                }

                if (qty > product.StockQuantity)
                {
                    message = $"Số lượng đặt ({qty}) vượt quá số lượng còn trong kho ({product.StockQuantity} chiếc)!";
                    return false;
                }

                List<CartItem> cart = Session["Cart"] as List<CartItem>;
                if (cart == null)
                {
                    cart = new List<CartItem>();
                }

                var existing = cart.FirstOrDefault(c => c.ProductID == product.ID_P);
                if (existing != null)
                {
                    if (existing.Quantity + qty > product.StockQuantity)
                    {
                        existing.Quantity = product.StockQuantity;
                        message = $"Số lượng trong giỏ hàng đã được điều chỉnh bằng số lượng tồn kho ({product.StockQuantity} chiếc)!";
                    }
                    else
                    {
                        existing.Quantity += qty;
                        message = $"Đã cập nhật số lượng chiếc '{product.Title}' trong giỏ hàng!";
                    }
                }
                else
                {
                    cart.Add(new CartItem
                    {
                        ProductID = product.ID_P,
                        Title = product.Title,
                        Image = product.Image,
                        Price = product.Price,
                        OriginalPrice = product.OriginalPrice ?? product.Price,
                        StockQuantity = product.StockQuantity,
                        Quantity = qty
                    });
                    message = $"Đã thêm thành công '{product.Title}' vào giỏ hàng!";
                }

                Session["Cart"] = cart;

                // Update MasterPage cart badge
                if (Master is Site siteMaster)
                {
                    siteMaster.UpdateCartPreview();
                }

                isSuccess = true;
                return true;
            }
        }
    }
}
