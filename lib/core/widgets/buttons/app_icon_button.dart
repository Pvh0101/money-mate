import 'package:flutter/material.dart';

import 'button_enums.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final ButtonClassType classType;
  final IconButtonShape shape;
  final IconButtonType iconButtonType;
  final bool isDisabled;
  final bool isLoading;
  final double? width;
  final double? height;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.classType = ButtonClassType.standard,
    this.shape = IconButtonShape.circle,
    this.iconButtonType = IconButtonType.filled,
    this.isDisabled = false,
    this.isLoading = false,
    this.width,
    this.height,
    this.iconSize,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final buttonSize = switch (size) {
      ButtonSize.small => 36.0,
      ButtonSize.medium => 44.0,
      ButtonSize.large => 52.0,
    };

    Color getResolvedBackgroundColor() {
      if (iconButtonType == IconButtonType.outline) return Colors.transparent;
      // Filled type
      if (isDarkMode) {
        return switch (classType) {
          ButtonClassType.standard => const Color(0xFF1F2937), // Dark Gray
          ButtonClassType.dangerous => const Color(0xFFDC2626), // Strong Red (Figma Dark Destructive BG)
        };
      } else {
        return switch (classType) {
          ButtonClassType.standard => const Color(0xFFFFFFFF), // White
          ButtonClassType.dangerous => const Color(0xFFFEE2E2), // Light Red
        };
      }
    }

    Color getResolvedIconColor() {
      if (isDarkMode) {
        if (iconButtonType == IconButtonType.filled) {
          return switch (classType) {
            ButtonClassType.standard => const Color(0xFF9CA3AF), // Light Gray
            ButtonClassType.dangerous => const Color(0xFFF87171), // Lightish Red (Figma Dark Destructive Icon)
          };
        } else { // Outline Dark Mode
          return switch (classType) {
            ButtonClassType.standard => const Color(0xFF9CA3AF), // Light Gray
            ButtonClassType.dangerous => const Color(0xFFF87171), // Lightish Red
          };
        }
      } else { // Light Mode
        // For both filled and outline in light mode, icon color depends on classType
        return switch (classType) {
          ButtonClassType.standard => const Color(0xFF6B7580), // Gray
          ButtonClassType.dangerous => const Color(0xFFEF4444), // Red
        };
      }
    }

    Color getBorderColor() {
      if (iconButtonType == IconButtonType.outline) {
        return getResolvedIconColor(); // Outline border always matches icon color
      }
      // Filled type border
      if (isDarkMode) {
        return switch (classType) {
          ButtonClassType.standard => const Color(0xFF374151), // Gray
          ButtonClassType.dangerous => const Color(0xFFDC2626), // Matches BG (Figma Dark Destructive BG)
        };
      } else {
        return switch (classType) {
          ButtonClassType.standard => const Color(0xFFE5E7EB), // Light Gray
          ButtonClassType.dangerous => const Color(0xFFFEE2E2), // Matches BG (Light Red)
        };
      }
    }

    final resolvedBackgroundColorVal = getResolvedBackgroundColor();
    final resolvedIconColorVal = getResolvedIconColor();
    final borderColorVal = getBorderColor();

    final defaultIconSize = switch (size) {
      ButtonSize.small => 18.0,
      ButtonSize.medium => 22.0,
      ButtonSize.large => 26.0,
    };

    final BorderRadius defaultShapeBorderRadius = switch (shape) {
      IconButtonShape.circle => BorderRadius.circular(buttonSize / 2),
      IconButtonShape.square => BorderRadius.circular(12.0),
    };

    final resolvedBorderRadius = borderRadius ?? defaultShapeBorderRadius;

    return SizedBox(
      width: width ?? buttonSize,
      height: height ?? buttonSize,
      child: Material(
        color: Colors.transparent,
        borderRadius: resolvedBorderRadius,
        child: InkWell(
          onTap: isDisabled || isLoading ? null : onPressed,
          borderRadius: resolvedBorderRadius,
          child: Container(
            padding: padding ?? EdgeInsets.all((buttonSize - defaultIconSize) / 2),
            decoration: BoxDecoration(
              color: resolvedBackgroundColorVal,
              borderRadius: resolvedBorderRadius,
              border: Border.all(
                color: isDisabled ? borderColorVal.withValues(alpha: 0.5) : borderColorVal,
                width: 1,
              ),
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: defaultIconSize,
                      height: defaultIconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          resolvedIconColorVal,
                        ),
                      ),
                    )
                  : Icon(
                      icon,
                      size: iconSize ?? defaultIconSize,
                      color: isDisabled
                          ? resolvedIconColorVal.withValues(alpha: 0.5  )
                          : resolvedIconColorVal,
                    ),
            ),
          ),
        ),
      ),
    );
  }
} 