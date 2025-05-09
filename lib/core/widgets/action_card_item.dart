import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:money_mate/core/theme/app_colors.dart'; // Consider importing if using AppColors constants directly

class ActionCardItem extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isHighlighted;
  final VoidCallback? onTap;

  const ActionCardItem({
    super.key,
    required this.title,
    required this.iconPath,
    this.isHighlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final Color textColor;
    final Color iconColor;
    final Color iconContainerBackground;
    BoxDecoration cardDecoration;

    if (isHighlighted) {
      textColor = Colors.white;
      iconColor = Colors.white;
      iconContainerBackground = Colors.white.withOpacity(0.25);
      cardDecoration = BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2F51FF),
            Color(0xFF0E33F3)
          ], // AppColors.primaryBlueGradientStartFigma, AppColors.primaryBrandBlue
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E33F3)
                .withValues(alpha: 0.25), // AppColors.primaryBrandBlue
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      );
    } else {
      textColor = colorScheme.onSurface;
      iconColor = colorScheme.onSurfaceVariant;
      iconContainerBackground = colorScheme.secondaryContainer;
      cardDecoration = BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: colorScheme.brightness == Brightness.light
                ? const Color(0xFF1D3A58)
                    .withValues(alpha: 0.12) // AppColors.neutralDark1 etc.
                : const Color(
                    0xFF1B2025), // AppColors.neutralDarkSomething etc.
            blurRadius: 64,
            offset: const Offset(0, 8),
          ),
        ],
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: cardDecoration,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: iconContainerBackground,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                width: 20,
                height: 20,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  color: textColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
