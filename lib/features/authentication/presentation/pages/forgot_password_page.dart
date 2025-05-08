import 'package:flutter/material.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/widgets/buttons/app_fill_button.dart';
import '../../../../core/widgets/fields/custom_text_field.dart';
import '../../../../core/widgets/buttons/button_enums.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  bool _isValidNameRule = false;
  bool _isValidLengthRule = false;
  bool _isValidSymbolOrNumberRule = false;
  String? _passwordErrorText;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePasswordOnInput);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_validatePasswordOnInput);
    _confirmPasswordController.removeListener(_validateConfirmPassword);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePasswordOnInput() {
    final password = _passwordController.text;
    setState(() {
      _isValidNameRule = !Validator.containsNameOrEmail(password, 'fisher');
      _isValidLengthRule = Validator.hasMinLength(password);
      _isValidSymbolOrNumberRule = Validator.containsSymbolOrNumber(password);
      _validateConfirmPassword();
    });
  }

  void _validateConfirmPassword() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    setState(() {
      if (Validator.isNotEmpty(confirmPassword) && password != confirmPassword) {
        _passwordErrorText = "Passwords do not match";
      } else {
        _passwordErrorText = null;
      }
    });
  }

  void _resetPassword() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    _validatePasswordOnInput();
    _validateConfirmPassword();

    if (!Validator.isNotEmpty(password) || !Validator.isNotEmpty(confirmPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all password fields.")),
      );
      return;
    }

    String? confirmPasswordError = Validator.validateConfirmPassword(password, confirmPassword);
    if (confirmPasswordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(confirmPasswordError)),
      );
      return;
    }
    
    String? complexityError = Validator.validatePasswordComplexity(password);
    if (complexityError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(complexityError)),
      );
      return;
    }

    if (Validator.containsNameOrEmail(password, 'fisher')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must not contain your name or email.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset successfully!")),
        );
        Routes.navigateToReplacement(context, RouteConstants.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFEEEFF0)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.chevron_left,
                        color: Color(0xFF242D35),
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Create Your New\nPassword',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF242D35),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your new password must be different\nfrom previous password.',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF9BA1A8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'New Password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: !_isPasswordVisible,
                  suffixIcon: _isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onSuffixIconTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: !_isConfirmPasswordVisible,
                  suffixIcon: _isConfirmPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onSuffixIconTap: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
                if (_passwordErrorText != null && _passwordErrorText!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                    child: Text(
                      _passwordErrorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 24),
                _buildValidationRule(
                  "Must not contain your name or email",
                  _isValidNameRule,
                  _passwordController.text.isNotEmpty,
                  Validator.isNotEmpty(_passwordController.text) && !_isValidNameRule ? Colors.red : Colors.blue,
                ),
                const SizedBox(height: 12),
                _buildValidationRule(
                  "At least 8 characters",
                  _isValidLengthRule,
                  _passwordController.text.isNotEmpty,
                  Validator.isNotEmpty(_passwordController.text) && !_isValidLengthRule ? Colors.red : null,
                ),
                const SizedBox(height: 12),
                _buildValidationRule(
                  "Contains a symbol or a number",
                  _isValidSymbolOrNumberRule,
                  _passwordController.text.isNotEmpty,
                  Validator.isNotEmpty(_passwordController.text) && !_isValidSymbolOrNumberRule ? Colors.red : null,
                ),
                const SizedBox(height: 32),
                AppFillButton(
                  text: 'RESET PASSWORD',
                  onPressed: _resetPassword,
                  isLoading: _isLoading,
                  isFullWidth: true,
                  size: ButtonSize.large,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValidationRule(String text, bool isValid, bool isPasswordEntered, Color? highlightColor) {
    final bool showError = isPasswordEntered && !isValid;
    Color ruleColor = isPasswordEntered ? 
                        (isValid ? (highlightColor ?? const Color(0xFF2F51FF)) : Colors.red) 
                        : const Color(0xFFC4C8CC);
    Color iconContainerColor = isPasswordEntered ? 
                                (isValid ? (highlightColor ?? const Color(0xFF2F51FF)) : const Color(0xFFEEEFF0)) 
                                : const Color(0xFFEEEFF0);
    Color iconColor = isPasswordEntered && isValid ? Colors.white : const Color(0xFFC4C8CC);

    if (highlightColor == Colors.blue && isPasswordEntered) {
      ruleColor = isValid ? Colors.blue : Colors.red;
      iconContainerColor = isValid ? Colors.blue : const Color(0xFFEEEFF0);
      iconColor = isValid ? Colors.white : const Color(0xFFC4C8CC); 
    } else if (isPasswordEntered && !isValid) {
         ruleColor = Colors.red;
         iconContainerColor = const Color(0xFFEEEFF0);
         iconColor = const Color(0xFFC4C8CC);
    }

    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconContainerColor,
          ),
          child: Icon(
            Icons.check,
            size: 16,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: ruleColor,
          ),
        ),
      ],
    );
  }
} 