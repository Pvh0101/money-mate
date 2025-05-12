import 'package:flutter/material.dart';
import 'package:money_mate/core/widgets/list_entries.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
                ListEntries(
                  isShowTitle: false,
                  latestEntries: const [],
                  categories: const [],
                  onLatestEntryTapped: (entry) {},
                  onMoreEntriesTapped: () {},
                ),
                // Reusing the same list builder
                ListEntries(
                  isShowTitle: false,
                  latestEntries: const [],
                  categories: const [],
                  onLatestEntryTapped: (entry) {},
                  onMoreEntriesTapped: () {},
                ),
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
        unselectedLabelColor: colorScheme.onSecondaryContainer,
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
}
