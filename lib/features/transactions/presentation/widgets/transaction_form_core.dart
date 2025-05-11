import 'package:flutter/material.dart';
import 'package:money_mate/core/widgets/date_picker_section.dart';
import 'package:money_mate/core/widgets/fields/app_text_form_field.dart';
import 'package:money_mate/core/widgets/fields/field_label_text.dart'; // Assuming this is the correct path

class TransactionFormCore extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final DateTime? initialDate;
  final Function(DateTime?) onDateSelected;
  final TextEditingController? titleController; // Made optional
  final TextEditingController? amountController; // Made optional
  final Widget categorySection;

  final bool isIncome;

  const TransactionFormCore({
    super.key,
    required this.formKey,
    this.initialDate,
    required this.onDateSelected,
    this.titleController,
    this.amountController,
    required this.categorySection,
    required this.isIncome,
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
          AppTextFormField(
            labelText: isIncome ? 'Income Title' : 'Expense Title',
            controller: titleController ?? TextEditingController(),
            hintText: isIncome ? 'Enter income title' : 'Enter expense title',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          AppTextFormField(
            labelText: "Amount",
            controller: amountController ?? TextEditingController(),
            hintText: isIncome ? 'Enter income amount' : 'Enter expense amount',
            keyboardType: TextInputType.number,
            suffixIconData: Icons.attach_money,
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
          const SizedBox(height: 32),
          FieldLabelText(isIncome ? 'Income Category' : 'Expense Category'),
          SizedBox(
            height: 56,
            child: categorySection,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
