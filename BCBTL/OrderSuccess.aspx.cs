using System;
using System.Linq;

namespace BCBTL
{
    public partial class OrderSuccess : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Verify order id matches session to prevent unauthorized direct URL tampering (DoD UC_KH_08)
                int orderId = 0;
                int.TryParse(Request.QueryString["orderid"], out orderId);

                int sessionOrderId = 0;
                if (Session["LastOrderID"] != null)
                {
                    int.TryParse(Session["LastOrderID"].ToString(), out sessionOrderId);
                }

                if (orderId > 0 && (orderId == sessionOrderId || (Session["Username"] != null)))
                {
                    LoadOrder(orderId);
                }
                else
                {
                    pnlSuccess.Visible = false;
                    pnlInvalid.Visible = true;
                }
            }
        }

        private void LoadOrder(int orderId)
        {
            using (var db = DbContextHelper.GetContext())
            {
                var order = db.Orders.FirstOrDefault(o => o.OrderID == orderId);
                if (order != null)
                {
                    pnlSuccess.Visible = true;
                    pnlInvalid.Visible = false;

                    litOrderId.Text = order.OrderID.ToString("D6");
                    litCustomerName.Text = Server.HtmlEncode(order.CustomerName);
                    litCustomerPhone.Text = Server.HtmlEncode(order.CustomerPhone);
                    litDeliveryAddress.Text = Server.HtmlEncode(order.DeliveryAddress);
                    litOrderDate.Text = order.OrderDate.ToString("dd/MM/yyyy HH:mm");
                    litOrderStatus.Text = Server.HtmlEncode(order.Status);
                    litTotalAmount.Text = string.Format("{0:N0} đ", order.TotalAmount);
                    lnkTrackThisOrder.NavigateUrl = "TrackOrder.aspx?id=" + order.OrderID;
                }
                else
                {
                    pnlSuccess.Visible = false;
                    pnlInvalid.Visible = true;
                }
            }
        }
    }
}
