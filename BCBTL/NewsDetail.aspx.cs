using System;
using System.Linq;

namespace BCBTL
{
    public partial class NewsDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (int.TryParse(Request.QueryString["id"], out int nid))
                {
                    LoadArticle(nid);
                }
                else
                {
                    pnlContent.Visible = false;
                    pnlNotFound.Visible = true;
                }
            }
        }

        private void LoadArticle(int articleId)
        {
            using (var db = DbContextHelper.GetContext())
            {
                var article = db.PageItems.FirstOrDefault(p => p.ID_P == articleId && p.ItemType == 2 && p.Hide == false);
                if (article == null)
                {
                    pnlContent.Visible = false;
                    pnlNotFound.Visible = true;
                    return;
                }

                pnlContent.Visible = true;
                pnlNotFound.Visible = false;

                Page.Title = article.Title + " - Duy Anh Watch";
                litBreadcrumbTitle.Text = Server.HtmlEncode(article.Title);
                litTitle.Text = Server.HtmlEncode(article.Title);
                litDate.Text = article.CreaDate.ToString("dd/MM/yyyy HH:mm");
                litAuthor.Text = Server.HtmlEncode(article.UserAdd ?? "Duy Anh Watch");
                litSummary.Text = Server.HtmlEncode(article.Sumary ?? "");
                litContents.Text = article.Contents ?? "<p>Nội dung đang được cập nhật.</p>";

                string img = string.IsNullOrEmpty(article.Image) ? "news_phanbiet.jpg" : article.Image;
                imgArticle.ImageUrl = "~/Assets/images/products/" + img;
                imgArticle.AlternateText = article.Title;
            }
        }
    }
}
