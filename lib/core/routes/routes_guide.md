# Hướng dẫn sử dụng hệ thống routing trong Money Mate

## Cấu trúc hệ thống routing

1. **RouteConstants**: Chứa tất cả các tên route được định nghĩa dưới dạng hằng số
   - Vị trí: `lib/core/constants/route_constants.dart`

2. **Routes**: Lớp chính để quản lý tất cả các route trong ứng dụng
   - Vị trí: `lib/core/routes/app_routes.dart`
   - Phương thức `generateRoute`: Tạo route dựa trên tên route
   - Các helper method để điều hướng

## Cách thêm màn hình mới

1. Tạo màn hình mới trong thư mục `lib/presentation/pages`

2. Thêm đường dẫn vào `RouteConstants` trong `route_constants.dart`:
   ```dart
   static const String myNewScreen = '/my-new-screen';
   ```

3. Cập nhật `Routes.generateRoute` trong `app_routes.dart`:
   ```dart
   case RouteConstants.myNewScreen:
     return _materialRoute(const MyNewScreen());
   ```

4. Thêm import cho màn hình mới ở đầu file `app_routes.dart`

## Cách sử dụng để điều hướng

### Điều hướng đến màn hình mới
```dart
Routes.navigateTo(context, RouteConstants.login);
```

### Thay thế màn hình hiện tại (không quay lại được)
```dart
Routes.navigateToReplacement(context, RouteConstants.home);
```

### Xóa tất cả màn hình trong stack và điều hướng đến màn hình mới
```dart
Routes.navigateAndRemoveUntil(context, RouteConstants.home);
```

### Quay lại màn hình trước đó
```dart
Routes.pop(context);
```

### Điều hướng đến màn hình mới và nhận kết quả trả về
```dart
var result = await Routes.navigateWithResult(context, RouteConstants.login);
```

## Truyền tham số giữa các màn hình

Để truyền tham số giữa các màn hình, bạn có thể sử dụng tham số `arguments` trong các phương thức điều hướng:

```dart
Routes.navigateTo(
  context,
  RouteConstants.login,
  arguments: {'key': 'value'},
);
```

Sau đó truy cập trong widget đích:
```dart
final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
final value = args['key'];
```

## Tuỳ chỉnh animation

Để tuỳ chỉnh animation, bạn có thể thêm các phương thức mới vào `Routes` với cách chuyển trang khác nhau, ví dụ:

```dart
static Route _slideUpRoute(Widget view) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => view,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
} 