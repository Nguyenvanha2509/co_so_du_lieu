--1. lệnh gồm select có điều kiện trên một bảng
	-- 1.1. Lấy thông tin các thuốc có giá trên 100,000 VND
	SELECT * 
	FROM Thuoc 
	WHERE Gia > 10000;

	-- 1.2. Lấy danh sách nhân viên có chức vụ là "Dược sĩ"
	SELECT * 
	FROM NhanVien 
	WHERE ChucVu = N'Dược sĩ';

--2. lệnh gồm select có điều kiện trên hai bảng
	-- 2.1.  Lấy thông tin hợp đồng cùng tên nhà cung cấp
	SELECT hd.MaHopDong, hd.NgayKy, hd.NgayHetHan, ncc.TenNhaCungCap
	FROM HopDong hd
	JOIN NhaCungCap ncc ON hd.MaNhaCungCap = ncc.MaNhaCungCap;
	
	-- 2.2.  Lấy danh sách đơn thuốc cùng tên khách hàng
	SELECT dt.MaDonThuoc, dt.NgayKeDon, kh.TenKhachHang
	FROM DonThuoc dt
	JOIN KhachHang kh ON dt.MaKhachHang = kh.MaKhachHang;
	
	-- 2.3. Lấy thông tin thuốc cùng tên hiệu thuốc
	SELECT t.MaThuoc, t.TenThuoc, t.LoaiThuoc, ht.TenHieuThuoc
	FROM Thuoc t
	JOIN HieuThuoc ht ON t.MaHieuThuoc = ht.MaHieuThuoc;

--3. câu lệnh gồm select có where và group by
	-- 3.1. Đếm số lượng thuốc theo loại
	SELECT LoaiThuoc, COUNT(*) AS SoLuong
	FROM Thuoc
	GROUP BY LoaiThuoc;
	
	-- 3.2. Tính tổng giá trị thuốc theo hiệu thuốc
	SELECT MaHieuThuoc, SUM(Gia) AS TongGiaTri
	FROM Thuoc
	GROUP BY MaHieuThuoc;

--4.câu lệnh gồm select có where, group by, having
	-- 4.1. Hiệu thuốc có tổng giá trị thuốc trên 50,000 VND
	SELECT MaHieuThuoc, SUM(Gia) AS TongGiaTri
	FROM Thuoc
	GROUP BY MaHieuThuoc
	HAVING SUM(Gia) > 50000;

	-- 4.2. Loại thuốc có số lượng nhiều hơn 1
	SELECT LoaiThuoc, COUNT(*) AS SoLuong
	FROM Thuoc
	GROUP BY LoaiThuoc
	HAVING COUNT(*) > 1;

	-- 4.3. Nhà cung cấp có từ 2 hợp đồng trở lên
	SELECT MaNhaCungCap, COUNT(*) AS SoHopDong
	FROM HopDong
	GROUP BY MaNhaCungCap
	HAVING COUNT(*) >= 2;

--5.câu lệnh gồm select có where, group by, having và order by
	-- 5.1. Sắp xếp các hiệu thuốc theo tổng giá trị thuốc giảm dần
	SELECT MaHieuThuoc, SUM(Gia) AS TongGiaTri
	FROM Thuoc
	GROUP BY MaHieuThuoc
	HAVING SUM(Gia) > 0
	ORDER BY TongGiaTri DESC;

	-- 5.2.  Sắp xếp loại thuốc theo số lượng tăng dần
	SELECT LoaiThuoc, COUNT(*) AS SoLuong
	FROM Thuoc
	GROUP BY LoaiThuoc
	HAVING COUNT(*) > 0
	ORDER BY SoLuong ASC;

--6.câu lệnh gồm select có where, group by, having và truy vấn con
	-- 6.1. Lấy thông tin thuốc có giá cao hơn giá trung bình
	SELECT MaThuoc, TenThuoc, Gia
	FROM Thuoc
	WHERE Gia > (SELECT AVG(Gia) FROM Thuoc)
	GROUP BY MaThuoc, TenThuoc, Gia
	HAVING Gia > 0;

	-- 6.2. Lấy hiệu thuốc có số lượng thuốc nhiều hơn trung bình
	SELECT MaHieuThuoc, COUNT(*) AS SoLuongThuoc
	FROM Thuoc
	GROUP BY MaHieuThuoc
	HAVING COUNT(*) > (SELECT AVG(SoLuong) 
	FROM (SELECT COUNT(*) AS SoLuong 
	FROM Thuoc 
	GROUP BY MaHieuThuoc) AS Temp);

--7.câu câu lệnh insert có điều kiện
	-- 7.1. Thêm thuốc mới nếu chưa tồn tại
	INSERT INTO Thuoc (MaThuoc, TenThuoc, LoaiThuoc, Gia, MaHieuThuoc, MaNhaCungCap)
	SELECT 'THUOC011', N'Efferalgan 500mg', N'Giảm đau', 12000, 'HT001', 'NCC001'
	WHERE NOT EXISTS (SELECT 1 FROM Thuoc WHERE MaThuoc = 'THUOC011');

	-- 7.2. Thêm nhân viên mới nếu số điện thoại chưa được sử dụng
	INSERT INTO NhanVien (MaNhanVien, TenNhanVien, ChucVu, MaHieuThuoc)
	SELECT 'NV006', 'Trần Thị Hương', 'Dược sĩ', 'HT002'
	WHERE NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNhanVien = 'NV006');

--8.câu lệnh update có điều kiện
	-- 8.1. Cập nhật giá thuốc tăng 10% cho thuốc kháng sinh
	UPDATE Thuoc
	SET Gia = Gia * 1.1
	WHERE LoaiThuoc = 'Kháng sinh';

	-- 8.2. Cập nhật chức vụ nhân viên thành "Quản lý" cho nhân viên làm việc tại hiệu thuốc HT001
	UPDATE NhanVien
	SET ChucVu = 'Quản lý'
	WHERE MaHieuThuoc = 'HT001' AND ChucVu = 'Dược sĩ';

--9.câu lệnh delete có điều kiện
	-- 9.1. Xóa các hợp đồng đã hết hạn (giả sử ngày hiện tại là 2023-07-01)
	DELETE FROM HopDong
	WHERE NgayHetHan < '2023-07-01';

	-- 9.2. Xóa các thuốc không có trong bất kỳ đơn thuốc nào
	DELETE FROM Thuoc
	WHERE MaThuoc NOT IN (SELECT DISTINCT MaThuoc FROM ChiTietDonThuoc);