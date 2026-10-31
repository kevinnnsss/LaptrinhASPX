using System;
using System.Linq;
using System.Web.UI.WebControls;

namespace BCBTL.Admin
{
    public partial class ManageAccounts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindAccountsGrid();
            }
        }

        private void BindAccountsGrid()
        {
            using (var db = DbContextHelper.GetContext())
            {
                var list = db.Acounts.OrderBy(a => a.Permission).ThenBy(a => a.Username).ToList();
                gvAccounts.DataSource = list;
                gvAccounts.DataBind();

                lblTotalAccounts.Text = list.Count.ToString();
            }
        }

        protected void btnAddAccount_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string fullname = txtFullname.Text.Trim();
            string email = txtEmail.Text.Trim();
            int permission = int.Parse(ddlPermission.SelectedValue);
            bool active = chkActive.Checked;
            bool lockAcc = chkLock.Checked;

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(fullname))
            {
                ShowAlert("Vui lòng điền đầy đủ Tên đăng nhập, Mật khẩu và Họ tên!", "alert-danger");
                return;
            }

            using (var db = DbContextHelper.GetContext())
            {
                // Kiểm tra trùng username
                bool exists = db.Acounts.Any(a => a.Username == username);
                if (exists)
                {
                    ShowAlert("Tên đăng nhập [" + username + "] đã tồn tại! Vui lòng chọn tên khác.", "alert-danger");
                    return;
                }

                // Băm mật khẩu chuẩn SHA-256
                string hashedPassword = SecurityHelper.HashPassword(password);

                Acount newAcc = new Acount
                {
                    Username = username,
                    Password = hashedPassword,
                    Fullname = fullname,
                    Email = email,
                    Permission = permission,
                    Active = active,
                    Lock = lockAcc
                };

                db.Acounts.InsertOnSubmit(newAcc);
                db.SubmitChanges();

                ShowAlert("Tạo tài khoản [" + username + "] thành công!", "alert-success");
            }

            ResetForm();
            BindAccountsGrid();
        }

        private void ResetForm()
        {
            txtUsername.Text = string.Empty;
            txtPassword.Text = string.Empty;
            txtFullname.Text = string.Empty;
            txtEmail.Text = string.Empty;
            ddlPermission.SelectedValue = "1";
            chkActive.Checked = true;
            chkLock.Checked = false;
        }

        protected void gvAccounts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string targetUsername = e.CommandArgument.ToString();
            string currentAdmin = Session["AdminUser"] != null ? Session["AdminUser"].ToString() : "";

            if (e.CommandName == "ToggleLock")
            {
                if (string.Equals(targetUsername, currentAdmin, StringComparison.OrdinalIgnoreCase))
                {
                    ShowAlert("Bạn không thể tự khóa tài khoản của chính mình khi đang đăng nhập!", "alert-danger");
                    return;
                }

                using (var db = DbContextHelper.GetContext())
                {
                    var acc = db.Acounts.FirstOrDefault(a => a.Username == targetUsername);
                    if (acc != null)
                    {
                        acc.Lock = !acc.Lock;
                        db.SubmitChanges();

                        string statusStr = acc.Lock ? "ĐÃ KHÓA" : "ĐÃ MỞ KHÓA";
                        ShowAlert("Tài khoản [" + targetUsername + "] hiện " + statusStr + " thành công!", "alert-success");
                    }
                }

                BindAccountsGrid();
            }
            else if (e.CommandName == "DeleteAccount")
            {
                if (string.Equals(targetUsername, currentAdmin, StringComparison.OrdinalIgnoreCase))
                {
                    ShowAlert("Bạn không thể tự xóa tài khoản của chính mình khi đang thao tác!", "alert-danger");
                    return;
                }

                using (var db = DbContextHelper.GetContext())
                {
                    var acc = db.Acounts.FirstOrDefault(a => a.Username == targetUsername);
                    if (acc != null)
                    {
                        // Kiểm tra nếu tài khoản có ràng buộc trong bảng Orders
                        bool hasOrders = db.Orders.Any(o => o.Username == targetUsername);
                        if (hasOrders)
                        {
                            acc.Lock = true;
                            db.SubmitChanges();
                            ShowAlert("Tài khoản [" + targetUsername + "] đã có liên kết đơn hàng. Hệ thống tự động KHÓA tài khoản thay vì xóa vật lý để bảo toàn dữ liệu!", "alert-warning");
                        }
                        else
                        {
                            db.Acounts.DeleteOnSubmit(acc);
                            db.SubmitChanges();
                            ShowAlert("Đã xóa hoàn toàn tài khoản [" + targetUsername + "]!", "alert-success");
                        }
                    }
                }

                BindAccountsGrid();
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
