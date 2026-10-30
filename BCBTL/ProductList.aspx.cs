using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BCBTL
{
    public partial class ProductList : System.Web.UI.Page
    {
        public int? CurrentGender { get; private set; }
        public int? CurrentBrandId { get; private set; }
        public string CurrentSearch { get; private set; }
        public string CurrentPriceRange { get; private set; }
        public string CurrentSort { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            ParseQueryParameters();

            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(CurrentSort))
                {
                    var item = ddlSort.Items.FindByValue(CurrentSort);
                    if (item != null)
                    {
                        ddlSort.SelectedValue = CurrentSort;
                    }
                }

                LoadFilterCounts();
                LoadProducts();
            }
        }

        private void ParseQueryParameters()
        {
            if (int.TryParse(Request.QueryString["gender"], out int g))
            {
                CurrentGender = g;
            }

            if (int.TryParse(Request.QueryString["idmn"], out int idmn))
            {
                CurrentBrandId = idmn;
            }

            CurrentSearch = Request.QueryString["q"]?.Trim();
            CurrentPriceRange = Request.QueryString["price"]?.Trim().ToLower();
            CurrentSort = Request.QueryString["sort"]?.Trim().ToLower();
            if (string.IsNullOrEmpty(CurrentSort))
            {
                CurrentSort = "newest";
            }
        }

        private void LoadFilterCounts()
        {
            using (var db = DbContextHelper.GetContext())
            {
                // Count active watches
                var baseQuery = db.PageItems.Where(p => p.ItemType == 1 && p.Hide == false);

                int countAll = baseQuery.Count();
                int countMen = baseQuery.Count(p => p.Gender == 1);
                int countWomen = baseQuery.Count(p => p.Gender == 2);
                int countUnisex = baseQuery.Count(p => p.Gender == 0);

                litCountAll.Text = countAll.ToString();
                litCountMen.Text = countMen.ToString();
                litCountWomen.Text = countWomen.ToString();
                litCountUnisex.Text = countUnisex.ToString();

                // Set URLs and Active classes for gender
                lnkGenderAll.NavigateUrl = GetFilterUrl("gender", "");
                lnkGenderMen.NavigateUrl = GetFilterUrl("gender", "1");
                lnkGenderWomen.NavigateUrl = GetFilterUrl("gender", "2");
                lnkGenderUnisex.NavigateUrl = GetFilterUrl("gender", "0");

                lnkGenderAll.CssClass = "filter-link" + (!CurrentGender.HasValue ? " active" : "");
                lnkGenderMen.CssClass = "filter-link" + (CurrentGender == 1 ? " active" : "");
                lnkGenderWomen.CssClass = "filter-link" + (CurrentGender == 2 ? " active" : "");
                lnkGenderUnisex.CssClass = "filter-link" + (CurrentGender == 0 ? " active" : "");

                // Load Brands with product counts
                var brands = (from m in db.Menus
                              where m.Hide == false && m.Parent > 0
                              orderby m.OrderKey, m.Lable
                              select new
                              {
                                  m.ID_MN,
                                  m.Lable,
                                  ProductCount = db.PageItems.Count(p => p.ID_MN == m.ID_MN && p.ItemType == 1 && p.Hide == false)
                              }).ToList();

                rptBrandFilter.DataSource = brands;
                rptBrandFilter.DataBind();
            }
        }

        private void LoadProducts()
        {
            using (var db = DbContextHelper.GetContext())
            {
                // Base query: ItemType = 1, Hide = false
                var query = from p in db.PageItems
                            join m in db.Menus on p.ID_MN equals m.ID_MN
                            join pr in db.ProductPrices on p.ID_P equals pr.ID_P
                            where p.ItemType == 1 && p.Hide == false
                            select new
                            {
                                p.ID_P,
                                p.Title,
                                p.Image,
                                p.Gender,
                                p.ID_MN,
                                p.OrderKey,
                                p.CreaDate,
                                BrandName = m.Lable,
                                pr.Price,
                                pr.OriginalPrice,
                                pr.StockQuantity,
                                pr.DiscountPercent
                            };

                // 1. Filter by Gender
                if (CurrentGender.HasValue)
                {
                    query = query.Where(w => w.Gender == CurrentGender.Value);
                }

                // 2. Filter by Brand (ID_MN)
                if (CurrentBrandId.HasValue)
                {
                    query = query.Where(w => w.ID_MN == CurrentBrandId.Value);
                }

                // 3. Search query
                if (!string.IsNullOrEmpty(CurrentSearch))
                {
                    query = query.Where(w => w.Title.Contains(CurrentSearch) || w.BrandName.Contains(CurrentSearch));
                }

                // 4. Filter by Price Range
                if (!string.IsNullOrEmpty(CurrentPriceRange))
                {
                    switch (CurrentPriceRange)
                    {
                        case "under3":
                            query = query.Where(w => w.Price < 3000000);
                            break;
                        case "3to5":
                            query = query.Where(w => w.Price >= 3000000 && w.Price <= 5000000);
                            break;
                        case "5to10":
                            query = query.Where(w => w.Price > 5000000 && w.Price <= 10000000);
                            break;
                        case "over10":
                            query = query.Where(w => w.Price > 10000000);
                            break;
                    }
                }

                // 5. Sorting
                switch (CurrentSort)
                {
                    case "price-asc":
                        query = query.OrderBy(w => w.Price);
                        break;
                    case "price-desc":
                        query = query.OrderByDescending(w => w.Price);
                        break;
                    case "name-asc":
                        query = query.OrderBy(w => w.Title);
                        break;
                    case "newest":
                    default:
                        query = query.OrderByDescending(w => w.ID_P);
                        break;
                }

                var list = query.ToList();
                litResultCount.Text = list.Count.ToString();

                // Setup Category Header Banner & Breadcrumb
                SetupCategoryHeader(db, list.Count);

                // Show Clear Filter button if filters are active
                bool hasFilters = CurrentGender.HasValue || CurrentBrandId.HasValue || !string.IsNullOrEmpty(CurrentPriceRange) || !string.IsNullOrEmpty(CurrentSearch);
                lnkClearFilters.Visible = hasFilters;

                if (list.Count > 0)
                {
                    pnlProductGrid.Visible = true;
                    pnlEmpty.Visible = false;
                    rptProducts.DataSource = list;
                    rptProducts.DataBind();
                }
                else
                {
                    pnlProductGrid.Visible = false;
                    pnlEmpty.Visible = true;
                }
            }
        }

        private void SetupCategoryHeader(WatchStoreDataContext db, int count)
        {
            if (!string.IsNullOrEmpty(CurrentSearch))
            {
                Page.Title = "Tìm kiếm: " + CurrentSearch;
                litBreadcrumbCategory.Text = "Tìm kiếm: \"" + Server.HtmlEncode(CurrentSearch) + "\"";
                litCategoryTitle.Text = "KẾT QUẢ TÌM KIẾM CHO: \"" + Server.HtmlEncode(CurrentSearch) + "\"";
                litCategoryDescription.Text = $"Hệ thống tìm thấy {count} mẫu đồng hồ chính hãng phù hợp với từ khóa tìm kiếm của bạn.";
            }
            else if (CurrentBrandId.HasValue)
            {
                var brand = db.Menus.FirstOrDefault(m => m.ID_MN == CurrentBrandId.Value);
                string bName = brand?.Lable ?? "Thương hiệu";
                Page.Title = "Đồng Hồ " + bName + " Chính Hãng";
                litBreadcrumbCategory.Text = bName;
                litCategoryTitle.Text = "ĐỒNG HỒ " + bName.ToUpper() + " CHÍNH HÃNG";
                litCategoryDescription.Text = $"Bộ sưu tập đồng hồ {bName} chính hãng được nhập khẩu và phân phối ủy quyền tại Duy Anh Watch. Bảo hành 5 năm độc quyền, miễn phí thay pin trọn đời.";
            }
            else if (CurrentGender.HasValue)
            {
                if (CurrentGender == 1)
                {
                    Page.Title = "Đồng Hồ Nam Chính Hãng - Duy Anh Watch";
                    litBreadcrumbCategory.Text = "Đồng hồ Nam";
                    litCategoryTitle.Text = "ĐỒNG HỒ NAM CHÍNH HÃNG";
                    litCategoryDescription.Text = "Duy Anh Watch tự hào là đại lý ủy quyền chính thức của các thương hiệu đồng hồ nam nổi tiếng thế giới: Casio, Seiko, Citizen, Rolex... Thiết kế mạnh mẽ, sang trọng và lịch lãm dành riêng cho phái mạnh. Cam kết 100% chính hãng, đền gấp 10 lần nếu phát hiện hàng giả.";
                }
                else if (CurrentGender == 2)
                {
                    Page.Title = "Đồng Hồ Nữ Chính Hãng - Duy Anh Watch";
                    litBreadcrumbCategory.Text = "Đồng hồ Nữ";
                    litCategoryTitle.Text = "ĐỒNG HỒ NỮ CHÍNH HÃNG";
                    litCategoryDescription.Text = "Bộ sưu tập đồng hồ nữ chính hãng quý phái, thanh lịch và cuốn hút. Phụ kiện hoàn hảo tôn vinh nét duyên dáng của phái đẹp với chất liệu kính Sapphire, đính đá sang trọng.";
                }
                else
                {
                    Page.Title = "Đồng Hồ Unisex & Cặp Đôi - Duy Anh Watch";
                    litBreadcrumbCategory.Text = "Đồng hồ Unisex";
                    litCategoryTitle.Text = "ĐỒNG HỒ UNISEX & CẶP ĐÔI";
                    litCategoryDescription.Text = "Những mẫu đồng hồ thiết kế hài hòa, đẳng cấp phù hợp cho cả nam và nữ.";
                }
            }
            else
            {
                Page.Title = "Tất Cả Đồng Hồ Chính Hãng - Duy Anh Watch";
                litBreadcrumbCategory.Text = "Tất cả đồng hồ";
                litCategoryTitle.Text = "ĐỒNG HỒ CHÍNH HÃNG CAO CẤP";
                litCategoryDescription.Text = "Khám phá hàng trăm mẫu đồng hồ chính hãng từ các thương hiệu danh tiếng Nhật Bản và Thụy Sĩ. Bảo hành 5 năm độc quyền, trả góp 0%, miễn phí giao hàng toàn quốc.";
            }
        }

        public string GetFilterUrl(string paramName, string paramValue)
        {
            NameValueCollection query = HttpUtility.ParseQueryString(Request.Url.Query);

            if (string.IsNullOrEmpty(paramValue))
            {
                query.Remove(paramName);
            }
            else
            {
                query[paramName] = paramValue;
            }

            string qString = query.ToString();
            return "ProductList.aspx" + (string.IsNullOrEmpty(qString) ? "" : "?" + qString);
        }

        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sortVal = ddlSort.SelectedValue;
            Response.Redirect(GetFilterUrl("sort", sortVal));
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

                if (Master is Site siteMaster)
                {
                    siteMaster.UpdateCartPreview();
                }

                Response.Redirect("~/Cart.aspx");
            }
        }
    }
}
