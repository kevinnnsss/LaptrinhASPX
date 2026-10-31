using System;
using System.Linq;
using System.Web.UI.WebControls;

namespace BCBTL.Admin
{
    public partial class ManageMenus : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadParentDropdown();
                BindMenuGrid();
            }
        }

        private void LoadParentDropdown()
        {
            ddlParent.Items.Clear();
            ddlParent.Items.Add(new ListItem("--- Danh mục gốc (Cấp 1 - Parent = 0) ---", "0"));

            using (var db = DbContextHelper.GetContext())
            {
                // Chỉ lấy các danh mục gốc (Parent = 0) để làm cha
                var rootMenus = db.Menus.Where(m => m.Parent == 0).OrderBy(m => m.OrderKey).ToList();
                foreach (var rm in rootMenus)
                {
                    ddlParent.Items.Add(new ListItem("📁 " + rm.Lable, rm.ID_MN.ToString()));
                }
            }
        }

        private void BindMenuGrid()
        {
            using (var db = DbContextHelper.GetContext())
            {
                var allMenus = db.Menus.ToList();

                var query = from m in allMenus
                            join p in allMenus on m.Parent equals p.ID_MN into parentGroup
                            from parent in parentGroup.DefaultIfEmpty()
                            orderby m.Pos, m.Parent, m.OrderKey
                            select new
                            {
                                m.ID_MN,
                                m.Parent,
                                m.Pos,
                                m.Lable,
                                m.UrlLink,
                                m.OrderKey,
                                m.Hide,
                                ParentName = parent != null ? parent.Lable : "Gốc"
                            };

                var list = query.ToList();
                gvMenus.DataSource = list;
                gvMenus.DataBind();

                lblTotalMenus.Text = list.Count.ToString();
            }
        }

        protected void btnSaveMenu_Click(object sender, EventArgs e)
        {
            string lable = txtLable.Text.Trim();
            if (string.IsNullOrEmpty(lable))
            {
                ShowAlert("Vui lòng nhập tên / tiêu đề danh mục!", "alert-danger");
                return;
            }

            int parentId = 0;
            int.TryParse(ddlParent.SelectedValue, out parentId);

            int pos = 1;
            int.TryParse(ddlPos.SelectedValue, out pos);

            int orderKey = 1;
            int.TryParse(txtOrderKey.Text.Trim(), out orderKey);

            string urlLink = txtUrlLink.Text.Trim();
            bool hide = chkHide.Checked;

            int menuId = 0;
            int.TryParse(hfMenuId.Value, out menuId);

            using (var db = DbContextHelper.GetContext())
            {
                if (menuId == 0)
                {
                    // Thêm mới Menu
                    Menu newMenu = new Menu
                    {
                        Lable = lable,
                        Parent = parentId,
                        Pos = pos,
                        UrlLink = string.IsNullOrEmpty(urlLink) ? "#" : urlLink,
                        OrderKey = orderKey,
                        Hide = hide
                    };

                    db.Menus.InsertOnSubmit(newMenu);
                    db.SubmitChanges();

                    ShowAlert("Thêm mới danh mục thành công!", "alert-success");
                }
                else
                {
                    // Cập nhật Menu
                    var existing = db.Menus.FirstOrDefault(m => m.ID_MN == menuId);
                    if (existing != null)
                    {
                        // Kiểm tra không cho phép chọn chính mình làm menu cha
                        if (parentId == menuId)
                        {
                            ShowAlert("Một danh mục không thể chọn chính nó làm danh mục cha!", "alert-danger");
                            return;
                        }

                        existing.Lable = lable;
                        existing.Parent = parentId;
                        existing.Pos = pos;
                        existing.UrlLink = string.IsNullOrEmpty(urlLink) ? "#" : urlLink;
                        existing.OrderKey = orderKey;
                        existing.Hide = hide;

                        db.SubmitChanges();
                        ShowAlert("Cập nhật danh mục #" + menuId + " thành công!", "alert-success");
                    }
                }
            }

            ResetForm();
            LoadParentDropdown();
            BindMenuGrid();
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        private void ResetForm()
        {
            hfMenuId.Value = "0";
            txtLable.Text = string.Empty;
            ddlParent.SelectedIndex = 0;
            ddlPos.SelectedIndex = 0;
            txtUrlLink.Text = string.Empty;
            txtOrderKey.Text = "1";
            chkHide.Checked = false;
            litFormTitle.Text = "➕ Thêm Danh Mục Mới";
            btnSaveMenu.Text = "Lưu Danh Mục";
        }

        protected void gvMenus_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int menuId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditMenu")
            {
                using (var db = DbContextHelper.GetContext())
                {
                    var m = db.Menus.FirstOrDefault(item => item.ID_MN == menuId);
                    if (m != null)
                    {
                        hfMenuId.Value = m.ID_MN.ToString();
                        txtLable.Text = m.Lable;
                        if (ddlParent.Items.FindByValue(m.Parent.ToString()) != null)
                        {
                            ddlParent.SelectedValue = m.Parent.ToString();
                        }
                        if (ddlPos.Items.FindByValue(m.Pos.ToString()) != null)
                        {
                            ddlPos.SelectedValue = m.Pos.ToString();
                        }
                        txtUrlLink.Text = m.UrlLink;
                        txtOrderKey.Text = m.OrderKey.ToString();
                        chkHide.Checked = m.Hide;

                        litFormTitle.Text = "✏️ Cập Nhật Danh Mục #" + m.ID_MN;
                        btnSaveMenu.Text = "Cập Nhật Danh Mục";
                    }
                }
            }
            else if (e.CommandName == "DeleteMenu")
            {
                using (var db = DbContextHelper.GetContext())
                {
                    // 1. Kiểm tra menu con
                    bool hasChildren = db.Menus.Any(m => m.Parent == menuId);
                    if (hasChildren)
                    {
                        ShowAlert("Không thể xóa danh mục này vì đang có danh mục con trực thuộc! Hãy xóa hoặc di chuyển các danh mục con trước.", "alert-danger");
                        return;
                    }

                    // 2. Kiểm tra liên kết với PageItems (Ràng buộc ON DELETE NO ACTION)
                    bool hasPageItems = db.PageItems.Any(p => p.ID_MN == menuId);
                    if (hasPageItems)
                    {
                        var menuToHide = db.Menus.FirstOrDefault(m => m.ID_MN == menuId);
                        if (menuToHide != null)
                        {
                            menuToHide.Hide = true;
                            db.SubmitChanges();
                            ShowAlert("Danh mục đang có sản phẩm/bài viết tham chiếu (Ràng buộc ON DELETE NO ACTION). Hệ thống đã tự động chuyển sang trạng thái ẨN để bảo toàn dữ liệu!", "alert-warning");
                        }
                    }
                    else
                    {
                        var menuToDelete = db.Menus.FirstOrDefault(m => m.ID_MN == menuId);
                        if (menuToDelete != null)
                        {
                            db.Menus.DeleteOnSubmit(menuToDelete);
                            db.SubmitChanges();
                            ShowAlert("Đã xóa hoàn toàn danh mục thành công!", "alert-success");
                        }
                    }
                }

                ResetForm();
                LoadParentDropdown();
                BindMenuGrid();
            }
        }

        public string GetPosName(int pos)
        {
            switch (pos)
            {
                case 1: return "Header (1)";
                case 2: return "Sidebar (2)";
                case 3: return "Footer (3)";
                default: return "Khác (" + pos + ")";
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
