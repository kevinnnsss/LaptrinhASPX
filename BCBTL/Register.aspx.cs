using System;
using System.Linq;
using System.Text.RegularExpressions;

namespace BCBTL
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Nếu đã đăng nhập rồi thì chuyển về trang chủ
                if (Session["Username"] != null)
                {
                    Response.Redirect("~/Default.aspx");
                }
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string fullname = txtFullname.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            // 1. Kiểm tra rỗng
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(fullname) || 
                string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(confirmPassword))
            {
                ShowAlert("Vui lòng điền đầy đủ tất cả các trường thông tin có dấu (*)", false);
                return;
            }

            // 2. Kiểm tra định dạng username (chỉ chứa chữ cái, số, gạch dưới, từ 3-30 ký tự)
            if (!Regex.IsMatch(username, "^[a-zA-Z0-9_]{3,30}$"))
            {
                ShowAlert("Tên đăng nhập từ 3 - 30 ký tự, viết liền không dấu, không chứa ký tự đặc biệt!", false);
                return;
            }

            // 3. Kiểm tra định dạng email
            if (!Regex.IsMatch(email, @"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"))
            {
                ShowAlert("Địa chỉ email không đúng định dạng!", false);
                return;
            }

            // 4. Kiểm tra độ dài mật khẩu
            if (password.Length < 6)
            {
                ShowAlert("Mật khẩu phải có độ dài tối thiểu từ 6 ký tự trở lên!", false);
                return;
            }

            // 5. Kiểm tra so khớp mật khẩu
            if (password != confirmPassword)
            {
                ShowAlert("Xác nhận mật khẩu không trùng khớp! Vui lòng nhập lại.", false);
                return;
            }

            using (var db = DbContextHelper.GetContext())
            {
                // 6. Kiểm tra trùng tên đăng nhập
                bool usernameExists = db.Acounts.Any(a => a.Username == username);
                if (usernameExists)
                {
                    ShowAlert("Tên đăng nhập [" + username + "] đã được sử dụng! Vui lòng chọn tên khác.", false);
                    return;
                }

                // 7. Băm mật khẩu chuẩn SHA-256 an toàn
                string hashedPassword = SecurityHelper.HashPassword(password);

                // 8. Tạo mới tài khoản khách hàng thành viên (Permission = 2)
                Acount newAcc = new Acount
                {
                    Username = username,
                    Password = hashedPassword,
                    Fullname = fullname,
                    Email = email,
                    Permission = 2, // 2 = Thành viên khách hàng
                    Lock = false,   // Hoạt động
                    Active = true   // Kích hoạt ngay
                };

                db.Acounts.InsertOnSubmit(newAcc);
                db.SubmitChanges();

                // 9. Tự động đăng nhập vào Session cho khách
                Session["Username"] = newAcc.Username;
                Session["Fullname"] = newAcc.Fullname;
                Session["Permission"] = newAcc.Permission;

                // 10. Chuyển hướng về trang chủ
                Response.Redirect("~/Default.aspx?reg=success");
            }
        }

        private void ShowAlert(string msg, bool isSuccess)
        {
            lblMsg.Visible = true;
            lblMsg.Text = (isSuccess ? "✔ " : "✖ ") + msg;
            lblMsg.CssClass = "alert-box " + (isSuccess ? "alert-success" : "alert-error");
        }
    }
}
