import 'package:flutter/material.dart';
import '../constants/route_constants.dart';
import '../../presentation/pages/onboarding/onboarding_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/home_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.splash:
        // Thay thế bằng SplashPage khi có
        return _materialRoute(const OnboardingPage());
      case RouteConstants.onboarding:
        return _materialRoute(const OnboardingPage());
      case RouteConstants.login:
        return _materialRoute(const LoginPage());
      case RouteConstants.home:
        return _materialRoute(const HomePage());
      // Các routes khác sẽ được thêm khi có file tương ứng
      default:
        return _materialRoute(const OnboardingPage());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(
      builder: (_) => view,
    );
  }

  // Helper methods để điều hướng
  static void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void navigateToReplacement(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static void navigateAndRemoveUntil(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }

  static Future<T?> navigateWithResult<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }
}
