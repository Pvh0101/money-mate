import 'package:flutter/material.dart';
import 'pages/summary_page.dart';

/// Định nghĩa các route cho tính năng Summary
class SummaryRoutes {
  static const String summary = '/summary';

  /// Đăng ký các route với RouteSettings
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case summary:
        return MaterialPageRoute(
          builder: (_) => const SummaryPage(),
          settings: settings,
        );
      default:
        throw Exception('Route không tồn tại: ${settings.name}');
    }
  }
}
