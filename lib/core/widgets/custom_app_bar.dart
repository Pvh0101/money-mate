import 'package:flutter/material.dart';
import 'package:money_mate/core/widgets/buttons/app_icon_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleText;
  final bool showBackButton;
  final Widget? trailing;

  const CustomAppBar({
    super.key,
    this.titleText,
    this.showBackButton = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    Widget? finalTitleWidget;
    if (titleText != null) {
      finalTitleWidget = Text(
        titleText!,
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: colorScheme.onSurface,
        ),
      );
    }

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor ?? colorScheme.surface,
      // elevation: theme.appBarTheme.elevation ?? 1,
      centerTitle: true,
      title: finalTitleWidget,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: AppIconButton(
                size: 20,
                isCircle: true,
                isFilled: false,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                ),
              ),
            )
          : null,
      actions: trailing != null ? [trailing!] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
