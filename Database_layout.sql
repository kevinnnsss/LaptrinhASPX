-- =========================================================================
-- DỰ ÁN BÀI TẬP LỚN: WEBSITE BÁN ĐỒNG HỒ (ASP.NET WEB FORMS - C# - LINQ TO SQL)
-- MÔN HỌC: LẬP TRÌNH WEB (ĐẠI HỌC ĐỒNG THÁP)
-- TÊN CSDL: layout
-- TƯƠNG THÍCH: MICROSOFT SQL SERVER 2012 / 2016 / 2019 / 2022
-- HƯỚNG DẪN: MỞ TRÊN SSMS VÀ NHẤN F5 ĐỂ CHẠY TOÀN BỘ SCRIPT
-- =========================================================================

USE master;
GO

-- 1. TẠO CSDL LAYOUT NẾU CHƯA CÓ
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'layout')
BEGIN
    CREATE DATABASE layout;
    PRINT N'==> Đã tạo mới CSDL layout thành công!';
END
ELSE
BEGIN
    PRINT N'==> CSDL layout đã tồn tại, tiếp tục sử dụng.';
END
GO

USE layout;
GO

-- 2. XÓA BẢNG CŨ THEO THỨ TỰ RÀNG BUỘC KHÓA NGOẠI (NẾU CÓ) ĐỂ TẠO LẠI SẠCH SẼ
IF OBJECT_ID(N'dbo.OrderDetails', N'U') IS NOT NULL DROP TABLE dbo.OrderDetails;
IF OBJECT_ID(N'dbo.Orders', N'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID(N'dbo.ProductPrices', N'U') IS NOT NULL DROP TABLE dbo.ProductPrices;
IF OBJECT_ID(N'dbo.PageItems', N'U') IS NOT NULL DROP TABLE dbo.PageItems;
IF OBJECT_ID(N'dbo.Menus', N'U') IS NOT NULL DROP TABLE dbo.Menus;
IF OBJECT_ID(N'dbo.Acounts', N'U') IS NOT NULL DROP TABLE dbo.Acounts;
GO

-- 3. TẠO 3 BẢNG LÕI (CHÍNH XÁC 100% TÊN BẢNG VÀ TÊN CỘT THEO ĐỀ CƯƠNG)

-- Bảng 3.1: Acounts (Quản lý tài khoản)
CREATE TABLE dbo.Acounts (
    Username    VARCHAR(50)     NOT NULL,
    Password    VARCHAR(256)    NOT NULL,
    Fullname    NVARCHAR(100)   NULL,
    Permission  INT             NOT NULL DEFAULT 2, -- 1: Admin, 2: Member
    Email       VARCHAR(100)    NULL,
    Lock        BIT             NOT NULL DEFAULT 0, -- 0: Bình thường, 1: Bị khóa
    Active      BIT             NOT NULL DEFAULT 1, -- 1: Đã kích hoạt
    CONSTRAINT PK_Acounts PRIMARY KEY CLUSTERED (Username ASC)
);
GO

-- Bảng 3.2: Menus (Quản lý menu và danh mục thương hiệu đồng hồ)
CREATE TABLE dbo.Menus (
    ID_MN       INT IDENTITY(1,1) NOT NULL,
    Parent      INT               NOT NULL DEFAULT 0, -- 0: Menu gốc
    Pos         INT               NOT NULL DEFAULT 1, -- 1: Header, 2: Danh mục sản phẩm, 3: Footer
    Lable       NVARCHAR(150)     NOT NULL,
    UrlLink     NVARCHAR(255)     NULL,
    OrderKey    INT               NOT NULL DEFAULT 0,
    UserAdd     VARCHAR(50)       NULL,
    UserTest    VARCHAR(50)       NULL,
    Hide        BIT               NOT NULL DEFAULT 0, -- 0: Hiển thị, 1: Ẩn
    CONSTRAINT PK_Menus PRIMARY KEY CLUSTERED (ID_MN ASC),
    CONSTRAINT FK_Menus_Acounts FOREIGN KEY (UserAdd) REFERENCES dbo.Acounts(Username) ON UPDATE CASCADE ON DELETE SET NULL
);
GO

-- Bảng 3.3: PageItems (Quản lý sản phẩm đồng hồ & tin tức)
CREATE TABLE dbo.PageItems (
    ID_P        INT IDENTITY(1,1) NOT NULL,
    ID_MN       INT               NOT NULL,
    Title       NVARCHAR(255)     NOT NULL,
    Sumary      NVARCHAR(500)     NULL,
    Contents    NVARCHAR(MAX)     NULL,
    CreaDate    DATETIME          NOT NULL DEFAULT GETDATE(),
    ModiDate    DATETIME          NULL DEFAULT GETDATE(),
    OrderKey    INT               NOT NULL DEFAULT 0,
    UserAdd     VARCHAR(50)       NULL,
    UserTest    VARCHAR(50)       NULL,
    Hide        BIT               NOT NULL DEFAULT 0, -- 0: Hiển thị/Đang bán, 1: Ẩn/Hết hàng
    Image       NVARCHAR(255)     NULL,
    CONSTRAINT PK_PageItems PRIMARY KEY CLUSTERED (ID_P ASC),
    CONSTRAINT FK_PageItems_Menus FOREIGN KEY (ID_MN) REFERENCES dbo.Menus(ID_MN) ON UPDATE CASCADE ON DELETE CASCADE
);
GO

-- 4. TẠO 3 BẢNG MỞ RỘNG (HỖ TRỢ ĐẦY ĐỦ CHỨC NĂNG BÁN HÀNG CHUYÊN NGHIỆP)

-- Bảng 4.1: ProductPrices (Giá và số lượng tồn kho của đồng hồ)
CREATE TABLE dbo.ProductPrices (
    ID_P            INT             NOT NULL,
    Price           DECIMAL(18,0)   NOT NULL DEFAULT 0,  -- Giá bán hiện tại (VNĐ)
    OriginalPrice   DECIMAL(18,0)   NULL DEFAULT 0,      -- Giá niêm yết ban đầu
    StockQuantity   INT             NOT NULL DEFAULT 10, -- Số lượng tồn kho
    DiscountPercent INT             NULL DEFAULT 0,      -- % Khuyến mãi
    CONSTRAINT PK_ProductPrices PRIMARY KEY CLUSTERED (ID_P ASC),
    CONSTRAINT FK_ProductPrices_PageItems FOREIGN KEY (ID_P) REFERENCES dbo.PageItems(ID_P) ON DELETE CASCADE
);
GO

-- Bảng 4.2: Orders (Đơn đặt hàng)
CREATE TABLE dbo.Orders (
    OrderID         INT IDENTITY(1,1) NOT NULL,
    CustomerName    NVARCHAR(100)     NOT NULL,
    CustomerPhone   VARCHAR(20)       NOT NULL,
    CustomerEmail   VARCHAR(100)      NULL,
    DeliveryAddress NVARCHAR(300)     NOT NULL,
    OrderNotes      NVARCHAR(500)     NULL,
    TotalAmount     DECIMAL(18,0)     NOT NULL DEFAULT 0,
    OrderDate       DATETIME          NOT NULL DEFAULT GETDATE(),
    Status          NVARCHAR(50)      NOT NULL DEFAULT N'Chờ xử lý', -- Chờ xử lý, Đã xác nhận, Đang giao, Đã hoàn tất, Đã hủy
    Username        VARCHAR(50)       NULL, -- Khách vãng lai = NULL, hoặc liên kết với tài khoản
    CONSTRAINT PK_Orders PRIMARY KEY CLUSTERED (OrderID ASC),
    CONSTRAINT FK_Orders_Acounts FOREIGN KEY (Username) REFERENCES dbo.Acounts(Username) ON DELETE SET NULL
);
GO

-- Bảng 4.3: OrderDetails (Chi tiết các sản phẩm trong đơn hàng)
CREATE TABLE dbo.OrderDetails (
    DetailID    INT IDENTITY(1,1) NOT NULL,
    OrderID     INT               NOT NULL,
    ID_P        INT               NOT NULL,
    Quantity    INT               NOT NULL DEFAULT 1,
    UnitPrice   DECIMAL(18,0)     NOT NULL DEFAULT 0,
    LineTotal   AS (Quantity * UnitPrice), -- Cột tính toán tự động
    CONSTRAINT PK_OrderDetails PRIMARY KEY CLUSTERED (DetailID ASC),
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID) ON DELETE CASCADE,
    CONSTRAINT FK_OrderDetails_PageItems FOREIGN KEY (ID_P) REFERENCES dbo.PageItems(ID_P)
);
GO

