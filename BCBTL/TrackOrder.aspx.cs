using System;
using System.Linq;
using System.Web.UI;

namespace BCBTL
{
    public partial class TrackOrder : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string q = Request.QueryString["q"] ?? Request.QueryString["orderid"];
                if (!string.IsNullOrEmpty(q))
                {
                    txtTrackQuery.Text = q;
                    PerformTrack(q);
                }
            }
        }

        protected void btnSearchTrack_Click(object sender, EventArgs e)
        {
            string query = txtTrackQuery.Text.Trim();
            if (string.IsNullOrEmpty(query))
            {
                lblTrackMsg.Visible = true;
                lblTrackMsg.Text = "Vui lòng nhập Số điện thoại hoặc Mã đơn hàng để tra cứu!";
                pnlResult.Visible = false;
                return;
            }

            PerformTrack(query);
        }

        private void PerformTrack(string query)
        {
            using (var db = DbContextHelper.GetContext())
            {
                Order order = null;

                // 1. Try parse as Order ID
                if (int.TryParse(query, out int orderId))
                {
                    order = db.Orders.FirstOrDefault(o => o.OrderID == orderId);
                }

                // 2. Or search by phone number
                if (order == null)
                {
                    order = db.Orders.OrderByDescending(o => o.OrderID).FirstOrDefault(o => o.CustomerPhone == query);
                }

                if (order == null)
                {
                    lblTrackMsg.Visible = true;
                    lblTrackMsg.Text = "Không tìm thấy đơn hàng nào khớp với thông tin '" + Server.HtmlEncode(query) + "'. Vui lòng kiểm tra lại!";
                    pnlResult.Visible = false;
                    return;
                }

                lblTrackMsg.Visible = false;
                pnlResult.Visible = true;

                litOrderId.Text = order.OrderID.ToString();
                litOrderDate.Text = order.OrderDate.ToString("dd/MM/yyyy HH:mm");
                litOrderStatus.Text = order.Status;
                litCustomerName.Text = Server.HtmlEncode(order.CustomerName);
                litCustomerPhone.Text = Server.HtmlEncode(order.CustomerPhone);
                litDeliveryAddress.Text = Server.HtmlEncode(order.DeliveryAddress);
                litTotalAmount.Text = string.Format("{0:N0} đ", order.TotalAmount);

                // Update Stepper Timeline
                UpdateStepperStatus(order.Status);

                // Load Order details
                var items = (from d in db.OrderDetails
                             join p in db.PageItems on d.ID_P equals p.ID_P
                             where d.OrderID == order.OrderID
                             select new
                             {
                                 p.Title,
                                 p.Image,
                                 d.Quantity,
                                 d.UnitPrice,
                                 TotalPrice = d.Quantity * d.UnitPrice
                             }).ToList();

                rptTrackItems.DataSource = items;
                rptTrackItems.DataBind();
            }
        }

        private void UpdateStepperStatus(string status)
        {
            // Reset styles
            step1.Attributes["class"] = "step-item";
            step2.Attributes["class"] = "step-item";
            step3.Attributes["class"] = "step-item";
            step4.Attributes["class"] = "step-item";

            switch (status?.Trim())
            {
                case "Chờ xử lý":
                    stepperProgress.Style["width"] = "15%";
                    step1.Attributes["class"] = "step-item active";
                    break;
                case "Đã xác nhận":
                    stepperProgress.Style["width"] = "45%";
                    step1.Attributes["class"] = "step-item completed";
                    step2.Attributes["class"] = "step-item active";
                    break;
                case "Đang giao":
                    stepperProgress.Style["width"] = "75%";
                    step1.Attributes["class"] = "step-item completed";
                    step2.Attributes["class"] = "step-item completed";
                    step3.Attributes["class"] = "step-item active";
                    break;
                case "Đã hoàn tất":
                    stepperProgress.Style["width"] = "100%";
                    step1.Attributes["class"] = "step-item completed";
                    step2.Attributes["class"] = "step-item completed";
                    step3.Attributes["class"] = "step-item completed";
                    step4.Attributes["class"] = "step-item completed";
                    break;
                case "Đã hủy":
                    stepperProgress.Style["width"] = "0%";
                    step1.Attributes["class"] = "step-item active";
                    break;
                default:
                    stepperProgress.Style["width"] = "15%";
                    step1.Attributes["class"] = "step-item active";
                    break;
            }
        }
    }
}
