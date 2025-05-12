import 'package:flutter/material.dart';
import 'package:money_mate/features/transactions/presentation/pages/total_expense_page.dart';
import 'package:money_mate/features/transactions/presentation/pages/total_income_page.dart';
import '../../features/authentication/presentation/pages/forgot_password_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/password_updated_page.dart';
import '../../features/authentication/presentation/pages/register_page.dart';
import 'package:money_mate/features/home/home_screen.dart';
import '../../features/authentication/presentation/pages/onboarding_page.dart';
import '../../features/transactions/presentation/pages/add_entry_page.dart';
import '../../features/transactions/presentation/pages/add_income_page.dart';
import '../../features/transactions/presentation/pages/add_expense_page.dart';
import '../../features/summary/presentation/pages/summary_page.dart';
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
      case RouteConstants.addEntry:
        return _materialRoute(const AddEntryPage());
      case RouteConstants.addIncome:
        return _materialRoute(const AddIncomePage());
      case RouteConstants.addExpense:
        return _materialRoute(const AddExpensePage());
      case RouteConstants.totalIncome:
        return _materialRoute(const TotalIncomePage());
      case RouteConstants.totalExpense:
        return _materialRoute(const TotalExpensePage());
      case RouteConstants.summary:
        return _materialRoute(const SummaryPage());
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
