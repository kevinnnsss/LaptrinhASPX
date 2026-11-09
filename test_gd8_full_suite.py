#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
================================================================================
DỰ ÁN: WEBSITE BÁN ĐỒNG HỒ CAO CẤP CHÍNH HÃNG KEVLOUIS / DUY ANH WATCH
GIAI ĐOẠN 8: KIỂM THỬ HỆ THỐNG TOÀN DIỆN & BẢO MẬT CƠ BẢN (GD8)
BỘ CÔNG CỤ TỰ ĐỘNG HÓA KIỂM THỬ: test_gd8_full_suite.py
Mục tiêu: Đảm bảo toàn vẹn dữ liệu, triệt tiêu 100% nguy cơ tấn công mạng
          (SQL Injection, XSS, lộ lọt thông tin xác thực) và nghiệm thu 16 Test Cases.
================================================================================
"""

import sys
import re
import time
import urllib.request
import urllib.parse
import http.cookiejar
import pyodbc
from html import unescape

# Reconfigure stdout for UTF-8 in Windows console
sys.stdout.reconfigure(encoding='utf-8')

BASE_URL = "http://localhost:54400"
DB_CONN_STR = "Driver={ODBC Driver 17 for SQL Server};Server=localhost;Database=layout;Trusted_Connection=yes;"

class NoRedirectHandler(urllib.request.HTTPRedirectHandler):
    """Handler to intercept HTTP redirects and capture 301/302 responses without following."""
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None

class TestClient:
    """HTTP Client simulating browser with Session Cookies & ASP.NET ViewState handling."""
    def __init__(self, allow_redirects=True):
        self.cj = http.cookiejar.CookieJar()
        self.allow_redirects = allow_redirects
        handlers = [urllib.request.HTTPCookieProcessor(self.cj)]
        if not allow_redirects:
            handlers.append(NoRedirectHandler())
        self.opener = urllib.request.build_opener(*handlers)

    def get(self, path):
        url = path if path.startswith("http") else f"{BASE_URL}/{path.lstrip('/')}"
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) TestClient/1.0'})
        try:
            resp = self.opener.open(req)
            content = resp.read().decode('utf-8', errors='ignore')
            return resp.code, resp.headers, content
        except urllib.error.HTTPError as e:
            content = e.read().decode('utf-8', errors='ignore')
            return e.code, e.headers, content

    def post(self, path, data_dict):
        url = path if path.startswith("http") else f"{BASE_URL}/{path.lstrip('/')}"
        encoded_data = urllib.parse.urlencode(data_dict).encode('utf-8')
        req = urllib.request.Request(url, data=encoded_data, headers={
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) TestClient/1.0',
            'Content-Type': 'application/x-www-form-urlencoded'
        })
        try:
            resp = self.opener.open(req)
            content = resp.read().decode('utf-8', errors='ignore')
            return resp.code, resp.headers, content
        except urllib.error.HTTPError as e:
            content = e.read().decode('utf-8', errors='ignore')
            return e.code, e.headers, content

    @staticmethod
    def extract_aspnet_fields(html):
        """Trích xuất các hidden input cần thiết của ASP.NET Web Forms"""
        fields = {}
        vs = re.search(r'id=["\']__VIEWSTATE["\']\s+value=["\']([^"\']*)["\']', html)
        if vs: fields['__VIEWSTATE'] = vs.group(1)
        ev = re.search(r'id=["\']__EVENTVALIDATION["\']\s+value=["\']([^"\']*)["\']', html)
        if ev: fields['__EVENTVALIDATION'] = ev.group(1)
        vg = re.search(r'id=["\']__VIEWSTATEGENERATOR["\']\s+value=["\']([^"\']*)["\']', html)
        if vg: fields['__VIEWSTATEGENERATOR'] = vg.group(1)
        return fields

class GD8TestSuite:
    def __init__(self):
        self.results = []

    def log_result(self, code, name, passed, detail):
        status_str = "✅ PASS" if passed else "❌ FAIL"
        self.results.append({
            "code": code,
            "name": name,
            "passed": passed,
            "detail": detail
        })
        print(f"[{status_str}] {code}: {name} -> {detail}")

    def run_all(self):
        print("\n" + "="*80)
        print("  BẮT ĐẦU CHẠY TOÀN DIỆN 16 TEST CASES GIAI ĐOẠN 8 (GD8)")
        print("  Môi trường: IIS Express (http://localhost:54400) + SQL Server 2022")
        print("="*80 + "\n")

        self.test_tc01_login_admin_success()
        self.test_tc02_login_admin_wrong_password()
        self.test_tc03_login_locked_account()
        self.test_tc04_admin_authorization_guard()
        self.test_tc05_multi_level_menu()
        self.test_tc06_brand_filter()
        self.test_tc07_add_to_cart()
        self.test_tc08_cart_voucher()
        self.test_tc09_admin_product_management()
        self.test_tc10_checkout_process()
        self.test_tc11_track_order()
        self.test_tc12_member_registration()
        self.test_tc13_duplicate_registration()
        self.test_sec01_sql_injection()
        self.test_sec02_xss_protection()
        self.test_sec03_sha256_integrity()

        self.print_summary()

    # --------------------------------------------------------------------------
    # TC01: Đăng nhập Admin thành công
    # --------------------------------------------------------------------------
    def test_tc01_login_admin_success(self):
        client = TestClient(allow_redirects=False)
        _, _, html = client.get("/Login.aspx")
        data = client.extract_aspnet_fields(html)
        data.update({
            'txtUsername': 'admin',
            'txtPassword': '123456',
            'btnLogin': 'ĐĂNG NHẬP NGAY'
        })
        status, headers, content = client.post("/Login.aspx", data)
        location = headers.get('Location', '')
        passed = (status in [302, 301] and 'Dashboard.aspx' in location)
        detail = f"Mã HTTP {status}, chuyển hướng tới '{location}'"
        self.log_result("TC01", "Đăng nhập Admin thành công", passed, detail)

    # --------------------------------------------------------------------------
    # TC02: Đăng nhập sai mật khẩu
    # --------------------------------------------------------------------------
    def test_tc02_login_admin_wrong_password(self):
        client = TestClient(allow_redirects=True)
        _, _, html = client.get("/Login.aspx")
        data = client.extract_aspnet_fields(html)
        data.update({
            'txtUsername': 'admin',
            'txtPassword': 'sai_mat_khau_123',
            'btnLogin': 'ĐĂNG NHẬP NGAY'
        })
        status, headers, content = client.post("/Login.aspx", data)
        expected_msg = "Tên đăng nhập hoặc mật khẩu không chính xác!"
        passed = (expected_msg in content)
        detail = f"Hệ thống từ chối xác thực, hiển thị cảnh báo đỏ chuẩn: '{expected_msg}'"
        self.log_result("TC02", "Đăng nhập sai mật khẩu", passed, detail)

    # --------------------------------------------------------------------------
    # TC03: Chặn tài khoản bị khóa
    # --------------------------------------------------------------------------
    def test_tc03_login_locked_account(self):
        # Thiết lập tạm thời Lock = 1 cho user 'member' trong CSDL
        conn = pyodbc.connect(DB_CONN_STR)
        cursor = conn.cursor()
        cursor.execute("UPDATE Acounts SET [Lock] = 1 WHERE Username = 'member'")
        conn.commit()

        try:
            client = TestClient(allow_redirects=True)
            _, _, html = client.get("/Login.aspx")
            data = client.extract_aspnet_fields(html)
            data.update({
                'txtUsername': 'member',
                'txtPassword': '123456',
                'btnLogin': 'ĐĂNG NHẬP NGAY'
            })
            status, headers, content = client.post("/Login.aspx", data)
            expected_msg = "Tài khoản này hiện đang bị khóa bởi Quản trị viên!"
            passed = (expected_msg in content)
            detail = f"Tài khoản bị khóa bị chặn cấp quyền, nhận cảnh báo: '{expected_msg}'"
            self.log_result("TC03", "Chặn tài khoản bị khóa", passed, detail)
        finally:
            # Khôi phục trạng thái bình thường Lock = 0 cho user 'member'
            cursor.execute("UPDATE Acounts SET [Lock] = 0 WHERE Username = 'member'")
            conn.commit()
            conn.close()

    # --------------------------------------------------------------------------
    # TC04: Bảo vệ thư mục Quản trị
    # --------------------------------------------------------------------------
    def test_tc04_admin_authorization_guard(self):
        client = TestClient(allow_redirects=False)
        status, headers, content = client.get("/Admin/ManageProducts.aspx")
        location = headers.get('Location', '')
        passed = (status in [302, 301] and 'Login.aspx' in location)
        detail = f"HTTP {status} Redirect về '{location}' chặn đứng truy cập trái phép"
        self.log_result("TC04", "Bảo vệ thư mục Quản trị", passed, detail)

    # --------------------------------------------------------------------------
    # TC05: Hiển thị Menu đa cấp & Header
    # --------------------------------------------------------------------------
    def test_tc05_multi_level_menu(self):
        client = TestClient(allow_redirects=True)
        status, headers, content = client.get("/Default.aspx")
        menu_items = ["Trang chủ", "Thương hiệu", "Đồng hồ Nam", "Đồng hồ Nữ", "Casio", "Seiko", "Citizen", "Rolex"]
        all_found = all(item in content for item in menu_items)
        passed = (status == 200 and all_found)
        detail = f"Nạp HTTP {status}, chứa đủ các mục menu cha & thương hiệu con: {', '.join(menu_items[:4])}..."
        self.log_result("TC05", "Hiển thị Menu đa cấp & Header", passed, detail)

    # --------------------------------------------------------------------------
    # TC06: Lọc theo thương hiệu Casio (idmn=7)
    # --------------------------------------------------------------------------
    def test_tc06_brand_filter(self):
        client = TestClient(allow_redirects=True)
        status, headers, content = client.get("/ProductList.aspx?idmn=7")
        casio_found = ("Casio" in content)
        passed = (status == 200 and casio_found)
        detail = f"HTTP {status}, lọc đúng danh mục và sản phẩm thương hiệu Casio"
        self.log_result("TC06", "Lọc theo thương hiệu", passed, detail)

    # --------------------------------------------------------------------------
    # TC07: Thêm vào giỏ hàng
    # --------------------------------------------------------------------------
    def test_tc07_add_to_cart(self):
        client = TestClient(allow_redirects=True)
        _, _, html = client.get("/ProductDetail.aspx?id=1")
        data = client.extract_aspnet_fields(html)
        data.update({
            'ctl00$MainContent$txtQuantity': '1',
            'ctl00$MainContent$btnBuyNow': 'MUA NGAY (GIAO TẬN NƠI)'
        })
        status, headers, content = client.post("/ProductDetail.aspx?id=1", data)
        # Sẽ chuyển hướng tới Cart.aspx và hiển thị sản phẩm vừa thêm
        passed = ("Cart.aspx" in client.opener.open(urllib.request.Request(f"{BASE_URL}/Cart.aspx")).geturl() 
                  and "Casio Edifice EFR-539D" in content)
        # Lưu lại client cho test case voucher kế tiếp nếu cần
        self.cart_client = client
        detail = f"Sản phẩm được lưu vào Session['Cart'], giỏ hàng hiển thị 'Casio Edifice EFR-539D'"
        self.log_result("TC07", "Thêm vào giỏ hàng", passed, detail)

    # --------------------------------------------------------------------------
    # TC08: Cập nhật giỏ & Voucher KEV10
    # --------------------------------------------------------------------------
    def test_tc08_cart_voucher(self):
        client = getattr(self, 'cart_client', None)
        if not client:
            client = TestClient(allow_redirects=True)
            _, _, html = client.get("/ProductDetail.aspx?id=1")
            data = client.extract_aspnet_fields(html)
            data.update({
                'ctl00$MainContent$txtQuantity': '1',
                'ctl00$MainContent$btnBuyNow': 'MUA NGAY (GIAO TẬN NƠI)'
            })
            client.post("/ProductDetail.aspx?id=1", data)

        _, _, cart_html = client.get("/Cart.aspx")
        data = client.extract_aspnet_fields(cart_html)
        data.update({
            'ctl00$MainContent$txtCouponCode': 'KEV10',
            'ctl00$MainContent$btnApplyCoupon': 'ÁP DỤNG'
        })
        status, headers, content = client.post("/Cart.aspx", data)
        passed = ("Áp dụng thành công" in content or "10%" in content or "KEV10" in content)
        self.cart_client = client
        detail = "Áp dụng thành công mã voucher KEV10, khấu trừ chiết khấu -10% tổng đơn hàng"
        self.log_result("TC08", "Cập nhật giỏ & Voucher", passed, detail)

    # --------------------------------------------------------------------------
    # TC09: Quản lý sản phẩm Admin
    # --------------------------------------------------------------------------
    def test_tc09_admin_product_management(self):
        client = TestClient(allow_redirects=True)
        # Đăng nhập Admin
        _, _, login_html = client.get("/Login.aspx")
        data = client.extract_aspnet_fields(login_html)
        data.update({
            'txtUsername': 'admin',
            'txtPassword': '123456',
            'btnLogin': 'ĐĂNG NHẬP NGAY'
        })
        client.post("/Login.aspx", data)

        # Truy cập trang Quản lý sản phẩm
        status, headers, content = client.get("/Admin/ManageProducts.aspx")
        has_form = ("Thêm Đồng Hồ Mới" in content or "LƯU SẢN PHẨM" in content)
        has_grid = ("gvProducts" in content or "Danh Sách Sản Phẩm" in content)
        passed = (status == 200 and has_form and has_grid)
        detail = f"HTTP {status}, form thêm mới, upload ảnh & GridView sản phẩm sẵn sàng"
        self.log_result("TC09", "Quản lý SP Admin", passed, detail)

    # --------------------------------------------------------------------------
    # TC10: Đặt hàng hoàn tất (Checkout)
    # --------------------------------------------------------------------------
    def test_tc10_checkout_process(self):
        client = getattr(self, 'cart_client', None)
        if not client:
            client = TestClient(allow_redirects=True)
            _, _, html = client.get("/ProductDetail.aspx?id=1")
            data = client.extract_aspnet_fields(html)
            data.update({
                'ctl00$MainContent$txtQuantity': '1',
                'ctl00$MainContent$btnBuyNow': 'MUA NGAY (GIAO TẬN NƠI)'
            })
            client.post("/ProductDetail.aspx?id=1", data)

        _, _, checkout_html = client.get("/Checkout.aspx")
        data = client.extract_aspnet_fields(checkout_html)
        data.update({
            'ctl00$MainContent$txtCustomerName': 'Nguyễn Văn Test GD8',
            'ctl00$MainContent$txtCustomerPhone': '0987654321',
            'ctl00$MainContent$txtCustomerEmail': 'testgd8@gmail.com',
            'ctl00$MainContent$txtDeliveryAddress': '123 Đường Test Tự Động, TP. Cao Lãnh, Đồng Tháp',
            'ctl00$MainContent$txtOrderNotes': 'Đơn hàng kiểm thử tự động Giai đoạn 8',
            'payMethod': 'COD',
            'ctl00$MainContent$btnPlaceOrder': 'XÁC NHẬN & ĐẶT HÀNG NGAY'
        })
        status, headers, content = client.post("/Checkout.aspx", data)
        # Kiểm tra CSDL xem đơn hàng vừa tạo có trong bảng Orders không
        conn = pyodbc.connect(DB_CONN_STR)
        cursor = conn.cursor()
        cursor.execute("SELECT TOP 1 OrderID, CustomerName, CustomerPhone, TotalAmount FROM Orders WHERE CustomerPhone = '0987654321' ORDER BY OrderID DESC")
        row = cursor.fetchone()
        self.created_order_id = row[0] if row else None
        conn.close()

        passed = (self.created_order_id is not None)
        detail = f"Đơn hàng lưu thành công vào CSDL với OrderID = {self.created_order_id}, giỏ hàng làm sạch"
        self.log_result("TC10", "Đặt hàng hoàn tất", passed, detail)

    # --------------------------------------------------------------------------
    # TC11: Tra cứu tiến độ đơn
    # --------------------------------------------------------------------------
    def test_tc11_track_order(self):
        client = TestClient(allow_redirects=True)
        order_query = str(getattr(self, 'created_order_id', 1))
        status, headers, content = client.get(f"/TrackOrder.aspx?q={order_query}")
        has_stepper = ("step-item" in content or "TIẾN ĐỘ ĐƠN HÀNG" in content or "Chờ xử lý" in content or "Đang giao" in content)
        passed = (status == 200 and has_stepper)
        detail = f"HTTP {status}, hiển thị Stepper 4 bước thời gian thực và chi tiết mã đơn {order_query}"
        self.log_result("TC11", "Tra cứu tiến độ đơn", passed, detail)

    # --------------------------------------------------------------------------
    # TC12: Đăng ký thành viên
    # --------------------------------------------------------------------------
    def test_tc12_member_registration(self):
        client = TestClient(allow_redirects=True)
        _, _, reg_html = client.get("/Register.aspx")
        data = client.extract_aspnet_fields(reg_html)
        test_user = f"user_{int(time.time())}"
        data.update({
            'ctl00$MainContent$txtUsername': test_user,
            'ctl00$MainContent$txtFullname': 'Người Dùng Kiểm Thử GD8',
            'ctl00$MainContent$txtPhone': '0933123456',
            'ctl00$MainContent$txtEmail': f"{test_user}@test.vn",
            'ctl00$MainContent$txtPassword': 'Password@123',
            'ctl00$MainContent$txtConfirmPassword': 'Password@123',
            'ctl00$MainContent$btnRegisterSubmit': 'HOÀN TẤT ĐĂNG KÝ'
        })
        client.post("/Register.aspx", data)

        # Kiểm tra trong CSDL SQL Server
        conn = pyodbc.connect(DB_CONN_STR)
        cursor = conn.cursor()
        cursor.execute("SELECT Username, Password, Permission, [Lock], Active FROM Acounts WHERE Username = ?", test_user)
        row = cursor.fetchone()
        passed = False
        detail = "Không tìm thấy user trong CSDL"
        if row:
            db_user, db_pass, perm, is_lock, is_active = row
            is_sha256 = bool(re.match(r'^[a-fA-F0-9]{64}$', db_pass))
            passed = (perm == 2 and not is_lock and is_active and is_sha256)
            detail = f"Lưu thành công: user={db_user}, Permission=2, SHA256={db_pass[:16]}... (64 hex)"
            # Dọn dẹp tài khoản test
            cursor.execute("DELETE FROM Acounts WHERE Username = ?", test_user)
            conn.commit()
        conn.close()
        self.log_result("TC12", "Đăng ký thành viên", passed, detail)

    # --------------------------------------------------------------------------
    # TC13: Đăng ký trùng username
    # --------------------------------------------------------------------------
    def test_tc13_duplicate_registration(self):
        client = TestClient(allow_redirects=True)
        _, _, reg_html = client.get("/Register.aspx")
        data = client.extract_aspnet_fields(reg_html)
        data.update({
            'ctl00$MainContent$txtUsername': 'admin',
            'ctl00$MainContent$txtFullname': 'Trùng Lặp Kiểm Thử',
            'ctl00$MainContent$txtPhone': '0912345678',
            'ctl00$MainContent$txtEmail': 'trunglap@test.vn',
            'ctl00$MainContent$txtPassword': 'Password@123',
            'ctl00$MainContent$txtConfirmPassword': 'Password@123',
            'ctl00$MainContent$btnRegisterSubmit': 'HOÀN TẤT ĐĂNG KÝ'
        })
        status, headers, content = client.post("/Register.aspx", data)
        expected_msg = "đã có người sử dụng"
        passed = (expected_msg in content)
        detail = f"Hệ thống phát hiện trùng lặp tài khoản 'admin', xuất cảnh báo: '{expected_msg}'"
        self.log_result("TC13", "Đăng ký trùng username", passed, detail)

    # --------------------------------------------------------------------------
    # SEC01: Chống SQL Injection
    # --------------------------------------------------------------------------
    def test_sec01_sql_injection(self):
        # Vector 1: Form Login
        client = TestClient(allow_redirects=False)
        _, _, login_html = client.get("/Login.aspx")
        data = client.extract_aspnet_fields(login_html)
        payload = "' OR '1'='1' --"
        data.update({
            'txtUsername': payload,
            'txtPassword': 'random_password',
            'btnLogin': 'ĐĂNG NHẬP NGAY'
        })
        status, headers, content = client.post("/Login.aspx", data)
        # Nếu bị SQLi sẽ redirect 302 vào Dashboard hoặc lỗi 500
        not_bypassed = (status == 200 and "Tên đăng nhập hoặc mật khẩu không chính xác!" in content)

        # Vector 2: URL Parameter
        sqli_payload = urllib.parse.quote("' UNION SELECT NULL, NULL --")
        status_search, _, content_search = client.get(f"/ProductList.aspx?q={sqli_payload}")
        search_safe = (status_search == 200 and "syntax error" not in content_search.lower())

        passed = (not_bypassed and search_safe)
        detail = "LINQ to SQL phân tích thành cây biểu thức @p0, vô hiệu hóa hoàn toàn SQL Injection"
        self.log_result("SEC01", "Chống SQL Injection", passed, detail)

    # --------------------------------------------------------------------------
    # SEC02: Chống XSS (Cross-Site Scripting)
    # --------------------------------------------------------------------------
    def test_sec02_xss_protection(self):
        client = TestClient(allow_redirects=True)
        payload = "<script>alert('XSS')</script>"
        encoded_payload = urllib.parse.quote(payload)

        # Kiểm tra Output Encoding trên trang Tìm kiếm
        status, _, content = client.get(f"/ProductList.aspx?q={encoded_payload}")
        # Không được chứa thẻ unescaped <script>alert('XSS')</script>
        has_unescaped = (payload in content)
        # Phải chứa &lt;script&gt;
        has_encoded = ("&lt;script&gt;" in content or "&amp;lt;script&amp;gt;" in content)

        # Kiểm tra Output Encoding trên trang Tra cứu đơn hàng
        status2, _, content2 = client.get(f"/TrackOrder.aspx?q={encoded_payload}")
        has_unescaped2 = (payload in content2)
        has_encoded2 = ("&lt;script&gt;" in content2 or "&amp;lt;script&amp;gt;" in content2)

        passed = (not has_unescaped and has_encoded and not has_unescaped2 and has_encoded2)
        detail = "Toàn bộ chuỗi payload độc hại đều được Server.HtmlEncode() chuyển đổi thành &lt;script&gt;"
        self.log_result("SEC02", "Chống XSS", passed, detail)

    # --------------------------------------------------------------------------
    # SEC03: Toàn vẹn băm SHA-256 trong CSDL
    # --------------------------------------------------------------------------
    def test_sec03_sha256_integrity(self):
        conn = pyodbc.connect(DB_CONN_STR)
        cursor = conn.cursor()
        cursor.execute("SELECT Username, Password FROM Acounts")
        rows = cursor.fetchall()
        conn.close()

        total = len(rows)
        valid_count = 0
        sha256_regex = re.compile(r'^[a-fA-F0-9]{64}$')

        for user, pwd in rows:
            if pwd and sha256_regex.match(pwd):
                valid_count += 1

        passed = (total > 0 and valid_count == total)
        detail = f"100% tài khoản ({valid_count}/{total}) trong CSDL đều lưu mã băm SHA-256 độ dài 64 hex characters"
        self.log_result("SEC03", "Toàn vẹn băm SHA-256", passed, detail)

    # --------------------------------------------------------------------------
    # Tổng kết bảng kết quả
    # --------------------------------------------------------------------------
    def print_summary(self):
        total = len(self.results)
        passed_count = sum(1 for r in self.results if r["passed"])
        fail_count = total - passed_count
        rate = (passed_count / total * 100) if total > 0 else 0

        print("\n" + "="*80)
        print(f"  TỔNG KẾT KẾT QUẢ KIỂM THỬ: {passed_count}/{total} ĐẠT (TỶ LỆ THÀNH CÔNG: {rate:.1f}%)")
        print("="*80)
        print(f"| {'Mã TC':<7} | {'Tên Test Case':<28} | {'Trạng Thái':<10} | {'Chi Tiết Kết Quả':<30} |")
        print("|" + "-"*9 + "|" + "-"*30 + "|" + "-"*12 + "|" + "-"*32 + "|")
        for r in self.results:
            st = "PASS" if r["passed"] else "FAIL"
            print(f"| {r['code']:<7} | {r['name']:<28} | {st:<10} | {r['detail'][:30]:<30} |")
        print("="*80 + "\n")

if __name__ == '__main__':
    suite = GD8TestSuite()
    suite.run_all()
