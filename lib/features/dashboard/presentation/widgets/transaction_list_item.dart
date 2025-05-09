import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_mate/core/theme/app_colors.dart';

class TransactionListItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String date;
  final String amount;
  final String paymentMethod;

  const TransactionListItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.date,
    required this.amount,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final titleStyle = textTheme.titleMedium?.copyWith(
      color: colorScheme.onSurface,
    );

    final dateStyle = textTheme.bodyMedium?.copyWith(
      color: neutralGrey1,
      letterSpacing: 0.02 * 14,
    );

    final amountStyle = textTheme.titleMedium?.copyWith(
      color: colorScheme.onSurface,
    );

    final paymentMethodStyle = textTheme.bodyMedium?.copyWith(
      color: neutralGrey1,
      letterSpacing: 0.02 * 14,
    );

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: neutralSoftGrey2,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: titleStyle),
              const SizedBox(height: 4),
              Text(date, style: dateStyle),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(amount, style: amountStyle),
            const SizedBox(height: 4),
            Text(paymentMethod, style: paymentMethodStyle),
          ],
        ),
      ],
    );
  }
}
