import 'package:flutter/material.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 136,
      child: Column(
        children: [
          Positioned(
            top: 0,
            child: Image.asset(
              'assets/logo/logo.png',
              width: 88,
              height: 88,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            'monex',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
