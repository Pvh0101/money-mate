
---

## Quy tắc gen code Flutter từ Figma

### 1. **Sử dụng màu sắc và text từ app_theme**
- **Luôn sử dụng các màu sắc, font, text style được định nghĩa trong `app_theme` (thường nằm trong `lib/core/theme/`).**
- Không hard-code màu sắc, font size, font family, hay text style trong widget.
- Khi cần màu hoặc text style, hãy gọi qua context hoặc trực tiếp từ theme, ví dụ:
  ```dart
  color: Theme.of(context).colorScheme.primary,
  style: Theme.of(context).textTheme.titleLarge,
  ```
- Nếu Figma có màu mới, hãy thêm vào `app_theme` trước, sau đó mới sử dụng.

---

### 2. **Tuân thủ Clean Architecture & Feature-first**
- Mỗi UI component sinh ra từ Figma phải nằm trong đúng feature, ví dụ:  
  `lib/features/ten_feature/presentation/widgets/`
- Không để logic xử lý trong widget, chỉ nhận dữ liệu qua constructor hoặc Bloc.
- Nếu widget cần dữ liệu động, sử dụng Bloc/Cubit để quản lý state.
- Không import trực tiếp từ feature khác, chỉ dùng core hoặc nội bộ feature.

---

### 3. **Code clean, dễ mở rộng**
- Tách nhỏ widget, mỗi widget chỉ nên đảm nhiệm một vai trò.
- Đặt tên widget, biến, hàm rõ ràng, đúng ngữ nghĩa.
- Sử dụng const constructor khi có thể.
- Nếu có nhiều biến thể (variant) của một widget, dùng enum hoặc factory constructor.
- Không lặp lại code, trích xuất phần dùng chung thành widget riêng hoặc extension.
- Đảm bảo null safety, không để warning/lint error.


---

### 4. **Quy chuẩn về style và cấu trúc**
- Sử dụng Freezed cho state nếu có Bloc/Cubit liên quan.
- Sử dụng Dartz cho xử lý lỗi nếu có logic.
- Đảm bảo tuân thủ các quy tắc lint của dự án (`flutter_lints`).
- Không để logic xử lý dữ liệu trong UI, chỉ nhận dữ liệu đã xử lý từ Bloc hoặc UseCase.
- Nếu cần animation, sử dụng widget Flutter chuẩn, không tự custom trừ khi thực sự cần thiết.

---

### 5. **Ví dụ sử dụng theme**
```dart
Text(
  'Tiêu đề',
  style: Theme.of(context).textTheme.titleLarge?.copyWith(
    color: Theme.of(context).colorScheme.primary,
  ),
)
```
```dart
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.background,
    borderRadius: BorderRadius.circular(16),
  ),
)
```

---

### 6. **Luồng phát triển**
1. **Phân tích Figma:** Xác định rõ các thành phần UI, màu sắc, text style.
2. **Cập nhật app_theme:** Nếu có màu/text style mới, thêm vào `app_theme`.
3. **Tạo widget:** Đặt trong đúng thư mục feature, sử dụng theme cho mọi style.
4. **Kết nối Bloc/Cubit:** Nếu cần dữ liệu động, kết nối qua BlocProvider.
5. **Kiểm tra lint:** Đảm bảo không có warning/error, code dễ đọc, dễ mở rộng.

---

**Tóm lại:**  
- Không hard-code style, luôn lấy từ theme.
- Đặt widget đúng feature, không lẫn lộn.
- Code sạch, tách nhỏ, dễ bảo trì.
- Tuân thủ Clean Architecture, Feature-first, và các quy chuẩn của dự án.

---
