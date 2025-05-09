import 'package:flutter/material.dart';
import 'package:money_mate/features/dashboard/presentation/widgets/total_expense_app_bar.dart';
import 'package:money_mate/features/dashboard/presentation/widgets/date_picker_section.dart';
import 'package:money_mate/features/dashboard/presentation/widgets/budget_summary_widget.dart';
import 'package:money_mate/features/dashboard/presentation/widgets/transaction_list_section.dart';

class TotalExpensePage extends StatelessWidget {
  const TotalExpensePage({super.key});

  static const String routeName = '/total-expense';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const TotalExpenseAppBar(),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DatePickerSection(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: BudgetSummaryWidget(
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
