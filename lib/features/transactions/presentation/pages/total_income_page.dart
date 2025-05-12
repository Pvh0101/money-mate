import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class TotalIncomePage extends StatelessWidget {
  const TotalIncomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        titleText: 'Total Income',
        showBackButton: true,
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                children: [
                  DatePickerSection(),
                  SizedBox(height: 24.0),
                  CircularSummaryWidget(
                    totalSpentAmountDisplay: "\$1,600",
                    spentPercentageValue: 0.60,
                  ),
                ],
              ),
            ),
            TransactionList(),
          ],
        ),
      ),
    );
  }
}
