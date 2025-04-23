-- Tạo cơ sở dữ liệu
CREATE DATABASE QuanLyHieuThuoc;
GO

USE QuanLyHieuThuoc;
GO

-- 1. Bảng Nhà Cung Cấp
CREATE TABLE NhaCungCap (
    MaNhaCungCap VARCHAR(10) PRIMARY KEY,
    TenNhaCungCap NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(200),
    SDT VARCHAR(15)
);

-- 2. Bảng Hiệu Thuốc
CREATE TABLE HieuThuoc (
    MaHieuThuoc VARCHAR(10) PRIMARY KEY,
    TenHieuThuoc NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(200),
    SDT VARCHAR(15)
);

-- 3. Bảng Nhân Viên
CREATE TABLE NhanVien (
    MaNhanVien VARCHAR(10) PRIMARY KEY,
    TenNhanVien NVARCHAR(100) NOT NULL,
    ChucVu NVARCHAR(50),
    MaHieuThuoc VARCHAR(10) FOREIGN KEY REFERENCES HieuThuoc(MaHieuThuoc)
);

-- 4. Bảng Khách Hàng
CREATE TABLE KhachHang (
    MaKhachHang VARCHAR(10) PRIMARY KEY,
    TenKhachHang NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(200),
    SDT VARCHAR(15),
    NgaySinh DATE
);

-- 5. Bảng Kho Thuốc
CREATE TABLE Kho (
    MaKho VARCHAR(10) PRIMARY KEY,
    TenKho NVARCHAR(100) NOT NULL,
    MaHieuThuoc VARCHAR(10) FOREIGN KEY REFERENCES HieuThuoc(MaHieuThuoc)
);

-- 6. Bảng Thuốc (đã loại bỏ các FK không cần thiết)
CREATE TABLE Thuoc (
    MaThuoc VARCHAR(10) PRIMARY KEY,
    TenThuoc NVARCHAR(100) NOT NULL,
    LoaiThuoc NVARCHAR(50),
    Gia DECIMAL(18,2),
    HanSuDung DATE
);

-- 7. Bảng Hợp Đồng
CREATE TABLE HopDong (
    MaHopDong VARCHAR(10) PRIMARY KEY,
    NgayKy DATE NOT NULL,
    NgayHetHan DATE NOT NULL,
    MaNhaCungCap VARCHAR(10) FOREIGN KEY REFERENCES NhaCungCap(MaNhaCungCap),
    MaHieuThuoc VARCHAR(10) FOREIGN KEY REFERENCES HieuThuoc(MaHieuThuoc)
);

-- 8. Bảng Đơn Thuốc
CREATE TABLE DonThuoc (
    MaDonThuoc VARCHAR(10) PRIMARY KEY,
    NgayKeDon DATE NOT NULL,
    MaNhanVien VARCHAR(10) FOREIGN KEY REFERENCES NhanVien(MaNhanVien),
    MaKhachHang VARCHAR(10) FOREIGN KEY REFERENCES KhachHang(MaKhachHang)
);

-- 9. Bảng Chi Tiết Đơn Thuốc
CREATE TABLE ChiTietDonThuoc (
    MaDonThuoc VARCHAR(10) FOREIGN KEY REFERENCES DonThuoc(MaDonThuoc),
    MaThuoc VARCHAR(10) FOREIGN KEY REFERENCES Thuoc(MaThuoc),
    SoLuong INT NOT NULL,
    PRIMARY KEY (MaDonThuoc, MaThuoc)
);

-- 10. Bảng Hóa Đơn
CREATE TABLE HoaDon (
    MaHoaDon VARCHAR(10) PRIMARY KEY,
    NgayXuat DATE NOT NULL,
    MaNhanVien VARCHAR(10) FOREIGN KEY REFERENCES NhanVien(MaNhanVien),
    MaKhachHang VARCHAR(10) FOREIGN KEY REFERENCES KhachHang(MaKhachHang),
    MaDonThuoc VARCHAR(10) FOREIGN KEY REFERENCES DonThuoc(MaDonThuoc),
    TongTien DECIMAL(18,2)
);

-- 11. Bảng Hiệu Thuốc - Thuốc
CREATE TABLE HieuThuoc_Thuoc (
    MaHieuThuoc VARCHAR(10) FOREIGN KEY REFERENCES HieuThuoc(MaHieuThuoc),
    MaThuoc VARCHAR(10) FOREIGN KEY REFERENCES Thuoc(MaThuoc),
	SoLuong INT NOT NULL,
    PRIMARY KEY (MaHieuThuoc, MaThuoc)
);

-- 12. Bảng Kho Thuốc - Thuốc 
CREATE TABLE KhoThuoc_Thuoc (
    MaKho VARCHAR(10) FOREIGN KEY REFERENCES Kho(MaKho),
    MaThuoc VARCHAR(10) FOREIGN KEY REFERENCES Thuoc(MaThuoc),
    SoLuong INT NOT NULL,
    PRIMARY KEY (MaKho, MaThuoc)
);

-- Thêm dữ liệu mẫu
-- Nhà cung cấp
INSERT INTO NhaCungCap VALUES 
('NCC001', N'Công ty Dược phẩm Hà Nội', N'123 Trần Duy Hưng, Hà Nội', '02438234567'),
('NCC002', N'Dược phẩm Tâm Bình', N'456 Láng Hạ, Hà Nội', '02438234568'),
('NCC003', N'Dược phẩm OPC', N'789 Nguyễn Trãi, Hà Nội', '02438234569');

-- Hiệu thuốc
INSERT INTO HieuThuoc VALUES 
('HT001', N'Hiệu thuốc Bình Minh', N'12 Hai Bà Trưng, Hà Nội', '02438234678'),
('HT002', N'Hiệu thuốc Phương Châm', N'34 Lý Thường Kiệt, Hà Nội', '02438234679'),
('HT003', N'Hiệu thuốc Gia Đình', N'56 Trần Hưng Đạo, Hà Nội', '02438234680');

