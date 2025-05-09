import 'package:flutter/material.dart';
import 'package:money_mate/core/theme/app_colors.dart';
import 'package:money_mate/features/dashboard/presentation/widgets/transaction_list_item.dart';

class TransactionListSection extends StatefulWidget {
  const TransactionListSection({super.key});

  @override
  State<TransactionListSection> createState() => _TransactionListSectionState();
}

class _TransactionListSectionState extends State<TransactionListSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _spendItems = [
    {
      'icon': 'assets/icons/icon_food_cashback.svg',
      'title': 'Food',
      'date': '20 Feb 2024',
      'amount': '+ \$20 + Vat 0.5%',
      'paymentMethod': 'Google Pay',
    },
    {
      'icon': 'assets/icons/icon_uber_bike.svg',
      'title': 'Uber',
      'date': '13 Mar 2024',
      'amount': '- \$18 + Vat 0.8%',
      'paymentMethod': 'Cash',
    },
    {
      'icon': 'assets/icons/icon_shopping_bags.svg',
      'title': 'Shopping',
      'date': '11 Mar 2024',
      'amount': '- \$400 + Vat 0.12%',
      'paymentMethod': 'Paytm',
    },
  ];

  final List<Map<String, String>> _categoryItems = [
    {
      'icon': 'assets/icons/icon_food_cashback.svg',
      'title': 'Food & Drinks',
      'date': '8 transactions',
      'amount': '\$250.00',
      'paymentMethod': '40% of total spend',
    },
    {
      'icon': 'assets/icons/icon_shopping_bags.svg',
      'title': 'Shopping',
      'date': '3 transactions',
      'amount': '\$550.00',
      'paymentMethod': '60% of total spend',
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
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final tabLabelStyle = textTheme.titleMedium;
    final unselectedTabLabelStyle =
        textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant);

    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 32.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTabBar(
              context, tabLabelStyle, unselectedTabLabelStyle, colorScheme),
          const SizedBox(height: 32.0),
          SizedBox(
            height: 300,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionList(_spendItems),
                _buildTransactionList(_categoryItems),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, TextStyle? selectedStyle,
      TextStyle? unselectedStyle, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: colorScheme.outline.withOpacity(0.7), width: 1.0)),
      ),
      child: TabBar(
        controller: _tabController,
        labelStyle: selectedStyle,
        unselectedLabelStyle: unselectedStyle,
        labelColor: colorScheme.onSurface,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: colorScheme.primary, width: 4.0),
          insets: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        tabs: const [
          Tab(text: 'Spends'),
          Tab(text: 'Categories'),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<Map<String, String>> items) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return TransactionListItem(
          iconPath: item['icon']!,
          title: item['title']!,
          date: item['date']!,
          amount: item['amount']!,
          paymentMethod: item['paymentMethod']!,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 32.0),
    );
  }
}
