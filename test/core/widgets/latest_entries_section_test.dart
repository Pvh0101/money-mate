import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/widgets/list_entries.dart';
import 'package:money_mate/core/widgets/entry_item.dart';
import 'package:money_mate/core/widgets/buttons/app_icon_button.dart';
import 'package:money_mate/features/transactions/domain/entities/transaction.dart';
import 'package:money_mate/core/enums/transaction_type.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';
import 'package:money_mate/core/enums/category_type.dart';

void main() {
  group('LatestEntriesSection Tests', () {
    final List<Transaction> sampleEntries = [
      Transaction(
        id: '1',
        amount: 50,
        date: DateTime(2024, 1, 10),
        categoryId: 'Groceries',
        note: '',
        type: TransactionType.expense,
        userId: 'u1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        includeVat: false,
        paymentMethod: PaymentMethod.cash,
      ),
      Transaction(
        id: '2',
        amount: 2000,
        date: DateTime(2024, 1, 12),
        categoryId: 'Salary',
        note: '',
        type: TransactionType.income,
        userId: 'u1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        includeVat: false,
        paymentMethod: PaymentMethod.bankTransfer,
      ),
    ];

    final List<Category> sampleCategories = [
      Category(
        id: 'Groceries',
        name: 'Food',
        iconName: 'food',
        type: CategoryType.expense,
      ),
      Category(
        id: 'Salary',
        name: 'Salary',
        iconName: 'salary',
        type: CategoryType.income,
      ),
    ];

    testWidgets('renders title and more button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListEntries(
              latestEntries: const [],
              categories: sampleCategories,
              onLatestEntryTapped: (_) {},
              onMoreEntriesTapped: () {},
            ),
          ),
        ),
      );

      expect(find.text('Latest Entries'), findsOneWidget);
      expect(find.byType(AppIconButton), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
    });

    testWidgets('calls onMoreEntriesTapped when more button is tapped',
        (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListEntries(
              latestEntries: const [],
              categories: sampleCategories,
              onLatestEntryTapped: (_) {},
              onMoreEntriesTapped: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('shows \'No entries yet.\' when data is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListEntries(
              latestEntries: const [],
              categories: sampleCategories,
              onLatestEntryTapped: (_) {},
              onMoreEntriesTapped: () {},
            ),
          ),
        ),
      );

      expect(find.text('No entries yet.'), findsOneWidget);
      expect(find.byType(EntryItem), findsNothing);
    });

    testWidgets('renders list of LatestEntryItem when data is provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListEntries(
              latestEntries: sampleEntries,
              categories: sampleCategories,
              onLatestEntryTapped: (_) {},
              onMoreEntriesTapped: () {},
            ),
          ),
        ),
      );

      expect(find.byType(EntryItem), findsNWidgets(sampleEntries.length));
      expect(find.text('No entries yet.'), findsNothing);
      expect(find.text(sampleEntries.first.categoryId!), findsOneWidget);
    });

    testWidgets(
        'calls onLatestEntryTapped with correct data when an item is tapped',
        (WidgetTester tester) async {
      Transaction? tappedEntryData;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListEntries(
              latestEntries: sampleEntries,
              categories: sampleCategories,
              onLatestEntryTapped: (entryData) {
                tappedEntryData = entryData;
              },
              onMoreEntriesTapped: () {},
            ),
          ),
        ),
      );

      await tester
          .tap(find.widgetWithText(InkWell, sampleEntries.first.categoryId));
      await tester.pump();

      expect(tappedEntryData, isNotNull);
      expect(tappedEntryData, equals(sampleEntries.first));
    });
  });
}
