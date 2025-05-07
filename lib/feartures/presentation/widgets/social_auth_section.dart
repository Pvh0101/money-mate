import 'package:flutter/material.dart';
import 'social_auth_button.dart';

class SocialAuthSection extends StatelessWidget {
  final bool isLogin;
  final bool isLoading;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  
  const SocialAuthSection({
    super.key,
    this.isLogin = true,
    this.isLoading = false,
    this.onGooglePressed,
    this.onApplePressed,
  });

  @override
  Widget build(BuildContext context) {
    final googleText = isLogin ? 'CONTINUE WITH GOOGLE' : 'ĐĂNG KÝ VỚI GOOGLE';
    final appleText = isLogin ? 'CONTINUE WITH APPLE' : 'ĐĂNG KÝ VỚI APPLE';
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SocialAuthButton(
          text: googleText,
          onPressed: isLoading ? null : onGooglePressed,
          icon: 'assets/icons/google_icon.png',
        ),
        const SizedBox(height: 20),
        SocialAuthButton(
          text: appleText,
          onPressed: isLoading ? null : onApplePressed,
          icon: 'assets/icons/apple_icon.png',
        ),
      ],
    );
  }
} 