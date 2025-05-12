import 'package:flutter/material.dart';
import 'package:money_mate/core/widgets/custom_app_bar.dart';
import 'package:money_mate/core/widgets/list_entries.dart';
import 'package:money_mate/features/transactions/presentation/widgets/add_options_section.dart';
import 'package:money_mate/core/constants/route_constants.dart';
import 'package:money_mate/features/transactions/domain/entities/transaction.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_bloc.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_state.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  // Mock data cho Latest Entries
  // final List<Map<String, dynamic>> _latestEntriesData = DashboardMockData.latestEntriesData;

  void _onAddIncomeTapped() {
    Navigator.pushNamed(context, RouteConstants.addIncome);
  }

  void _onAddExpenseTapped() {
    Navigator.pushNamed(context, RouteConstants.addExpense);
  }

  void _onPlusIconTapped() {}

  void _onLatestEntryTapped(Map<String, dynamic> entryData) {}

  void _onMoreEntriesTapped() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background, // Nền chính của trang
      appBar: const CustomAppBar(
        titleText: 'Add Entry',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: AddOptionsSection(
              onAddIncomeTap: _onAddIncomeTapped,
              onAddExpenseTap: _onAddExpenseTapped,
              onPlusIconTap: _onPlusIconTapped,
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 32.0),
                  child: BlocBuilder<TransactionBloc, TransactionState>(
                    builder: (context, tState) {
                      if (tState is TransactionLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (tState is TransactionsLoaded) {
                        final transactions = tState.transactions;
                        transactions.sort((a, b) => b.date.compareTo(a.date));
                        final lastEntries = transactions.take(5).toList();
                        return BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, cState) {
                            List<Category> categories = [];
                            if (cState is CategoriesLoaded) {
                              categories = cState.categories;
                            }
                            return ListEntries(
                              latestEntries: lastEntries,
                              categories: categories,
                              onLatestEntryTapped: (entry) {},
                              onMoreEntriesTapped: _onMoreEntriesTapped,
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
