import 'package:flutter/material.dart';
import '../../../../core/widgets/buttons/app_fill_button.dart';
import '../../../../core/widgets/buttons/button_enums.dart';
import '../../../../core/widgets/fields/custom_text_field.dart';
import '../../widgets/auth_layout.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/constants/route_constants.dart';
import '../../widgets/auth_error_toast.dart';
import '../../widgets/auth_or_divider.dart';
import '../../widgets/social_auth_section.dart';
import '../../widgets/auth_footer_link.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      errorToast: _hasError 
          ? const AuthErrorToast(message: 'Incorrect username or password')
          : null,
      child: _buildFormSection(),
    );
  }

  Widget _buildFormSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Username field
        CustomTextField(
          controller: _usernameController,
          hintText: 'Username',
          prefixIcon: Icons.person_outline,
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
          onSuffixIconTap: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        const SizedBox(height: 24),

        // Login button
        AppFillButton(
          size: ButtonSize.large,
          isFullWidth: true,
          text: 'LOGIN',
          isLoading: _isLoading,
          onPressed: _handleLogin,
        ),
        const SizedBox(height: 24),

        // Forgot password
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

        // Social buttons
        SocialAuthSection(
          isLogin: true,
          isLoading: _isLoading,
          onGooglePressed: () {
            // Handle Google login
          },
          onApplePressed: () {
            // Handle Apple login
          },
        ),
        const SizedBox(height: 24),

        // Register link
        AuthFooterLink(
          isLogin: true,
          onPressed: () {
            Routes.navigateTo(context, RouteConstants.register);
          },
        ),
      ],
    );
  }

  Future<void> _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _hasError = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }
}
