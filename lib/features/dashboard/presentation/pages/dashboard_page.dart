import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/dashboard_stats_section.dart';
import 'package:money_mate/core/widgets/list_entries.dart'; // Import mới
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_bloc.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_state.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_event.dart';
import 'package:money_mate/features/summary/presentation/bloc/summary_bloc.dart';
import 'package:money_mate/features/summary/presentation/bloc/summary_event.dart';
import 'package:money_mate/features/summary/presentation/bloc/summary_state.dart';
import 'package:money_mate/features/summary/domain/entities/time_range.dart';
import 'package:money_mate/core/enums/category_type.dart';
import 'package:hive/hive.dart';
import 'package:money_mate/core/storage/hive_config.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentCarouselIndex = 0;
  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  @override
  void initState() {
    super.initState();

    // Xóa cache summary để tính toán lại từ transactions
    _clearSummaryCache();

    // Lấy danh sách transaction thực tế khi vào dashboard
    context.read<TransactionBloc>().add(const GetTransactionsEvent());
    // Lấy cả income và expense categories
    context.read<CategoryBloc>().add(GetCategoriesEvent(CategoryType.income));
    context.read<CategoryBloc>().add(GetCategoriesEvent(CategoryType.expense));

    // Lấy dữ liệu summary cho tháng hiện tại
    final now = DateTime.now();
    print('Dashboard: Current date is $now');

    // Sử dụng khoảng thời gian custom thay vì enum để đảm bảo lấy dữ liệu hiện tại
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    context.read<SummaryBloc>().add(GetSummaryByDateRangeEvent(
          startDate: firstDayOfMonth,
          endDate: lastDayOfMonth,
        ));
  }

  Future<void> _clearSummaryCache() async {
    try {
      final summaryBox = Hive.box(HiveBoxes.summaryBox);
      await summaryBox.clear();
      print(
          'Dashboard: Cleared summary cache to recalculate from transactions');
    } catch (e) {
      print('Dashboard: Error clearing summary cache: $e');
    }
  }

  void _debugTransactions() {
    final transactionState = context.read<TransactionBloc>().state;
    if (transactionState is TransactionsLoaded) {
      print('Transactions loaded: ${transactionState.transactions.length}');

      for (final transaction in transactionState.transactions) {
        print(
            'Transaction: ${transaction.id}, amount: ${transaction.amount}, type: ${transaction.type}');
      }
    } else {
      print('Transaction state: $transactionState');
    }
  }

  void _onStatCardTapped(Map<String, dynamic> statData) {
    print("Stat card tapped: ${statData['title']}");
    // TODO: Navigate to a relevant screen
  }

  void _onActionCardTapped(Map<String, dynamic> actionData) {
    print("Action card tapped: ${actionData['title']}");
    // TODO: Navigate or perform action
  }

  void _onLatestEntryTapped(Map<String, dynamic> entryData) {
    print("Latest entry tapped: ${entryData['category']}");
    // TODO: Navigate to Transaction Detail screen
  }

  void _onMoreEntriesTapped() {
    print("More entries tapped");
    // TODO: Navigate to All Transactions screen
  }

  void _onUserProfileTapped() {
    print("User profile tapped");
    // TODO: Navigate to Profile screen
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Debug transactions
    Future.delayed(const Duration(seconds: 2), () {
      _debugTransactions();
    });

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: DashboardAppBar(
        onUserProfileTap: _onUserProfileTapped,
      ),
      body: ListView(
        children: [
          BlocBuilder<SummaryBloc, SummaryState>(
            builder: (context, state) {
              String totalIncome = "\$0.00";
              String totalExpense = "\$0.00";
              String monthlyExpense = "\$0.00";

              if (state is SummaryLoaded) {
                print(
                    'Summary data loaded: Income=${state.summaryData.totalIncome}, Expense=${state.summaryData.totalExpense}');
                totalIncome =
                    currencyFormatter.format(state.summaryData.totalIncome);
                totalExpense =
                    currencyFormatter.format(state.summaryData.totalExpense);
                monthlyExpense =
                    currencyFormatter.format(state.summaryData.totalExpense);
              } else if (state is SummaryLoading) {
                print('Summary is loading...');
              } else if (state is SummaryError) {
                print('Summary error: ${state.message}');
              } else {
                print('Summary state: $state');
              }

              return DashboardStatsSection(
                totalSalary: totalIncome,
                totalExpense: totalExpense,
                totalMonthlyExpense: monthlyExpense,
              );
            },
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DashboardActionsSection(
                //   actionCardData: ,
                //   currentCarouselIndex:
                //       _currentCarouselIndex, // Truyền state này
                //   onActionCardTapped: _onActionCardTapped,
                // ),
                const SizedBox(height: 32.0),
                BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, state) {
                    if (state is TransactionLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TransactionsLoaded) {
                      final transactions = state.transactions;
                      transactions.sort((a, b) => b.date.compareTo(a.date));
                      final lastEntries = transactions.take(5).toList();
                      return BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, catState) {
                          List<Category> categories = [];
                          if (catState is CategoriesLoaded) {
                            categories = catState.categories;
                          }
                          return ListEntries(
                            latestEntries: lastEntries,
                            categories: categories,
                            onLatestEntryTapped: (entry) =>
                                _onLatestEntryTapped({}),
                            onMoreEntriesTapped: _onMoreEntriesTapped,
                          );
                        },
                      );
                    } else if (state is TransactionFailure) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
