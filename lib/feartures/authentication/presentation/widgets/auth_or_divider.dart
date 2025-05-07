import 'package:flutter/material.dart';

class AuthOrDivider extends StatelessWidget {
  final String text;
  
  const AuthOrDivider({
    super.key,
    this.text = 'Or',
  });

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
              text,
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