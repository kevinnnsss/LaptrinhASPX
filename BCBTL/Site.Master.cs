using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;

namespace BCBTL
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RenderNavigationMenu();
                UpdateCartPreview();
                CheckUserAuth();
            }
        }

        public void UpdateCartPreview()
        {
            var cart = Session["Cart"] as List<CartItem>;
            if (cart != null && cart.Count > 0)
            {
                int totalCount = cart.Sum(c => c.Quantity);
                decimal totalAmount = cart.Sum(c => c.TotalPrice);
                litCartCount.Text = totalCount.ToString();
                litCartTotal.Text = string.Format("{0:N0} đ", totalAmount);
            }
            else
            {
                litCartCount.Text = "0";
                litCartTotal.Text = "0 đ";
            }

            if (upHeaderCart != null)
            {
                upHeaderCart.Update();
            }
        }

        private void CheckUserAuth()
        {
            if (Session["Username"] != null)
            {
                string displayName = Session["Fullname"]?.ToString() ?? Session["Username"].ToString();
                string adminLink = "";
                if (Session["Permission"] != null && Convert.ToInt32(Session["Permission"]) == 1)
                {
                    adminLink = " | <a href='Admin/Dashboard.aspx' class='top-bar-link' style='color:#ffc107;font-weight:700;'>[Trang Quản Trị]</a>";
                }

                litUserAuth.Text = string.Format(
                    "<span style='color:var(--gold-color);font-weight:700;'>Xin chào, {0}</span>{1} | <a href='Logout.aspx' class='top-bar-link'>Đăng xuất</a>",
                    Server.HtmlEncode(displayName),
                    adminLink
                );
            }
            else
            {
                litUserAuth.Text = "<a href='Login.aspx' class='top-bar-link'>Đăng nhập</a> | <a href='Register.aspx' class='top-bar-link'>Đăng ký</a>";
            }
        }

        private void RenderNavigationMenu()
        {
            using (var db = DbContextHelper.GetContext())
            {
                var allMenus = db.Menus.Where(m => m.Hide == false).OrderBy(m => m.OrderKey).ToList();
                var rootMenus = allMenus.Where(m => m.Parent == 0).ToList();

                string currentUrl = Request.Url.PathAndQuery.ToLower();

                StringBuilder sb = new StringBuilder();
                sb.Append("<ul class='nav-menu'>");

                foreach (var parent in rootMenus)
                {
                    var childMenus = allMenus.Where(m => m.Parent == parent.ID_MN).ToList();
                    string parentUrl = ResolveUrl(string.IsNullOrEmpty(parent.UrlLink) ? "#" : parent.UrlLink);
                    bool isParentActive = !string.IsNullOrEmpty(parent.UrlLink) && parent.UrlLink != "#" && currentUrl.Contains(parent.UrlLink.ToLower());

                    if (childMenus.Count > 0)
                    {
                        sb.AppendFormat(
                            "<li class='nav-item has-dropdown'><a href='{0}' class='nav-link {1}'>{2} <span style='font-size:10px;'>▼</span></a>",
                            parentUrl,
                            isParentActive ? "active" : "",
                            Server.HtmlEncode(parent.Lable)
                        );

                        sb.Append("<ul class='nav-dropdown'>");
                        foreach (var child in childMenus)
                        {
                            string childUrl = ResolveUrl(string.IsNullOrEmpty(child.UrlLink) ? "#" : child.UrlLink);
                            sb.AppendFormat(
                                "<li class='dropdown-item'><a href='{0}'>{1} <span>▶</span></a></li>",
                                childUrl,
                                Server.HtmlEncode(child.Lable)
                            );
                        }
                        sb.Append("</ul></li>");
                    }
                    else
                    {
                        sb.AppendFormat(
                            "<li class='nav-item'><a href='{0}' class='nav-link {1}'>{2}</a></li>",
                            parentUrl,
                            isParentActive ? "active" : "",
                            Server.HtmlEncode(parent.Lable)
                        );
                    }
                }

                sb.Append("</ul>");
                litNavMenu.Text = sb.ToString();
            }
        }

        protected void btnHeaderSearch_Click(object sender, EventArgs e)
        {
            string keyword = txtHeaderSearch.Text.Trim();
            if (!string.IsNullOrEmpty(keyword))
            {
                Response.Redirect("~/ProductList.aspx?q=" + Server.UrlEncode(keyword));
            }
            else
            {
                Response.Redirect("~/ProductList.aspx");
            }
        }
    }
}
