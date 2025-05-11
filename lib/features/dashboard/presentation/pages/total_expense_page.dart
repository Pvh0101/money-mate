import 'package:flutter/material.dart';
import 'package:money_mate/features/dashboard/presentation/widgets/transaction_list_section.dart';

import '../../../../core/core.dart';

class TotalExpensePage extends StatelessWidget {
  const TotalExpensePage({super.key});

  static const String routeName = '/total-expense';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        titleText: 'Total Expenses',
        showBackButton: true,
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DatePickerSection(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: CircularSummaryWidget(
                totalSpentAmountDisplay: "\$1,600",
                spentPercentageValue: 0.60,
              ),
            ),
            TransactionListSection(),
          ],
        ),
      ),
    );
  }
}
