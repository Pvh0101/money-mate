import 'package:flutter/material.dart';

class StatCardItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isPrimaryStyle;

  const StatCardItem({
    super.key,
    required this.title,
    required this.value,
    required this.isPrimaryStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color textColor; 
    final Color iconColor; 
    BoxDecoration backgroundDecoration;

    if (isPrimaryStyle) {
      // Style cho thẻ primary (gradient xanh)
      textColor = Colors.white;
      iconColor = Colors.white;
      backgroundDecoration = BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2F51FF), Color(0xFF0E33F3)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20.0),
        
      );
    } else {
      // Style cho thẻ thường (nền trắng/tối)
      textColor = theme.colorScheme.onSurface;
      iconColor = theme.colorScheme.onSurface;
      backgroundDecoration = BoxDecoration(
        color: theme.colorScheme.surface, // Màu nền từ theme
        borderRadius: BorderRadius.circular(20.0),
      );
    }

    return Container(
      width: 124, 
      height: 140, 
      padding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 20.0), 
      decoration: backgroundDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.account_balance_wallet_outlined, color: iconColor, size: 24),
              const SizedBox(height: 8.0), 
              Text(
                title,
                // Sử dụng style từ theme, điều chỉnh nếu cần
                style: theme.textTheme.bodySmall?.copyWith(
                  color: textColor, 
                  fontWeight: FontWeight.w400, // Figma: Body 12 (Regular) weight is 400
                  letterSpacing: 0.02 * 12, 
                ),
              ),
            ],
          ),
          Text(
            value,
            // Sử dụng style từ theme, điều chỉnh nếu cần
            style: theme.textTheme.titleLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600, // Figma: Subheading 18 (SemiBold) - titleLarge or headlineSmall might fit size 18
              fontSize: 18, // Giữ lại fontSize 18
              letterSpacing: 0.02 * 18, 
            ),
          ),
        ],
      ),
    );
  }
} 