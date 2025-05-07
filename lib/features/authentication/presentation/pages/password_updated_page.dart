import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Thêm import cho flutter_svg

import '../../../../core/constants/route_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/buttons/custom_button.dart'; // Giả sử bạn có CustomButton tái sử dụng được

class PasswordUpdatedPage extends StatelessWidget {
  const PasswordUpdatedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color onSurfaceColor = theme.colorScheme.onSurface;
    final Color secondaryTextColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    // Kích thước mong muốn cho SVG, bạn có thể điều chỉnh nếu cần
    const double svgIconSize = 100.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(flex: 2),
              // Icon - Thay thế CircleAvatar bằng SvgPicture.asset
              SizedBox(
                width: svgIconSize,
                height: svgIconSize,
                child: SvgPicture.asset(
                  'assets/icons/password_updated_illustration.svg',
                  semanticsLabel: 'Password Updated Illustration',
                  // fit: BoxFit.contain, // Bạn có thể cần điều chỉnh fit
                ),
              ),
              const SizedBox(height: 48.0), // Khoảng cách từ Figma (gap: 32px cho text, cộng thêm khoảng cách từ icon)

              // Title
              Text(
                'Password Changed!', // Text từ Figma
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500, // Figma: 500
                  color: onSurfaceColor, // Figma: #242D35
                ),
              ),
              const SizedBox(height: 8.0), // Khoảng cách từ Figma

              // Subtitle
              Text(
                'Your password has been changed\nsuccessfully.', // Text từ Figma, điều chỉnh cho khớp
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: secondaryTextColor, // Figma: #9BA1A8
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 3),

              // Button
              CustomButton(
                text: 'BACK TO LOGIN', // Text từ Figma
                onPressed: () {
                  Routes.navigateAndRemoveUntil(context, RouteConstants.login);
                },
                // gradientColors: const [Color(0xFF2F51FF), Color(0xFF0E33F3)], // Gradient từ Figma
                // textColor: Colors.white,
                // textStyle: theme.textTheme.labelLarge?.copyWith(
                //   color: Colors.white,
                //   fontWeight: FontWeight.w600, // Figma: 600
                //   letterSpacing: 0.5, // Thêm chút letter spacing cho chữ IN HOA
                // ),
              ),
              const SizedBox(height: 40), // Khoảng cách dưới cùng
            ],
          ),
        ),
      ),
    );
  }
} 