import 'package:flutter/material.dart';
import 'package:money_mate/core/constants/route_constants.dart';
import 'package:money_mate/core/enums/category_type.dart';
import 'package:money_mate/core/widgets/custom_app_bar.dart';
import 'package:money_mate/core/widgets/buttons/app_fill_button.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';
import '../widgets/category_list.dart';
import '../widgets/transaction_form_core.dart';

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({super.key});
  static const String routeName = RouteConstants.addIncome;

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _actualSelectedDate;
  String? _selectedCategoryId;
  Category? _selectedCategory;

  @override
  void dispose() {
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
        titleText: 'Add Income',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TransactionFormCore(
              isIncome: true,
              formKey: _formKey,
              initialDate: _actualSelectedDate,
              onDateSelected: _handleDateSelected,
              categorySection: CategoryList(
                type: CategoryType.income,
                selectedCategoryId: _selectedCategoryId,
                onCategorySelected: _handleCategorySelected,
              ),
            ),
            const SizedBox(height: 48),
            AppFillButton(
              text: 'Add Income',
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _selectedCategory != null) {
                  // TODO: Implement income submission logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Income added: ${_selectedCategory!.name}'),
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
