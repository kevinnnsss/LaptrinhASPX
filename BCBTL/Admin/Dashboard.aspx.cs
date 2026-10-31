using System;
using System.Linq;

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
                LoadLowStockProducts();
            }
        }

        private void LoadDashboardStatistics()
        {
            using (var db = DbContextHelper.GetContext())
            {
                // 1. Tổng sản phẩm đồng hồ đang bán (ItemType = 1, Hide = 0)
                int totalProducts = db.PageItems.Count(p => p.ItemType == 1 && !p.Hide);
                lblTotalProducts.Text = totalProducts.ToString("N0");

                // 2. Số đơn hàng chờ xử lý
                int pendingOrders = db.Orders.Count(o => o.Status == "Chờ xử lý");
                lblPendingOrders.Text = pendingOrders.ToString("N0");

                // 3. Doanh thu thực tế (Tổng giá trị các đơn hàng trừ đơn Đã hủy)
                decimal totalRevenue = db.Orders
                    .Where(o => o.Status != "Đã hủy")
                    .Sum(o => (decimal?)o.TotalAmount) ?? 0;
                lblTotalRevenue.Text = string.Format("{0:N0} đ", totalRevenue);

                // 4. Tổng số đơn hàng
                int totalOrders = db.Orders.Count();
                lblTotalOrders.Text = totalOrders.ToString("N0");

                // 5. Cảnh báo tồn kho thấp (<= 5)
                int lowStockCount = (from pr in db.ProductPrices
                                     join p in db.PageItems on pr.ID_P equals p.ID_P
                                     where p.ItemType == 1 && !p.Hide && pr.StockQuantity <= 5
                                     select pr.ID_P).Count();
                lblLowStock.Text = lowStockCount.ToString("N0");
            }
        }

        private void LoadRecentOrders()
        {
            using (var db = DbContextHelper.GetContext())
            {
                var orders = (from o in db.Orders
                              orderby o.OrderID descending
                              select new
                              {
                                  o.OrderID,
                                  o.CustomerName,
                                  o.CustomerPhone,
                                  o.OrderDate,
                                  o.TotalAmount,
                                  o.Status
                              }).Take(5).ToList();

                gvRecentOrders.DataSource = orders;
                gvRecentOrders.DataBind();
            }
        }

        private void LoadLowStockProducts()
        {
            using (var db = DbContextHelper.GetContext())
            {
                var lowStock = (from p in db.PageItems
                                join pr in db.ProductPrices on p.ID_P equals pr.ID_P
                                join m in db.Menus on p.ID_MN equals m.ID_MN
                                where p.ItemType == 1 && !p.Hide && pr.StockQuantity <= 5
                                orderby pr.StockQuantity ascending
                                select new
                                {
                                    p.ID_P,
                                    p.Title,
                                    p.Image,
                                    BrandName = m.Lable,
                                    pr.StockQuantity,
                                    pr.Price
                                }).Take(5).ToList();

                gvLowStockProducts.DataSource = lowStock;
                gvLowStockProducts.DataBind();
            }
        }

        public string GetStatusBadgeClass(string status)
        {
            switch (status)
            {
                case "Chờ xử lý":
                    return "badge badge-warning";
                case "Đã xác nhận":
                    return "badge badge-info";
                case "Đang giao":
                    return "badge badge-purple";
                case "Đã hoàn tất":
                    return "badge badge-success";
                case "Đã hủy":
                    return "badge badge-danger";
                default:
                    return "badge badge-secondary";
            }
        }
    }
}
