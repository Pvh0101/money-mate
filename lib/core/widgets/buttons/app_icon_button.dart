import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.isCircle = true,
    this.isFilled = false,
    this.size = 16,
  });

  final VoidCallback onPressed;
  final Widget icon;
  final String? tooltip;
  final bool isCircle;
  final bool isFilled;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor =
        isFilled ? colorScheme.primaryFixed : Colors.transparent;
    final foregroundColor = isFilled ? Colors.white : colorScheme.onSurface;
    final shape = isCircle
        ? const CircleBorder()
        : RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
    final side =
        isFilled ? null : BorderSide(color: colorScheme.outline, width: 1);
    return SizedBox(
      width: size * 2,
      height: size * 2,
      child: IconButton(
        onPressed: onPressed,
        icon: IconTheme(
          data: IconThemeData(size: 20, color: foregroundColor),
          child: icon,
        ),
        tooltip: tooltip,
        style: IconButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: shape,
          side: side,
          alignment: Alignment.center,
          padding: EdgeInsets.zero, // Thêm dòng này để loại bỏ padding mặc định
          // BỎ fixedSize đi!
        ),
      ),
    );
  }
}
