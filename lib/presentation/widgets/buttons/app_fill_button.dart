import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'button_enums.dart';

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
    this.isFullWidth = false, // Thêm tùy chọn fullWidth
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

  // Style Getters
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
        return const EdgeInsets.symmetric(vertical: 8, horizontal: 20);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(vertical: 12, horizontal: 20);
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

  Color _getTextColorForState(Set<WidgetState> states, ColorScheme colorScheme) {
    if (isDisabled || isLoading || states.contains(WidgetState.disabled)) {
      return colorScheme.onSurface.withAlpha((255 * 0.38).round());
    }
    return colorScheme.onPrimary;
  }

  Gradient? _getStandardNormalGradient() {
    if (classType == ButtonClassType.standard && !(isDisabled || isLoading)) {
      return const LinearGradient(
        colors: [Color(0xFF2F51FF), Color(0xFF0E33F3)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
    }
    return null;
  }

  Color _getSolidContainerBackgroundColor(bool isActuallyDisabled, ColorScheme colorScheme) {
    if (isActuallyDisabled) {
      return colorScheme.onSurface.withAlpha((255 * 0.12).round());
    }
    if (classType == ButtonClassType.dangerous) {
      return colorScheme.error;
    }
    if (classType == ButtonClassType.standard) {
      return colorScheme.primary;
    }
    return colorScheme.primary;
  }
  
  List<BoxShadow>? _getShadow(ColorScheme colorScheme) {
    if (classType == ButtonClassType.standard && !(isDisabled || isLoading)) {
        return [
            BoxShadow(
                color: colorScheme.primary.withAlpha((255 * 0.3).round()),
                blurRadius: 12,
                offset: const Offset(0, 6),
            ),
        ];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double height = _getHeight();
    final double borderRadius = _getBorderRadius();
    final EdgeInsets padding = _getPadding();
    final double fontSize = _getFontSize();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme; // Lấy TextTheme

    final bool actualDisabled = isDisabled || isLoading;
    final VoidCallback? pressHandler = actualDisabled ? null : onPressed;

    BoxDecoration containerDecoration;
    final Gradient? standardGradient = _getStandardNormalGradient();

    if (actualDisabled) {
      containerDecoration = BoxDecoration(
        color: _getSolidContainerBackgroundColor(true, colorScheme),
        borderRadius: BorderRadius.circular(borderRadius),
      );
    } else if (classType == ButtonClassType.standard && standardGradient != null) {
      containerDecoration = BoxDecoration(
        gradient: standardGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: _getShadow(colorScheme),
      );
    } else {
      containerDecoration = BoxDecoration(
        color: _getSolidContainerBackgroundColor(false, colorScheme),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: _getShadow(colorScheme),
      );
    }
    
    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null)
          Padding(
            padding: EdgeInsets.only(right: text.isNotEmpty ? 8.0 : 0.0),
            // Icon color sẽ được xử lý bởi foregroundColor của ElevatedButton
            // hoặc có thể bọc trong IconTheme nếu cần màu khác biệt
            child: IconTheme(
              data: IconThemeData(color: _getTextColorForState({ if (actualDisabled) WidgetState.disabled else WidgetState.selected }, colorScheme)),
              child: leadingIcon!,
            ), 
          ),
        if (text.isNotEmpty) 
          Text(
            text.toUpperCase(),
            // TextStyle được quản lý bởi ButtonStyle của ElevatedButton
          ),
        if (trailingIcon != null)
          Padding(
            padding: EdgeInsets.only(left: text.isNotEmpty ? 8.0 : 0.0),
            child: IconTheme(
              data: IconThemeData(color: _getTextColorForState({ if (actualDisabled) WidgetState.disabled else WidgetState.selected }, colorScheme)),
              child: trailingIcon!,
            ),
          ),
      ],
    );

    if (isLoading) {
      buttonContent = SizedBox(
        width: fontSize * 1.5,
        height: fontSize * 1.5,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
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
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.resolveWith((states) => _getTextColorForState(states, colorScheme)),
          padding: WidgetStateProperty.all(padding),
          minimumSize: WidgetStateProperty.all(Size(isFullWidth ? double.infinity : 0, height)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
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
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
              if (classType == ButtonClassType.standard) {
                return colorScheme.onPrimary.withAlpha((255 * 0.12).round());
              }
              if (classType == ButtonClassType.dangerous) {
                return colorScheme.onError.withAlpha((255 * 0.12).round());
              }
            }
            return null;
          }),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
        ),
        child: buttonContent,
      ),
    );
  }
} 