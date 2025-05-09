import 'package:flutter/material.dart';
import 'package:money_mate/core/widgets/fields/app_text_field.dart';
import 'package:money_mate/core/widgets/date_picker_section.dart'; // Assuming this is the correct path

class TransactionFormCore extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final DateTime? initialDate;
  final Function(DateTime?) onDateSelected;
  final TextEditingController? titleController; // Made optional
  final TextEditingController? amountController; // Made optional
  final Widget categorySection;

  const TransactionFormCore({
    super.key,
    required this.formKey,
    this.initialDate,
    required this.onDateSelected,
    this.titleController,
    this.amountController,
    required this.categorySection,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DatePickerSection(
            initialDate: initialDate,
            onDateSelected: onDateSelected,
            // title: 'Transaction Date', // Optional: Add title if needed in DatePickerSection
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller:
                titleController, // Use provided controller or it will be null (managed internally by AppTextField if needed)
            labelText: 'Title',
            hintText: 'Enter transaction title',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller:
                amountController, // Use provided controller or it will be null
            labelText: 'Amount',
            hintText: 'Enter amount',
            keyboardType: TextInputType.number,
            // prefixIcon: Icons.attach_money, // Consider if this should be part of AppTextField or specific to page
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              if (double.parse(value) <= 0) {
                return 'Amount must be greater than zero';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          categorySection,
        ],
      ),
    );
  }
}
