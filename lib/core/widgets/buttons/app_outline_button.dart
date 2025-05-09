import 'package:flutter/material.dart';
import 'button_enums.dart';
import 'button_style_helpers.dart';

class AppOutlineButton extends StatelessWidget {
  const AppOutlineButton({
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

  @override
  Widget build(BuildContext context) {
    final double height = AppButtonStyleHelper.getHeight(size);
    final double borderRadiusAmount =
        AppButtonStyleHelper.getBorderRadius(size);
    final EdgeInsets padding = AppButtonStyleHelper.getPadding(size);
    final double fontSize = AppButtonStyleHelper.getFontSize(size);

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final bool actualDisabled = isDisabled || isLoading;
    final VoidCallback? pressHandler = actualDisabled ? null : onPressed;

    final Color determinedForegroundColor =
        AppButtonStyleHelper.getForegroundColor(
      colorScheme: colorScheme,
      classType: classType,
      isDisabledOrLoading: actualDisabled,
      variant: ButtonVariant.outline,
    );

    final Color determinedBorderColor = determinedForegroundColor;

    return Container(
      width: isFullWidth ? double.infinity : null,
      height: height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadiusAmount),
        border: Border.all(
          color: determinedBorderColor,
          width: 1.0,
        ),
      ),
      child: ElevatedButton(
        onPressed: pressHandler,
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(determinedForegroundColor),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed)) {
              return determinedForegroundColor.withAlpha((255 * 0.08).round());
            }
            return Colors.transparent;
          }),
          padding: WidgetStateProperty.all(padding),
          minimumSize: WidgetStateProperty.all(
              Size(isFullWidth ? double.infinity : 0, height)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadiusAmount - 1),
            ),
          ),
          textStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
            return textTheme.labelLarge?.copyWith(fontSize: fontSize);
          }),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
        ),
        child: isLoading
            ? SizedBox(
                width: fontSize * 1.2,
                height: fontSize * 1.2,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppButtonStyleHelper.getLoadingIndicatorColor(
                      variant: ButtonVariant.outline,
                      colorScheme: colorScheme,
                      classType: classType,
                    ),
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null)
                    Padding(
                      padding:
                          EdgeInsets.only(right: text.isNotEmpty ? 8.0 : 0.0),
                      child: IconTheme(
                        data: IconThemeData(
                          color: determinedForegroundColor,
                        ),
                        child: leadingIcon!,
                      ),
                    ),
                  if (text.isNotEmpty)
                    Text(
                      text.toUpperCase(),
                    ),
                  if (trailingIcon != null)
                    Padding(
                      padding:
                          EdgeInsets.only(left: text.isNotEmpty ? 8.0 : 0.0),
                      child: IconTheme(
                        data: IconThemeData(
                          color: determinedForegroundColor,
                        ),
                        child: trailingIcon!,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
