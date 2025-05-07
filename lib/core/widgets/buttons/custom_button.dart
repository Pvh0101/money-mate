import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  static const List<Color> defaultGradient = [
    Color(0xFF2F51FF),
    Color(0xFF0E33F3),
  ];

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final List<Color>? gradientColors;
  final double? width;
  final double height;
  final double borderRadius;
  final bool hasShadow;
  final EdgeInsets? padding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? buttonTextStyle;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.gradientColors,
    this.width,
    this.height = 48,
    this.borderRadius = 14,
    this.hasShadow = true,
    this.padding,
    this.prefixIcon,
    this.suffixIcon,
    this.buttonTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> currentGradient = gradientColors ?? defaultGradient;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: backgroundColor == null
            ? LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: currentGradient,
              )
            : null,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: (backgroundColor ?? currentGradient.last)
                      .withOpacity(0.35),
                  offset: const Offset(0, 8),
                  blurRadius: 24,
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: (backgroundColor ?? currentGradient.last)
                      .withOpacity(0.2),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon!,
                    const SizedBox(width: 12),
                  ],
                  Text(
                    text,
                    style: GoogleFonts.inter(
                      color: buttonTextStyle?.color ?? textColor,
                      fontSize: buttonTextStyle?.fontSize ?? 16,
                      fontWeight: buttonTextStyle?.fontWeight ?? FontWeight.w600,
                      letterSpacing: buttonTextStyle?.letterSpacing,
                      fontStyle: buttonTextStyle?.fontStyle,
                      height: buttonTextStyle?.height,
                    ),
                  ),
                  if (suffixIcon != null) ...[
                    const SizedBox(width: 12),
                    suffixIcon!,
                  ],
                ],
              ),
      ),
    );
  }
}
