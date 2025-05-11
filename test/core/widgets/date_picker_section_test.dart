import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/widgets/date_picker_section.dart';
import 'package:intl/intl.dart'; // Cần cho DateFormat

void main() {
  group('DatePickerSection Tests', () {
    late DateTime initialTestDate;

    setUp(() {
      initialTestDate = DateTime(2024, 7, 15); // Monday, July 15, 2024
    });

    Widget buildTestableDatePicker({
      DateTime? initialDate,
      ValueChanged<DateTime>? onDateSelected,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: DatePickerSection(
            initialDate: initialDate ?? initialTestDate,
            onDateSelected: onDateSelected,
          ),
        ),
      );
    }

    testWidgets('renders date picker widget correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableDatePicker());
      await tester.pumpAndSettle();

      // Kiểm tra widget đã được render
      expect(find.byType(DatePickerSection), findsOneWidget);
    });
  });
}
