using System;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BCBTL.Admin
{
    public partial class ManageProducts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategoryDropdowns();
                BindProductGrid();
            }
        }

        private void LoadCategoryDropdowns()
        {
            using (var db = DbContextHelper.GetContext())
            {
                var brands = db.Menus.Where(m => m.Hide == false && m.Parent > 0).OrderBy(m => m.OrderKey).ToList();

                ddlCategory.DataSource = brands;
                ddlCategory.DataTextField = "Lable";
                ddlCategory.DataValueField = "ID_MN";
                ddlCategory.DataBind();

                ddlFilterCategory.DataSource = brands;
                ddlFilterCategory.DataTextField = "Lable";
                ddlFilterCategory.DataValueField = "ID_MN";
                ddlFilterCategory.DataBind();
                ddlFilterCategory.Items.Insert(0, new ListItem("-- Tất cả thương hiệu --", "0"));
            }
        }

        private void BindProductGrid()
        {
            using (var db = DbContextHelper.GetContext())
            {
                var query = from p in db.PageItems
                            join m in db.Menus on p.ID_MN equals m.ID_MN
                            join pr in db.ProductPrices on p.ID_P equals pr.ID_P into prGroup
                            from price in prGroup.DefaultIfEmpty()
                            where p.ItemType == 1 && p.Hide == false
                            select new
                            {
                                p.ID_P,
                                p.Title,
                                p.Image,
                                p.Gender,
                                CategoryId = m.ID_MN,
                                CategoryName = m.Lable,
                                Price = price != null ? price.Price : 0,
                                StockQuantity = price != null ? price.StockQuantity : 0,
                                CreaDate = p.CreaDate
                            };

                // Filter by keyword
                string search = txtSearchKey.Text.Trim();
                if (!string.IsNullOrEmpty(search))
                {
                    query = query.Where(p => p.Title.Contains(search));
                }

                // Filter by brand
                if (int.TryParse(ddlFilterCategory.SelectedValue, out int brandId) && brandId > 0)
                {
                    query = query.Where(p => p.CategoryId == brandId);
                }

                var list = query.OrderByDescending(p => p.ID_P).ToList();
                litProductCount.Text = list.Count.ToString("N0");

                gvProducts.DataSource = list;
                gvProducts.DataBind();
            }
        }

        protected void btnSaveProduct_Click(object sender, EventArgs e)
        {
            string title = txtTitle.Text.Trim();
            if (string.IsNullOrEmpty(title))
            {
                ShowMsg("Vui lòng nhập tên sản phẩm!", true);
                return;
            }

            decimal price = 0;
            decimal.TryParse(txtPrice.Text.Trim(), out price);

            decimal origPrice = 0;
            decimal.TryParse(txtOriginalPrice.Text.Trim(), out origPrice);
            if (origPrice < price) origPrice = price;

            int discount = 0;
            int.TryParse(txtDiscountPercent.Text.Trim(), out discount);

            int stock = 20;
            int.TryParse(txtStockQuantity.Text.Trim(), out stock);

            int idmn = int.Parse(ddlCategory.SelectedValue);
            int gender = int.Parse(ddlGender.SelectedValue);

            using (var db = DbContextHelper.GetContext())
            {
                if (string.IsNullOrEmpty(hfEditProductId.Value))
                {
                    // 1. ADD NEW PRODUCT
                    string imageName = "default-watch.jpg";
                    if (fuProductImage.HasFile)
                    {
                        string ext = Path.GetExtension(fuProductImage.FileName).ToLower();
                        if (ext == ".jpg" || ext == ".png" || ext == ".jpeg" || ext == ".webp")
                        {
                            imageName = Guid.NewGuid().ToString().Substring(0, 8) + "_" + fuProductImage.FileName;
                            string folder = Server.MapPath("~/Assets/images/products/");
                            if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
                            fuProductImage.SaveAs(Path.Combine(folder, imageName));
                        }
                    }

                    PageItem watch = new PageItem
                    {
                        ID_MN = idmn,
                        Title = title,
                        Sumary = txtSummary.Text.Trim(),
                        Contents = txtContents.Text,
                        Image = imageName,
                        CreaDate = DateTime.Now,
                        ModiDate = DateTime.Now,
                        UserAdd = Session["AdminUser"]?.ToString() ?? "Admin",
                        Hide = false,
                        OrderKey = 0,
                        Gender = gender,
                        ItemType = 1 // 1: Product
                    };

                    db.PageItems.InsertOnSubmit(watch);
                    db.SubmitChanges(); // Generates ID_P

                    ProductPrice pr = new ProductPrice
                    {
                        ID_P = watch.ID_P,
                        Price = price,
                        OriginalPrice = origPrice,
                        DiscountPercent = discount,
                        StockQuantity = stock
                    };
                    db.ProductPrices.InsertOnSubmit(pr);
                    db.SubmitChanges();

                    ShowMsg("Thêm mới sản phẩm đồng hồ thành công!", false);
                }
                else
                {
                    // 2. UPDATE EXISTING PRODUCT
                    int pid = int.Parse(hfEditProductId.Value);
                    var watch = db.PageItems.FirstOrDefault(p => p.ID_P == pid);
                    if (watch != null)
                    {
                        watch.Title = title;
                        watch.ID_MN = idmn;
                        watch.Gender = gender;
                        watch.Sumary = txtSummary.Text.Trim();
                        watch.Contents = txtContents.Text;
                        watch.ModiDate = DateTime.Now;

                        if (fuProductImage.HasFile)
                        {
                            string ext = Path.GetExtension(fuProductImage.FileName).ToLower();
                            if (ext == ".jpg" || ext == ".png" || ext == ".jpeg" || ext == ".webp")
                            {
                                string imageName = Guid.NewGuid().ToString().Substring(0, 8) + "_" + fuProductImage.FileName;
                                string folder = Server.MapPath("~/Assets/images/products/");
                                if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
                                fuProductImage.SaveAs(Path.Combine(folder, imageName));
                                watch.Image = imageName;
                            }
                        }

                        var pr = db.ProductPrices.FirstOrDefault(x => x.ID_P == pid);
                        if (pr != null)
                        {
                            pr.Price = price;
                            pr.OriginalPrice = origPrice;
                            pr.DiscountPercent = discount;
                            pr.StockQuantity = stock;
                        }
                        else
                        {
                            ProductPrice newPr = new ProductPrice
                            {
                                ID_P = pid,
                                Price = price,
                                OriginalPrice = origPrice,
                                DiscountPercent = discount,
                                StockQuantity = stock
                            };
                            db.ProductPrices.InsertOnSubmit(newPr);
                        }

                        db.SubmitChanges();
                        ShowMsg("Cập nhật sản phẩm đồng hồ thành công!", false);
                    }
                }
            }

            ResetForm();
            BindProductGrid();
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int pid = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditItem")
            {
                using (var db = DbContextHelper.GetContext())
                {
                    var product = (from p in db.PageItems
                                   join pr in db.ProductPrices on p.ID_P equals pr.ID_P into prGroup
                                   from price in prGroup.DefaultIfEmpty()
                                   where p.ID_P == pid
                                   select new { p, price }).FirstOrDefault();

                    if (product != null)
                    {
                        hfEditProductId.Value = pid.ToString();
                        txtTitle.Text = product.p.Title;
                        txtSummary.Text = product.p.Sumary;
                        txtContents.Text = product.p.Contents;

                        if (ddlCategory.Items.FindByValue(product.p.ID_MN.ToString()) != null)
                        {
                            ddlCategory.SelectedValue = product.p.ID_MN.ToString();
                        }

                        if (ddlGender.Items.FindByValue(product.p.Gender.ToString()) != null)
                        {
                            ddlGender.SelectedValue = product.p.Gender.ToString();
                        }

                        if (product.price != null)
                        {
                            txtPrice.Text = product.price.Price.ToString("F0");
                            txtOriginalPrice.Text = (product.price.OriginalPrice ?? product.price.Price).ToString("F0");
                            txtDiscountPercent.Text = (product.price.DiscountPercent ?? 0).ToString();
                            txtStockQuantity.Text = product.price.StockQuantity.ToString();
                        }

                        litFormTitle.Text = "Chỉnh Sửa Đồng Hồ: " + Server.HtmlEncode(product.p.Title);
                        btnSaveProduct.Text = "CẬP NHẬT THAY ĐỔI";
                        btnCancelEdit.Visible = true;

                        if (!string.IsNullOrEmpty(product.p.Image))
                        {
                            pnlCurrentImg.Visible = true;
                            imgCurrentPreview.ImageUrl = "~/Assets/images/products/" + product.p.Image;
                        }
                    }
                }
            }
            else if (e.CommandName == "DeleteItem")
            {
                using (var db = DbContextHelper.GetContext())
                {
                    var p = db.PageItems.FirstOrDefault(x => x.ID_P == pid);
                    if (p != null)
                    {
                        // Soft delete (Hide = true)
                        p.Hide = true;
                        db.SubmitChanges();
                        ShowMsg("Đã ẩn / xóa sản phẩm ID #" + pid + " thành công!", false);
                    }
                }
                BindProductGrid();
            }
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        private void ResetForm()
        {
            hfEditProductId.Value = "";
            txtTitle.Text = "";
            txtPrice.Text = "0";
            txtOriginalPrice.Text = "0";
            txtDiscountPercent.Text = "0";
            txtStockQuantity.Text = "20";
            txtSummary.Text = "";
            txtContents.Text = "";
            litFormTitle.Text = "Thêm Đồng Hồ Mới";
            btnSaveProduct.Text = "LƯU SẢN PHẨM";
            btnCancelEdit.Visible = false;
            pnlCurrentImg.Visible = false;
        }

        private void ShowMsg(string msg, bool isError)
        {
            lblMsg.Visible = true;
            lblMsg.Text = (isError ? "✖ " : "✔ ") + msg;
            lblMsg.CssClass = "alert-msg " + (isError ? "alert-error" : "alert-success");
        }

        protected void gvProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProducts.PageIndex = e.NewPageIndex;
            BindProductGrid();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            gvProducts.PageIndex = 0;
            BindProductGrid();
        }

        protected void ddlFilterCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvProducts.PageIndex = 0;
            BindProductGrid();
        }

        protected void btnResetFilter_Click(object sender, EventArgs e)
        {
            txtSearchKey.Text = "";
            ddlFilterCategory.SelectedIndex = 0;
            gvProducts.PageIndex = 0;
            BindProductGrid();
        }
    }
}
