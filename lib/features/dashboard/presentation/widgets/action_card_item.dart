import 'package:flutter/material.dart';

class ActionCardItem extends StatelessWidget {
  final String title;
  final Widget icon;  
  final bool isHighlighted;

  const ActionCardItem({
    super.key,
    required this.title,
    required this.icon,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final Color textColor; 
    final Color iconContainerBackground;
    BoxDecoration cardDecoration;

    if (isHighlighted) {
      // Style cho thẻ highlighted (gradient xanh)
      textColor = Colors.white;
      iconContainerBackground = const Color.fromRGBO(255, 255, 255, 0.25);
      cardDecoration = BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2F51FF), Color(0xFF0E33F3)], 
          begin: Alignment.centerLeft, 
          end: Alignment.centerRight,   
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.12), // Sử dụng shadow từ theme
            blurRadius: 64.0,
            offset: const Offset(0, 8),
          ),
        ],
      );
    } else {
      // Style cho thẻ thường (nền trắng/tối)
      textColor = theme.colorScheme.onSurface;
      iconContainerBackground = theme.colorScheme.surfaceVariant; // Màu nền icon từ theme
      cardDecoration = BoxDecoration(
        color: theme.colorScheme.surface, // Màu nền card từ theme
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.12), // Sử dụng shadow từ theme
            blurRadius: 64.0,
            offset: const Offset(0, 8),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: cardDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: iconContainerBackground,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: icon, 
          ),
          const SizedBox(width: 8.0), 
          Text(
            title,
            // Sử dụng style từ theme, điều chỉnh nếu cần
            style: theme.textTheme.titleSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600, // Figma: Subheading 12 (SemiBold)
            ),
          ),
        ],
      ),
    );
  }
} 