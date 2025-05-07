import 'package:flutter/material.dart';

class AuthBottomIndicator extends StatelessWidget {
  const AuthBottomIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
} 