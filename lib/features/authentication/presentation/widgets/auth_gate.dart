import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/features/authentication/presentation/pages/onboarding_page.dart';
import 'package:money_mate/features/home/home_screen.dart';
import '../bloc/auth_bloc.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  // Không cần routeName tĩnh nếu nó là home/initial của MaterialApp

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const HomeScreen(); // Hiển thị trực tiếp HomePage
        } else if (state is Unauthenticated) {
          return const OnboardingPage(); // Hiển thị trực tiếp OnboardingPage
        } else {
          // AuthInitial, AuthLoading, hoặc AuthError (trạng thái lỗi ban đầu chưa xử lý)
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
} 