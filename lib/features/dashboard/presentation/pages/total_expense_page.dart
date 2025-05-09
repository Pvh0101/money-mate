import 'package:flutter/material.dart';
import 'package:money_mate/core/theme/app_colors.dart'; // For scaffold background
import 'package:money_mate/features/dashboard/presentation/widgets/total_expense_app_bar.dart';
import 'package:money_mate/features/dashboard/presentation/widgets/date_picker_section.dart';
import 'package:money_mate/features/dashboard/presentation/widgets/budget_summary_widget.dart';
import 'package:money_mate/features/dashboard/presentation/widgets/transaction_list_section.dart';
// Import other widgets once created

class TotalExpensePage extends StatelessWidget {
  const TotalExpensePage({super.key});

  static const String routeName = '/total-expense';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context)
          .scaffoldBackgroundColor, // Use theme-dependent background color
      appBar: const TotalExpenseAppBar(),
      body: SingleChildScrollView(
        // Ensure the SingleChildScrollView allows its children to determine their own size as much as possible,
        // but also that it can scroll if the content overflows.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Date Picker Section
            const DatePickerSection(),
            // Spacing between DatePicker and BudgetSummary is handled by their respective internal/external paddings/margins

            // 2. Budget Summary Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: BudgetSummaryWidget(
                totalSpentAmountDisplay: "\$1,600", // Mock data for display
                spentPercentageValue: 0.60, // Mock data for display
              ),
            ),
            // Spacing before TransactionListSection (gap between stats and list container in Figma)
            // The TransactionListSection itself has top padding of 32px.
            // The visual gap is between the calendar card and the list card.
            // DatePickerSection has bottom margin of 16. BudgetSummary has vertical padding of 24.
            // The list container (TransactionListSection) will be directly after.

            // 3. Transaction List Section
            const TransactionListSection(),
          ],
        ),
      ),
    );
  }
}
