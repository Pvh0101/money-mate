# Active Context: Money Mate

## Trọng tâm hiện tại
Hiện dự án đang tập trung vào việc phát triển các tính năng cốt lõi của ứng dụng Money Mate, theo cấu trúc Clean Architecture đã thiết lập.

## Thay đổi gần đây
- Khởi tạo cấu trúc dự án với Flutter
- Tích hợp Firebase cho authentication và cơ sở dữ liệu
- Thiết lập các lớp kiến trúc: presentation, domain, và data
- Cài đặt các dependencies cần thiết trong pubspec.yaml
- Hoàn thiện UI cho trang Onboarding theo thiết kế Figma (3 slides, SVG, text styles, page indicator).
- Cập nhật `CustomButton` widget để hỗ trợ `buttonTextStyle` và tùy chỉnh gradient, áp dụng cho nút trên trang Onboarding.
- Tích hợp `flutter_svg` để hiển thị hình ảnh SVG từ Figma.
- Sử dụng `google_fonts` (cụ thể là Inter) cho `CustomButton` và các text trên trang Onboarding.

## Các quyết định đang hoạt động
- Sử dụng Bloc/Cubit làm giải pháp quản lý trạng thái
- Áp dụng go_router cho việc điều hướng
- Thiết kế UI theo Material Design 3
- Lưu trữ dữ liệu trên Firestore
- Sử dụng `flutter_svg` cho các tài sản hình ảnh vector.
- Sử dụng `google_fonts` để quản lý và áp dụng font chữ nhất quán.

## Các vấn đề đang xem xét
- Thực hiện tính năng đăng nhập/đăng ký người dùng
- Xây dựng trang dashboard để hiển thị tổng quan tài chính
- Thiết kế màn hình thêm/sửa giao dịch
- Kết nối và đồng bộ dữ liệu offline

## Trở ngại hiện tại
- Xác thực và quản lý phiên người dùng
- Thiết kế UI/UX phù hợp cho dashboard
- Tối ưu hóa tốc độ truy vấn Firestore
- Testing các tình huống đồng bộ dữ liệu

## Ưu tiên ngắn hạn
1. Hoàn thiện quản lý xác thực người dùng
2. Xây dựng màn hình chính với các thông tin tổng quan
3. Phát triển tính năng ghi nhận giao dịch
4. Thiết kế và triển khai quản lý danh mục

## Nhiệm vụ sắp tới
- Hoàn thiện thiết kế cơ sở dữ liệu Firestore
- Triển khai repository cho các entity chính
- Phát triển UI cho màn hình dashboard
- Xây dựng hệ thống phân quyền người dùng 