import 'package:flutter/foundation.dart';

/// Lớp quản lý sự kiện toàn cục trong ứng dụng
class AppEvents {
  /// Singleton instance
  static final AppEvents _instance = AppEvents._internal();

  factory AppEvents() => _instance;

  AppEvents._internal();

  /// Event bus cho giao dịch thay đổi (thêm, sửa, xóa)
  final ValueNotifier<bool> transactionChanged = ValueNotifier<bool>(false);

  /// Phương thức thông báo khi có giao dịch mới được thêm, sửa hoặc xóa
  void notifyTransactionChanged() {
    transactionChanged.value = !transactionChanged.value;
    debugPrint('AppEvents: Transaction changed notification sent');
  }
}

/// Singleton instance để sử dụng trong toàn bộ ứng dụng
final appEvents = AppEvents();
