<%@ Page Title="Đăng Ký Tài Khoản" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="BCBTL.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .register-container { max-width: 520px; margin: 40px auto; }
        .register-card { background: #fff; border-radius: 8px; border: 1px solid #e2e8f0; padding: 32px; box-shadow: 0 4px 16px rgba(0,0,0,0.04); }
        .register-header { text-align: center; margin-bottom: 24px; }
        .register-header h1 { font-size: 24px; color: var(--primary-color); font-weight: 700; margin-bottom: 8px; }
        .register-header p { color: #718096; font-size: 14px; }

        .form-row { margin-bottom: 16px; }
        .form-row label { display: block; font-weight: 600; font-size: 13.5px; margin-bottom: 6px; color: #2d3748; }
        .form-input { width: 100%; padding: 10px 14px; border: 1px solid #cbd5e0; border-radius: 6px; font-size: 14.5px; outline: none; transition: border-color 0.2s; box-sizing: border-box; }
        .form-input:focus { border-color: var(--primary-color); box-shadow: 0 0 0 3px rgba(158,11,15,0.1); }
        .val-error { color: #e53e3e; font-size: 12.5px; margin-top: 4px; display: block; }
        .btn-register-submit { width: 100%; background: var(--primary-color); color: #fff; padding: 12px; border: none; border-radius: 6px; font-weight: 700; font-size: 15px; cursor: pointer; transition: background 0.2s; margin-top: 10px; }
        .btn-register-submit:hover { background: var(--primary-dark); }
        .register-footer { text-align: center; margin-top: 20px; font-size: 14px; color: #718096; }
        .register-footer a { color: var(--primary-color); font-weight: 600; text-decoration: none; }
        .register-footer a:hover { text-decoration: underline; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container register-container">
        <div class="register-card">
            <div class="register-header">
                <h1>TẠO TÀI KHOẢN MỚI</h1>
                <p>Trở thành thành viên để nhận ưu đãi độc quyền từ Duy Anh Watch</p>
            </div>

            <asp:Label ID="lblMsg" runat="server" Visible="false" style="display:block; padding:10px 14px; border-radius:6px; margin-bottom:16px; font-size:13.5px; font-weight:600; background:#fff5f5; color:#c53030; border:1px solid #feb2b2;"></asp:Label>

            <asp:ValidationSummary ID="valSummary" runat="server" HeaderText="Vui lòng kiểm tra lại các mục sau:"
                CssClass="val-error" style="background:#fff5f5; padding:12px; border-radius:6px; border:1px solid #feb2b2; margin-bottom:16px;" />

            <div class="form-row">
                <label>Tên đăng nhập (*):</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-input" placeholder="Viết liền không dấu (VD: nguyenvanan)..."></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername"
                    ErrorMessage="Tên đăng nhập không được để trống!" CssClass="val-error" Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revUsername" runat="server" ControlToValidate="txtUsername"
                    ValidationExpression="^[a-zA-Z0-9_]{3,20}$" ErrorMessage="Tên đăng nhập từ 3-20 ký tự chữ và số!"
                    CssClass="val-error" Display="Dynamic" />
            </div>

            <div class="form-row">
                <label>Họ và tên (*):</label>
                <asp:TextBox ID="txtFullname" runat="server" CssClass="form-input" placeholder="VD: Nguyễn Văn An..."></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvFullname" runat="server" ControlToValidate="txtFullname"
                    ErrorMessage="Họ và tên không được để trống!" CssClass="val-error" Display="Dynamic" />
            </div>

            <div class="form-row">
                <label>Số điện thoại (*):</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-input" placeholder="VD: 0912345678..."></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone"
                    ErrorMessage="Số điện thoại không được để trống!" CssClass="val-error" Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtPhone"
                    ValidationExpression="^(0|\+84)[0-9]{9,10}$" ErrorMessage="Số điện thoại Việt Nam không hợp lệ (10 số)!"
                    CssClass="val-error" Display="Dynamic" />
            </div>

            <div class="form-row">
                <label>Địa chỉ Email:</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" TextMode="Email" placeholder="VD: an.nguyen@gmail.com..."></asp:TextBox>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                    ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" ErrorMessage="Địa chỉ Email không đúng định dạng!"
                    CssClass="val-error" Display="Dynamic" />
            </div>

            <div class="form-row">
                <label>Mật khẩu (*):</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Tối thiểu 6 ký tự..."></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                    ErrorMessage="Mật khẩu không được để trống!" CssClass="val-error" Display="Dynamic" />
            </div>

            <div class="form-row">
                <label>Xác nhận lại mật khẩu (*):</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Nhập lại mật khẩu..."></asp:TextBox>
                <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="txtConfirmPassword"
                    ControlToCompare="txtPassword" ErrorMessage="Mật khẩu xác nhận không khớp!" CssClass="val-error" Display="Dynamic" />
            </div>

            <asp:Button ID="btnRegisterSubmit" runat="server" Text="HOÀN TẤT ĐĂNG KÝ" CssClass="btn-register-submit" OnClick="btnRegisterSubmit_Click" />

            <div class="register-footer">
                Bạn đã có tài khoản rồi? <a href="Login.aspx">Đăng nhập tại đây ▶</a>
            </div>
        </div>
    </div>
</asp:Content>
