import 'package:flutter/material.dart';
// import 'package:money_mate/core/theme/app_colors.dart'; // Not directly used anymore for item colors
import 'package:money_mate/core/widgets/transaction_list_item.dart'; // Updated path

class TransactionListSection extends StatefulWidget {
  const TransactionListSection({super.key});

  @override
  State<TransactionListSection> createState() => _TransactionListSectionState();
}

class _TransactionListSectionState extends State<TransactionListSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Updated mock data structure
  final List<Map<String, dynamic>> _spendItems = [
    {
      'categoryIconPath': 'assets/icons/icon_food_cashback.svg',
      'title': 'Lunch at Cafe',
      'transactionDate': DateTime(2024, 2, 20),
      'amount': -20.50, // Negative for expense
      'categoryName': 'Food',
    },
    {
      'categoryIconPath': 'assets/icons/icon_uber_bike.svg',
      'title': 'Uber Ride',
      'transactionDate': DateTime(2024, 3, 13),
      'amount': -18.75, // Negative for expense
      'categoryName': 'Transport',
    },
    {
      'categoryIconPath': 'assets/icons/icon_shopping_bags.svg',
      'title': 'New Shoes',
      'transactionDate': DateTime(2024, 3, 11),
      'amount': -120.00, // Negative for expense
      'categoryName': 'Shopping',
    },
    {
      'categoryIconPath':
          'assets/icons/icon_salary_money_bag.svg', // Example income
      'title': 'Monthly Salary',
      'transactionDate': DateTime(2024, 3, 1),
      'amount': 2500.00, // Positive for income
      'categoryName': 'Salary',
    },
  ];

  // For the "Categories" tab, the structure might be different.
  // TransactionListItem expects: title, category (as sub-text), amount, date, categoryIconPath
  // Let's adapt _categoryItems to fit or consider a different list item widget if adaptation is too forced.
  // For now, we'll try to adapt.
  final List<Map<String, dynamic>> _categoryItems = [
    {
      'categoryIconPath': 'assets/icons/icon_food_cashback.svg',
      'title': 'Food & Drinks', // This will be the main title
      'transactionDate':
          DateTime.now(), // Placeholder, as "date" was "8 transactions"
      'amount': -250.00, // Representing total spend in this category
      'categoryName':
          '8 transactions', // This will be the sub-text (formerly category)
    },
    {
      'categoryIconPath': 'assets/icons/icon_shopping_bags.svg',
      'title': 'Shopping',
      'transactionDate': DateTime.now(),
      'amount': -550.00,
      'categoryName': '3 transactions',
    },
    {
      'categoryIconPath': 'assets/icons/icon_salary_money_bag.svg',
      'title': 'Income Sources',
      'transactionDate': DateTime.now(),
      'amount': 3000.00, // Total income example
      'categoryName': '2 sources',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final textTheme = theme.textTheme; // Not directly used here
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 32.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        // Consider adding boxShadow similar to other container elements if needed
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTabBar(colorScheme),
          const SizedBox(height: 32.0),
          SizedBox(
            // Constrain the height of the TabBarView
            height: 300, // Adjust as needed, or make it flexible
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionList(_spendItems),
                _buildTransactionList(
                    _categoryItems), // Reusing the same list builder
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ColorScheme colorScheme) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: colorScheme.outline.withOpacity(0.7), width: 1.0)),
      ),
      child: TabBar(
        controller: _tabController,
        labelStyle: textTheme.titleMedium,
        unselectedLabelStyle: textTheme.titleMedium,
        labelColor: colorScheme.onSurface,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: theme.primaryColor, width: 4.0),
          insets: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        tabs: const [
          Tab(text: 'Spends'),
          Tab(text: 'Categories'),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<Map<String, dynamic>> items) {
    return ListView.separated(
      itemCount: items.length,
      shrinkWrap:
          true, // Added to ensure ListView takes minimum necessary space within SizedBox
      physics:
          const AlwaysScrollableScrollPhysics(), // Ensure it's scrollable even if content is small
      itemBuilder: (context, index) {
        final item = items[index];
        return TransactionListItem(
          categoryIconPath: item['categoryIconPath'] as String,
          title: item['title'] as String,
          date: item['transactionDate'] as DateTime,
          amount: item['amount'] as double,
          subtitle: item['categoryName'] // Đổi từ category sang subtitle
              as String,
          onTap: () {
            // Handle tap, e.g., navigate to transaction details
            // print("Tapped on: ${item['title']}");
          },
        );
      },
      separatorBuilder: (context, index) =>
          const SizedBox(height: 16.0), // Reduced separator height
    );
  }
}
