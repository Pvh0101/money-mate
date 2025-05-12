import 'package:flutter/material.dart';
import 'package:money_mate/core/core.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_bloc.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_state.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Entries',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, tState) {
            if (tState is TransactionLoading) {
              return const LoadingStateShimmerList();
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
                    onLatestEntryTapped: (entry) {
                      // TODO: Xử lý khi một entry được tap, ví dụ điều hướng đến chi tiết
                      // print('Entry tapped: ${entry['category']}');
                    },
                    onMoreEntriesTapped: () {
                      // TODO: Xử lý khi nút "More" được tap, ví dụ điều hướng đến một trang đầy đủ hơn nếu cần
                      // print('More entries tapped');
                      // Trong ngữ cảnh của EntriesPage, nút này có thể không cần thiết
                      // hoặc có thể ẩn đi nếu LatestEntriesSection cho phép.
                      // Hiện tại, LatestEntriesSection luôn hiển thị nút này.
                    },
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
