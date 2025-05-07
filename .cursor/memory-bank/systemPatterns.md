# System Patterns: Money Mate

## Kiến trúc tổng thể
Money Mate được xây dựng theo **Clean Architecture** với ba lớp chính:

```
┌────────────────────┐
│  Presentation      │
├────────────────────┤
│  Domain            │
├────────────────────┤
│  Data              │
└────────────────────┘
```

### 1. Presentation Layer (UI)
- Sử dụng mẫu thiết kế Flutter Bloc/Cubit để quản lý trạng thái
- Tách biệt giao diện người dùng khỏi logic nghiệp vụ
- Các thành phần:
  - Screens: Các màn hình chính của ứng dụng
  - Widgets: Các thành phần UI có thể tái sử dụng
    - `CustomButton`: Widget nút tùy chỉnh, hỗ trợ gradient, `buttonTextStyle` cho phép tùy chỉnh font, size, weight, color, và các thuộc tính style khác. Đã được cập nhật để tăng tính linh hoạt.
    - `_OnboardingSlide`: Widget cục bộ được sử dụng trong `OnboardingPage` để hiển thị nội dung từng slide (hình ảnh SVG, tiêu đề, mô tả).
  - Blocs/Cubits: Quản lý trạng thái và logic UI
  - Routes: Quản lý điều hướng ứng dụng

### 2. Domain Layer
- Chứa các business rules độc lập với framework
- Không phụ thuộc vào bất kỳ tầng nào khác
- Các thành phần:
  - Entities: Các đối tượng domain chính
  - Use Cases: Các trường hợp sử dụng của ứng dụng
  - Repository Interfaces: Định nghĩa các interfaces cho repositories

### 3. Data Layer
- Quản lý truy cập dữ liệu từ nhiều nguồn
- Triển khai các interfaces được định nghĩa trong domain layer
- Các thành phần:
  - Repositories: Triển khai repository interfaces từ domain layer
  - Data Sources: Nguồn dữ liệu (Firebase, local storage)
  - Models: Các mô hình dữ liệu, thường map từ entities

## Design Patterns
- **Repository Pattern**: Trừu tượng hóa truy cập dữ liệu
- **Dependency Injection**: Sử dụng thư viện get_it để quản lý dependencies
- **BLoC/Cubit Pattern**: Quản lý trạng thái với luồng dữ liệu một chiều
- **Factory Pattern**: Tạo đối tượng theo yêu cầu
- **Singleton Pattern**: Đảm bảo các services chỉ có một instance

## Quản lý trạng thái
Sử dụng Flutter Bloc/Cubit với các trạng thái chính:
- Initial: Trạng thái khởi tạo
- Loading: Đang tải dữ liệu
- Loaded: Đã tải dữ liệu thành công
- Error: Lỗi khi tải dữ liệu

## Luồng dữ liệu
```
┌────────────┐    ┌────────────┐    ┌────────────┐    ┌────────────┐
│            │    │            │    │            │    │            │
│    UI      │───▶│ Bloc/Cubit │───▶│  Use Case  │───▶│ Repository │
│            │    │            │    │            │    │            │
└────────────┘    └────────────┘    └────────────┘    └────────────┘
                                                            │
                                                            ▼
                                                      ┌────────────┐
                                                      │            │
                                                      │ Data Source│
                                                      │            │
                                                      └────────────┘
```

## Mô hình dữ liệu chính
- **User**: Thông tin người dùng
- **Transaction**: Giao dịch tài chính
- **Category**: Danh mục giao dịch
- **Budget**: Ngân sách theo danh mục hoặc thời gian

## Chiến lược Testing
- **Unit Tests**: Kiểm thử các thành phần độc lập
- **Widget Tests**: Kiểm thử UI widgets
- **Integration Tests**: Kiểm thử tích hợp các thành phần
- **Mocking**: Sử dụng mockito cho việc mô phỏng dependencies 