using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BCBTL
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadHomeData();
            }
        }

        private void LoadHomeData()
        {
            using (var db = DbContextHelper.GetContext())
            {
                // Query for watches: ItemType == 1, Hide == false
                // Prices and stock strictly from ProductPrices (never from Sumary)
                var watchQuery = from p in db.PageItems
                                 join m in db.Menus on p.ID_MN equals m.ID_MN
                                 join pr in db.ProductPrices on p.ID_P equals pr.ID_P
                                 where p.ItemType == 1 && p.Hide == false
                                 select new
                                 {
                                     p.ID_P,
                                     p.Title,
                                     p.Image,
                                     p.Gender,
                                     p.OrderKey,
                                     p.CreaDate,
                                     BrandName = m.Lable,
                                     pr.Price,
                                     pr.OriginalPrice,
                                     pr.StockQuantity,
                                     pr.DiscountPercent
                                 };

                var watchList = watchQuery.ToList();

                // 1. Men watches (Gender == 1)
                rptMenWatches.DataSource = watchList.Where(w => w.Gender == 1).Take(4).ToList();
                rptMenWatches.DataBind();

                // 2. Women watches (Gender == 2)
                rptWomenWatches.DataSource = watchList.Where(w => w.Gender == 2).Take(4).ToList();
                rptWomenWatches.DataBind();

                // 3. New arrivals: 6 newest watches (Order by ID_P descending)
                rptNewWatches.DataSource = watchList.OrderByDescending(w => w.ID_P).Take(6).ToList();
                rptNewWatches.DataBind();

                // 4. News: ItemType == 2, Hide == false (strictly no price)
                var newsQuery = from n in db.PageItems
                                where n.ItemType == 2 && n.Hide == false
                                orderby n.ID_P descending
                                select new
                                {
                                    n.ID_P,
                                    n.Title,
                                    n.Sumary,
                                    n.Image,
                                    n.CreaDate,
                                    n.UserAdd
                                };

                rptNews.DataSource = newsQuery.Take(3).ToList();
                rptNews.DataBind();
            }
        }

        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                AddToCart(productId, 1);
            }
        }

        private void AddToCart(int productId, int quantity)
        {
            using (var db = DbContextHelper.GetContext())
            {
                // Verify product exists, is active (Hide == false), is watch (ItemType == 1) and in stock
                var product = (from p in db.PageItems
                               join pr in db.ProductPrices on p.ID_P equals pr.ID_P
                               where p.ID_P == productId && p.Hide == false && p.ItemType == 1
                               select new
                               {
                                   p.ID_P,
                                   p.Title,
                                   p.Image,
                                   pr.Price,
                                   pr.OriginalPrice,
                                   pr.StockQuantity
                               }).FirstOrDefault();

                if (product == null || product.StockQuantity <= 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Sản phẩm đã hết hàng hoặc không khả dụng!');", true);
                    return;
                }

                List<CartItem> cart = Session["Cart"] as List<CartItem>;
                if (cart == null)
                {
                    cart = new List<CartItem>();
                }

                var existingItem = cart.FirstOrDefault(c => c.ProductID == productId);
                if (existingItem != null)
                {
                    if (existingItem.Quantity + quantity <= product.StockQuantity)
                    {
                        existingItem.Quantity += quantity;
                    }
                    else
                    {
                        existingItem.Quantity = product.StockQuantity;
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Số lượng trong giỏ hàng đã đạt tối đa số lượng tồn kho!');", true);
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
                        Quantity = Math.Min(quantity, product.StockQuantity)
                    });
                }

                Session["Cart"] = cart;

                // Update MasterPage cart preview
                if (Master is Site siteMaster)
                {
                    siteMaster.UpdateCartPreview();
                }

                Response.Redirect("~/Cart.aspx");
            }
        }
    }
}
