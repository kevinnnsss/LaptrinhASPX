using System;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

namespace BCBTL.Admin
{
    public partial class ManageProducts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBrandDropdowns();
                BindProductGrid();
            }
        }

        private void LoadBrandDropdowns()
        {
            using (var db = DbContextHelper.GetContext())
            {
                // Lấy các danh mục thương hiệu (Parent > 0 hoặc Pos = 2)
                var brands = db.Menus.Where(m => m.Hide == false && m.Parent > 0).OrderBy(m => m.Lable).ToList();

                // Nạp vào Form Thêm/Sửa
                ddlCategory.Items.Clear();
                foreach (var b in brands)
                {
                    ddlCategory.Items.Add(new ListItem(b.Lable, b.ID_MN.ToString()));
                }

                // Nạp vào Bộ Lọc
                ddlFilterBrand.Items.Clear();
                ddlFilterBrand.Items.Add(new ListItem("-- Mọi thương hiệu --", "0"));
                foreach (var b in brands)
                {
                    ddlFilterBrand.Items.Add(new ListItem(b.Lable, b.ID_MN.ToString()));
                }
            }
        }

        private void BindProductGrid()
        {
            string keyword = txtSearchKeyword.Text.Trim();
            int filterBrand = int.Parse(ddlFilterBrand.SelectedValue);
            int filterGender = int.Parse(ddlFilterGender.SelectedValue);
            int filterStatus = int.Parse(ddlFilterStatus.SelectedValue);

            using (var db = DbContextHelper.GetContext())
            {
                var query = from p in db.PageItems
                            join m in db.Menus on p.ID_MN equals m.ID_MN
                            join pr in db.ProductPrices on p.ID_P equals pr.ID_P into prGroup
                            from price in prGroup.DefaultIfEmpty()
                            where p.ItemType == 1 // Chỉ lấy sản phẩm đồng hồ
                            select new
                            {
                                p.ID_P,
                                p.Title,
                                p.Image,
                                p.Gender,
                                p.Hide,
                                p.ID_MN,
                                CategoryName = m.Lable,
                                Price = price != null ? price.Price : 0,
                                OriginalPrice = price != null ? price.OriginalPrice : 0,
                                StockQuantity = price != null ? price.StockQuantity : 0,
                                DiscountPercent = price != null ? price.DiscountPercent : 0
                            };

                // Áp dụng bộ lọc
                if (!string.IsNullOrEmpty(keyword))
                {
                    query = query.Where(p => p.Title.Contains(keyword));
                }

                if (filterBrand > 0)
                {
                    query = query.Where(p => p.ID_MN == filterBrand);
                }

                if (filterGender != -1)
                {
                    query = query.Where(p => p.Gender == filterGender);
                }

                if (filterStatus != -1)
                {
                    bool isHidden = (filterStatus == 1);
                    query = query.Where(p => p.Hide == isHidden);
                }

                var list = query.OrderByDescending(p => p.ID_P).ToList();
                gvProducts.DataSource = list;
                gvProducts.DataBind();

                lblTotalCount.Text = list.Count.ToString();
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            gvProducts.PageIndex = 0;
            BindProductGrid();
        }

        protected void btnResetFilter_Click(object sender, EventArgs e)
        {
            txtSearchKeyword.Text = string.Empty;
            ddlFilterBrand.SelectedIndex = 0;
            ddlFilterGender.SelectedIndex = 0;
            ddlFilterStatus.SelectedIndex = 0;
            gvProducts.PageIndex = 0;
            BindProductGrid();
        }

        protected void gvProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProducts.PageIndex = e.NewPageIndex;
            BindProductGrid();
        }

        protected void btnSaveProduct_Click(object sender, EventArgs e)
        {
            string title = txtTitle.Text.Trim();
            if (string.IsNullOrEmpty(title))
            {
                ShowAlert("Vui lòng nhập tên sản phẩm đồng hồ!", "alert-danger");
                return;
            }

            decimal price = 0;
            decimal.TryParse(txtPrice.Text.Trim(), out price);

            decimal originalPrice = 0;
            decimal.TryParse(txtOriginalPrice.Text.Trim(), out originalPrice);
            if (originalPrice <= 0) originalPrice = price;

            int discountPercent = 0;
            int.TryParse(txtDiscountPercent.Text.Trim(), out discountPercent);
            if (discountPercent < 0) discountPercent = 0;
            if (discountPercent > 100) discountPercent = 100;

            int stockQuantity = 20;
            int.TryParse(txtStockQuantity.Text.Trim(), out stockQuantity);
            if (stockQuantity < 0) stockQuantity = 0;

            int categoryId = int.Parse(ddlCategory.SelectedValue);
            int gender = int.Parse(ddlGender.SelectedValue);
            int itemType = int.Parse(ddlItemType.SelectedValue);
            bool hide = chkHide.Checked;

            int productId = 0;
            int.TryParse(hfProductId.Value, out productId);

            // Xử lý upload ảnh
            string imageName = productId > 0 ? hfCurrentImage.Value : "default-watch.jpg";
            if (fuProductImage.HasFile)
            {
                string ext = Path.GetExtension(fuProductImage.FileName).ToLower();
                if (ext == ".jpg" || ext == ".png" || ext == ".jpeg" || ext == ".webp")
                {
                    string safeFileName = Path.GetFileNameWithoutExtension(fuProductImage.FileName);
                    safeFileName = safeFileName.Replace(" ", "_");
                    imageName = Guid.NewGuid().ToString().Substring(0, 8) + "_" + safeFileName + ext;

                    string uploadFolder = Server.MapPath("~/Assets/images/products/");
                    if (!Directory.Exists(uploadFolder))
                    {
                        Directory.CreateDirectory(uploadFolder);
                    }
                    fuProductImage.SaveAs(Path.Combine(uploadFolder, imageName));
                }
                else
                {
                    ShowAlert("Định dạng ảnh không được hỗ trợ! Vui lòng chọn tệp .jpg, .png, .jpeg, .webp.", "alert-danger");
                    return;
                }
            }

            using (var db = DbContextHelper.GetContext())
            {
                string currentUser = Session["AdminUser"] != null ? Session["AdminUser"].ToString() : "admin";

                if (productId == 0)
                {
                    // THÊM MỚI SẢN PHẨM
                    PageItem watch = new PageItem
                    {
                        ID_MN = categoryId,
                        Title = title,
                        Sumary = txtSummary.Text.Trim(), // v2: CHỈ chứa tóm tắt, không chứa giá
                        Contents = txtContents.Text.Trim(),
                        Image = imageName,
                        CreaDate = DateTime.Now,
                        ModiDate = DateTime.Now,
                        UserAdd = currentUser,
                        Hide = hide,
                        OrderKey = 0,
                        Gender = gender,
                        ItemType = itemType
                    };

                    db.PageItems.InsertOnSubmit(watch);
                    db.SubmitChanges(); // Lưu để sinh ID_P tự tăng

                    // Thêm bản ghi giá vào ProductPrices
                    ProductPrice pr = new ProductPrice
                    {
                        ID_P = watch.ID_P,
                        Price = price,
                        OriginalPrice = originalPrice,
                        StockQuantity = stockQuantity,
                        DiscountPercent = discountPercent
                    };

                    db.ProductPrices.InsertOnSubmit(pr);
                    db.SubmitChanges();

                    ShowAlert("Thêm mới sản phẩm đồng hồ thành công (Mã ID: " + watch.ID_P + ")!", "alert-success");
                }
                else
                {
                    // CẬP NHẬT SẢN PHẨM
                    var watch = db.PageItems.FirstOrDefault(p => p.ID_P == productId);
                    if (watch != null)
                    {
                        watch.ID_MN = categoryId;
                        watch.Title = title;
                        watch.Sumary = txtSummary.Text.Trim();
                        watch.Contents = txtContents.Text.Trim();
                        watch.ModiDate = DateTime.Now;
                        watch.Gender = gender;
                        watch.ItemType = itemType;
                        watch.Hide = hide;
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            watch.Image = imageName;
                        }

                        // Cập nhật ProductPrices
                        var pr = db.ProductPrices.FirstOrDefault(x => x.ID_P == productId);
                        if (pr != null)
                        {
                            pr.Price = price;
                            pr.OriginalPrice = originalPrice;
                            pr.StockQuantity = stockQuantity;
                            pr.DiscountPercent = discountPercent;
                        }
                        else
                        {
                            ProductPrice newPr = new ProductPrice
                            {
                                ID_P = productId,
                                Price = price,
                                OriginalPrice = originalPrice,
                                StockQuantity = stockQuantity,
                                DiscountPercent = discountPercent
                            };
                            db.ProductPrices.InsertOnSubmit(newPr);
                        }

                        db.SubmitChanges();
                        ShowAlert("Cập nhật thông tin đồng hồ #" + productId + " thành công!", "alert-success");
                    }
                }
            }

            ResetForm();
            BindProductGrid();
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        private void ResetForm()
        {
            hfProductId.Value = "0";
            hfCurrentImage.Value = string.Empty;
            txtTitle.Text = string.Empty;
            if (ddlCategory.Items.Count > 0) ddlCategory.SelectedIndex = 0;
            ddlGender.SelectedValue = "1";
            ddlItemType.SelectedValue = "1";
            txtPrice.Text = "0";
            txtOriginalPrice.Text = "0";
            txtDiscountPercent.Text = "0";
            txtStockQuantity.Text = "20";
            txtSummary.Text = string.Empty;
            txtContents.Text = string.Empty;
            chkHide.Checked = false;
            pnlCurrentPreview.Visible = false;
            lblEditModeNotice.Visible = false;
            litFormTitle.Text = "➕ Thêm Sản Phẩm Đồng Hồ Mới";
            btnSaveProduct.Text = "Lưu Sản Phẩm";
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditProduct")
            {
                using (var db = DbContextHelper.GetContext())
                {
                    var product = (from p in db.PageItems
                                   join pr in db.ProductPrices on p.ID_P equals pr.ID_P into prGroup
                                   from price in prGroup.DefaultIfEmpty()
                                   where p.ID_P == productId
                                   select new
                                   {
                                       p.ID_P,
                                       p.Title,
                                       p.ID_MN,
                                       p.Gender,
                                       p.ItemType,
                                       p.Image,
                                       p.Sumary,
                                       p.Contents,
                                       p.Hide,
                                       Price = price != null ? price.Price : 0,
                                       OriginalPrice = price != null ? price.OriginalPrice : 0,
                                       StockQuantity = price != null ? price.StockQuantity : 0,
                                       DiscountPercent = price != null ? price.DiscountPercent : 0
                                   }).FirstOrDefault();

                    if (product != null)
                    {
                        hfProductId.Value = product.ID_P.ToString();
                        txtTitle.Text = product.Title;
                        if (ddlCategory.Items.FindByValue(product.ID_MN.ToString()) != null)
                        {
                            ddlCategory.SelectedValue = product.ID_MN.ToString();
                        }
                        if (ddlGender.Items.FindByValue(product.Gender.ToString()) != null)
                        {
                            ddlGender.SelectedValue = product.Gender.ToString();
                        }
                        if (ddlItemType.Items.FindByValue(product.ItemType.ToString()) != null)
                        {
                            ddlItemType.SelectedValue = product.ItemType.ToString();
                        }
                        txtPrice.Text = Convert.ToInt64(product.Price).ToString();
                        txtOriginalPrice.Text = Convert.ToInt64(product.OriginalPrice).ToString();
                        txtStockQuantity.Text = product.StockQuantity.ToString();
                        txtDiscountPercent.Text = product.DiscountPercent.ToString();
                        txtSummary.Text = product.Sumary;
                        txtContents.Text = product.Contents;
                        chkHide.Checked = product.Hide;

                        hfCurrentImage.Value = product.Image ?? "default-watch.jpg";
                        pnlCurrentPreview.Visible = true;
                        imgCurrentPreview.ImageUrl = ResolveUrl("~/Assets/images/products/" + (string.IsNullOrEmpty(product.Image) ? "default-watch.jpg" : product.Image));
                        lblCurrentImgName.Text = product.Image;

                        litFormTitle.Text = "✏️ Cập Nhật Đồng Hồ #" + product.ID_P;
                        btnSaveProduct.Text = "Cập Nhật Sản Phẩm";
                        lblEditModeNotice.Visible = true;
                    }
                }
            }
            else if (e.CommandName == "DeleteProduct")
            {
                using (var db = DbContextHelper.GetContext())
                {
                    // 1. Kiểm tra xem sản phẩm đã có trong OrderDetails hay chưa
                    bool hasOrders = db.OrderDetails.Any(od => od.ID_P == productId);

                    if (hasOrders)
                    {
                        // Đã có trong đơn hàng -> Chuyển sang ẨN để bảo toàn lịch sử đơn hàng
                        var item = db.PageItems.FirstOrDefault(p => p.ID_P == productId);
                        if (item != null)
                        {
                            item.Hide = true;
                            db.SubmitChanges();
                            ShowAlert("Sản phẩm #" + productId + " đã từng có trong đơn hàng của khách. Hệ thống đã tự động chuyển sang trạng thái ẨN để bảo toàn dữ liệu lịch sử giao dịch!", "alert-warning");
                        }
                    }
                    else
                    {
                        // Chưa có đơn hàng -> Xóa an toàn
                        var price = db.ProductPrices.FirstOrDefault(pr => pr.ID_P == productId);
                        if (price != null)
                        {
                            db.ProductPrices.DeleteOnSubmit(price);
                        }

                        var item = db.PageItems.FirstOrDefault(p => p.ID_P == productId);
                        if (item != null)
                        {
                            db.PageItems.DeleteOnSubmit(item);
                        }

                        db.SubmitChanges();
                        ShowAlert("Đã xóa hoàn toàn sản phẩm #" + productId + " khỏi hệ thống!", "alert-success");
                    }
                }

                ResetForm();
                BindProductGrid();
            }
        }

        public string GetGenderName(int gender)
        {
            switch (gender)
            {
                case 1: return "Nam";
                case 2: return "Nữ";
                default: return "Unisex";
            }
        }

        public string GetGenderBadgeClass(int gender)
        {
            switch (gender)
            {
                case 1: return "badge badge-info";
                case 2: return "badge badge-purple";
                default: return "badge badge-secondary";
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
