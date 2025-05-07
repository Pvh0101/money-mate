import 'package:flutter/material.dart';

class AuthFooterLink extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onPressed;

  const AuthFooterLink({
    super.key,
    required this.isLogin,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final questionText =
        isLogin ? 'Don\'t have an account?' : 'Already have an account?';

    final actionText = isLogin ? 'Register here' : 'Login now';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          questionText,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0E33F3),
            ),
          ),
        ),
      ],
    );
  }
}
