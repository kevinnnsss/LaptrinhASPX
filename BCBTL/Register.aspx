<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="BCBTL.Register" %>

<!DOCTYPE html>
<html lang="vi">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng Ký Tài Khoản Thành Viên - KevLouis Watch</title>
    <link rel="stylesheet" href="~/Assets/css/style.css" />
    <style>
        .register-wrapper {
            min-height: 85vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 15px;
        }
        .register-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            box-shadow: var(--shadow-md);
            width: 100%;
            max-width: 460px;
            padding: 35px 30px;
        }
        .register-header {
            text-align: center;
            margin-bottom: 22px;
        }
        .register-header h2 {
            font-size: 22px;
            font-weight: 800;
            color: var(--primary-color);
            text-transform: uppercase;
            margin-bottom: 4px;
        }
        .register-header p {
            font-size: 13px;
            color: #777777;
        }
        .form-group {
            margin-bottom: 14px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 700;
            font-size: 13px;
            color: var(--dark-color);
        }
        .form-group label .req {
            color: #dc2626;
        }
        .form-control {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 13px;
            outline: none;
            transition: var(--transition);
        }
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(158, 11, 15, 0.1);
        }
        .btn-register {
            width: 100%;
            padding: 12px;
            background-color: var(--primary-color);
            color: #ffffff;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            text-transform: uppercase;
            transition: var(--transition);
            margin-top: 8px;
        }
        .btn-register:hover {
            background-color: var(--primary-hover);
        }
        .alert-box {
            padding: 10px 14px;
            border-radius: 4px;
            font-size: 13px;
            text-align: center;
            margin-top: 15px;
            display: block;
            font-weight: 600;
        }
        .alert-error {
            color: #dc2626;
            background-color: #fee2e2;
            border: 1px solid #fecaca;
        }
        .alert-success {
            color: #166534;
            background-color: #dcfce7;
            border: 1px solid #bbf7d0;
        }
        .val-summary-box {
            background: #fee2e2;
            border: 1px solid #f87171;
            color: #991b1b;
            padding: 10px 14px;
            border-radius: 4px;
            font-size: 12px;
            margin-bottom: 15px;
            font-weight: 600;
        }
        .val-summary-box ul {
            margin: 4px 0 0 16px;
            padding: 0;
        }
        .register-footer {
            margin-top: 20px;
            text-align: center;
            font-size: 13px;
            color: #555555;
            border-top: 1px solid var(--border-color);
            padding-top: 15px;
        }
        .register-footer a {
            color: var(--primary-color);
            font-weight: 700;
        }
    </style>
</head>
<body style="background:#f4f6f9;">
    <form id="formRegister" runat="server">
        <div class="register-wrapper">
            <div class="register-card">
                <div class="register-header">
                    <a href="Default.aspx" style="text-decoration:none;">
                        <h1 style="font-size:24px; font-weight:900; color:var(--primary-color); margin-bottom:5px;">
                            KEV<span style="color:#111;">LOUIS</span>
                        </h1>
                    </a>
                    <h2>ĐĂNG KÝ TÀI KHOẢN</h2>
                    <p>Trở thành thành viên để nhận ưu đãi bảo hành & quà tặng</p>
                </div>

                <asp:ValidationSummary ID="valSummaryReg" runat="server" CssClass="val-summary-box" 
                    HeaderText="⚠ Vui lòng hoàn thiện các trường sau:" />

                <div class="form-group">
                    <label>Tên đăng nhập <span class="req">(*)</span>:</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Viết liền không dấu (vd: hoangnam123)..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername" 
                        ErrorMessage="Tên đăng nhập không được để trống!" ForeColor="#dc2626" Font-Size="11px" Display="Dynamic" Font-Bold="true"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revUsername" runat="server" ControlToValidate="txtUsername" 
                        ValidationExpression="^[a-zA-Z0-9_]{3,30}$" ErrorMessage="Tên đăng nhập từ 3 - 30 ký tự, viết liền không dấu!" ForeColor="#dc2626" Font-Size="11px" Display="Dynamic" Font-Bold="true"></asp:RegularExpressionValidator>
                </div>

                <div class="form-group">
                    <label>Họ và tên đầy đủ <span class="req">(*)</span>:</label>
                    <asp:TextBox ID="txtFullname" runat="server" CssClass="form-control" placeholder="Ví dụ: Nguyễn Hoàng Nam..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvFullname" runat="server" ControlToValidate="txtFullname" 
                        ErrorMessage="Họ và tên là bắt buộc!" ForeColor="#dc2626" Font-Size="11px" Display="Dynamic" Font-Bold="true"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label>Địa chỉ Email <span class="req">(*)</span>:</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="example@gmail.com" TextMode="Email"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" 
                        ErrorMessage="Email là bắt buộc!" ForeColor="#dc2626" Font-Size="11px" Display="Dynamic" Font-Bold="true"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" 
                        ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" ErrorMessage="Email chưa đúng định dạng!" ForeColor="#dc2626" Font-Size="11px" Display="Dynamic" Font-Bold="true"></asp:RegularExpressionValidator>
                </div>

                <div class="form-group">
                    <label>Mật khẩu <span class="req">(*)</span>:</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Tối thiểu 6 ký tự..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" 
                        ErrorMessage="Mật khẩu là bắt buộc!" ForeColor="#dc2626" Font-Size="11px" Display="Dynamic" Font-Bold="true"></asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label>Xác nhận lại mật khẩu <span class="req">(*)</span>:</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Nhập lại mật khẩu phía trên..."></asp:TextBox>
                    <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="txtConfirmPassword" 
                        ControlToCompare="txtPassword" ErrorMessage="Xác nhận mật khẩu không trùng khớp!" ForeColor="#dc2626" Font-Size="11px" Display="Dynamic" Font-Bold="true"></asp:CompareValidator>
                </div>

                <asp:Button ID="btnRegister" runat="server" Text="ĐĂNG KÝ TÀI KHOẢN NGAY" CssClass="btn-register" OnClick="btnRegister_Click" />

                <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>

                <div class="register-footer">
                    <p>Bạn đã có tài khoản rồi? <a href="Login.aspx">Đăng nhập ngay ◀</a></p>
                    <p style="margin-top:8px; font-size:12px;"><a href="Default.aspx">Quay về Trang chủ KevLouis</a></p>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
