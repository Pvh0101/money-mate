import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import SvgPicture

class StatCardItem extends StatelessWidget {
  final String title;
  final String value;
  final String iconPath; // Thêm iconPath
  final bool isPrimaryStyle; // Để xác định màu sắc
  final VoidCallback? onTap; // Thêm onTap callback

  const StatCardItem({
    super.key,
    required this.title,
    required this.value,
    required this.iconPath,
    this.isPrimaryStyle = false, // Mặc định là style thường
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final Color cardBackgroundColor = isPrimaryStyle
        ? colorScheme.primaryFixed // Style chính: nền màu primaryFixed
        : colorScheme.surface; // Style thường: nền màu surface
    final Color contentColor = isPrimaryStyle
        ? Colors.white
        : colorScheme.onSurface; // Style thường: icon và text màu onSurface

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          width: 124,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12.0,
                offset: const Offset(0, 6),
                spreadRadius: -5,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    iconPath,
                    colorFilter:
                        ColorFilter.mode(contentColor, BlendMode.srcIn),
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    title,
                    style: textTheme.bodySmall?.copyWith(color: contentColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Text(
                value,
                style: textTheme.titleMedium?.copyWith(
                    color: contentColor, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
