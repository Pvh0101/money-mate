import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import SvgPicture

class StatCardItem extends StatelessWidget {
  final String title;
  final String value;
  final String iconPath; // Thêm iconPath
  final bool isPrimaryStyle;
  final VoidCallback? onTap; // Thêm onTap callback

  const StatCardItem({
    super.key,
    required this.title,
    required this.value,
    required this.iconPath,
    required this.isPrimaryStyle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final Color textColor;
    final Color iconColor;
    // final List<BoxShadow>? boxShadow; // boxShadow được quản lý trong backgroundDecoration
    BoxDecoration backgroundDecoration;

    if (isPrimaryStyle) {
      textColor = Colors.white; // Figma: Màu chữ trắng trên nền gradient
      iconColor = Colors.white; // Figma: Màu icon trắng trên nền gradient
      backgroundDecoration = BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2F51FF),
            Color(0xFF0E33F3)
          ], // Nên dùng màu từ AppColors nếu có
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20.0), // Figma: borderRadius 20px
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E33F3) // Nên dùng màu từ AppColors nếu có
                .withValues(alpha: 0.25), // Bóng mờ màu xanh đậm hơn
            blurRadius: 12.0,
            offset: const Offset(0, 6),
          ),
        ],
      );
      // boxShadow = null;
    } else {
      textColor = colorScheme.onSurface; // Màu chữ trên nền surface
      iconColor =
          colorScheme.onSurfaceVariant; // Icon thường có màu nhẹ hơn text chính
      backgroundDecoration = BoxDecoration(
        color: colorScheme.surface, // Màu nền từ theme
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: colorScheme.brightness == Brightness.light
                ? const Color(0xFF1D3A58) // Nên dùng màu từ AppColors nếu có
                    .withValues(alpha: 0.12) // Figma light shadow
                : const Color(
                    0xFF1B2025), // Nên dùng màu từ AppColors nếu có // Figma dark shadow
            blurRadius: 64, // Giống OptionCardItem
            offset: const Offset(0, 8), // Giống OptionCardItem
          ),
        ],
      );
      // boxShadow = null;
    }

    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(20.0), // Cho hiệu ứng ripple khớp với card
      child: Container(
        width: 124, // Figma: width 124px
        height: 140, // Figma: height 140px (bao gồm padding)
        padding: const EdgeInsets.all(20.0), // Figma: padding 20px đều các cạnh
        decoration: backgroundDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  width: 24, // Figma: icon size 24x24
                  height: 24,
                ),
                const SizedBox(height: 8.0), // Khoảng cách giữa icon và title
                Text(
                  title,
                  style: textTheme.bodySmall?.copyWith(
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Text(
              value,
              style: textTheme.titleLarge?.copyWith(
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
