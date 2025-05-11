import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/widgets/dark_mode_switch.dart';

void main() {
  group('DarkModeSwitch Basic Tests', () {
    Widget buildTestableWidget(Brightness brightness) {
      return AdaptiveTheme(
          light: ThemeData.light(),
          dark: ThemeData.dark(),
          initial: brightness == Brightness.light
              ? AdaptiveThemeMode.light
              : AdaptiveThemeMode.dark,
          builder: (theme, darkTheme) {
            return MaterialApp(
              theme: theme,
              darkTheme: darkTheme,
              home: const Scaffold(
                body: Center(
                  child: DarkModeSwitch(),
                ),
              ),
            );
          });
    }

    testWidgets('shows dark_mode_outlined icon when theme brightness is light',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(Brightness.light));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
      expect(find.byIcon(Icons.light_mode_outlined), findsNothing);
    });

    testWidgets('shows light_mode_outlined icon when theme brightness is dark',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(Brightness.dark));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode_outlined), findsNothing);
    });

    testWidgets('IconButton can be tapped (does not verify theme change)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        AdaptiveTheme(
          light: ThemeData.light(),
          dark: ThemeData.dark(),
          initial: AdaptiveThemeMode.light,
          builder: (theme, darkTheme) => MaterialApp(
            theme: theme,
            darkTheme: darkTheme,
            home: const Scaffold(body: DarkModeSwitch()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(true, isTrue); // Placeholder
    });
  });
}
