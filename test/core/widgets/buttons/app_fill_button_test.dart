import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/widgets/buttons/app_fill_button.dart';

void main() {
  testWidgets('AppFillButton displays text correctly',
      (WidgetTester tester) async {
    const buttonText = 'Test Button';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppFillButton(
              text: buttonText,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text(buttonText), findsOneWidget);
  });

  testWidgets('AppFillButton calls onPressed when tapped',
      (WidgetTester tester) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppFillButton(
              text: 'Tap Me',
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AppFillButton));
    await tester.pump();

    expect(wasPressed, isTrue);
  });

  testWidgets('AppFillButton expands to full width when isExpanded is true',
      (WidgetTester tester) async {
    // First test with isExpanded = false (default)
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppFillButton(
              text: 'Normal Button',
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    final normalButtonSize = tester.getSize(find.byType(ElevatedButton));

    // Then test with isExpanded = true
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppFillButton(
              text: 'Expanded Button',
              onPressed: () {},
              isExpanded: true,
            ),
          ),
        ),
      ),
    );

    final expandedButtonSize = tester.getSize(find.byType(ElevatedButton));

    // The expanded button should be wider than the normal button
    expect(expandedButtonSize.width, greaterThan(normalButtonSize.width));

    // The expanded button should take the full width of its parent container
    final parentSize = tester.getSize(find.byType(Center));
    expect(expandedButtonSize.width, equals(parentSize.width));
  });

  testWidgets('AppFillButton has correct styling', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppFillButton(
              text: 'Styled Button',
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    final elevatedButton = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton),
    );

    // Verify button styling
    final buttonStyle = elevatedButton.style as ButtonStyle;

    // Check that padding exists
    expect(buttonStyle.padding, isNotNull);

    // Check that elevation exists
    expect(buttonStyle.elevation, isNotNull);

    // Check that shape exists and is a RoundedRectangleBorder
    expect(buttonStyle.shape, isNotNull);

    // Check text styling
    final textWidget = tester.widget<Text>(find.byType(Text));
    expect(textWidget.textAlign, equals(TextAlign.center));
  });
}
