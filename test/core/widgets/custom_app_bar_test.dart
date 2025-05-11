import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/widgets/custom_app_bar.dart';
// Import AppIconButton nếu nó được sử dụng trong các test, ví dụ như kiểm tra sự tồn tại của nó.
// import 'package:money_mate/core/widgets/buttons/app_icon_button.dart';

void main() {
  group('CustomAppBar Tests', () {
    testWidgets('renders titleText and back button by default',
        (WidgetTester tester) async {
      const String testTitle = 'Test Title';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(
              titleText: testTitle,
            ),
          ),
        ),
      );

      expect(find.text(testTitle), findsOneWidget);
      // Mặc định showBackButton là true, nên icon arrow_back_ios_new sẽ hiển thị
      // vì CustomAppBar sử dụng AppIconButton với Icon(Icons.arrow_back_ios_new)
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });

    testWidgets('does not render back button when showBackButton is false',
        (WidgetTester tester) async {
      const String testTitle = 'No Back Button';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(
              titleText: testTitle,
              showBackButton: false,
            ),
          ),
        ),
      );

      expect(find.text(testTitle), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsNothing);
    });

    testWidgets('renders trailing widget when provided',
        (WidgetTester tester) async {
      const String testTitle = 'With Trailing';
      final Key trailingKey = UniqueKey();
      final Widget testTrailing = IconButton(
        key: trailingKey,
        icon: const Icon(Icons.settings),
        onPressed: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(
              titleText: testTitle,
              trailing: testTrailing,
            ),
          ),
        ),
      );

      expect(find.text(testTitle), findsOneWidget);
      expect(find.byKey(trailingKey), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('does not render title when titleText is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(// titleText is omitted, so it's null
                ),
          ),
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.title, isNull);
    });

    testWidgets('back button pops navigation when pressed',
        (WidgetTester tester) async {
      bool navigatedBack = false;
      final GlobalKey<NavigatorState> navigatorKey =
          GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Scaffold(
            appBar: const CustomAppBar(titleText: 'Page 1'),
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return Scaffold(
                      appBar: CustomAppBar(
                        titleText: 'Page 2',
                        // Đảm bảo nút quay lại được hiển thị
                        showBackButton: true,
                        // Cung cấp context cho Navigator.pop
                        // Điều này thường được xử lý bởi Navigator tự động
                      ),
                      body: const Center(child: Text('Page 2 Content')),
                    );
                  }));
                },
                child: const Text('Go to Page 2'),
              ),
            ),
          ),
        ),
      );

      // Navigate to Page 2
      await tester.tap(find.text('Go to Page 2'));
      await tester.pumpAndSettle(); // Wait for navigation to complete

      // Verify we are on Page 2
      expect(find.text('Page 2'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);

      // Tap the back button on Page 2's CustomAppBar
      // Chúng ta cần đảm bảo rằng context được sử dụng bởi Navigator.pop(context) trong CustomAppBar là đúng.
      // Trong trường hợp này, nó sẽ sử dụng context của CustomAppBar, vốn là một phần của Page 2.
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle(); // Wait for pop navigation to complete

      // Verify we are back on Page 1
      expect(find.text('Page 1'), findsOneWidget);
      // Kiểm tra rằng không còn Page 2 trên stack nữa
      expect(find.text('Page 2'), findsNothing);
    });
  });
}
