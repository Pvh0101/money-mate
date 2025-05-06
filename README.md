# Ứng dụng quản lý tài chính cá nhân

## Kiến trúc ứng dụng

Ứng dụng được xây dựng dựa trên các nguyên tắc kiến trúc hiện đại:

### Clean Architecture
* Phân tách thành 3 tầng chính:
  * **Presentation Layer**: Giao diện người dùng và tương tác
  * **Domain Layer**: Logic nghiệp vụ và các use cases
  * **Data Layer**: Nguồn dữ liệu và truy cập dữ liệu

### Tuân thủ nguyên tắc  SOLID

### Quản lý trạng thái
* Sử dụng BLoC/Cubit pattern để quản lý trạng thái ứng dụng
* Tách biệt UI và business logic
* Luồng dữ liệu một chiều, dễ dàng kiểm thử

### Cơ sở dữ liệu
* Firebase  làm cơ sở dữ liệu 

## Các chức năng cốt lõi

### 🔑 1. **Ghi nhận chi tiêu / thu nhập**

* Thêm giao dịch với các thông tin:
  * Số tiền
  * Loại giao dịch: **Chi tiêu / Thu nhập**
  * Danh mục: Ăn uống, Đi lại, Giải trí, Lương...
  * Ghi chú
  * Ngày giờ giao dịch
* Tùy chọn: thêm hình ảnh hóa đơn

### 🔑 2. **Quản lý danh mục**

* Cung cấp danh sách danh mục mặc định (ăn uống, di chuyển, mua sắm...)
* Cho phép người dùng tạo, chỉnh sửa, xóa danh mục riêng
* Hỗ trợ tùy chỉnh icon và màu sắc cho từng danh mục

### 🔑 3. **Danh sách giao dịch (Lịch sử)**

* Hiển thị các giao dịch gần nhất
* Sắp xếp theo ngày / số tiền
* Bộ lọc theo:
  * Khoảng thời gian (hôm nay, tuần, tháng…)
  * Loại (chi tiêu / thu nhập)
  * Danh mục

### 🔑 4. **Chỉnh sửa và xóa giao dịch**

* Cho phép chỉnh sửa toàn bộ thông tin của giao dịch đã thêm
* Hiển thị xác nhận trước khi xóa giao dịch
* Hỗ trợ hoàn tác (undo) sau khi xóa

### 🔑 5. **Tổng quan (Dashboard)**

* Hiển thị nhanh các thông tin quan trọng:
  * Tổng chi tiêu hôm nay / tuần này / tháng này
  * Tỷ lệ phần trăm chi tiêu theo danh mục
  * Số dư hiện tại (thu - chi)
  * Cảnh báo vượt hạn mức ngân sách (nếu có)

### 🔑 6. **Tìm kiếm & lọc giao dịch**

* Tìm kiếm giao dịch theo tên, ghi chú
* Lọc giao dịch theo nhiều tiêu chí:
  * Khoảng thời gian cụ thể
  * Loại giao dịch
  * Danh mục
  * Khoảng số tiền

### 🔑 7. **Thống kê & biểu đồ**

* Tổng thu, tổng chi theo ngày/tuần/tháng/năm
* Biểu đồ hình tròn (Pie) hoặc cột (Bar) thể hiện tỷ lệ chi tiêu theo danh mục
* Biểu đồ đường (Line) theo dõi xu hướng chi tiêu theo thời gian

## Tính năng nâng cao (phát triển trong tương lai)

| Tính năng nâng cao | Mô tả |
|-------------------|-------|
| Lập ngân sách (Budgeting) | Thiết lập giới hạn chi tiêu theo tháng hoặc theo từng danh mục, nhận thông báo khi gần đạt hoặc vượt ngân sách |
| Đồng bộ cloud | Lưu trữ và đồng bộ dữ liệu lên Firebase để đảm bảo an toàn và không mất dữ liệu khi đổi thiết bị |
| Đăng nhập đa thiết bị | Hỗ trợ đăng nhập qua Google, Facebook hoặc Email, cho phép truy cập dữ liệu trên nhiều thiết bị |
| Giao dịch định kỳ | Tự động thêm các giao dịch lặp lại định kỳ (lương, tiền thuê nhà, hóa đơn hàng tháng...) |
| Đa loại tiền tệ | Hỗ trợ nhiều đơn vị tiền tệ khác nhau, tự động cập nhật tỷ giá và chuyển đổi giữa các loại tiền |
