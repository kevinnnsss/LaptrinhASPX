using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BCBTL.Admin
{
    public partial class ManageOrders : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (int.TryParse(Request.QueryString["viewId"], out int vId))
                {
                    ShowOrderDetail(vId);
                }

                BindOrdersGrid();
            }
        }

        private void BindOrdersGrid()
        {
            using (var db = DbContextHelper.GetContext())
            {
                var query = db.Orders.AsQueryable();

                string status = ddlFilterStatus.SelectedValue;
                if (!string.IsNullOrEmpty(status) && status != "ALL")
                {
                    query = query.Where(o => o.Status == status);
                }

                var list = query.OrderByDescending(o => o.OrderID).ToList();
                gvOrders.DataSource = list;
                gvOrders.DataBind();
            }
        }

        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewOrder")
            {
                int orderId = Convert.ToInt32(e.CommandArgument);
                ShowOrderDetail(orderId);
            }
        }

        private void ShowOrderDetail(int orderId)
        {
            using (var db = DbContextHelper.GetContext())
            {
                var order = db.Orders.FirstOrDefault(o => o.OrderID == orderId);
                if (order != null)
                {
                    pnlOrderDetail.Visible = true;
                    litDetailOrderId.Text = order.OrderID.ToString();
                    litDetailCustomerName.Text = Server.HtmlEncode(order.CustomerName);
                    litDetailPhone.Text = Server.HtmlEncode(order.CustomerPhone);
                    litDetailEmail.Text = string.IsNullOrEmpty(order.CustomerEmail) ? "Chưa cung cấp" : Server.HtmlEncode(order.CustomerEmail);
                    litDetailDate.Text = order.OrderDate.ToString("dd/MM/yyyy HH:mm:ss");
                    litDetailAddress.Text = Server.HtmlEncode(order.DeliveryAddress);
                    litDetailNotes.Text = string.IsNullOrEmpty(order.OrderNotes) ? "Không có ghi chú" : Server.HtmlEncode(order.OrderNotes);
                    litDetailTotal.Text = string.Format("{0:N0} đ", order.TotalAmount);

                    if (ddlUpdateStatus.Items.FindByValue(order.Status) != null)
                    {
                        ddlUpdateStatus.SelectedValue = order.Status;
                    }

                    // Load Items
                    var items = (from d in db.OrderDetails
                                 join p in db.PageItems on d.ID_P equals p.ID_P
                                 where d.OrderID == orderId
                                 select new
                                 {
                                     p.Title,
                                     p.Image,
                                     d.Quantity,
                                     d.UnitPrice,
                                     LineTotal = d.Quantity * d.UnitPrice
                                 }).ToList();

                    gvOrderItems.DataSource = items;
                    gvOrderItems.DataBind();
                }
            }
        }

        protected void btnUpdateStatus_Click(object sender, EventArgs e)
        {
            if (int.TryParse(litDetailOrderId.Text, out int orderId))
            {
                using (var db = DbContextHelper.GetContext())
                {
                    var order = db.Orders.FirstOrDefault(o => o.OrderID == orderId);
                    if (order != null)
                    {
                        order.Status = ddlUpdateStatus.SelectedValue;
                        db.SubmitChanges();

                        lblDetailMsg.Visible = true;
                        lblDetailMsg.Text = "✔ Đã cập nhật trạng thái đơn hàng thành công sang: " + order.Status;
                    }
                }

                BindOrdersGrid();
            }
        }

        protected void btnCloseDetail_Click(object sender, EventArgs e)
        {
            pnlOrderDetail.Visible = false;
        }

        protected void ddlFilterStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvOrders.PageIndex = 0;
            BindOrdersGrid();
        }

        protected void gvOrders_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvOrders.PageIndex = e.NewPageIndex;
            BindOrdersGrid();
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
