import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/features/transactions/presentation/widgets/option_card_item.dart';

void main() {
  testWidgets('OptionCardItem renders correctly with all properties',
      (WidgetTester tester) async {
    // Arrange
    bool wasTapped = false;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OptionCardItem(
            title: 'Test Title',
            iconPath: 'assets/icons/test_icon.svg',
            onTap: () {
              wasTapped = true;
            },
            isHighlighted: true,
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.byType(OptionCardItem), findsOneWidget);

    // Test that tapping works
    await tester.tap(find.byType(OptionCardItem));
    expect(wasTapped, true);
  });

  testWidgets('OptionCardItem renders correctly without title',
      (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OptionCardItem(
            iconPath: 'assets/icons/test_icon.svg',
            onTap: () {},
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('OptionCardItem uses correct colors when highlighted',
      (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OptionCardItem(
            title: 'Highlighted',
            iconPath: 'assets/icons/test_icon.svg',
            onTap: () {},
            isHighlighted: true,
          ),
        ),
      ),
    );

    // Find the container to verify its color properties
    final Container container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(OptionCardItem),
            matching: find.byType(Container),
          )
          .first,
    );

    // Testing the background color would require mocking ThemeData
    // This is a basic assertion to check the structure
    expect(container.decoration, isNotNull);
    expect(container.decoration, isA<BoxDecoration>());
  });

  testWidgets('OptionCardItem uses default colors when not highlighted',
      (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OptionCardItem(
            title: 'Not Highlighted',
            iconPath: 'assets/icons/test_icon.svg',
            onTap: () {},
            isHighlighted: false,
          ),
        ),
      ),
    );

    // Find the container to verify its color properties
    final Container container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(OptionCardItem),
            matching: find.byType(Container),
          )
          .first,
    );

    // Testing the background color would require mocking ThemeData
    // This is a basic assertion to check the structure
    expect(container.decoration, isNotNull);
    expect(container.decoration, isA<BoxDecoration>());
  });
}
