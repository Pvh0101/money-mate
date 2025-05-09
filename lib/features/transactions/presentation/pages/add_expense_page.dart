import 'package:flutter/material.dart';
import 'package:money_mate/core/constants/route_constants.dart';
import 'package:money_mate/core/widgets/custom_app_bar.dart';
import 'package:money_mate/core/widgets/buttons/app_fill_button.dart';
import 'package:money_mate/core/widgets/buttons/button_enums.dart';
import '../models/category_ui_data.dart';
import '../widgets/transaction_form_core.dart';
import '../widgets/expense_category_list.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});
  static const String routeName = RouteConstants.addExpense;

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _actualSelectedDate;
  String? _selectedCategory;

  // Mock data for expense categories
  final List<CategoryUIData> _expenseCategories = [
    CategoryUIData(label: 'Food'),
    CategoryUIData(label: 'Transport'),
    CategoryUIData(label: 'Shopping'),
    CategoryUIData(label: 'Bills'),
    CategoryUIData(label: 'Entertainment'),
  ];

  @override
  void dispose() {
    // Dispose controllers if any were managed here
    super.dispose();
  }

  void _handleCategorySelected(String categoryLabel) {
    setState(() {
      _selectedCategory = categoryLabel;
    });
  }

  void _handleAddNewCategory() {
    // Placeholder for add new expense category logic
    // print('Add New Expense Category tapped');
  }

  void _handleDateSelected(DateTime? date) {
    setState(() {
      _actualSelectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Add Expense',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TransactionFormCore(
              formKey: _formKey,
              initialDate: _actualSelectedDate,
              onDateSelected: _handleDateSelected,
              // titleController and amountController can be managed by TransactionFormCore or passed in
              categorySection: ExpenseCategoryList(
                categories: _expenseCategories,
                selectedCategory: _selectedCategory,
                onCategorySelected: _handleCategorySelected,
                onAddNewCategory: _handleAddNewCategory,
              ),
            ),
            const SizedBox(height: 48),
            AppFillButton(
              text: 'Add Expense',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Implement expense submission logic
                }
              },
              isFullWidth: true,
              size: ButtonSize.large,
            ),
          ],
        ),
      ),
    );
  }
}