-- 5. CHÈN DỮ LIỆU MẪU (SEED DATA ĐỂ CHẠY DEMO NGAY)

-- 5.1. Dữ liệu bảng Acounts (Mật khẩu '123456' băm mã SHA-256)
INSERT INTO dbo.Acounts (Username, Password, Fullname, Permission, Email, Lock, Active)
VALUES 
('admin', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Quản trị viên Hệ thống', 1, 'admin@watchstore.vn', 0, 1),
('member', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'Nguyễn Văn Khách', 2, 'khachhang@gmail.com', 0, 1);
GO

-- 5.2. Dữ liệu bảng Menus (Cây menu đa cấp chuẩn cho shop đồng hồ)
-- Menu cấp 1 (Menu gốc: Parent = 0)
INSERT INTO dbo.Menus (Parent, Pos, Lable, UrlLink, OrderKey, UserAdd, Hide) VALUES
(0, 1, N'Trang chủ', 'Default.aspx', 1, 'admin', 0),            -- ID_MN = 1
(0, 1, N'Thương hiệu', '#', 2, 'admin', 0),                     -- ID_MN = 2 (Cha của các hãng)
(0, 1, N'Đồng hồ Nam', 'ProductList.aspx?cat=nam', 3, 'admin', 0),-- ID_MN = 3
(0, 1, N'Đồng hồ Nữ', 'ProductList.aspx?cat=nu', 4, 'admin', 0),  -- ID_MN = 4
(0, 1, N'Tin tức & Đánh giá', 'NewsList.aspx', 5, 'admin', 0),   -- ID_MN = 5
(0, 1, N'Liên hệ', 'Contact.aspx', 6, 'admin', 0);               -- ID_MN = 6

-- Menu cấp 2 (Thương hiệu con thuộc Menu 'Thương hiệu' có ID_MN = 2)
INSERT INTO dbo.Menus (Parent, Pos, Lable, UrlLink, OrderKey, UserAdd, Hide) VALUES
(2, 2, N'Casio Nhật Bản', 'ProductList.aspx?idmn=7', 1, 'admin', 0),  -- ID_MN = 7
(2, 2, N'Seiko Huyền thoại', 'ProductList.aspx?idmn=8', 2, 'admin', 0),-- ID_MN = 8
(2, 2, N'Citizen Eco-Drive', 'ProductList.aspx?idmn=9', 3, 'admin', 0),-- ID_MN = 9
(2, 2, N'Rolex Thụy Sĩ', 'ProductList.aspx?idmn=10', 4, 'admin', 0); -- ID_MN = 10
GO

-- 5.3. Dữ liệu bảng PageItems (10 sản phẩm đồng hồ chuẩn + mô tả, ảnh, kèm định dạng "Giá|Tóm tắt")
INSERT INTO dbo.PageItems (ID_MN, Title, Sumary, Contents, CreaDate, ModiDate, OrderKey, UserAdd, Hide, Image) VALUES
-- Casio (ID_MN = 7)
(7, N'Đồng hồ Nam Casio Edifice EFR-539D', N'3450000|Thiết kế Chronograph thể thao mạnh mẽ, kính khoáng chịu lực, chống nước 100m.', 
 N'<p>Đồng hồ Casio Edifice EFR-539D với mặt số nhiều lớp ấn tượng mang đến vẻ đẹp cá tính, phong trần cho phái mạnh. Vỏ và dây hoàn thiện từ thép không gỉ 316L sáng bóng theo thời gian.</p>', 
 GETDATE(), GETDATE(), 1, 'admin', 0, 'casio_efr539d.jpg'),

(7, N'Đồng hồ Casio G-Shock GA-2100-1A1', N'2890000|Dòng CasiOak vỏ Carbon siêu bền, kiểu dáng bát giác góc cạnh thời thượng.', 
 N'<p>Mẫu đồng hồ G-Shock GA-2100 có thiết kế vỏ mỏng nhẹ được gia cố bằng sợi Carbon bảo vệ bộ máy tối đa trước mọi va đập mạnh. Chống nước vượt trội ở độ sâu 200m.</p>', 
 GETDATE(), GETDATE(), 2, 'admin', 0, 'gshock_ga2100.jpg'),

(7, N'Đồng hồ Nữ Casio Baby-G BGA-280', N'2200000|Phong cách trẻ trung ngọt ngào, đa chức năng bấm giờ và đèn LED.', 
 N'<p>Sự kết hợp hoàn hảo giữa độ bền của G-Shock và nét duyên dáng, nữ tính dành riêng cho các bạn nữ năng động.</p>', 
 GETDATE(), GETDATE(), 3, 'admin', 0, 'babyg_bga280.jpg'),

-- Seiko (ID_MN = 8)
(8, N'Đồng hồ Nam Seiko 5 Sports SRPD55K1', N'5600000|Máy cơ Automatic Caliber 4R36, trữ cót 41 giờ, lộ đáy quyến rũ.', 
 N'<p>Dòng Seiko 5 Sports tái sinh với diện mạo thợ lặn kinh điển. Vành bezel xoay một chiều, dạ quang LumiBrite phát sáng rực rỡ trong bóng tối.</p>', 
 GETDATE(), GETDATE(), 4, 'admin', 0, 'seiko5_srpd55k1.jpg'),

(8, N'Đồng hồ Nam Seiko Presage Cocktail Time', N'9800000|Mặt vân Guilloche tỏa sáng như ly cocktail thượng hạng, kính vòm cong.', 
 N'<p>Kiệt tác đồng hồ cổ điển chuẩn doanh nhân. Trang bị bộ máy cơ Automatic có hỗ trợ lên cót tay và dừng kim giây khi chỉnh giờ.</p>', 
 GETDATE(), GETDATE(), 5, 'admin', 0, 'seiko_presage.jpg'),

-- Citizen (ID_MN = 9)
(9, N'Đồng hồ Citizen Eco-Drive BM7100-59E', N'6200000|Công nghệ năng lượng ánh sáng độc quyền Eco-Drive, kính Sapphire nguyên khối.', 
 N'<p>Không cần thay pin trong suốt quá trình sử dụng nhờ khả năng hấp thụ bất kỳ nguồn ánh sáng nào để sạc pin. Mặt kính Sapphire chống trầy xước tuyệt đối.</p>', 
 GETDATE(), GETDATE(), 6, 'admin', 0, 'citizen_bm7100.jpg'),

(9, N'Đồng hồ Nữ Citizen Eco-Drive EM0500', N'4750000|Họa tiết xà cừ tinh xảo, đính pha lê lấp lánh sang trọng.', 
 N'<p>Món trang sức đẳng cấp trên cổ tay phái đẹp với nét thanh mảnh và độ chính xác vượt trội.</p>', 
 GETDATE(), GETDATE(), 7, 'admin', 0, 'citizen_em0500.jpg'),

-- Rolex (ID_MN = 10)
(10, N'Đồng hồ Rolex Submariner Date 126610LN', N'345000000|Biểu tượng đồng hồ lặn thế giới, gốm Cerachrom, thép Oystersteel siêu bền.', 
 N'<p>Đỉnh cao của nghệ thuật chế tác đồng hồ Thụy Sĩ. Bộ máy Calibre 3235 đạt chuẩn Superlative Chronometer chuẩn xác đến kinh ngạc.</p>', 
 GETDATE(), GETDATE(), 8, 'admin', 0, 'rolex_submariner.jpg'),

(10, N'Đồng hồ Rolex Datejust 36mm M126234', N'285000000|Vành khía vàng trắng, dây Jubilee 5 mắt truyền thống quý tộc.', 
 N'<p>Mẫu đồng hồ cổ điển trường tồn với thời gian, khẳng định vị thế và đẳng cấp của chủ nhân sở hữu.</p>', 
 GETDATE(), GETDATE(), 9, 'admin', 0, 'rolex_datejust.jpg'),

-- Tin tức kiến thức (ID_MN = 5)
(5, N'Hướng dẫn cách phân biệt đồng hồ thật và giả', N'0|Những mẹo kiểm tra kim trôi, mặt kính sapphire và logo thương hiệu sắc nét.', 
 N'<p>Bài viết chia sẻ các kiến thức bổ ích giúp người mua đồng hồ tránh khỏi việc mua phải hàng kém chất lượng trên thị trường hiện nay.</p>', 
 GETDATE(), GETDATE(), 10, 'admin', 0, 'news_phanbiet.jpg');
GO

-- 5.4. Dữ liệu bảng ProductPrices (Ánh xạ 1-1 với ID_P từ 1 đến 9)
INSERT INTO dbo.ProductPrices (ID_P, Price, OriginalPrice, StockQuantity, DiscountPercent) VALUES
(1, 3450000, 3900000, 25, 11),
(2, 2890000, 3200000, 40, 10),
(3, 2200000, 2500000, 15, 12),
(4, 5600000, 6200000, 18, 10),
(5, 9800000, 11000000, 8, 11),
(6, 6200000, 6800000, 12, 9),
(7, 4750000, 5300000, 20, 10),
(8, 345000000, 360000000, 2, 4),
(9, 285000000, 299000000, 3, 5);
GO

PRINT N'==> ĐÃ KHỞI TẠO CSDL VÀ CHÈN DỮ LIỆU MẪU THÀNH CÔNG 100%!';
GO
