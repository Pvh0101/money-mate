import 'dart:ui'; // Import PathMetric
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_mate/core/theme/app_colors.dart'; // Import app_colors

enum OptionCardType {
  dashed,
  normal,
  highlighted,
}

class OptionCardItem extends StatelessWidget {
  final String? title;
  final String iconPath;
  final OptionCardType type;
  final VoidCallback onTap;
  final bool isIconOnly; // Để xử lý card chỉ có icon plus

  const OptionCardItem({
    super.key,
    this.title,
    required this.iconPath,
    this.type = OptionCardType.normal,
    required this.onTap,
    this.isIconOnly = false,
  });

  // Hàm vẽ viền đứt nét
  Widget _buildDashedBorderContainer({
    required BuildContext context,
    required Widget child,
    required Color borderColor,
  }) {
    return CustomPaint(
      painter: DashedRectPainter(borderColor: borderColor),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    Color backgroundColor;
    Color iconColor;
    Color textColor;
    List<BoxShadow>? boxShadow;
    Border? border;

    switch (type) {
      case OptionCardType.dashed:
        backgroundColor = colorScheme.brightness == Brightness.light
            ? colorScheme.background // Light: neutralSoftGrey3 (#FAFAFB)
            : colorScheme.surfaceVariant; // Dark: neutralDark1 (#1F2933)
        iconColor = colorScheme.onSurfaceVariant;
        textColor = colorScheme.onSurfaceVariant;
        // Viền đứt nét sẽ được xử lý bằng CustomPaint, màu viền sẽ là colorScheme.outline
        break;
      case OptionCardType.highlighted:
        backgroundColor = Colors.transparent;
        iconColor = Colors.white;
        textColor = Colors.white;
        boxShadow = [
          BoxShadow(
            color: primaryBrandBlue
                .withOpacity(0.3), // Figma: #1D41F9 (primaryBrandBlue)
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ];
        break;
      case OptionCardType.normal:
      default:
        backgroundColor = colorScheme.surface;
        iconColor = colorScheme.onSurface; // Đổi sang onSurface
        textColor = colorScheme.onSurface;
        boxShadow = [
          BoxShadow(
            color: colorScheme.brightness == Brightness.light
                ? const Color(0xFF1D3A58).withOpacity(0.12)
                : const Color(0xFF1B2025),
            blurRadius: 64,
            offset: const Offset(0, 8),
          ),
        ];
        // border = Border.all(color: colorScheme.outline.withOpacity(0.1), width: 0.5); // Bỏ border này
        break;
    }

    Widget cardContent;
    if (isIconOnly) {
      cardContent = Center(
        child: Container(
          padding:
              const EdgeInsets.all(4.0), // Theo Figma (padding 4px quanh icon)
          // decoration: BoxDecoration(
          //   // Không có background riêng cho icon trong trường hợp dashed
          //   // borderRadius: BorderRadius.circular(8),
          // ),
          child: SvgPicture.asset(
            iconPath,
            width: 24, // Kích thước icon từ Figma
            height: 24,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
      );
    } else {
      cardContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8), // Wrapper cho icon
            decoration: BoxDecoration(
              // Figma có vẻ không dùng background cho icon trong card này
              // color: type == OptionCardType.highlighted ? Colors.white.withOpacity(0.1) : iconBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
          if (title != null)
            const SizedBox(
                height:
                    8), // Khoảng cách giữa icon và text theo Figma (32px tổng giữa icon và text, nhưng icon có padding riêng)
          if (title != null)
            Text(
              title!,
              textAlign: TextAlign.center,
              style: textTheme.labelMedium?.copyWith(color: textColor),
            ),
        ],
      );
    }

    Widget cardContainer = Container(
      // Kích thước thẻ từ Figma: Add Income/Expense là ~101x104, dashed là ~101x104
      // Width sẽ được quyết định bởi Flexible/Expanded trong Row
      // Height cố định
      height: 104,
      padding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 12), // Padding chung của card
      decoration: type == OptionCardType.highlighted
          ? BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2F51FF), Color(0xFF0E33F3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: boxShadow,
            )
          : BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(
                  type == OptionCardType.dashed ? 16 : 20),
              boxShadow: type == OptionCardType.dashed
                  ? null
                  : boxShadow, // Không có shadow cho dashed card
            ),
      child: cardContent,
    );

    // Áp dụng CustomPaint cho viền đứt nét SAU KHI Container cơ bản đã được tạo
    // Điều này đảm bảo CustomPaint vẽ lên trên decoration của Container
    if (type == OptionCardType.dashed) {
      cardContainer = _buildDashedBorderContainer(
        context: context,
        child: cardContainer,
        borderColor: colorScheme.brightness == Brightness.light
            ? neutralGrey3 // Light: #B0B8BF
            : colorScheme.outline, // Dark: neutralGrey2 (#9BA1A8)
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(type == OptionCardType.dashed ? 16 : 20),
      child: cardContainer,
    );
  }
}

// Custom painter cho viền đứt nét
class DashedRectPainter extends CustomPainter {
  final Color borderColor;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final Radius radius;

  DashedRectPainter({
    required this.borderColor,
    this.strokeWidth = 1.0,
    this.dashWidth = 6.0, // Theo Figma
    this.dashSpace = 6.0, // Theo Figma
    this.radius = const Radius.circular(16.0), // Theo Figma
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = borderColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Path path = Path();
    // Sử dụng kích thước từ size và radius đã định nghĩa
    path.addRRect(RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius,
    ));

    Path dashPath = Path();
    double distance = 0.0;

    // Cần lặp qua các path metrics để vẽ đường đứt nét chính xác theo path (bao gồm cả bo góc)
    for (PathMetric metric in path.computeMetrics()) {
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
