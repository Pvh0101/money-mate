import 'package:flutter/material.dart';

class TransactionItemData {
  final String iconPath;
  final String title;
  final String date; // Can be date or any primary subtitle
  final String amount;
  final String description; // Can be payment method or any secondary subtitle
  final Color amountColor; // To distinguish income/expense or based on category
  final Color? iconBackgroundColor; // Optional background for the icon

  TransactionItemData({
    required this.iconPath,
    required this.title,
    required this.date,
    required this.amount,
    required this.description,
    required this.amountColor,
    this.iconBackgroundColor,
  });
}
