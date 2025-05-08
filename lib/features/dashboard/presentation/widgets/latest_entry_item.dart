import 'package:flutter/material.dart';

class LatestEntryItem extends StatelessWidget {
  final Widget iconWidget;
  final String category;
  final String date;
  final String amount;
  final String paymentMethod;

  const LatestEntryItem({
    super.key,
    required this.iconWidget,
    required this.category,
    required this.date,
    required this.amount,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        // Left side: Icon + Category/Date
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0), 
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant, // Màu nền icon từ theme
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: iconWidget, // Sử dụng iconWidget được truyền vào trực tiếp
            ),
            const SizedBox(width: 14.0), 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  // Sử dụng style từ theme
                  style: theme.textTheme.titleMedium?.copyWith(
                     fontWeight: FontWeight.w600 // Giữ lại weight 600
                  ),
                ),
                const SizedBox(height: 4), 
                Text(
                  date,
                  // Sử dụng style từ theme
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant // Màu nhạt hơn cho date
                  ),
                ),
              ],
            ),
          ],
        ),
        // Right side: Amount + Payment Method
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              // Sử dụng style từ theme
              style: theme.textTheme.titleMedium?.copyWith(
                 fontWeight: FontWeight.w600 // Giữ lại weight 600
              ),
            ),
            const SizedBox(height: 4), 
            Text(
              paymentMethod,
              // Sử dụng style từ theme
              style: theme.textTheme.bodyMedium?.copyWith(
                 color: theme.colorScheme.onSurfaceVariant // Màu nhạt hơn cho payment method
              ),
            ),
          ],
        ),
      ],
    );
  }
} 