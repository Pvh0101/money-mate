import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  final bool enabled;
  final VoidCallback? onSuffixIconTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.enabled = true,
    this.onSuffixIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: enabled ? const Color(0xFFF5F6F7) : const Color(0xFFEDEEF0),
        border: Border.all(color: const Color(0xFFDCDFE3)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          enabled: enabled,
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFF242D35),
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 16,
              color: const Color(0xFF9BA1A8),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(prefixIcon, color: const Color(0xFF242D35), size: 20),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: enabled ? onSuffixIconTap : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(suffixIcon,
                          color: const Color(0xFFB0B8BF), size: 20),
                    ),
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}
