import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import SvgPicture
import 'package:money_mate/core/theme/app_colors.dart'; // Import app_colors
import 'package:money_mate/features/transactions/domain/entities/transaction.dart';
import '../../../../core/enums/transaction_type.dart';
import 'package:intl/intl.dart';

class EntryItem extends StatelessWidget {
  final Transaction transaction;
  final String categoryName;
  final VoidCallback? onTap;

  const EntryItem({
    super.key,
    required this.transaction,
    required this.categoryName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bool isIncome = transaction.type == TransactionType.income;
    Color effectiveAmountColor = isIncome ? systemGreen : colorScheme.onSurface;
    if (colorScheme.brightness == Brightness.dark && isIncome) {
      effectiveAmountColor = colorScheme.onSurface;
    }

    final iconSvgColor = colorScheme.brightness == Brightness.light
        ? colorScheme.onSurface
        : colorScheme.onSecondaryContainer;

    // Format amount
    final String sign = isIncome ? '+' : '-';
    final String currencySymbol = '\$';
    final String mainAmountValue = transaction.amount.toStringAsFixed(0);
    final String? vatText =
        (transaction.includeVat && transaction.vatRate != null)
            ? '${transaction.vatRate!.toStringAsFixed(2)}%'
            : null;

    String _paymentMethodToDisplay(PaymentMethod method) {
      switch (method) {
        case PaymentMethod.cash:
          return 'Cash';
        case PaymentMethod.bankTransfer:
          return 'Bank Transfer';
        case PaymentMethod.card:
          return 'Card';
        case PaymentMethod.momo:
          return 'Momo';
        case PaymentMethod.zalopay:
          return 'ZaloPay';
        case PaymentMethod.other:
          return 'Other';
      }
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side: Icon + Category/Date
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Icon(
                      isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                      color: iconSvgColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          categoryName,
                          style: textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          DateFormat('dd MMM yyyy').format(transaction.date),
                          style: textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Right side: Amount + Payment Method
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: sign,
                        style: textTheme.titleMedium
                            ?.copyWith(color: effectiveAmountColor),
                      ),
                      TextSpan(
                        text: currencySymbol,
                        style: textTheme.titleMedium
                            ?.copyWith(color: effectiveAmountColor),
                      ),
                      TextSpan(
                        text: mainAmountValue,
                        style: textTheme.titleMedium
                            ?.copyWith(color: effectiveAmountColor),
                      ),
                      if (vatText != null) ...[
                        TextSpan(
                          text: ' + VAT ',
                          style: textTheme.titleMedium?.copyWith(
                              color: effectiveAmountColor.withOpacity(0.7)),
                        ),
                        TextSpan(
                          text: vatText,
                          style: textTheme.titleMedium?.copyWith(
                              color: effectiveAmountColor.withOpacity(0.7)),
                        ),
                      ]
                    ],
                  ),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  _paymentMethodToDisplay(transaction.paymentMethod),
                  style: textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
