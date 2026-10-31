using System;
using System.Linq;
using System.Web.UI;

namespace BCBTL
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] != null)
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        protected void btnRegisterSubmit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string username = txtUsername.Text.Trim();
            string fullname = txtFullname.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            using (var db = DbContextHelper.GetContext())
            {
                if (db.Acounts.Any(a => a.Username == username))
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = "Tên đăng nhập '" + Server.HtmlEncode(username) + "' đã có người sử dụng. Vui lòng chọn tên khác!";
                    return;
                }

                Acount acc = new Acount
                {
                    Username = username,
                    Password = SecurityHelper.HashPassword(password),
                    Fullname = fullname,
                    Email = string.IsNullOrEmpty(email) ? null : email,
                    Permission = 2, // 2 = Customer / Member
                    Lock = false,
                    Active = true
                };

                db.Acounts.InsertOnSubmit(acc);
                db.SubmitChanges();

                // Auto login to Session
                Session["Username"] = acc.Username;
                Session["Fullname"] = acc.Fullname;
                Session["Permission"] = acc.Permission;

                Response.Redirect("~/Default.aspx?reg=success");
            }
        }
    }
}
