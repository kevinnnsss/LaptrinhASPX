using System;
using System.Web.UI;

namespace BCBTL.Admin
{
    public partial class AdminMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Kiểm tra phân quyền bảo mật (Security Gatekeeper)
            if (Session["AdminUser"] == null && (Session["Username"] == null || Convert.ToInt32(Session["Permission"]) != 1))
            {
                Response.Redirect("~/Login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }

            if (!IsPostBack)
            {
                string displayName = Session["Fullname"]?.ToString() ?? Session["AdminUser"]?.ToString() ?? Session["Username"]?.ToString() ?? "Quản Trị Viên";
                litAdminName.Text = "<strong>" + Server.HtmlEncode(displayName) + "</strong>";
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Remove("AdminUser");
            Session.Remove("Username");
            Session.Remove("Fullname");
            Session.Remove("Permission");
            Response.Redirect("~/Login.aspx");
        }
    }
}
