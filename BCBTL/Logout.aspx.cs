using System;

namespace BCBTL
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session.Remove("Username");
            Session.Remove("Fullname");
            Session.Remove("Permission");
            Session.Remove("AdminUser");
            Response.Redirect("~/Default.aspx");
        }
    }
}
