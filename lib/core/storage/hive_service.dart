import 'package:hive_flutter/hive_flutter.dart';
import 'hive_config.dart';

class HiveService {
  /// Khởi tạo Hive
  static Future<void> init() async {
    // Khởi tạo Hive Flutter
    await Hive.initFlutter();

    // Đăng ký các adapter - LƯU Ý: Chỉ gọi hàm này sau khi đã chạy build_runner
    // Hàm này sẽ gây lỗi nếu các file .g.dart chưa được tạo
    await registerHiveAdapters();

    // Mở các box chính
    await Hive.openBox(HiveBoxes.categoriesBox);
    await Hive.openBox(HiveBoxes.transactionsBox);
    await Hive.openBox(HiveBoxes.userBox);
    await Hive.openBox(HiveBoxes.settingsBox);
    await Hive.openBox(HiveBoxes.summaryBox);
  }

  /// Đóng tất cả các box Hive
  static Future<void> closeBoxes() async {
    await Hive.close();
  }

  /// Xóa toàn bộ dữ liệu Hive (chỉ dùng khi cần thiết, ví dụ: đăng xuất)
  static Future<void> clearAllData() async {
    await Hive.deleteBoxFromDisk(HiveBoxes.categoriesBox);
    await Hive.deleteBoxFromDisk(HiveBoxes.transactionsBox);
    await Hive.deleteBoxFromDisk(HiveBoxes.userBox);
    await Hive.deleteBoxFromDisk(HiveBoxes.settingsBox);
    await Hive.deleteBoxFromDisk(HiveBoxes.summaryBox);
  }

  /// Lấy box theo tên
  static Box getBox(String boxName) {
    return Hive.box(boxName);
  }

  /// Lấy box kiểu T
  static Box<T> getTypedBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }

  /// Lưu dữ liệu người dùng hiện tại
  static Future<void> saveCurrentUser(dynamic userModel) async {
    final box = Hive.box(HiveBoxes.userBox);
    await box.put(HiveKeys.currentUser, userModel);
  }

  /// Lấy dữ liệu người dùng hiện tại
  static dynamic getCurrentUser() {
    final box = Hive.box(HiveBoxes.userBox);
    return box.get(HiveKeys.currentUser);
  }

  /// Lưu cài đặt ứng dụng
  static Future<void> saveAppSettings(dynamic settings) async {
    final box = Hive.box(HiveBoxes.settingsBox);
    await box.put(HiveKeys.appSettings, settings);
  }

  /// Lấy cài đặt ứng dụng
  static dynamic getAppSettings() {
    final box = Hive.box(HiveBoxes.settingsBox);
    return box.get(HiveKeys.appSettings);
  }
}
