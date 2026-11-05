using System;
using System.Linq;
using System.Web.UI;
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
            }
        }

        protected void btnCreateAccount_Click(object sender, EventArgs e)
        {
            string username = txtNewUsername.Text.Trim();
            string password = txtNewPassword.Text.Trim();
            string fullname = txtNewFullname.Text.Trim();
            string email = txtNewEmail.Text.Trim();
            int perm = int.Parse(ddlNewRole.SelectedValue);

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(fullname))
            {
                ShowMsg("Vui lòng điền đầy đủ Tên đăng nhập, Mật khẩu và Họ tên!", true);
                return;
            }

            using (var db = DbContextHelper.GetContext())
            {
                if (db.Acounts.Any(a => a.Username == username))
                {
                    ShowMsg("Tên đăng nhập '" + Server.HtmlEncode(username) + "' đã tồn tại trên hệ thống!", true);
                    return;
                }

                Acount acc = new Acount
                {
                    Username = username,
                    Password = SecurityHelper.HashPassword(password),
                    Fullname = fullname,
                    Email = string.IsNullOrEmpty(email) ? null : email,
                    Permission = perm,
                    Lock = false,
                    Active = true
                };

                db.Acounts.InsertOnSubmit(acc);
                db.SubmitChanges();

                ShowMsg("Tạo tài khoản '" + Server.HtmlEncode(username) + "' thành công!", false);
                txtNewUsername.Text = "";
                txtNewPassword.Text = "";
                txtNewFullname.Text = "";
                txtNewEmail.Text = "";
            }

            BindAccountsGrid();
        }

        protected void gvAccounts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string user = e.CommandArgument?.ToString();
            if (string.IsNullOrEmpty(user)) return;

            using (var db = DbContextHelper.GetContext())
            {
                var acc = db.Acounts.FirstOrDefault(a => a.Username == user);
                if (acc != null)
                {
                    if (e.CommandName == "ToggleLock")
                    {
                        // Prevent locking yourself
                        if (user.Equals(Session["Username"]?.ToString(), StringComparison.OrdinalIgnoreCase) ||
                            user.Equals(Session["AdminUser"]?.ToString(), StringComparison.OrdinalIgnoreCase))
                        {
                            ShowMsg("Bạn không thể tự khóa tài khoản của chính mình!", true);
                            return;
                        }

                        acc.Lock = !acc.Lock;
                        db.SubmitChanges();
                        ShowMsg("Đã " + (acc.Lock ? "khóa" : "mở khóa") + " tài khoản " + Server.HtmlEncode(user) + " thành công!", false);
                    }
                    else if (e.CommandName == "ResetPassword")
                    {
                        acc.Password = SecurityHelper.HashPassword("123456");
                        db.SubmitChanges();
                        ShowMsg("Đã đặt lại mật khẩu của '" + Server.HtmlEncode(user) + "' về '123456' thành công!", false);
                    }
                }
            }

            BindAccountsGrid();
        }

        protected void gvAccounts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvAccounts.PageIndex = e.NewPageIndex;
            BindAccountsGrid();
        }

        private void ShowMsg(string msg, bool isError)
        {
            lblMsg.Visible = true;
            lblMsg.Text = (isError ? "✖ " : "✔ ") + msg;
            lblMsg.CssClass = "alert-msg " + (isError ? "alert-error" : "alert-success");
        }
    }
}
