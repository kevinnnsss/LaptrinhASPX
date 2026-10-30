using System;
using System.Linq;

namespace BCBTL
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                ShowError("Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
                return;
            }

            string hashedPassword = SecurityHelper.HashPassword(password);

            using (var db = DbContextHelper.GetContext())
            {
                var account = db.Acounts.FirstOrDefault(a => a.Username == username && (a.Password == hashedPassword || a.Password == password));

                if (account == null)
                {
                    ShowError("Tên đăng nhập hoặc mật khẩu không chính xác!");
                    return;
                }

                if (account.Lock)
                {
                    ShowError("Tài khoản này hiện đang bị khóa bởi Quản trị viên!");
                    return;
                }

                if (!account.Active)
                {
                    ShowError("Tài khoản này chưa được kích hoạt!");
                    return;
                }

                // Save session
                Session["Username"] = account.Username;
                Session["Fullname"] = account.Fullname;
                Session["Permission"] = account.Permission;

                if (account.Permission == 1)
                {
                    Session["AdminUser"] = account.Username;
                    Response.Redirect("~/Admin/Dashboard.aspx");
                }
                else
                {
                    Response.Redirect("~/Default.aspx");
                }
            }
        }

        private void ShowError(string msg)
        {
            lblError.Visible = true;
            lblError.Text = msg;
        }
    }
}
