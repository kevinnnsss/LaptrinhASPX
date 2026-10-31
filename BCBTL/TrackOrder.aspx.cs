using System;
using System.Linq;

namespace BCBTL
{
    public partial class TrackOrder : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Hỗ trợ tra cứu tự động qua Query String ?id= hoặc ?phone=
                string queryId = Request.QueryString["id"];
                string queryPhone = Request.QueryString["phone"];

                if (!string.IsNullOrEmpty(queryId))
                {
                    txtKeyword.Text = queryId;
                    SearchOrder(queryId);
                }
                else if (!string.IsNullOrEmpty(queryPhone))
                {
                    txtKeyword.Text = queryPhone;
                    SearchOrder(queryPhone);
                }
            }
        }

        protected void btnTrack_Click(object sender, EventArgs e)
        {
            string keyword = txtKeyword.Text.Trim();
            SearchOrder(keyword);
        }

        private void SearchOrder(string keyword)
        {
            lblTrackMsg.Visible = false;

            if (string.IsNullOrEmpty(keyword))
            {
                lblTrackMsg.Visible = true;
                lblTrackMsg.Text = "Vui lòng nhập số điện thoại hoặc mã đơn hàng!";
                lblTrackMsg.BackColor = System.Drawing.Color.FromArgb(254, 235, 235);
                lblTrackMsg.ForeColor = System.Drawing.Color.FromArgb(220, 38, 38);
                pnlResult.Visible = false;
                pnlNotFound.Visible = false;
                return;
            }

            using (var db = DbContextHelper.GetContext())
            {
                int orderId = 0;
                bool isId = int.TryParse(keyword, out orderId);

                Order order = null;

                if (isId && orderId > 0)
                {
                    // Tìm chính xác theo mã đơn hàng trước
                    order = db.Orders.FirstOrDefault(o => o.OrderID == orderId);
                }

                // Nếu không tìm thấy theo mã, tìm theo số điện thoại (lấy đơn mới nhất)
                if (order == null)
                {
                    order = db.Orders
                        .Where(o => o.CustomerPhone.Contains(keyword) || o.CustomerPhone == keyword)
                        .OrderByDescending(o => o.OrderID)
                        .FirstOrDefault();
                }

                if (order != null)
                {
                    pnlResult.Visible = true;
                    pnlNotFound.Visible = false;

                    lblOrderID.Text = order.OrderID.ToString("D6");
                    lblOrderDate.Text = order.OrderDate.ToString("dd/MM/yyyy HH:mm");
                    lblCustomerName.Text = Server.HtmlEncode(order.CustomerName);
                    lblCustomerPhone.Text = Server.HtmlEncode(order.CustomerPhone);
                    lblCustomerEmail.Text = string.IsNullOrEmpty(order.CustomerEmail) ? "(Không có)" : Server.HtmlEncode(order.CustomerEmail);
                    lblDeliveryAddress.Text = Server.HtmlEncode(order.DeliveryAddress);
                    lblOrderNotes.Text = string.IsNullOrEmpty(order.OrderNotes) ? "(Không có ghi chú)" : Server.HtmlEncode(order.OrderNotes);
                    lblTotalAmount.Text = string.Format("{0:N0} đ", order.TotalAmount);

                    // Badge trạng thái
                    lblStatusBadge.Text = string.Format("<span class='{0}'>{1}</span>", GetStatusBadgeClass(order.Status), order.Status);

                    // Cập nhật thanh tiến trình Stepper
                    UpdateStepper(order.Status);

                    // Tải danh sách đồng hồ đặt mua
                    var items = (from d in db.OrderDetails
                                 join p in db.PageItems on d.ID_P equals p.ID_P
                                 where d.OrderID == order.OrderID
                                 select new
                                 {
                                     d.ID_P,
                                     p.Title,
                                     p.Image,
                                     d.UnitPrice,
                                     d.Quantity,
                                     d.LineTotal
                                 }).ToList();

                    gvItems.DataSource = items;
                    gvItems.DataBind();
                }
                else
                {
                    pnlResult.Visible = false;
                    pnlNotFound.Visible = true;
                }
            }
        }

        private void UpdateStepper(string status)
        {
            // Reset class
            step1.Attributes["class"] = "stepper-step";
            step2.Attributes["class"] = "stepper-step";
            step3.Attributes["class"] = "stepper-step";
            step4.Attributes["class"] = "stepper-step";

            if (status == "Đã hủy")
            {
                pnlStepper.Visible = false;
                pnlCancelled.Visible = true;
                return;
            }

            pnlStepper.Visible = true;
            pnlCancelled.Visible = false;

            switch (status)
            {
                case "Chờ xử lý":
                    step1.Attributes["class"] = "stepper-step completed current";
                    break;
                case "Đã xác nhận":
                    step1.Attributes["class"] = "stepper-step completed";
                    step2.Attributes["class"] = "stepper-step completed current";
                    break;
                case "Đang giao":
                    step1.Attributes["class"] = "stepper-step completed";
                    step2.Attributes["class"] = "stepper-step completed";
                    step3.Attributes["class"] = "stepper-step completed current";
                    break;
                case "Đã hoàn tất":
                    step1.Attributes["class"] = "stepper-step completed";
                    step2.Attributes["class"] = "stepper-step completed";
                    step3.Attributes["class"] = "stepper-step completed";
                    step4.Attributes["class"] = "stepper-step completed current";
                    break;
                default:
                    step1.Attributes["class"] = "stepper-step completed current";
                    break;
            }
        }

        private string GetStatusBadgeClass(string status)
        {
            switch (status)
            {
                case "Chờ xử lý":
                    return "stock-status in-stock";
                case "Đã xác nhận":
                    return "badge-auth-tag";
                case "Đang giao":
                    return "stock-status in-stock";
                case "Đã hoàn tất":
                    return "stock-status in-stock";
                case "Đã hủy":
                    return "stock-status out-of-stock";
                default:
                    return "stock-status";
            }
        }
    }
}
