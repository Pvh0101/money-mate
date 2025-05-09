import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_mate/core/models/transaction_item_data.dart';
import 'package:money_mate/core/widgets/custom_app_bar.dart';
import 'package:money_mate/features/entries/presentation/widgets/entry_list_item.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mock data for transaction items
    final List<TransactionItemData> mockTransactions = [
      TransactionItemData(
        iconPath:
            'assets/icons/icon_food_cashback.svg', // Ensure these icons exist
        title: 'Food',
        date: 'May 21, 2024',
        amount: '-\$45.60',
        description:
            'Google Pay', // This maps to paymentMethod in EntryListItem
        amountColor: colorScheme.error, // Or determine based on amount sign
        iconBackgroundColor:
            colorScheme.surfaceVariant, // Default icon background
      ),
      TransactionItemData(
        iconPath: 'assets/icons/icon_uber_bike.svg',
        title: 'Uber',
        date: 'May 20, 2024',
        amount: '-\$12.00',
        description: 'Cash',
        amountColor: colorScheme.error,
        iconBackgroundColor: colorScheme.surfaceVariant,
      ),
      TransactionItemData(
        iconPath: 'assets/icons/icon_shopping_bags.svg',
        title: 'Shopping',
        date: 'May 19, 2024',
        amount: '+\$120.00',
        description: 'Paytm',
        amountColor: Colors.green, // Income color
        iconBackgroundColor: colorScheme.surfaceVariant,
      ),
      TransactionItemData(
        iconPath: 'assets/icons/home.svg', // Assuming rent icon is home.svg
        title: 'Rent',
        date: 'May 18, 2024',
        amount: '-\$400.00',
        description: 'Google Pay',
        amountColor: colorScheme.error,
        iconBackgroundColor: colorScheme.surfaceVariant,
      ),
      TransactionItemData(
        iconPath:
            'assets/icons/bill_icon.svg', // Assuming bill icon (e.g. invoices 1 from figma)
        title: 'Bill',
        date: 'May 17, 2024',
        amount: '-\$160.00',
        description: 'Cash',
        amountColor: colorScheme.error,
        iconBackgroundColor: colorScheme.surfaceVariant,
      ),
      TransactionItemData(
        iconPath:
            'assets/icons/movie_icon.svg', // Assuming movie icon (e.g. film 1 from figma)
        title: 'Movie',
        date: 'May 16, 2024',
        amount: '-\$80.00',
        description: 'Paytm',
        amountColor: colorScheme.error,
        iconBackgroundColor: colorScheme.surfaceVariant,
      ),
    ];

    return Scaffold(
      // backgroundColor: colorScheme.background, // Figma light: #F5F6F7, dark: #000000
      // Sẽ để default scaffoldBackgroundColor để theme tự xử lý light/dark
      appBar: CustomAppBar(
        titleText: 'Entries',
        // centerTitle: true, // Không cần nữa vì đã là mặc định trong CustomAppBar
        // actions: [ // Sẽ bị lỗi vì CustomAppBar không còn tham số actions
        //   IconButton(
        //     icon: SvgPicture.asset(
        //       'assets/icons/filter_icon.svg',
        //       colorFilter: ColorFilter.mode(
        //         colorScheme.onSurfaceVariant,
        //         BlendMode.srcIn,
        //       ),
        //     ),
        //     onPressed: () {
        //       // TODO: Implement filter functionality
        //     },
        //     tooltip: 'Filter',
        //   ),
        // ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: mockTransactions.length,
        itemBuilder: (context, index) {
          final item = mockTransactions[index];
          return EntryListItem(
            iconPath: item.iconPath,
            title: item.title,
            date: item.date,
            amount: item.amount,
            paymentMethod: item
                .description, // description từ data model giờ là paymentMethod
            iconColor: colorScheme.onSurfaceVariant, // Màu icon bên trong nền
            iconBackgroundColor:
                item.iconBackgroundColor ?? colorScheme.surfaceVariant,
            amountStyle: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: item.amount.startsWith('-')
                  ? colorScheme.error
                  : Colors.green, // Màu tiền theo +/-
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(
          height: 1, // Chỉ là đường kẻ, không cần khoảng cách lớn
          thickness: 1,
          color: theme.dividerColor.withOpacity(0.2), // Màu divider mờ hơn
          indent: 16, // Thụt lề cho divider
          endIndent: 16,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement FAB action (e.g., add new entry)
        },
        backgroundColor: theme.colorScheme.primary,
        child: SvgPicture.asset(
          'assets/icons/plus.svg',
          colorFilter: ColorFilter.mode(
            theme.colorScheme.onPrimary,
            BlendMode.srcIn,
          ),
          width: 24,
          height: 24,
        ),
        tooltip: 'Add Entry',
      ),
    );
  }
}

// Model đơn giản cho mock data, nên đặt ở file riêng nếu dùng nhiều
// Đã có TransactionItemData trong core/models, sẽ dùng nó
// import 'package:money_mate/core/models/transaction_item_data.dart';
