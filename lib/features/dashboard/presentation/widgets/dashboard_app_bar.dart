import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_mate/core/widgets/dark_mode_switch.dart'; // For SystemUiOverlayStyle
// import 'dart:ui'; // ImageFilter.blur không còn được sử dụng trực tiếp ở đây

// import 'package:money_mate/core/widgets/dark_mode_switch.dart'; // Tạm thời loại bỏ nếu không có trong Figma

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onUserProfileTap;

  const DashboardAppBar({super.key, this.onUserProfileTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    // Style cho tiêu đề AppBar, khớp với Figma (18px, semibold)
    // final appBarTitleStyle = textTheme.titleLarge?.copyWith(
    //   color: colorScheme.onBackground, // Màu chữ trên màu nền scaffold
    //   fontWeight: FontWeight.w600,
    //   fontSize: 18,
    // );

    return AppBar(
      backgroundColor: Colors
          .transparent, // Trong suốt để hiện màu scaffoldBackgroundColor của Page
      elevation: 0,
      systemOverlayStyle: isDarkMode
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent) // Icons sáng trên nền tối
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent), // Icons tối trên nền sáng
      title: Text(
        'Overview',
        style: textTheme.titleLarge, // Sử dụng trực tiếp từ theme
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
              right: 16.0), // Figma: 16px padding từ mép phải
          child: InkWell(
            onTap: onUserProfileTap,
            customBorder: const CircleBorder(),
            child: CircleAvatar(
              radius: 20, // Figma: avatar 40x40
              backgroundColor: colorScheme.brightness == Brightness.light
                  ? colorScheme
                      .surfaceVariant // Light: neutralSoftGrey2 (#EBEEF0)
                  : colorScheme
                      .secondaryContainer, // Dark: darkIconBackground (#3E4C59)
              // TODO: Replace with actual user image from UserBloc/AuthBloc state
              // child: userImageUrl != null ? ClipOval(child: Image.network(userImageUrl, fit: BoxFit.cover)) : Icon(Icons.person, color: colorScheme.onSurfaceVariant),
              child: Icon(Icons.person_outline,
                  color: colorScheme.onSurfaceVariant,
                  size: 24), // Placeholder icon
            ),
          ),
        ),
        const DarkModeSwitch(), // Tạm thời loại bỏ, không thấy trong Figma overview
        // const SizedBox(width: 8), // Không cần nếu DarkModeSwitch bị bỏ
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
