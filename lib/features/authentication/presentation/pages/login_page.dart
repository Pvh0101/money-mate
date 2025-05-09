import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/core/core.dart';
import '../widgets/auth_layout.dart';
import '../widgets/auth_or_divider.dart';
import '../widgets/social_auth_section.dart';
import '../widgets/auth_footer_link.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return AuthLayout(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Routes.navigateToReplacement(context, RouteConstants.home);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: _buildFormContents(context, emailController, passwordController),
      ),
    );
  }

  Widget _buildFormContents(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          controller: emailController,
          hintText: 'Email',
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: passwordController,
          hintText: 'Password',
          prefixIcon: Icons.lock_outline,
        ),
        const SizedBox(height: 24),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return AppFillButton(
              size: ButtonSize.large,
              isFullWidth: true,
              text: 'LOGIN',
              isLoading: isLoading,
              onPressed: isLoading
                  ? null
                  : () {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      String? emailError = Validator.validateEmailField(email);

                      String? passwordError;
                      if (!Validator.isNotEmpty(password)) {
                        passwordError = 'Mật khẩu không được để trống';
                      }

                      if (emailError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(emailError),
                              backgroundColor: Colors.red),
                        );
                        return;
                      }
                      if (passwordError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(passwordError),
                              backgroundColor: Colors.red),
                        );
                        return;
                      }

                      context.read<AuthBloc>().add(
                            LoginWithEmailPasswordRequested(
                              email: email,
                              password: password,
                            ),
                          );
                    },
            );
          },
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: () {
            Routes.navigateTo(context, RouteConstants.forgotPassword);
          },
          style: TextButton.styleFrom(
            minimumSize: const Size(44, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'FORGOT PASSWORD',
            style: TextStyle(
              color: Color(0xFF6B7580),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const AuthOrDivider(),
        const SizedBox(height: 8),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return SocialAuthSection(
              isLogin: true,
              isLoading: isLoading,
              onGooglePressed: isLoading
                  ? null
                  : () {
                      context
                          .read<AuthBloc>()
                          .add(const LoginWithGoogleRequested());
                    },
              onApplePressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Chức năng đăng nhập Apple chưa được hỗ trợ.')),
                );
              },
            );
          },
        ),
        const SizedBox(height: 24),
        AuthFooterLink(
          isLogin: true,
          onPressed: () {
            Routes.navigateTo(context, RouteConstants.register);
          },
        ),
      ],
    );
  }
}
