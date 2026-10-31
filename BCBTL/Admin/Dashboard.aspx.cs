using System;
using System.Linq;
using System.Web.UI;

namespace BCBTL.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardStatistics();
                LoadRecentOrders();
                LoadLowStockAlerts();
            }
        }

        private void LoadDashboardStatistics()
        {
            using (var db = DbContextHelper.GetContext())
            {
                int totalProducts = db.PageItems.Count(p => p.ItemType == 1 && p.Hide == false);
                int totalBrands = db.Menus.Count(m => m.Hide == false);
                int totalOrders = db.Orders.Count();
                decimal totalRevenue = db.Orders.Where(o => o.Status != "Đã hủy").Sum(o => (decimal?)o.TotalAmount) ?? 0;

                litTotalProducts.Text = totalProducts.ToString("N0");
                litTotalBrands.Text = totalBrands.ToString("N0");
                litTotalOrders.Text = totalOrders.ToString("N0");
                litTotalRevenue.Text = totalRevenue.ToString("N0") + " đ";
            }
        }

        private void LoadRecentOrders()
        {
            using (var db = DbContextHelper.GetContext())
            {
                var recentOrders = db.Orders
                    .OrderByDescending(o => o.OrderID)
                    .Take(5)
                    .Select(o => new
                    {
                        o.OrderID,
                        o.CustomerName,
                        o.CustomerPhone,
                        o.TotalAmount,
                        o.Status,
                        o.OrderDate
                    })
                    .ToList();

                gvRecentOrders.DataSource = recentOrders;
                gvRecentOrders.DataBind();
            }
        }

        private void LoadLowStockAlerts()
        {
            using (var db = DbContextHelper.GetContext())
            {
                var lowStock = (from p in db.PageItems
                                join pr in db.ProductPrices on p.ID_P equals pr.ID_P
                                join m in db.Menus on p.ID_MN equals m.ID_MN
                                where p.ItemType == 1 && p.Hide == false && pr.StockQuantity <= 5
                                orderby pr.StockQuantity ascending
                                select new
                                {
                                    p.ID_P,
                                    p.Title,
                                    CategoryName = m.Lable,
                                    pr.StockQuantity
                                }).Take(5).ToList();

                gvLowStock.DataSource = lowStock;
                gvLowStock.DataBind();
            }
        }

        public string GetStatusClass(string status)
        {
            if (string.IsNullOrEmpty(status)) return "status-pending";
            switch (status.Trim())
            {
                case "Chờ xử lý": return "status-pending";
                case "Đã xác nhận": return "status-confirmed";
                case "Đang giao": return "status-shipping";
                case "Đã hoàn tất": return "status-completed";
                case "Đã hủy": return "status-cancelled";
                default: return "status-pending";
            }
        }
    }
}
