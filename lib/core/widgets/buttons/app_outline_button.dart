import 'package:flutter/material.dart';
import 'button_enums.dart';

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

  // Style Getters - Giữ nguyên từ FillButton
  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return 32.0;
      case ButtonSize.medium:
        return 40.0;
      case ButtonSize.large:
        return 48.0;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case ButtonSize.small:
        return 10.0;
      case ButtonSize.medium:
        return 12.0;
      case ButtonSize.large:
        return 14.0;
    }
  }

  EdgeInsets _getPadding() {
    
    switch (size) {
      case ButtonSize.small:
        
        return const EdgeInsets.symmetric(vertical: 5, horizontal: 15); 
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(vertical: 7, horizontal: 19);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(vertical: 11, horizontal: 19);
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return 14.0;
      case ButtonSize.medium:
      case ButtonSize.large:
        return 16.0;
    }
  }

  // Màu sắc cho CustomOutlineButton
  Color _getForegroundColor(Set<WidgetState> states, ColorScheme colorScheme) {
    if (isDisabled || isLoading || states.contains(WidgetState.disabled)) {
      return colorScheme.onSurface.withAlpha((255 * 0.38).round());
    }
    // Đối với outline button, màu chữ khi pressed/hovered và normal thường là màu chính (primary/error)
    if (classType == ButtonClassType.standard) {
      return colorScheme.primaryFixed;
    }
    if (classType == ButtonClassType.dangerous) {
      return colorScheme.error;
    }
    return colorScheme.primary; // Fallback
  }

  Color _getBorderColor(Set<WidgetState> states, ColorScheme colorScheme) {
    return _getForegroundColor(states, colorScheme);
  }
  
  Color _getLoadingIndicatorColor(ColorScheme colorScheme) {
    if (classType == ButtonClassType.standard) {
      return colorScheme.primaryFixed;
    }
    if (classType == ButtonClassType.dangerous) {
      return colorScheme.error;
    }
    return colorScheme.primary; // Fallback
  }


  @override
  Widget build(BuildContext context) {
    final double height = _getHeight();
    final double borderRadiusAmount = _getBorderRadius();
    final EdgeInsets padding = _getPadding();
    final double fontSize = _getFontSize();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final bool actualDisabled = isDisabled || isLoading;
    final VoidCallback? pressHandler = actualDisabled ? null : onPressed;

    final Set<WidgetState> currentStates = {
      if (actualDisabled) WidgetState.disabled else WidgetState.selected
    };

    return Container(
      width: isFullWidth ? double.infinity : null,
      height: height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadiusAmount),
        border: Border.all(
          color: _getBorderColor(currentStates, colorScheme),
          width: 1.0,
        ),
      ),
      child: ElevatedButton(
        onPressed: pressHandler,
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.resolveWith((states) => _getForegroundColor(states, colorScheme)),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
              return _getForegroundColor(states, colorScheme).withAlpha((255 * 0.08).round());
            }
            return Colors.transparent;
          }),
          padding: WidgetStateProperty.all(padding),
          minimumSize: WidgetStateProperty.all(Size(isFullWidth ? double.infinity : 0, height)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadiusAmount -1),
            ),
          ),
          textStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
            TextStyle? baseStyle;
            if (size == ButtonSize.small) {
              baseStyle = textTheme.labelLarge?.copyWith(fontSize: fontSize); 
            } else {
              baseStyle = textTheme.labelLarge;
            }
            return baseStyle;
          }),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
        ),
        child: isLoading
            ? SizedBox(
                width: fontSize * 1.2,
                height: fontSize * 1.2,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation<Color>(_getLoadingIndicatorColor(colorScheme)),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null)
                    Padding(
                      padding: EdgeInsets.only(right: text.isNotEmpty ? 8.0 : 0.0),
                      child: IconTheme(
                        data: IconThemeData(color: _getForegroundColor(currentStates, colorScheme)),
                        child: leadingIcon!,
                      ),
                    ),
                  if (text.isNotEmpty)
                    Text(
                      text.toUpperCase(),
                    ),
                  if (trailingIcon != null)
                    Padding(
                      padding: EdgeInsets.only(left: text.isNotEmpty ? 8.0 : 0.0),
                       child: IconTheme(
                        data: IconThemeData(color: _getForegroundColor(currentStates, colorScheme)),
                        child: trailingIcon!,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
} 