-- Nhân viên
INSERT INTO NhanVien VALUES 
('NV001', N'Nguyễn Thị Hà', N'Dược sĩ', 'HT001'),
('NV002', N'Trần Văn Nam', N'Dược sĩ', 'HT001'),
('NV003', N'Lê Thị Mai', N'Quản lý', 'HT002'),
('NV004', N'Phạm Văn Đức', N'Dược sĩ', 'HT002'),
('NV005', N'Hoàng Thị Lan', N'Dược sĩ', 'HT003');

-- Khách hàng
INSERT INTO KhachHang VALUES 
('KH001', N'Nguyễn Văn An', N'12 Nguyễn Du, Hà Nội', '0987654321', '1980-05-15'),
('KH002', N'Trần Thị Bình', N'34 Tràng Thi, Hà Nội', '0987654322', '1975-08-20'),
('KH003', N'Lê Văn Cường', N'56 Hàng Bài, Hà Nội', '0987654323', '1990-11-25'),
('KH004', N'Phạm Thị Dung', N'78 Lý Thái Tổ, Hà Nội', '0987654324', '1985-03-10');

-- Kho thuốc
INSERT INTO Kho VALUES 
('KHO001', N'Kho chính', 'HT001'),
('KHO002', N'Kho phụ', 'HT001'),
('KHO003', N'Kho chính', 'HT002'),
('KHO004', N'Kho chính', 'HT003');

-- Thuốc
INSERT INTO Thuoc VALUES 
('THUOC001', N'Paracetamol 500mg', N'Giảm đau', 5000, '2024-12-31'),
('THUOC002', N'Amoxicillin 500mg', N'Kháng sinh', 15000, '2024-10-31'),
('THUOC003', N'Cefixime 200mg', N'Kháng sinh', 25000, '2025-01-31'),
('THUOC004', N'Vitamin C 500mg', N'Vitamin', 10000, '2024-11-30'),
('THUOC005', N'Oresol', N'Bù nước', 8000, '2024-09-30'),
('THUOC006', N'Panadol Extra', N'Giảm đau', 12000, '2025-02-28'),
('THUOC007', N'Gaviscon', N'Tiêu hóa', 35000, '2024-08-31'),
('THUOC008', N'Biseptol', N'Kháng sinh', 18000, '2025-03-31'),
('THUOC009', N'Smecta', N'Tiêu hóa', 22000, '2024-12-31'),
('THUOC010', N'Vitamin B Complex', N'Vitamin', 15000, '2025-01-31');

-- Quan hệ Hiệu thuốc - Thuốc
INSERT INTO HieuThuoc_Thuoc VALUES
('HT001', 'THUOC001'),
('HT001', 'THUOC002'),
('HT001', 'THUOC003'),
('HT001', 'THUOC004'),
('HT002', 'THUOC005'),
('HT002', 'THUOC006'),
('HT002', 'THUOC007'),
('HT003', 'THUOC008'),
('HT003', 'THUOC009'),
('HT003', 'THUOC010');

-- Quan hệ Kho - Thuốc
INSERT INTO KhoThuoc_Thuoc VALUES
('KHO001', 'THUOC001', 100),
('KHO001', 'THUOC002', 50),
('KHO002', 'THUOC003', 30),
('KHO002', 'THUOC004', 40),
('KHO003', 'THUOC005', 60),
('KHO003', 'THUOC006', 45),
('KHO003', 'THUOC007', 25),
('KHO004', 'THUOC008', 35),
('KHO004', 'THUOC009', 50),
('KHO004', 'THUOC010', 40);

-- Hợp đồng
INSERT INTO HopDong VALUES 
('HD001', '2023-01-15', '2024-01-15', 'NCC001', 'HT001'),
('HD002', '2023-02-20', '2024-02-20', 'NCC002', 'HT001'),
('HD003', '2023-03-10', '2024-03-10', 'NCC003', 'HT002'),
('HD004', '2023-04-05', '2024-04-05', 'NCC001', 'HT003'),
('HD005', '2023-05-12', '2024-05-12', 'NCC002', 'HT003');

-- Đơn thuốc
INSERT INTO DonThuoc VALUES 
('DT001', '2023-06-01', 'NV001', 'KH001'),
('DT002', '2023-06-02', 'NV002', 'KH002'),
('DT003', '2023-06-03', 'NV003', 'KH003'),
('DT004', '2023-06-04', 'NV004', 'KH004'),
('DT005', '2023-06-05', 'NV005', 'KH001');

-- Chi tiết đơn thuốc
INSERT INTO ChiTietDonThuoc VALUES 
('DT001', 'THUOC001', 2),
('DT001', 'THUOC002', 1),
('DT002', 'THUOC003', 3),
('DT002', 'THUOC004', 1),
('DT003', 'THUOC005', 2),
('DT003', 'THUOC006', 1),
('DT004', 'THUOC007', 1),
('DT004', 'THUOC008', 2),
('DT005', 'THUOC009', 3),
('DT005', 'THUOC010', 1);

-- Hóa đơn
INSERT INTO HoaDon VALUES 
('HD001', '2023-06-01', 'NV001', 'KH001', 'DT001', 25000),
('HD002', '2023-06-02', 'NV002', 'KH002', 'DT002', 85000),
('HD003', '2023-06-03', 'NV003', 'KH003', 'DT003', 32000),
('HD004', '2023-06-04', 'NV004', 'KH004', 'DT004', 91000),
('HD005', '2023-06-05', 'NV005', 'KH001', 'DT005', 81000);
