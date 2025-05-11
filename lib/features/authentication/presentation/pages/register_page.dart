import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_layout.dart';
import '../widgets/auth_or_divider.dart';
import '../widgets/social_auth_section.dart';
import '../widgets/auth_footer_link.dart';
import '../../../../core/core.dart';

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
            _errorMessage = state.failure.toString();
          });
        } else if (state is Authenticated) {
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
            AppTextFormField(
              controller: _emailController,
              hintText: 'Email',
              prefixIconData: Icons.email_outlined,
            ),
            const SizedBox(height: 20),

            // Password field
            PasswordTextFormField(
              controller: _passwordController,
              hintText: 'Password',
              prefixIconData: Icons.lock_outline,
            ),
            const SizedBox(height: 20),

            // Confirm Password field
            PasswordTextFormField(
              controller: _confirmPasswordController,
              hintText: 'Confirm Password',
              prefixIconData: Icons.lock_outline,
            ),
            const SizedBox(height: 24),

            // Register button
            AppFillButton(
              isExpanded: true,
              text: 'REGISTER',
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
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (!Validator.isNotEmpty(email) ||
        !Validator.isNotEmpty(password) ||
        !Validator.isNotEmpty(confirmPassword)) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Vui lòng điền đầy đủ thông tin';
      });
      return;
    }

    String? emailError = Validator.validateEmailField(email);
    if (emailError != null) {
      setState(() {
        _hasError = true;
        _errorMessage = emailError;
      });
      return;
    }

    String? passwordError = Validator.validatePasswordComplexity(password);
    if (passwordError != null) {
      setState(() {
        _hasError = true;
        _errorMessage = passwordError;
      });
      return;
    }

    String? confirmPasswordError =
        Validator.validateConfirmPassword(password, confirmPassword);
    if (confirmPasswordError != null) {
      setState(() {
        _hasError = true;
        _errorMessage = confirmPasswordError;
      });
      return;
    }

    setState(() {
      _hasError = false;
      _errorMessage = '';
    });

    context.read<AuthBloc>().add(RegisterWithEmailEvent(
          email: _emailController.text,
          password: _passwordController.text,
        ));
  }
}
