using System;
using System.Linq;

namespace BCBTL
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["auth"] == "required")
                {
                    ShowError("Vui lòng đăng nhập với tài khoản Quản trị viên (Permission = 1) để truy cập!");
                }
            }
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

            using (var db = DbContextHelper.GetContext())
            {
                // LINQ to SQL: Tự động Parameterized Query chống SQL Injection 100%
                var account = db.Acounts.FirstOrDefault(a => a.Username == username);

                // GĐ8: Xác thực mật khẩu qua giải thuật băm SHA-256
                if (account == null || !SecurityHelper.VerifyPassword(password, account.Password))
                {
                    ShowError("Tên đăng nhập hoặc mật khẩu không chính xác!");
                    return;
                }

                // Tự động nâng cấp mật khẩu sang SHA-256 nếu trong DB còn lưu văn bản thô
                if (!SecurityHelper.IsSha256(account.Password))
                {
                    account.Password = SecurityHelper.HashPassword(password);
                    db.SubmitChanges();
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

                // Lưu thông tin phiên đăng nhập (Session)
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
