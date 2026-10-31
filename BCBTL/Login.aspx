<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="BCBTL.Login" %>

<!DOCTYPE html>
<html lang="vi">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng Nhập Tài Khoản - KevLouis</title>
    <link rel="stylesheet" href="~/Assets/css/style.css" />
    <style>
        .login-wrapper {
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 15px;
        }
        .login-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            box-shadow: var(--shadow-md);
            width: 100%;
            max-width: 420px;
            padding: 35px 30px;
        }
        .login-header {
            text-align: center;
            margin-bottom: 25px;
        }
        .login-header h2 {
            font-size: 22px;
            font-weight: 800;
            color: var(--primary-color);
            text-transform: uppercase;
            margin-bottom: 6px;
        }
        .login-header p {
            font-size: 13px;
            color: #777777;
        }
        .form-group {
            margin-bottom: 18px;
        }
        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 700;
            font-size: 13px;
            color: var(--dark-color);
        }
        .form-control {
            width: 100%;
            padding: 11px 14px;
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
        .btn-login {
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
        }
        .btn-login:hover {
            background-color: var(--primary-hover);
        }
        .error-msg {
            color: #dc2626;
            background-color: #fee2e2;
            padding: 10px;
            border-radius: 4px;
            font-size: 13px;
            text-align: center;
            margin-top: 15px;
            display: block;
        }
        .login-footer {
            margin-top: 20px;
            text-align: center;
            font-size: 12px;
            color: #777777;
        }
        .login-footer a {
            color: var(--primary-color);
            font-weight: 700;
        }
    </style>
</head>
<body style="background:#f4f6f9;">
    <form id="formLogin" runat="server">
        <div class="login-wrapper">
            <div class="login-card">
                <div class="login-header">
                    <a href="Default.aspx" style="text-decoration:none;">
                        <h1 style="font-size:24px; font-weight:900; color:var(--primary-color); margin-bottom:5px;">
                            KEV<span style="color:#111;">LOUIS</span>
                        </h1>
                    </a>
                    <h2>ĐĂNG NHẬP</h2>
                    <p>Hệ thống khách hàng & quản trị viên</p>
                </div>

                <div class="form-group">
                    <label>Tên đăng nhập / Tài khoản:</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Nhập tài khoản (vd: admin hoặc member)..."></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Mật khẩu:</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Nhập mật khẩu (mặc định 123456)..."></asp:TextBox>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="ĐĂNG NHẬP NGAY" CssClass="btn-login" OnClick="btnLogin_Click" />

                <div style="text-align:center; margin-top:14px; font-size:13px;">
                    Chưa có tài khoản? <a href="Register.aspx" style="color:var(--primary-color); font-weight:700;">Đăng ký thành viên ngay ▶</a>
                </div>

                <asp:Label ID="lblError" runat="server" CssClass="error-msg" Visible="false"></asp:Label>

                <div class="login-footer">
                    <p>Tài khoản mẫu: <b>admin</b> (Quản trị) / <b>member</b> (Khách hàng) | Pass: <b>123456</b></p>
                    <p style="margin-top:10px;"><a href="Default.aspx">◀ Quay về Trang chủ</a></p>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
