import 'package:flutter/material.dart';
import 'package:money_mate/core/constants/route_constants.dart';
import 'package:money_mate/core/widgets/stat_card_item.dart'; // Import mới

class DashboardStatsSection extends StatelessWidget {
  final String totalSalary;
  final String totalExpense;
  final String totalMonthlyExpense;
  const DashboardStatsSection({
    super.key,
    required this.totalSalary,
    required this.totalExpense,
    required this.totalMonthlyExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
      child: SizedBox(
        height: 140,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            StatCardItem(
              title: "Total Income",
              value: totalSalary,
              iconPath: "assets/icons/wallet.svg",
              onTap: () {
                Navigator.pushNamed(context, RouteConstants.totalIncome);
              },
            ),
            const SizedBox(width: 16),
            StatCardItem(
              title: "Total Expense",
              value: totalExpense,
              iconPath: "assets/icons/wallet.svg",
              isPrimaryStyle: true,
              onTap: () {
                Navigator.pushNamed(context, RouteConstants.totalExpense);
              },
            ),
            const SizedBox(width: 16),
            StatCardItem(
              title: "Monthly Expense",
              value: totalMonthlyExpense,
              iconPath: "assets/icons/wallet.svg",
              onTap: () {
                Navigator.pushNamed(context, RouteConstants.summary);
              },
            ),
          ]),
        ),
      ),
    );
  }
}
