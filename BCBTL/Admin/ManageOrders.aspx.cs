using System;
using System.Linq;
using System.Web.UI.WebControls;

namespace BCBTL.Admin
{
    public partial class ManageOrders : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindOrdersGrid();

                // Nếu có query string ?id= từ Dashboard chuyển sang thì mở ngay chi tiết
                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    int orderId = 0;
                    if (int.TryParse(Request.QueryString["id"], out orderId))
                    {
                        ShowOrderDetail(orderId);
                    }
                }
            }
        }

        private void BindOrdersGrid()
        {
            string keyword = txtSearchCustomer.Text.Trim();
            string statusFilter = ddlFilterStatus.SelectedValue;

            using (var db = DbContextHelper.GetContext())
            {
                var query = from o in db.Orders
                            select o;

                if (!string.IsNullOrEmpty(statusFilter))
                {
                    query = query.Where(o => o.Status == statusFilter);
                }

                if (!string.IsNullOrEmpty(keyword))
                {
                    query = query.Where(o => o.CustomerName.Contains(keyword) || o.CustomerPhone.Contains(keyword));
                }

                var list = query.OrderByDescending(o => o.OrderID).ToList();
                gvOrders.DataSource = list;
                gvOrders.DataBind();

                lblTotalOrdersCount.Text = list.Count.ToString();
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            gvOrders.PageIndex = 0;
            BindOrdersGrid();
        }

        protected void btnResetFilter_Click(object sender, EventArgs e)
        {
            txtSearchCustomer.Text = string.Empty;
            ddlFilterStatus.SelectedIndex = 0;
            gvOrders.PageIndex = 0;
            BindOrdersGrid();
        }

        protected void gvOrders_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvOrders.PageIndex = e.NewPageIndex;
            BindOrdersGrid();
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
                    lblDetailOrderId.Text = order.OrderID.ToString();
                    lblDetailCustomerName.Text = Server.HtmlEncode(order.CustomerName);
                    lblDetailPhone.Text = Server.HtmlEncode(order.CustomerPhone);
                    lblDetailEmail.Text = string.IsNullOrEmpty(order.CustomerEmail) ? "(Không có)" : Server.HtmlEncode(order.CustomerEmail);
                    lblDetailAddress.Text = Server.HtmlEncode(order.DeliveryAddress);
                    lblDetailNotes.Text = string.IsNullOrEmpty(order.OrderNotes) ? "(Không có ghi chú)" : Server.HtmlEncode(order.OrderNotes);
                    lblDetailAccount.Text = string.IsNullOrEmpty(order.Username) ? "Khách vãng lai" : "Thành viên (" + order.Username + ")";
                    lblDetailOrderDate.Text = order.OrderDate.ToString("dd/MM/yyyy HH:mm:ss");
                    lblDetailTotalAmount.Text = string.Format("{0:N0} VNĐ", order.TotalAmount);

                    lblDetailCurrentStatus.Text = string.Format("<span class='{0}'>{1}</span>", GetStatusBadgeClass(order.Status), order.Status);

                    if (ddlUpdateStatus.Items.FindByValue(order.Status) != null)
                    {
                        ddlUpdateStatus.SelectedValue = order.Status;
                    }

                    // Tải danh sách sản phẩm trong đơn
                    var items = (from d in db.OrderDetails
                                 join p in db.PageItems on d.ID_P equals p.ID_P
                                 where d.OrderID == orderId
                                 select new
                                 {
                                     d.ID_P,
                                     p.Title,
                                     p.Image,
                                     d.UnitPrice,
                                     d.Quantity,
                                     d.LineTotal
                                 }).ToList();

                    gvOrderItems.DataSource = items;
                    gvOrderItems.DataBind();

                    pnlOrderDetail.Visible = true;
                }
            }
        }

        protected void btnUpdateStatus_Click(object sender, EventArgs e)
        {
            int orderId = 0;
            if (int.TryParse(lblDetailOrderId.Text, out orderId))
            {
                string newStatus = ddlUpdateStatus.SelectedValue;

                using (var db = DbContextHelper.GetContext())
                {
                    var order = db.Orders.FirstOrDefault(o => o.OrderID == orderId);
                    if (order != null)
                    {
                        order.Status = newStatus;
                        db.SubmitChanges();

                        ShowAlert("Cập nhật trạng thái đơn hàng #" + orderId + " sang [" + newStatus + "] thành công!", "alert-success");
                    }
                }

                ShowOrderDetail(orderId);
                BindOrdersGrid();
            }
        }

        protected void btnCloseDetail_Click(object sender, EventArgs e)
        {
            pnlOrderDetail.Visible = false;
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

        private void ShowAlert(string msg, string cssClass)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = "alert " + cssClass;
            lblAlertMsg.Text = msg;
        }
    }
}
