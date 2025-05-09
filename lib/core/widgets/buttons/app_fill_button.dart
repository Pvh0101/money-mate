import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart'; // Removed if not directly used for global font override
import 'button_enums.dart';
import 'button_style_helpers.dart';

class AppFillButton extends StatelessWidget {
  const AppFillButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ButtonSize.large,
    this.classType = ButtonClassType.standard,
    this.isDisabled = false,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  final VoidCallback? onPressed;
  final String text;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final ButtonSize size;
  final ButtonClassType classType;
  final bool isDisabled;
  final bool isLoading;
  final bool isFullWidth;

  // Private color methods (_getTextColorForState, _getStandardNormalGradient,
  // _getSolidContainerBackgroundColor, _getShadow) are now removed
  // as their logic is centralized in AppButtonStyleHelper.

  @override
  Widget build(BuildContext context) {
    final double height = AppButtonStyleHelper.getHeight(size);
    final double borderRadiusAmount =
        AppButtonStyleHelper.getBorderRadius(size);
    final EdgeInsets padding = AppButtonStyleHelper.getPadding(size);
    final double fontSize = AppButtonStyleHelper.getFontSize(size);
    // final double leadingTrailingIconSize = AppButtonStyleHelper.getLeadingTrailingIconSize(size);

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final bool actualDisabled = isDisabled || isLoading;
    final VoidCallback? pressHandler = actualDisabled ? null : onPressed;

    // Resolve colors and styles using AppButtonStyleHelper
    final Color determinedTextColor = AppButtonStyleHelper.getOnFillColor(
      colorScheme: colorScheme,
      classType: classType,
      isDisabledOrLoading: actualDisabled,
    );

    final Gradient? buttonGradient =
        AppButtonStyleHelper.getFillButtonStandardGradient(
      classType,
      actualDisabled,
    );

    final Color? buttonSurfaceColor =
        AppButtonStyleHelper.getFillBackgroundColor(
      colorScheme: colorScheme,
      classType: classType,
      isDisabledOrLoading: actualDisabled,
      precomputedGradient:
          buttonGradient, // Pass gradient to allow helper to decide if color is needed
    );

    final List<BoxShadow>? buttonBoxShadow =
        AppButtonStyleHelper.getFillButtonShadow(
      colorScheme,
      classType,
      actualDisabled,
    );

    BoxDecoration containerDecoration = BoxDecoration(
      gradient: buttonGradient,
      color:
          buttonSurfaceColor, // This will be null if gradient is active for standard type
      borderRadius: BorderRadius.circular(borderRadiusAmount),
      boxShadow: buttonBoxShadow,
    );

    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null)
          Padding(
            padding: EdgeInsets.only(right: text.isNotEmpty ? 8.0 : 0.0),
            child: IconTheme(
              data: IconThemeData(
                color: determinedTextColor,
                // size: leadingTrailingIconSize,
              ),
              child: leadingIcon!,
            ),
          ),
        if (text.isNotEmpty)
          Text(
            text.toUpperCase(),
            // TextStyle is now more directly controlled by ElevatedButton's ButtonStyle
          ),
        if (trailingIcon != null)
          Padding(
            padding: EdgeInsets.only(left: text.isNotEmpty ? 8.0 : 0.0),
            child: IconTheme(
              data: IconThemeData(
                color: determinedTextColor,
                // size: leadingTrailingIconSize,
              ),
              child: trailingIcon!,
            ),
          ),
      ],
    );

    if (isLoading) {
      final Color loadingIndicatorColor =
          AppButtonStyleHelper.getLoadingIndicatorColor(
        variant: ButtonVariant.filled,
        colorScheme: colorScheme,
        classType: classType,
      );
      buttonContent = SizedBox(
        width: fontSize * 1.5,
        height: fontSize * 1.5,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(loadingIndicatorColor),
        ),
      );
    }

    return Container(
      width: isFullWidth ? double.infinity : null,
      height: height,
      decoration: containerDecoration,
      child: ElevatedButton(
        onPressed: pressHandler,
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(
              Colors.transparent), // Background handled by outer Container
          foregroundColor: WidgetStateProperty.all(
              determinedTextColor), // Use the resolved text/icon color
          padding: WidgetStateProperty.all(padding),
          minimumSize: WidgetStateProperty.all(
              Size(isFullWidth ? double.infinity : 0, height)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadiusAmount),
            ),
          ),
          textStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
            TextStyle? baseStyle = textTheme.labelLarge?.copyWith(
              fontSize: fontSize,
              // If you need to ensure the text color within TextStyle also respects disabled state:
              // color: states.contains(WidgetState.disabled) ? determinedTextColor : determinedTextColor,
              // However, ButtonStyle.foregroundColor should typically handle this.
            );
            return baseStyle;
          }),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              Color overlayBase =
                  determinedTextColor; // Overlay is based on text color for contrast
              // For filled buttons, overlay is usually a subtle shade on the button itself.
              // If button bg is dark (e.g. primary), overlay is light (e.g. onPrimary.withOpacity)
              // If button bg is light, overlay is dark (e.g. primary.withOpacity)
              // The current getOnFillColor returns onPrimary. So this is white/light.
              return overlayBase.withAlpha((255 * 0.12).round());
            }
            return null;
          }),
          shadowColor: WidgetStateProperty.all(
              Colors.transparent), // Shadow handled by outer Container
        ),
        child: buttonContent,
      ),
    );
  }
}
