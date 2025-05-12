# Hướng dẫn thiết lập và sử dụng Hive trong Money Mate

## 1. Giới thiệu

Hive là một cơ sở dữ liệu NoSQL nhẹ, nhanh chóng và dễ sử dụng cho Flutter. Nó được thiết kế để tối ưu hóa hiệu suất và lưu trữ dữ liệu cục bộ trên thiết bị.

Trong Money Mate, chúng ta sử dụng Hive để:
- Lưu trữ dữ liệu offline khi không có kết nối mạng
- Cache dữ liệu để tăng tốc độ tải ứng dụng
- Lưu trữ cài đặt người dùng

## 2. Cấu trúc Hive trong Money Mate

### Model Hive

Chúng ta có 4 model chính:
- `TransactionHiveModel`: Lưu trữ thông tin giao dịch
- `CategoryHiveModel`: Lưu trữ thông tin danh mục
- `UserHiveModel`: Lưu trữ thông tin người dùng
- `AppSettingsHiveModel`: Lưu trữ cài đặt ứng dụng

### Boxes

Dữ liệu Hive được lưu trữ trong các "box" (tương tự như các bảng trong SQL):
- `categories`: Lưu trữ danh mục
- `transactions`: Lưu trữ giao dịch
- `user`: Lưu trữ thông tin người dùng
- `settings`: Lưu trữ cài đặt ứng dụng

## 3. Thiết lập Hive

Trước khi sử dụng Hive, bạn cần thực hiện các bước sau:

1. **Tạo adapter cho model**:
   ```bash
   # Chạy build_runner để tạo các file .g.dart
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
   Hoặc chạy script đã tạo sẵn:
   ```bash
   # Đảm bảo script có quyền thực thi
   chmod +x build_hive.sh
   # Chạy script
   ./build_hive.sh
   ```

2. **Mở comment trong HiveService.init()**: Sau khi tạo các adapter, vào file `lib/core/storage/hive_service.dart` và mở comment để đăng ký các adapter:
   ```dart
   // Mở comment dòng này sau khi chạy build_runner
   await registerHiveAdapters();
   ```

## 4. Sử dụng Hive trong project

### Lưu trữ và đọc dữ liệu

```dart
// Lưu trữ dữ liệu vào box
final transactionsBox = HiveService.getBox(HiveBoxes.transactionsBox);
final transactionModel = TransactionHiveModel.fromEntity(transaction);
await transactionsBox.put(transaction.id, transactionModel);

// Đọc dữ liệu từ box
final transactionModel = transactionsBox.get(transactionId);
if (transactionModel != null) {
  return transactionModel.toEntity();
}
```

### Lưu và đọc người dùng hiện tại

```dart
// Lưu thông tin người dùng hiện tại
final userModel = UserHiveModel.fromEntity(user);
await HiveService.saveCurrentUser(userModel);

// Đọc thông tin người dùng hiện tại
final userModel = HiveService.getCurrentUser();
if (userModel != null) {
  return userModel.toEntity();
}
```

### Lưu và đọc cài đặt ứng dụng

```dart
// Lưu cài đặt ứng dụng
final settings = AppSettingsHiveModel(
  isDarkMode: true,
  language: 'vi',
);
await HiveService.saveAppSettings(settings);

// Đọc cài đặt ứng dụng
final settings = HiveService.getAppSettings();
```

## 5. Triển khai trong Repository

Để tuân thủ Clean Architecture, bạn nên triển khai Hive trong lớp Repository:

```dart
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final Box transactionsBox;

  TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.transactionsBox,
  });

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions({String? userId}) async {
    if (await networkInfo.isConnected) {
      try {
        // Lấy dữ liệu từ remote
        final transactions = await remoteDataSource.getTransactions(userId: userId);
        
        // Cache dữ liệu vào Hive
        for (var transaction in transactions) {
          final hiveModel = TransactionHiveModel.fromEntity(transaction);
          await transactionsBox.put(transaction.id, hiveModel);
        }
        
        return Right(transactions);
      } catch (e) {
        return const Left(ServerFailure());
      }
    } else {
      // Khi không có kết nối, lấy dữ liệu từ Hive
      try {
        final cachedTransactions = transactionsBox.values
            .map((model) => (model as TransactionHiveModel).toEntity())
            .toList();
        
        if (userId != null) {
          return Right(cachedTransactions
              .where((transaction) => transaction.userId == userId)
              .toList());
        }
        
        return Right(cachedTransactions);
      } catch (e) {
        return const Left(CacheFailure());
      }
    }
  }
}
```

## 6. Xóa dữ liệu khi đăng xuất

Khi người dùng đăng xuất, bạn nên xóa dữ liệu cục bộ:

```dart
Future<void> logout() async {
  // Xử lý đăng xuất
  await authService.signOut();
  
  // Xóa dữ liệu cục bộ
  await HiveService.clearAllData();
  
  // Khởi tạo lại các box
  await HiveService.init();
}
```

## 7. Các lỗi thường gặp

1. **Chưa chạy build_runner**: Lỗi "Type 'XAdapter' not found" - Chạy build_runner để tạo các adapter.
2. **Sai TypeId**: TypeId không được trùng nhau giữa các model.
3. **Chưa đăng ký adapter**: Đảm bảo gọi registerAdapter trước khi sử dụng.
4. **Chưa mở box**: Đảm bảo đã mở box trước khi sử dụng.

## 8. Tài liệu tham khảo

- [Hive Documentation](https://docs.hivedb.dev/)
- [Flutter Hive Tutorial](https://pub.dev/packages/hive)
- [Flutter Hive Database](https://pub.dev/packages/hive_flutter) 