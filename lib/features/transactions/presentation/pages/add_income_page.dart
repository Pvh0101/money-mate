import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/core/constants/route_constants.dart';
import 'package:money_mate/core/widgets/custom_app_bar.dart';
import 'package:money_mate/core/widgets/fields/app_text_field.dart';
import 'package:money_mate/core/widgets/buttons/app_fill_button.dart';
import 'package:money_mate/core/widgets/buttons/button_enums.dart';
import 'package:money_mate/core/widgets/date_picker_section.dart';
// import 'package:money_mate/features/transactions/presentation/widgets/income_category_list.dart'; // Removed incorrect import
import '../models/category_ui_data.dart'; // Added correct import for CategoryUIData
import '../widgets/income_category_list.dart';
import '../widgets/transaction_form_core.dart';

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({super.key});
  // static const String routeName = '/add-income'; // Sẽ dùng RouteConstants
  static const String routeName = RouteConstants.addIncome;

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _actualSelectedDate;
  String? _selectedCategory;

  final List<CategoryUIData> _incomeCategories = [
    CategoryUIData(label: 'Salary'),
    CategoryUIData(label: 'Rewards'),
    CategoryUIData(label: 'Investment'),
    CategoryUIData(label: 'Side Business'),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  void _handleCategorySelected(String categoryLabel) {
    setState(() {
      _selectedCategory = categoryLabel;
    });
  }

  void _handleAddNewCategory() {
    // print('Add New Category tapped in AddIncomePage');
  }

  void _handleDateSelected(DateTime? date) {
    setState(() {
      _actualSelectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Add Income',
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
              categorySection: IncomeCategoryList(
                categories: _incomeCategories,
                selectedCategory: _selectedCategory,
                onCategorySelected: _handleCategorySelected,
                onAddNewCategory: _handleAddNewCategory,
              ),
            ),
            const SizedBox(height: 48),
            AppFillButton(
              text: 'Add Income',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Xử lý logic submit income
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
