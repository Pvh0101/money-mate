import 'package:flutter/material.dart';
import 'package:money_mate/core/constants/route_constants.dart';
import 'package:money_mate/core/enums/category_type.dart';
import 'package:money_mate/core/widgets/custom_app_bar.dart';
import 'package:money_mate/core/widgets/buttons/app_fill_button.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';
import '../widgets/category_list.dart';
import '../widgets/transaction_form_core.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});
  static const String routeName = RouteConstants.addExpense;

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _actualSelectedDate;
  String? _selectedCategoryId;
  Category? _selectedCategory;

  @override
  void dispose() {
    // Dispose controllers if any were managed here
    super.dispose();
  }

  void _handleCategorySelected(Category category) {
    setState(() {
      _selectedCategoryId = category.id;
      _selectedCategory = category;
    });
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TransactionFormCore(
              isIncome: false,
              formKey: _formKey,
              initialDate: _actualSelectedDate,
              onDateSelected: _handleDateSelected,
              categorySection: CategoryList(
                type: CategoryType.expense,
                selectedCategoryId: _selectedCategoryId,
                onCategorySelected: _handleCategorySelected,
              ),
            ),
            const SizedBox(height: 48),
            AppFillButton(
              text: 'Add Expense',
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _selectedCategory != null) {
                  // TODO: Implement expense submission logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Expense added: ${_selectedCategory!.name}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (_selectedCategory == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a category'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              isExpanded: true,
            ),
          ],
        ),
      ),
    );
  }
}
