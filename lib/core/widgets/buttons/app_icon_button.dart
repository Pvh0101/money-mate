import 'package:flutter/material.dart';

import 'button_enums.dart';
import 'button_style_helpers.dart';

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
    this.size = ButtonSize.large,
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
    final colorScheme = theme.colorScheme;

    final double defaultButtonSize =
        AppButtonStyleHelper.getIconButtonContainerSize(this.size);
    final double defaultActualIconSize =
        AppButtonStyleHelper.getIconButtonIconSize(this.size);

    final double finalButtonSizeWidth = width ?? defaultButtonSize;
    final double finalButtonSizeHeight = height ?? defaultButtonSize;
    final double finalIconSize = this.iconSize ?? defaultActualIconSize;
    final bool actualDisabled = isDisabled || isLoading;

    // Resolve colors using AppButtonStyleHelper
    final Color resolvedBackgroundColorVal =
        AppButtonStyleHelper.getIconButtonSurfaceColor(
      colorScheme: colorScheme,
      classType: classType,
      iconButtonType: iconButtonType,
      isDisabledOrLoading: actualDisabled,
    );

    final Color resolvedIconColorVal =
        AppButtonStyleHelper.getIconButtonIconColor(
      colorScheme: colorScheme,
      classType: classType,
      iconButtonType: iconButtonType,
      isDisabledOrLoading: actualDisabled,
    );

    final Color borderColorVal = AppButtonStyleHelper.getIconButtonBorderColor(
      colorScheme: colorScheme,
      classType: classType,
      iconButtonType: iconButtonType,
      isDisabledOrLoading: actualDisabled,
    );

    final double verticalPadding =
        AppButtonStyleHelper.getIconButtonContentVerticalPadding(this.size);
    final double horizontalPadding = (finalButtonSizeWidth - finalIconSize) / 2;

    final EdgeInsetsGeometry finalPadding = padding ??
        EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding.clamp(0, double.infinity));

    final BorderRadius defaultShapeBorderRadius =
        shape == IconButtonShape.circle
            ? BorderRadius.circular(finalButtonSizeWidth / 2)
            : BorderRadius.circular(
                AppButtonStyleHelper.getBorderRadius(this.size));

    final resolvedBorderRadius = borderRadius ?? defaultShapeBorderRadius;

    return SizedBox(
      width: finalButtonSizeWidth,
      height: finalButtonSizeHeight,
      child: Material(
        color: Colors.transparent,
        borderRadius: resolvedBorderRadius,
        child: InkWell(
          onTap: actualDisabled ? null : onPressed,
          borderRadius: resolvedBorderRadius,
          child: Container(
            padding: finalPadding,
            decoration: BoxDecoration(
              color: resolvedBackgroundColorVal,
              borderRadius: resolvedBorderRadius,
              border: Border.all(
                color:
                    borderColorVal, // Already considers disabled state from helper
                width: 1,
              ),
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: finalIconSize,
                      height: finalIconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          // Use the generic loading indicator color resolver
                          AppButtonStyleHelper.getLoadingIndicatorColor(
                            variant: ButtonVariant.icon,
                            colorScheme: colorScheme,
                            classType: classType,
                            iconButtonType: iconButtonType,
                          ),
                        ),
                      ),
                    )
                  : Icon(
                      icon,
                      size: finalIconSize,
                      color:
                          resolvedIconColorVal, // Already considers disabled state from helper
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
