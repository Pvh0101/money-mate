import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_mate/core/theme/app_colors.dart';
import 'package:money_mate/core/utils/extensions/string_extensions.dart'; // For capitalizeFirstLetter
import 'package:intl/intl.dart'; // For number formatting

class TransactionListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final String currencySymbol;
  final String categoryIconPath; // New parameter
  final VoidCallback? onTap;

  const TransactionListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    this.currencySymbol = '\$',
    required this.categoryIconPath, // Made required
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'en_US', // Adjust locale as needed
      symbol: currencySymbol,
    );
    final bool isIncome = amount >=
        0; // Treat 0 as income for color neutrality or define a third color
    final Color amountColor;

    if (amount > 0) {
      amountColor = systemGreen;
    } else if (amount < 0) {
      amountColor = systemRed;
    } else {
      // For amount == 0, use a neutral color, e.g., from theme
      amountColor = Theme.of(context).colorScheme.onSurface;
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                categoryIconPath,
                width: 24,
                height: 24,
                // ignore: deprecated_member_use
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.capitalizeFirstLetter(),
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle.capitalizeFirstLetter(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormatter
                      .format(amount.abs()), // Display absolute amount
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: amountColor),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(date), // Simple date format
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
