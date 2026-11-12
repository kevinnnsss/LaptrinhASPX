# ⌚ HỆ THỐNG WEBSITE BÁN ĐỒNG HỒ CAO CẤP CHÍNH HÃNG KEVLOUIS WATCH

> **Đề tài Bài tập lớn:** Học phần Lập trình Web Nâng cao (ASP.NET Web Forms)  
> **Khoa:** Công nghệ Thông tin - Trường Đại học Đồng Tháp  
> **Công nghệ chủ đạo:** ASP.NET Web Forms (.NET Framework 4.8), C# 7.3, LINQ to SQL, Microsoft SQL Server 2022, Bootstrap & CSS3 Cinema Style, SHA-256 Cryptography.

---

## 📌 HƯỚNG DẪN CÀI ĐẶT & CHẠY DỰ ÁN TRÊN MÁY TÍNH (CHO BẠN BÈ & GIẢNG VIÊN)

Để website hiển thị **đầy đủ 100% hình ảnh thật**, video trailer, danh mục thương hiệu và toàn bộ nghiệp vụ bán hàng, vui lòng thực hiện tuần tự 3 bước đơn giản dưới đây:

### 🔹 Bước 1: Nạp Cơ Sở Dữ Liệu SQL Server
1. Mở phần mềm **SQL Server Management Studio (SSMS)**.
2. Kết nối vào máy chủ SQL Server của máy bạn.
3. Vào menu **File &rarr; Open &rarr; File...** (hoặc kéo thả) file [`Database_layout.sql`](Database_layout.sql) ở thư mục gốc vào SSMS.
4. Nhấn phím **F5 (Execute)** để hệ thống tự động:
   * Tạo cơ sở dữ liệu `layout`.
   * Khởi tạo đủ 6 bảng chuẩn hóa: `Acounts`, `Menus`, `PageItems`, `ProductPrices`, `Orders`, `OrderDetails`.
   * Nạp sẵn toàn bộ danh mục hãng (Casio, Seiko, Citizen, Rolex), sản phẩm đồng hồ kèm **liên kết ảnh thật sắc nét (HD)** và tài khoản quản trị mẫu.

### 🔹 Bước 2: Mở Dự Án Bằng Visual Studio
1. Khởi động **Visual Studio 2022** (hoặc Visual Studio 2019).
2. Click đúp mở file solution [`BCBTL.sln`](BCBTL.sln) (hoặc `BCBTL.slnx`).
3. Mở file [`BCBTL/Web.config`](BCBTL/Web.config) kiểm tra chuỗi kết nối:
   ```xml
   <connectionStrings>
     <add name="layoutConnectionString" 
          connectionString="Data Source=localhost;Initial Catalog=layout;Integrated Security=True;Encrypt=False" 
          providerName="System.Data.SqlClient" />
   </connectionStrings>
   ```
   *(💡 **Lưu ý:** Nếu máy tính của bạn dùng SQL Server Express, hãy đổi `Data Source=localhost` thành `Data Source=.\SQLEXPRESS` hoặc `Data Source=localhost\SQLEXPRESS`).*

### 🔹 Bước 3: Khởi Chạy Website
1. Trong cửa sổ **Solution Explorer**, click chuột phải vào file **`Default.aspx`** &rarr; Chọn **Set As Start Page**.
2. Nhấn phím **Ctrl + F5** (Start Without Debugging) hoặc **F5**.
3. Trình duyệt sẽ tự động mở trang chủ website bán đồng hồ KevLouis với video trailer hero banner, menu đa cấp và đầy đủ ảnh thật của tất cả sản phẩm.

---

## 🔑 DANH SÁCH TÀI KHOẢN MẪU TRẢI NGHIỆM

Mật khẩu của tất cả tài khoản đều đã được băm an toàn bằng giải thuật một chiều **SHA-256** (64 ký tự Hexadecimal):

