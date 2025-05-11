import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/core/widgets/custom_app_bar.dart';
import 'package:money_mate/core/widgets/empty_state_list.dart';
import 'package:money_mate/core/widgets/error_state_list.dart';
import 'package:money_mate/core/widgets/loading_state_shimmer_list.dart';
import 'package:money_mate/features/transactions/domain/entities/transaction.dart'
    as entity;
import 'package:money_mate/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:money_mate/features/transactions/presentation/widgets/transaction_item.dart';
import 'package:money_mate/features/transactions/presentation/pages/add_entry_page.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    final userId =
        'user_id'; // Sẽ thay thế bằng userId thực khi tích hợp với Auth

    context.read<TransactionBloc>().add(
          GetTransactionsByDateRangeEvent(
            start: _dateRange.start,
            end: _dateRange.end,
            userId: userId,
          ),
        );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _dateRange) {
      setState(() {
        _dateRange = picked;
      });
      _loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Giao dịch',
        trailing: IconButton(
          icon: const Icon(Icons.date_range),
          onPressed: _selectDateRange,
          tooltip: 'Chọn khoảng thời gian',
        ),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const LoadingStateShimmerList();
          } else if (state is TransactionsLoaded) {
            final transactions = state.transactions;
            if (transactions.isEmpty) {
              return EmptyStateList(
                imageAssetName: 'assets/images/empty_transactions.png',
                title: 'Không có giao dịch nào',
                description: 'Thêm giao dịch mới bằng cách nhấn nút dưới đây',
              );
            }

            // Sắp xếp giao dịch theo ngày (mới nhất lên đầu)
            transactions.sort((a, b) => b.date.compareTo(a.date));

            // Nhóm giao dịch theo ngày
            final Map<String, List<entity.Transaction>> groupedTransactions =
                {};

            for (var transaction in transactions) {
              final dateStr = DateFormat('yyyy-MM-dd').format(transaction.date);
              if (!groupedTransactions.containsKey(dateStr)) {
                groupedTransactions[dateStr] = [];
              }
              groupedTransactions[dateStr]!.add(transaction);
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                final dateStr = groupedTransactions.keys.elementAt(index);
                final transactionsForDate = groupedTransactions[dateStr]!;
                final date = DateTime.parse(dateStr);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        DateFormat('EEEE, d MMMM yyyy', 'vi_VN').format(date),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ...transactionsForDate
                        .map(
                          (transaction) => TransactionItem(
                            transaction: transaction,
                            onTap: () {
                              // TODO: Điều hướng đến trang chi tiết giao dịch
                            },
                          ),
                        )
                        .toList(),
                    const SizedBox(height: 16),
                  ],
                );
              },
            );
          } else if (state is TransactionFailure) {
            return ErrorStateList(
              imageAssetName: 'assets/images/error.png',
              errorMessage: 'Đã xảy ra lỗi: ${state.message}',
              onRetry: _loadTransactions,
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEntryPage(),
            ),
          );

          if (result == true) {
            _loadTransactions();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
