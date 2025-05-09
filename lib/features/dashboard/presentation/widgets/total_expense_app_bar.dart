import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TotalExpenseAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const TotalExpenseAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appBarTitleStyle = textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: colorScheme.onSurface,
    );

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leadingWidth: 80,
      leading: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 8, bottom: 8),
        child: InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.outline,
                width: 0.5,
              ),
            ),
            child: SvgPicture.asset(
              'assets/icons/arrow_left_nav.svg',
              colorFilter:
                  ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
      title: Text(
        'Total Expenses',
        style: appBarTitleStyle,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
