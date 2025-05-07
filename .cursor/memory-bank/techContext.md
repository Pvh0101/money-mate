# Tech Context: Money Mate

## Công nghệ nền tảng
- **Flutter**: Framework UI đa nền tảng từ Google
- **Dart**: Ngôn ngữ lập trình được sử dụng với Flutter
- **Firebase**: Nền tảng backend-as-a-service từ Google

## Phiên bản & Dependencies
- Flutter SDK: >= 3.1.3
- Dart SDK: >= 3.1.3 < 4.0.0
- Dependencies chính:
  - firebase_core: ^2.24.2
  - firebase_auth: ^4.15.3
  - cloud_firestore: ^4.13.6
  - firebase_messaging: ^14.7.9
  - flutter_bloc: ^9.1.1
  - fl_chart: ^0.71.0
  - shimmer: ^3.0.0
  - uuid: ^4.3.3
  - equatable: ^2.0.5
  - google_sign_in: ^6.2.1
  - smooth_page_indicator: ^1.1.0
  - google_fonts: ^6.1.0
  - go_router: ^13.2.0

## Thành phần Firebase
- **Firebase Authentication**: Xác thực người dùng
- **Cloud Firestore**: Cơ sở dữ liệu NoSQL cho dữ liệu ứng dụng
- **Firebase Cloud Messaging**: Thông báo đẩy
- **Firebase Analytics**: Phân tích hành vi người dùng

## Môi trường phát triển
- IDE: VS Code/Android Studio
- Quản lý state: Flutter Bloc/Cubit
- Định tuyến: go_router
- Quản lý giao diện: Material Design 3
- Animation: Flutter built-in animation + custom animations

## Cấu trúc thư mục
```
lib/
  ├── core/            # Các tiện ích, hằng số, config, extensions
  ├── domain/          # Entities, use cases, repository interfaces
  ├── data/            # Data sources, repositories, models
  ├── presentation/    # UI components (screens, widgets, blocs)
  ├── firebase_options.dart
  └── main.dart        # Entry point
```

## Nền tảng hỗ trợ
- **Mobile**: Android, iOS
- **Web**: Progressive Web App
- **Desktop**: Windows, macOS, Linux (experimental)

## Điểm triển khai
- Google Play Store (Android)
- Apple App Store (iOS)
- Firebase Hosting (Web)

## Cơ sở dữ liệu
**Firestore Collections**:
- users: Thông tin người dùng
- transactions: Giao dịch tài chính
- categories: Danh mục giao dịch
- budgets: Cài đặt ngân sách

## An ninh & Quyền riêng tư
- Xác thực Firebase với email/password và OAuth providers
- Rules Firestore bảo vệ dữ liệu người dùng
- Mã hóa dữ liệu nhạy cảm
- Tuân thủ GDPR và các quy định bảo mật dữ liệu

## Chiến lược thử nghiệm
- **Unit tests**: Kiểm thử logic nghiệp vụ và repositories
- **Widget tests**: Kiểm thử UI components và màn hình
- **Integration tests**: Kiểm thử luồng người dùng end-to-end
- **Firebase Emulator**: Thử nghiệm tích hợp Firebase

## CI/CD
- GitHub Actions cho CI/CD
- Tự động kiểm tra, build và triển khai
- Phiên bản beta và production channels 