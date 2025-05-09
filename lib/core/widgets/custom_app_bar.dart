import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_mate/core/widgets/buttons/app_icon_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleText;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    this.titleText,
    this.showBackButton = true,
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
      elevation: theme.appBarTheme.elevation ?? 0.5,
      centerTitle: true,
      title: finalTitleWidget,
      leading: showBackButton
          ? AppIconButton(
            
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
            )
          : null,
      iconTheme:
          theme.appBarTheme.iconTheme?.copyWith(color: colorScheme.onSurface),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
