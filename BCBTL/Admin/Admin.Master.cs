using System;
using System.IO;
using System.Web.UI;

namespace BCBTL.Admin
{
    public partial class Admin : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Kiểm tra bảo mật: Bắt buộc phải có Session AdminUser và quyền Permission = 1
            if (Session["AdminUser"] == null || Session["Permission"] == null || Convert.ToInt32(Session["Permission"]) != 1)
            {
                Response.Redirect("~/Login.aspx?auth=required");
                return;
            }

            if (!IsPostBack)
            {
                string displayName = Session["Fullname"] != null ? Session["Fullname"].ToString() : Session["AdminUser"].ToString();
                litSidebarName.Text = Server.HtmlEncode(displayName);

                if (!string.IsNullOrEmpty(displayName))
                {
                    litAvatarChar.Text = Server.HtmlEncode(displayName.Substring(0, 1).ToUpper());
                }
            }
        }

        // Hàm kiểm tra trang hiện tại để gán class active vào menu sidebar
        public string IsActivePage(string pageName)
        {
            string currentPath = Request.Url.AbsolutePath;
            string currentPage = Path.GetFileName(currentPath);
            if (string.Equals(currentPage, pageName, StringComparison.OrdinalIgnoreCase))
            {
                return "active";
            }
            return string.Empty;
        }
    }
}
