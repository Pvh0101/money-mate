import 'package:flutter/material.dart';
import 'button_enums.dart'; // Assuming ButtonSize is defined here

// Enum to differentiate button types for styling if needed
enum ButtonVariant {
  filled,
  outline,
  text,
  icon,
}

class AppButtonStyleHelper {
  // Private constructor to prevent instantiation
  AppButtonStyleHelper._();

  static double getHeight(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 32.0;
      case ButtonSize.medium:
        return 40.0;
      case ButtonSize.large:
        return 48.0;
    }
  }

  static double getBorderRadius(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 10.0;
      case ButtonSize.medium:
        return 12.0;
      case ButtonSize.large:
        return 14.0;
    }
  }

  // Updated getPadding to be unified and reduced
  static EdgeInsets getPadding(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(vertical: 4, horizontal: 15);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(vertical: 6, horizontal: 19);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(vertical: 10, horizontal: 19);
    }
  }

  static double getFontSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 14.0;
      case ButtonSize.medium:
      case ButtonSize.large:
        return 16.0;
    }
  }

  // Placeholder for icon sizes for text/outline/fill buttons if needed (icons next to text)
  static double getLeadingTrailingIconSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 16.0;
      case ButtonSize.medium:
      case ButtonSize.large:
        return 18.0; // Or 20.0, check Figma/design
    }
  }

  // Logic for icon button's own icon size (different from leading/trailing icons)
  static double getIconButtonIconSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 18.0;
      case ButtonSize.medium:
        return 22.0;
      case ButtonSize.large:
        return 26.0;
    }
  }

  // New helper for Icon Button specific vertical padding
  static double getIconButtonContentVerticalPadding(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 4.0;
      case ButtonSize.medium:
        return 6.0;
      case ButtonSize.large:
        return 10.0;
    }
  }

  // Logic for icon button's overall size (width/height if square/circle)
  static double getIconButtonContainerSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 36.0;
      case ButtonSize.medium:
        return 44.0;
      case ButtonSize.large:
        return 52.0;
    }
  }

  // --- Color Resolvers ---

  static Color getDisabledColor(ColorScheme colorScheme) {
    return colorScheme.onSurface
        .withOpacity(0.38); // Standard disabled opacity from Material Design
  }

  static Color getDisabledContainerColor(ColorScheme colorScheme) {
    // For disabled containers, a very subtle version of onSurface or a specific disabled container color
    return colorScheme.onSurface.withOpacity(0.05); // More subtle than text
  }

  // For Text, Outline buttons (foreground, border)
  static Color getForegroundColor({
    required ColorScheme colorScheme,
    required ButtonClassType classType,
    required bool isDisabledOrLoading,
    required ButtonVariant variant,
  }) {
    if (isDisabledOrLoading) return getDisabledColor(colorScheme);
    switch (classType) {
      case ButtonClassType.standard:
        if (variant == ButtonVariant.outline) {
          // For Standard Outline button, use the same color as Standard Text button
          return getTextButtonStandardForegroundColor(
              colorScheme, isDisabledOrLoading);
        }
        // Default for other standard variants (e.g. if a hypothetical standard text button didn't use the specific blue)
        return colorScheme.primary;
      case ButtonClassType.dangerous:
        return colorScheme.error;
    }
  }

  // Specific for AppTextButton's standard color, if it must be different from colorScheme.primary
  static Color getTextButtonStandardForegroundColor(
      ColorScheme colorScheme, bool isDisabledOrLoading) {
    if (isDisabledOrLoading) return getDisabledColor(colorScheme);
    return const Color(
        0xFF0E33F3); // Keeping the specific blue for TextButton if it's a design requirement
  }

  // For Fill buttons (text/icon color on top of the fill)
  static Color getOnFillColor({
    required ColorScheme colorScheme,
    required ButtonClassType classType,
    required bool isDisabledOrLoading,
  }) {
    if (isDisabledOrLoading) return getDisabledColor(colorScheme);
    // Text on a filled button should contrast with the fill color.
    switch (classType) {
      case ButtonClassType.standard:
        return colorScheme.onPrimary;
      case ButtonClassType.dangerous:
        return colorScheme.onError;
    }
  }

  // For Fill buttons (background color of the button itself)
  // Returns null if a gradient is to be used (e.g. standard fill button)
  static Color? getFillBackgroundColor({
    required ColorScheme colorScheme,
    required ButtonClassType classType,
    required bool isDisabledOrLoading,
    Gradient?
        precomputedGradient, // If a gradient is active (e.g. standard fill), this color is ignored
  }) {
    if (isDisabledOrLoading) return getDisabledContainerColor(colorScheme);
    // Standard fill buttons with a gradient won't use this solid background color.
    if (precomputedGradient != null && classType == ButtonClassType.standard)
      return null;

    switch (classType) {
      case ButtonClassType.standard:
        // This would apply if standard fill button *didn't* have a gradient
        return colorScheme.primary;
      case ButtonClassType.dangerous:
        return colorScheme.error;
    }
  }

  // Gradient for Standard Fill button (kept as it's a specific design feature)
  static Gradient? getFillButtonStandardGradient(
      ButtonClassType classType, bool isDisabledOrLoading) {
    if (classType == ButtonClassType.standard && !isDisabledOrLoading) {
      return const LinearGradient(
        colors: [
          Color(0xFF2F51FF),
          Color(0xFF0E33F3)
        ], // Specific gradient colors
        begin: Alignment.centerLeft, end: Alignment.centerRight,
      );
    }
    return null;
  }

  // Shadow for Standard Fill button
  static List<BoxShadow>? getFillButtonShadow(ColorScheme colorScheme,
      ButtonClassType classType, bool isDisabledOrLoading) {
    if (classType == ButtonClassType.standard && !isDisabledOrLoading) {
      return [
        BoxShadow(
          color: colorScheme.primary.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ];
    }
    return null;
  }

  // For Icon buttons
  static Color getIconButtonSurfaceColor({
    required ColorScheme colorScheme,
    required ButtonClassType classType,
    required IconButtonType iconButtonType,
    required bool isDisabledOrLoading,
  }) {
    if (isDisabledOrLoading) return getDisabledContainerColor(colorScheme);
    if (iconButtonType == IconButtonType.outline) return Colors.transparent;

    // Filled Icon Button Backgrounds
    switch (classType) {
      case ButtonClassType.standard:
        // Use surface/surfaceContainer for standard icon buttons background
        // M3 suggests using Surface Container variants. If not available, fallback to surface/onInverseSurface.
        return colorScheme.brightness == Brightness.light
            ? colorScheme.surfaceContainerLowest
            : colorScheme.surfaceContainerHigh;
      case ButtonClassType.dangerous:
        // Use errorContainer for dangerous icon buttons background
        return colorScheme.errorContainer;
    }
  }

  static Color getIconButtonIconColor({
    required ColorScheme colorScheme,
    required ButtonClassType classType,
    required IconButtonType iconButtonType,
    required bool isDisabledOrLoading,
  }) {
    if (isDisabledOrLoading) return getDisabledColor(colorScheme);

    // Icon color generally depends on the classType and the background it's on.
    // For filled icon buttons, this would be onSurfaceContainer or onErrorContainer etc.
    switch (classType) {
      case ButtonClassType.standard:
        // If bg is surfaceContainerLowest/High, icon should be onSecondaryContainer or similar
        return colorScheme.onSecondaryContainer;
      case ButtonClassType.dangerous:
        return colorScheme
            .onErrorContainer; // Icon color for on errorContainer background
    }
  }

  static Color getIconButtonBorderColor({
    required ColorScheme colorScheme,
    required ButtonClassType classType,
    required IconButtonType iconButtonType,
    required bool isDisabledOrLoading,
  }) {
    if (iconButtonType == IconButtonType.outline) {
      // For outline, border uses the same color as the icon itself (or its disabled state)
      return getIconButtonIconColor(
          colorScheme: colorScheme,
          classType: classType,
          iconButtonType: iconButtonType,
          isDisabledOrLoading: isDisabledOrLoading);
    }

    // Filled Icon Button Borders (Subtle or from theme)
    // Typically, filled buttons might not have a prominent border unless specified by design
    // Using colorScheme.outline with some opacity can provide a subtle, theme-aware border.
    Color normalBorderColor =
        colorScheme.outline.withOpacity(0.2); // Default subtle border

    // Example: if filled dangerous buttons need a more prominent error-colored border
    // if (classType == ButtonClassType.dangerous) {
    //   normalBorderColor = colorScheme.error.withOpacity(0.5);
    // }

    return isDisabledOrLoading
        ? normalBorderColor.withOpacity(0.5)
        : normalBorderColor;
  }

  // Loading indicator color - should generally match the foreground/icon color of the button type
  static Color getLoadingIndicatorColor({
    required ButtonVariant variant,
    required ColorScheme colorScheme,
    required ButtonClassType classType,
    IconButtonType? iconButtonType, // Only for icon buttons
  }) {
    // For loading, we generally use the 'enabled' version of the foreground/icon color.
    const bool effectivelyDisabled = false;

    switch (variant) {
      case ButtonVariant.filled:
        return getOnFillColor(
            colorScheme: colorScheme,
            classType: classType,
            isDisabledOrLoading: effectivelyDisabled);
      case ButtonVariant.outline:
        return getForegroundColor(
            colorScheme: colorScheme,
            classType: classType,
            isDisabledOrLoading: effectivelyDisabled,
            variant: ButtonVariant.outline);
      case ButtonVariant.text:
        if (classType == ButtonClassType.standard)
          return getTextButtonStandardForegroundColor(
              colorScheme, effectivelyDisabled);
        // For dangerous text button, use the dangerous foreground color.
        return getForegroundColor(
            colorScheme: colorScheme,
            classType: ButtonClassType.dangerous,
            isDisabledOrLoading: effectivelyDisabled,
            variant: ButtonVariant.text);
      case ButtonVariant.icon:
        assert(iconButtonType != null,
            'iconButtonType must be provided for Icon Button variant');
        return getIconButtonIconColor(
            colorScheme: colorScheme,
            classType: classType,
            iconButtonType: iconButtonType!,
            isDisabledOrLoading: effectivelyDisabled);
    }
  }
}
