import 'package:flutter/material.dart';
import 'package:money_mate/features/transactions/domain/entities/transaction.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';
import 'package:money_mate/core/core.dart';

class ListEntries extends StatelessWidget {
  // Đổi tên class
  final List<Transaction> latestEntries;
  final List<Category> categories;
  final Function(Transaction entry) onLatestEntryTapped;
  final VoidCallback onMoreEntriesTapped;
  final bool? isShowTitle;

  const ListEntries({
    // Đổi tên constructor
    super.key,
    required this.latestEntries,
    required this.categories,
    required this.onLatestEntryTapped,
    required this.onMoreEntriesTapped,
    this.isShowTitle = true,
  });

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return isShowTitle!
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Entries',
                style: textTheme.titleMedium,
              ),
              AppIconButton(
                onPressed: onMoreEntriesTapped,
                icon: const Icon(Icons.more_horiz),
                isCircle: false,
                isFilled: false,
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget _buildList(BuildContext context) {
    if (latestEntries.isEmpty) {
      return const Center(child: Text('No entries yet.'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: latestEntries.length,
      itemBuilder: (context, index) {
        final entry = latestEntries[index];
        final categoryName = categories
            .firstWhere(
              (c) => c.id == entry.categoryId,
              orElse: () => Category(
                id: entry.categoryId,
                name: 'Unknown',
                iconName: '',
                type: entry.type == TransactionType.income
                    ? CategoryType.income
                    : CategoryType.expense,
              ),
            )
            .name;
        return EntryItem(
          transaction: entry,
          categoryName: categoryName,
          onTap: () => onLatestEntryTapped(entry),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 24.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context),
        const SizedBox(height: 24.0), // Khoảng cách giữa title và list
        _buildList(context),
      ],
    );
  }
}
