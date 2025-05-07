import 'package:flutter/material.dart';
import 'package:money_mate/presentation/widgets/custom_button.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/logo_section.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/constants/route_constants.dart';

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
                          const _ErrorToast(),
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
        CustomButton(
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

        const _OrDivider(),
        const SizedBox(height: 8),

        // Social buttons
        const _SocialLoginSection(),
        const SizedBox(height: 24),

        // Register link
        const _RegisterLink(),
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

class _ErrorToast extends StatelessWidget {
  const _ErrorToast();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD7D7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFEF4E4E),
            size: 24,
          ),
          SizedBox(width: 8),
          Text(
            'Incorrect username or password',
            style: TextStyle(
              color: Color(0xFFEF4E4E),
              fontSize: 12,

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Or',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
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
          text: 'CONTINUE WITH GOOGLE',
          onPressed: () {},
          icon: 'assets/icons/google_icon.png',
        ),
        const SizedBox(height: 20),
        _SocialLoginButton(
          text: 'CONTINUE WITH APPLE',
          onPressed: () {},
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

class _RegisterLink extends StatelessWidget {
  const _RegisterLink();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Register here',
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
