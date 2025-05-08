import 'package:flutter/material.dart';

import '../../features/authentication/presentation/pages/forgot_password_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/password_updated_page.dart';
import '../../features/authentication/presentation/pages/register_page.dart';
// import '../../features/authentication/presentation/widgets/home_page.dart'; // Đã comment/xóa ở bước trước nếu thành công
import 'package:money_mate/features/home/presentation/pages/home_screen.dart'; 
import '../../features/authentication/presentation/pages/onboarding_page.dart';
import '../constants/route_constants.dart';

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
      case RouteConstants.register:
        return _materialRoute(const RegisterPage());
      case RouteConstants.forgotPassword:
        return _materialRoute(const ForgotPasswordPage());
      case RouteConstants.passwordUpdated:
        return _materialRoute(const PasswordUpdatedPage());
      case RouteConstants.home:
        return _materialRoute(const HomeScreen());
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
