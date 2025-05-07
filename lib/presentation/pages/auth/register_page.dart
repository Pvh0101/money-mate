import 'package:flutter/material.dart';
import 'package:money_mate/presentation/widgets/buttons/app_fill_button.dart';
import 'package:money_mate/presentation/widgets/buttons/button_enums.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/logo_section.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/constants/route_constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController(); // Added email controller
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); // Added confirm password controller
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false; // Added for confirm password
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = ''; // For dynamic error messages

  @override
  void dispose() {

    _emailController.dispose(); // Dispose email controller
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // Dispose confirm password controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          _ErrorToast(message: _errorMessage), // Pass dynamic error message
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
    );
  }

  Widget _buildFormSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Email field
        CustomTextField(
          controller: _emailController,
          hintText: 'Email',
          prefixIcon: Icons.email_outlined,
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
          text: 'REGISTER', // Changed text to REGISTER
          isLoading: _isLoading,
          onPressed: _handleRegister, // Changed to _handleRegister
        ),
        const SizedBox(height: 24),

        const _OrDivider(),
        const SizedBox(height: 8),

        // Social buttons
        const _SocialLoginSection(), // Keep social login, update text inside widget
        const SizedBox(height: 24),

        // Login link
        const _LoginLink(), // Changed to _LoginLink
      ],
    );
  }

  Future<void> _handleRegister() async { // Renamed to _handleRegister
    if (
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    // Basic email validation
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegExp.hasMatch(_emailController.text)) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Invalid email format';
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
    // TODO: Navigate to home page or verify email page after successful registration
    // Routes.navigateTo(context, RouteConstants.home); // Example
  }
}

class _ErrorToast extends StatelessWidget {
  final String message; // Added message parameter
  const _ErrorToast({required this.message}); // Updated constructor

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
          Expanded( // Added Expanded to prevent overflow
            child: Text(
              message, // Use dynamic message
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
              'Or',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7580), // Adjusted color for consistency
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
  const _SocialLoginSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialLoginButton(
          text: 'REGISTER WITH GOOGLE', // Changed text
          onPressed: () {
            // TODO: Implement Google registration
          },
          icon: 'assets/icons/google_icon.png',
        ),
        const SizedBox(height: 20),
        _SocialLoginButton(
          text: 'REGISTER WITH APPLE', // Changed text
          onPressed: () {
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
  final VoidCallback onPressed;

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

class _LoginLink extends StatelessWidget { // Renamed from _RegisterLink
  const _LoginLink();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?', // Changed text
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigate to Login Page
            Routes.navigateTo(context, RouteConstants.login); // TODO: Ensure login route is defined
          },
          child: const Text(
            'Login here', // Changed text
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