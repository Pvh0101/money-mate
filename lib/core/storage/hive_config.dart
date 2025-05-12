import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_mate/features/authentication/data/models/user_hive_model.dart';
import 'package:money_mate/features/categories/data/models/category_hive_model.dart';
import 'package:money_mate/features/transactions/data/models/transaction_hive_model.dart';
import 'package:money_mate/features/summary/data/models/summary_hive_model.dart';
import 'package:money_mate/core/models/app_settings_hive_model.dart';

/// Tên các box Hive
class HiveBoxes {
  static const String categoriesBox = 'categories';
  static const String transactionsBox = 'transactions';
  static const String userBox = 'user';
  static const String settingsBox = 'settings';
  static const String summaryBox = 'summary';
}

/// Khóa cho các giá trị trong box
class HiveKeys {
  static const String currentUser = 'current_user';
  static const String appSettings = 'app_settings';
}

/// Type ID cho các adapter
class HiveTypeIds {
  static const int transaction = 1;
  static const int category = 2;
  static const int user = 3;
  static const int appSettings = 4;
  static const int summary = 5;
}

/// Đăng ký tất cả các adapter
Future<void> registerHiveAdapters() async {
  // Đăng ký các adapter sau khi chạy build_runner để tạo ra các file .g.dart
  Hive.registerAdapter(TransactionHiveModelAdapter());
  Hive.registerAdapter(CategoryHiveModelAdapter());
  Hive.registerAdapter(UserHiveModelAdapter());
  Hive.registerAdapter(AppSettingsHiveModelAdapter());
  Hive.registerAdapter(SummaryHiveModelAdapter());
}
