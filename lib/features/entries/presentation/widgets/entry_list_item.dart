import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EntryListItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String date;
  final String amount;
  final String paymentMethod;
  final Color iconColor;
  final Color iconBackgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? dateStyle;
  final TextStyle? amountStyle;
  final TextStyle? paymentMethodStyle;

  const EntryListItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.date,
    required this.amount,
    required this.paymentMethod,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.titleStyle,
    this.dateStyle,
    this.amountStyle,
    this.paymentMethodStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Default styles from theme, can be overridden by parameters
    final finalTitleStyle = titleStyle ??
        theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600, // SemiBold
            fontSize: 16, // Figma: 16px for entry item title
            color: colorScheme.onSurface);
    final finalDateStyle = dateStyle ??
        theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14, // Figma: 14px for entry item date/subtitle
            color: colorScheme.onSurfaceVariant);
    final finalAmountStyle = amountStyle ??
        theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600, // SemiBold
          fontSize: 16, // Figma: 16px for amount
          color: amount.startsWith('-')
              ? colorScheme.error
              : Colors.green, // Basic income/expense color
        );
    final finalPaymentMethodStyle = paymentMethodStyle ??
        theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14, // Figma: 14px for payment method
            color: colorScheme.onSurfaceVariant);

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 12.0), // Vertical spacing for each item
      child: Row(
        children: [
          // Icon with background
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 16),
          // Title and Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: finalTitleStyle),
                const SizedBox(height: 4),
                Text(date, style: finalDateStyle),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Amount and Payment Method
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: finalAmountStyle),
              const SizedBox(height: 4),
              Text(paymentMethod, style: finalPaymentMethodStyle),
            ],
          ),
        ],
      ),
    );
  }
}
