import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/core/di/service_locator.dart';
import 'package:money_mate/presentation/bloc/auth/auth_bloc.dart';
import 'package:money_mate/presentation/widgets/buttons/app_fill_button.dart';
import 'package:money_mate/presentation/widgets/buttons/button_enums.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/logo_section.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/constants/route_constants.dart';

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
  final TextEditingController _confirmPasswordController = TextEditingController();
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
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          // Logo section
                          const LogoSection(),
                          const SizedBox(height: 52),

                          // Form section
                          if (_hasError) ...[
                            _ErrorToast(message: _errorMessage),
                            const SizedBox(height: 16),
                          ],
                          _buildFormSection(),

                          const Spacer(),
                          // Bottom indicator
                          Container(
                            height: 34,
                            margin: const EdgeInsets.only(bottom: 8),
                            alignment: Alignment.center,
                            child: Container(
                              width: 135,
                              height: 5,
                              decoration: BoxDecoration(
                                color: const Color(0xFF242D35),
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
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

            const _OrDivider(),
            const SizedBox(height: 8),

            // Social buttons
            _SocialLoginSection(isLoading: isLoading),
            const SizedBox(height: 24),

            // Login link
            const _LoginLink(),
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

class _ErrorToast extends StatelessWidget {
  final String message;
  const _ErrorToast({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD7D7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFEF4E4E),
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFEF4E4E),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: const Color(0xFFDCDFE3))),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Hoặc',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7580),
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: const Color(0xFFDCDFE3))),
        ],
      ),
    );
  }
}

class _SocialLoginSection extends StatelessWidget {
  final bool isLoading;
  
  const _SocialLoginSection({this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialLoginButton(
          text: 'ĐĂNG KÝ VỚI GOOGLE',
          onPressed: isLoading 
              ? null 
              : () {
                  context.read<AuthBloc>().add(
                    const RegisterWithGoogleEvent(),
                  );
                },
          icon: 'assets/icons/google_icon.png',
        ),
        const SizedBox(height: 20),
        _SocialLoginButton(
          text: 'ĐĂNG KÝ VỚI APPLE',
          onPressed: isLoading ? null : () {
            // TODO: Implement Apple registration
          },
          icon: 'assets/icons/apple_icon.png',
        ),
      ],
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback? onPressed;

  const _SocialLoginButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFB0B8BF)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon on the left
            Image.asset(
              icon,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 20),
            // Centered text
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginLink extends StatelessWidget {
  const _LoginLink();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Đã có tài khoản?',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigate to Login Page
            Routes.navigateTo(context, RouteConstants.login);
          },
          child: const Text(
            'Đăng nhập ngay',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF0E33F3),
            ),
          ),
        ),
      ],
    );
  }
} 