import 'package:flutter/material.dart';

import '../../feartures/presentation/pages/auth/forgot_password_page.dart';
import '../../feartures/presentation/pages/auth/login_page.dart';
import '../../feartures/presentation/pages/auth/password_updated_page.dart';
import '../../feartures/presentation/pages/auth/register_page.dart';
import '../../feartures/presentation/widgets/home_page.dart';
import '../../feartures/presentation/pages/auth/onboarding_page.dart';
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
