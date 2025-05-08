import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemUiOverlayStyle
import 'dart:ui';

import 'package:money_mate/core/widgets/dark_mode_switch.dart'; // For ImageFilter.blur

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AppBar(
      // Sử dụng màu nền scaffold để hòa vào nền
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0, // Bỏ shadow
      // Đảm bảo icon status bar có màu tương phản
      systemOverlayStyle: isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      title: Text(
        'Overview',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          // AppBar tự xử lý màu chữ dựa trên brightness của backgroundColor
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0), // Padding cho avatar
          child: CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.surfaceVariant,
            // TODO: Replace with actual user image
            // child: Image.network('URL_TO_IMAGE_ONCE_DOWNLOADED'),
          ),
        ),
        const DarkModeSwitch(), // Thêm nút chuyển đổi
        const SizedBox(width: 8), // Padding cuối
      ],
    );
  }

  @override
  // Sử dụng chiều cao AppBar chuẩn
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 