import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/widgets/buttons/app_fill_button.dart';
import '../../../../core/widgets/buttons/button_enums.dart';
import '../../../../core/widgets/fields/custom_text_field.dart';
import '../widgets/auth_layout.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/error_toast.dart';
import '../widgets/auth_or_divider.dart';
import '../widgets/social_auth_section.dart';
import '../widgets/auth_footer_link.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: const RegisterPageView(),
    );
  }
}

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  @override
  State<RegisterPageView> createState() => _RegisterPageViewState();
}

class _RegisterPageViewState extends State<RegisterPageView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() {
            _hasError = false;
          });
        } else if (state is AuthError) {
          setState(() {
            _hasError = true;
            _errorMessage = state.message;
          });
        } else if (state is AuthSuccess) {
          // Điều hướng đến trang home sau khi đăng ký thành công
          Routes.navigateTo(context, RouteConstants.home);
        }
      },
      child: AuthLayout(
        errorToast: _hasError ? ErrorToast(message: _errorMessage) : null,
        child: _buildFormSection(),
      ),
    );
  }

  Widget _buildFormSection() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Email field
            CustomTextField(
              controller: _emailController,
              hintText: 'Email',
              prefixIcon: Icons.email_outlined,
              enabled: !isLoading,
            ),
            const SizedBox(height: 20),

            // Password field
            CustomTextField(
              controller: _passwordController,
              hintText: 'Password',
              prefixIcon: Icons.lock_outline,
              suffixIcon: _isPasswordVisible
                  ? Icons.visibility_off
                  : Icons.visibility_outlined,
              isPassword: !_isPasswordVisible,
              enabled: !isLoading,
              onSuffixIconTap: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 20),

            // Confirm Password field
            CustomTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm Password',
              prefixIcon: Icons.lock_outline,
              suffixIcon: _isConfirmPasswordVisible
                  ? Icons.visibility_off
                  : Icons.visibility_outlined,
              isPassword: !_isConfirmPasswordVisible,
              enabled: !isLoading,
              onSuffixIconTap: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 24),

            // Register button
            AppFillButton(
              size: ButtonSize.large,
              isFullWidth: true,
              text: 'REGISTER',
              isLoading: isLoading,
              onPressed: _handleRegister,
            ),
            const SizedBox(height: 24),

            const AuthOrDivider(text: 'Hoặc'),
            const SizedBox(height: 8),

            // Social buttons
            SocialAuthSection(
              isLogin: false,
              isLoading: isLoading,
              onGooglePressed: () {
                context.read<AuthBloc>().add(
                      const RegisterWithGoogleEvent(),
                    );
              },
              onApplePressed: () {
                // TODO: Implement Apple registration
              },
            ),
            const SizedBox(height: 24),

            // Login link
            AuthFooterLink(
              isLogin: false,
              onPressed: () {
                Routes.navigateTo(context, RouteConstants.login);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleRegister() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Vui lòng điền đầy đủ thông tin';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Mật khẩu nhập lại không khớp';
      });
      return;
    }

    // Basic email validation
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegExp.hasMatch(_emailController.text)) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Email không hợp lệ';
      });
      return;
    }

    context.read<AuthBloc>().add(RegisterWithEmailEvent(
          email: _emailController.text,
          password: _passwordController.text,
        ));
  }
}
