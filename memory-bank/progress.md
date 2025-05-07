# Progress: Money Mate

## Trạng thái hiện tại
Dự án đang ở giai đoạn phát triển. Cấu trúc dự án, các công nghệ cốt lõi và trang Onboarding đã được thiết lập. Các tính năng xác thực người dùng đang được phát triển theo kiến trúc Clean Architecture.

## Đã hoàn thành
- ✅ Khởi tạo dự án với cấu trúc Clean Architecture
- ✅ Thiết lập Firebase và cấu hình cơ bản
- ✅ Cài đặt các dependencies chính
- ✅ Thiết kế sơ bộ cơ sở dữ liệu Firestore
- ✅ Tạo cấu trúc thư mục theo kiến trúc đã chọn
- ✅ Thiết kế và triển khai UI cho trang Onboarding (3 slide) với hình ảnh SVG, text styles, và page indicator theo Figma.
- ✅ Cập nhật `CustomButton` để phù hợp với yêu cầu thiết kế của trang Onboarding (gradient, text style, padding).
- ✅ Triển khai Domain Layer và Data Layer cho chức năng đăng ký
- ✅ Tạo tests cho AuthRepositoryImpl và đảm bảo tất cả tests pass
- ✅ Triển khai AuthBloc và kết nối UI RegisterPage với BLoC

## Đang phát triển
- 🔄 Hoàn thiện tính năng đăng nhập
- 🔄 Quản lý phiên người dùng
- 🔄 Các màn hình chính của ứng dụng (dashboard, danh sách giao dịch)
- 🔄 Thêm/sửa/xóa giao dịch

## Cần phát triển
- ⬜ Hiển thị thống kê và biểu đồ
- ⬜ Tìm kiếm và lọc giao dịch
- ⬜ Quản lý danh mục tùy chỉnh
- ⬜ Thiết lập và theo dõi ngân sách
- ⬜ Đồng bộ dữ liệu giữa các thiết bị
- ⬜ Thông báo và nhắc nhở

## Các vấn đề đã biết
- Chưa có cơ chế xử lý offline cho ứng dụng
- Hiệu suất truy vấn Firestore chưa được tối ưu
- Giao diện người dùng cần cải thiện trải nghiệm (Trang Onboarding đã cải thiện một phần)
- Cần thêm tests cho UI/Bloc interactions

## Dự định phát triển tiếp theo
1. Hoàn thiện tính năng đăng nhập người dùng
2. Triển khai quản lý session (auto-login, logout)
3. Phát triển màn hình dashboard
4. Triển khai CRUD cho giao dịch

## Thống kê dự án
- **Tính năng đã hoàn thành**: 30%
- **Tính năng đang phát triển**: 30%
- **Tính năng cần phát triển**: 40%
- **Độ hoàn thiện UI/UX**: 20%
- **Độ ổn định**: 40% 