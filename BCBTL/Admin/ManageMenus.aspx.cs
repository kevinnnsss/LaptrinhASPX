using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BCBTL.Admin
{
    public partial class ManageMenus : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadParentMenuDropdown();
                BindMenuGrid();
            }
        }

        private void LoadParentMenuDropdown()
        {
            using (var db = DbContextHelper.GetContext())
            {
                var roots = db.Menus.Where(m => m.Parent == 0).OrderBy(m => m.OrderKey).ToList();

                ddlParentMenu.Items.Clear();
                ddlParentMenu.Items.Add(new ListItem("--- Là Menu Gốc (Cấp 1) ---", "0"));

                foreach (var r in roots)
                {
                    ddlParentMenu.Items.Add(new ListItem("Thư mục cha: " + r.Lable, r.ID_MN.ToString()));
                }
            }
        }

        private void BindMenuGrid()
        {
            using (var db = DbContextHelper.GetContext())
            {
                var allMenus = db.Menus.ToList();

                var list = allMenus.OrderBy(m => m.Parent == 0 ? m.ID_MN * 100 : (m.Parent * 100 + m.OrderKey))
                    .Select(m => new
                    {
                        m.ID_MN,
                        m.Lable,
                        UrlLink = m.UrlLink,
                        m.OrderKey,
                        m.Hide,
                        m.Parent,
                        ParentName = m.Parent == 0 ? "Menu Gốc (Root)" : allMenus.FirstOrDefault(p => p.ID_MN == m.Parent)?.Lable ?? "Gốc"
                    }).ToList();

                gvMenus.DataSource = list;
                gvMenus.DataBind();
            }
        }

        protected void btnSaveMenu_Click(object sender, EventArgs e)
        {
            string lable = txtLable.Text.Trim();
            if (string.IsNullOrEmpty(lable))
            {
                ShowMsg("Vui lòng nhập tên nhãn danh mục!", true);
                return;
            }

            int parent = int.Parse(ddlParentMenu.SelectedValue);
            int order = 1;
            int.TryParse(txtOrderKey.Text.Trim(), out order);
            string link = txtLink.Text.Trim();
            if (string.IsNullOrEmpty(link)) link = "#";
            bool hide = chkHide.Checked;

            using (var db = DbContextHelper.GetContext())
            {
                if (string.IsNullOrEmpty(hfEditMenuId.Value))
                {
                    // ADD NEW
                    Menu mn = new Menu
                    {
                        Lable = lable,
                        Parent = parent,
                        Pos = 1,
                        UrlLink = link,
                        OrderKey = order,
                        Hide = hide
                    };
                    db.Menus.InsertOnSubmit(mn);
                    db.SubmitChanges();
                    ShowMsg("Thêm danh mục mới thành công!", false);
                }
                else
                {
                    // UPDATE
                    int mid = int.Parse(hfEditMenuId.Value);
                    var mn = db.Menus.FirstOrDefault(m => m.ID_MN == mid);
                    if (mn != null)
                    {
                        mn.Lable = lable;
                        mn.Parent = parent;
                        mn.UrlLink = link;
                        mn.OrderKey = order;
                        mn.Hide = hide;
                        db.SubmitChanges();
                        ShowMsg("Cập nhật danh mục thành công!", false);
                    }
                }
            }

            ResetForm();
            LoadParentMenuDropdown();
            BindMenuGrid();
        }

        protected void gvMenus_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int mid = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditMenu")
            {
                using (var db = DbContextHelper.GetContext())
                {
                    var mn = db.Menus.FirstOrDefault(m => m.ID_MN == mid);
                    if (mn != null)
                    {
                        hfEditMenuId.Value = mid.ToString();
                        txtLable.Text = mn.Lable;
                        txtLink.Text = mn.UrlLink;
                        txtOrderKey.Text = mn.OrderKey.ToString();
                        chkHide.Checked = mn.Hide;

                        if (ddlParentMenu.Items.FindByValue(mn.Parent.ToString()) != null)
                        {
                            ddlParentMenu.SelectedValue = mn.Parent.ToString();
                        }

                        litFormTitle.Text = "Chỉnh Sửa Danh Mục: " + Server.HtmlEncode(mn.Lable);
                        btnSaveMenu.Text = "CẬP NHẬT DANH MỤC";
                        btnCancelEdit.Visible = true;
                    }
                }
            }
            else if (e.CommandName == "DeleteMenu")
            {
                using (var db = DbContextHelper.GetContext())
                {
                    // Check if menu has products
                    bool hasProducts = db.PageItems.Any(p => p.ID_MN == mid && p.Hide == false);
                    if (hasProducts)
                    {
                        ShowMsg("Không thể xóa danh mục này vì đang có sản phẩm đồng hồ thuộc về nó! Vui lòng chuyển hoặc ẩn danh mục.", true);
                        return;
                    }

                    var mn = db.Menus.FirstOrDefault(m => m.ID_MN == mid);
                    if (mn != null)
                    {
                        db.Menus.DeleteOnSubmit(mn);
                        db.SubmitChanges();
                        ShowMsg("Đã xóa danh mục thành công!", false);
                    }
                }

                LoadParentMenuDropdown();
                BindMenuGrid();
            }
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        private void ResetForm()
        {
            hfEditMenuId.Value = "";
            txtLable.Text = "";
            txtLink.Text = "";
            txtOrderKey.Text = "1";
            chkHide.Checked = false;
            ddlParentMenu.SelectedIndex = 0;
            litFormTitle.Text = "Thêm Danh Mục / Thương Hiệu Mới";
            btnSaveMenu.Text = "LƯU DANH MỤC";
            btnCancelEdit.Visible = false;
        }

        private void ShowMsg(string msg, bool isError)
        {
            lblMsg.Visible = true;
            lblMsg.Text = (isError ? "✖ " : "✔ ") + msg;
            lblMsg.CssClass = "alert-msg " + (isError ? "alert-error" : "alert-success");
        }

        protected void gvMenus_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMenus.PageIndex = e.NewPageIndex;
            BindMenuGrid();
        }
    }
}
