import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          ? IconButton(
              icon: SvgPicture.asset(
                'assets/icons/chevron_left.svg',
                colorFilter: ColorFilter.mode(
                  colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
                width: 24,
                height: 24,
              ),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            )
          : null,
      iconTheme:
          theme.appBarTheme.iconTheme?.copyWith(color: colorScheme.onSurface),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
