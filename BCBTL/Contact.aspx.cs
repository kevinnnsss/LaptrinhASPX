using System;

namespace BCBTL
{
    public partial class Contact : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSendContact_Click(object sender, EventArgs e)
        {
            string name = txtContactName.Text.Trim();
            string phone = txtContactPhone.Text.Trim();

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(phone))
            {
                lblContactMsg.Visible = true;
                lblContactMsg.Text = "Vui lòng nhập họ tên và số điện thoại liên hệ!";
                lblContactMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }

            lblContactMsg.Visible = true;
            lblContactMsg.Text = "Cảm ơn quý khách! Chuyên viên Duy Anh Watch sẽ liên hệ lại trong ít phút.";
            lblContactMsg.ForeColor = System.Drawing.Color.Green;

            txtContactName.Text = "";
            txtContactPhone.Text = "";
            txtContactEmail.Text = "";
            txtContactMessage.Text = "";
        }
    }
}
