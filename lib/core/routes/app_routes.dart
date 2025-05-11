import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_bloc.dart';

import '../../features/authentication/presentation/pages/forgot_password_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/password_updated_page.dart';
import '../../features/authentication/presentation/pages/register_page.dart';
// import '../../features/authentication/presentation/widgets/home_page.dart'; // Đã comment/xóa ở bước trước nếu thành công
import 'package:money_mate/features/home/home_screen.dart';
import '../../features/authentication/presentation/pages/onboarding_page.dart';
import '../../features/transactions/presentation/pages/add_entry_page.dart';
import '../../features/transactions/presentation/pages/add_income_page.dart';
import '../../features/transactions/presentation/pages/add_expense_page.dart';
import '../constants/route_constants.dart';
import '../di/service_locator.dart';

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

  // Giữ lại phương thức này để tham khảo sau này nếu cần
  static Route<dynamic> _materialRouteWithCategoryBloc(Widget view) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider<CategoryBloc>(
        create: (_) => sl<CategoryBloc>(),
        child: view,
      ),
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
