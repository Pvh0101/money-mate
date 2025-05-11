import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OptionCardItem extends StatelessWidget {
  final String? title;
  final String iconPath;
  final VoidCallback onTap;
  final bool isHighlighted; // Thêm để xử lý màu sắc

  const OptionCardItem({
    super.key,
    this.title,
    required this.iconPath,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final Color backgroundColor = isHighlighted
        ? colorScheme.primaryFixed // Highlighted: Màu primary
        : colorScheme.surface; // Normal: Màu surface
    final Color contentColor = isHighlighted
        ? colorScheme.onPrimary // Highlighted: Màu onPrimary cho icon và text
        : colorScheme.onSurface; // Normal: Màu onSurface

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        height: 88,
        width: 123,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10.0,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
            ),
            if (title != null) const SizedBox(height: 8),
            if (title != null)
              Text(
                title!,
                textAlign: TextAlign.center,
                style: textTheme.labelMedium?.copyWith(color: contentColor),
              ),
          ],
        ),
      ),
    );
  }
}
