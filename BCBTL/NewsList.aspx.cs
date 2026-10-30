using System;
using System.Linq;

namespace BCBTL
{
    public partial class NewsList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadNews();
            }
        }

        private void LoadNews()
        {
            using (var db = DbContextHelper.GetContext())
            {
                // ItemType == 2 (News), Hide == false
                // No product prices loaded here
                var news = (from p in db.PageItems
                            where p.ItemType == 2 && p.Hide == false
                            orderby p.ID_P descending
                            select new
                            {
                                p.ID_P,
                                p.Title,
                                p.Sumary,
                                p.Image,
                                p.CreaDate,
                                p.UserAdd
                            }).ToList();

                rptNews.DataSource = news;
                rptNews.DataBind();
            }
        }
    }
}