| Tên Đăng Nhập | Mật Khẩu | Họ Và Tên | Quyền Hạn (Permission) | Ghi Chú |
| :---: | :---: | :--- | :---: | :--- |
| **`admin`** | `123456` | Quản trị viên Hệ thống | `1` (Quản trị Admin) | Toàn quyền Dashboard, Quản lý sản phẩm, Menus, Đơn hàng |
| **`anhloi`** | `123456` | Nguyễn Quốc Lợi | `2` (Thành viên / Khách) | Tài khoản khách hàng mua sắm |
| **`member`** | `123456` | Nguyễn Văn Khách | `2` (Thành viên / Khách) | Tài khoản khách hàng mẫu |

---

## 🖼️ CẤU TRÚC LƯU TRỮ HÌNH ẢNH TRONG DỰ ÁN

Toàn bộ tài nguyên ảnh thật đã được commit và theo dõi trực tiếp trên Git, được khai báo đầy đủ trong project:

* 📁 **`BCBTL/Assets/images/products/`**: Ảnh đại diện chính của từng mẫu đồng hồ (Casio Edifice, G-Shock, Baby-G, Seiko 5 Sports, Seiko Presage, Citizen Eco-Drive, Rolex Submariner, Rolex Datejust...).
* 📁 **`BCBTL/Assets/images/gallery/{id}/`**: Bộ sưu tập hình ảnh chụp thực tế từng góc cạnh và chi tiết máy (Gallery góc chụp 1, 2, 3...) cho từng sản phẩm `ID_P`.
* 📁 **`BCBTL/trailer/`**: Video trailer điện ảnh chính hãng `trailerdonghorollex.mp4`.
* 📁 **`BCBTL/Assets/images/banners/`**: Các banner khuyến mãi và poster trình chiếu.

---

## 🚀 CÁC TÍNH NĂNG VÀ PHÂN HỆ NỔI BẬT

1. **Giao diện Khách hàng (Storefront):**
   * Video Trailer Hero Banner chuẩn phong cách Cinema hiện đại.
   * Menu đa cấp đổ động từ CSDL theo cấp cha - con.
   * Danh mục sản phẩm theo thương hiệu (Casio, Seiko, Citizen, Rolex) và lọc theo Giới tính (Nam, Nữ, Unisex).
   * Trang chi tiết sản phẩm: Tích hợp thư viện ảnh thực tế đa góc chụp (Interactive Photo Gallery), kiểm tra tồn kho thời gian thực, chính sách bảo hành 5 năm độc quyền.
2. **Nghiệp vụ Bán hàng & Trải nghiệm:**
   * Giỏ hàng `Session["Cart"]` mượt mà, tích hợp **ASP.NET AJAX UpdatePanel** cập nhật số lượng không giật màn hình.
   * Áp dụng mã Voucher giảm giá 10% tức thì (`KEV10`, `CHAOBAN`).
   * Thanh toán linh hoạt: COD và Chuyển khoản ngân hàng VietQR.
   * **Tra cứu đơn hàng thời gian thực:** `TrackOrder.aspx` theo dõi trạng thái đơn hàng qua thanh Stepper Timeline 4 bước.
3. **Phân hệ Quản trị (Admin CMS):**
   * Bảo mật chặn quyền truy cập bằng Session Master Page.
   * Dashboard thống kê 4 chỉ số KPI quan trọng.
   * Quản lý sản phẩm (CRUD): Hỗ trợ `FileUpload` upload ảnh sản phẩm mới lên server, phân trang GridView.
   * Quản lý đơn hàng: Xem chi tiết giỏ hàng khách mua và cập nhật tiến độ giao hàng.
4. **Bảo mật & Kiểm thử hệ thống (GĐ8):**
   * Băm mật khẩu một chiều **SHA-256** qua `SecurityHelper.cs`.
   * Chống SQL Injection 100% nhờ cơ chế Parameterized Query của LINQ to SQL.
   * Chống tấn công XSS thông qua cơ chế phòng thủ đa tầng `Server.HtmlEncode()`.
   * Bộ kiểm thử tự động hóa 16/16 Test Cases đạt chuẩn tuyệt đối (`test_gd8_full_suite.py`).
