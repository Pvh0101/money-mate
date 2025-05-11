import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/widgets/latest_entries_section.dart';
import 'package:money_mate/core/widgets/latest_entry_item.dart';
import 'package:money_mate/core/widgets/buttons/app_icon_button.dart';

void main() {
  group('LatestEntriesSection Tests', () {
    final List<Map<String, dynamic>> sampleEntries = [
      {
        'icon': 'assets/icons/sample_icon_1.svg',
        'category': 'Groceries',
        'date': 'Jan 10',
        'amount': '+ \$50',
        'paymentMethod': 'Cash'
      },
      {
        'icon': 'assets/icons/sample_icon_2.svg',
        'category': 'Salary',
        'date': 'Jan 12',
        'amount': '+ \$2000',
        'paymentMethod': 'Bank Transfer'
      },
    ];

    testWidgets('renders title and more button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LatestEntriesSection(
              latestEntriesData: const [],
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
            body: LatestEntriesSection(
              latestEntriesData: const [],
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
            body: LatestEntriesSection(
              latestEntriesData: const [],
              onLatestEntryTapped: (_) {},
              onMoreEntriesTapped: () {},
            ),
          ),
        ),
      );

      expect(find.text('No entries yet.'), findsOneWidget);
      expect(find.byType(LatestEntryItem), findsNothing);
    });

    testWidgets('renders list of LatestEntryItem when data is provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LatestEntriesSection(
              latestEntriesData: sampleEntries,
              onLatestEntryTapped: (_) {},
              onMoreEntriesTapped: () {},
            ),
          ),
        ),
      );

      expect(find.byType(LatestEntryItem), findsNWidgets(sampleEntries.length));
      expect(find.text('No entries yet.'), findsNothing);
      expect(find.text(sampleEntries.first['category']!), findsOneWidget);
    });

    testWidgets(
        'calls onLatestEntryTapped with correct data when an item is tapped',
        (WidgetTester tester) async {
      Map<String, dynamic>? tappedEntryData;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LatestEntriesSection(
              latestEntriesData: sampleEntries,
              onLatestEntryTapped: (entryData) {
                tappedEntryData = entryData;
              },
              onMoreEntriesTapped: () {},
            ),
          ),
        ),
      );

      // Vì LatestEntryItem có thể phức tạp, ta tìm widget con của nó là Text với category để tap
      // Điều này giả định rằng LatestEntryItem render Text widget cho category
      await tester
          .tap(find.widgetWithText(InkWell, sampleEntries.first['category']!));
      await tester.pump();

      expect(tappedEntryData, isNotNull);
      expect(tappedEntryData, equals(sampleEntries.first));
    });
  });
}
