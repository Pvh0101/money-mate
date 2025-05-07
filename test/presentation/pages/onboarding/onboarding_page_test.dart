import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/constants/route_constants.dart';
import 'package:money_mate/core/routes/app_routes.dart';
import 'package:money_mate/features/authentication/presentation/pages/onboarding_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  Widget createTestableWidget() {
    return const MaterialApp(
      home: OnboardingPage(),
    );
  }

  testWidgets('OnboardingPage hiển thị đúng phần tử UI cho trang đầu tiên',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    // Kiểm tra logo hiển thị
    expect(find.text('monex'), findsOneWidget);

    // Kiểm tra các phần tử của slide đầu tiên
    expect(find.text('Note Down Expenses'), findsOneWidget);
    expect(find.text('Daily note your expenses to\nhelp manage money'),
        findsOneWidget);

    // Kiểm tra nút NEXT hiển thị (vì đang ở trang đầu tiên)
    expect(find.text('NEXT'), findsOneWidget);
    expect(find.text('LET\'S GO'), findsNothing);

    // Kiểm tra chỉ số trang hiển thị
    expect(find.byType(SmoothPageIndicator), findsOneWidget);
  });

  testWidgets('Chuyển trang khi nhấn nút NEXT', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    // Xác nhận đang ở trang đầu tiên
    expect(find.text('Note Down Expenses'), findsOneWidget);
    expect(find.text('NEXT'), findsOneWidget);

    // Nhấn nút NEXT
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle(); // Đợi animation hoàn thành

    // Kiểm tra đã chuyển sang trang thứ hai
    expect(find.text('Note Down Expenses'), findsNothing);
    expect(find.text('Simple Money Management'), findsOneWidget);
    expect(
        find.text(
            'Get your notifications or alert\nwhen you do the over expenses'),
        findsOneWidget);
  });

  testWidgets('Hiển thị nút LET\'S GO ở trang cuối cùng',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    // Chuyển đến trang thứ 2
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();

    // Chuyển đến trang thứ 3
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();

    // Kiểm tra đã hiển thị nút LET'S GO thay vì NEXT
    expect(find.text('NEXT'), findsNothing);
    expect(find.text('LET\'S GO'), findsOneWidget);
    expect(find.text('Easy to Track and Analize'), findsOneWidget);
    expect(
        find.text('Tracking your expense help make sure\nyou don\'t overspend'),
        findsOneWidget);
  });

  testWidgets('Có thể vuốt để chuyển trang', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    // Xác nhận đang ở trang đầu tiên
    expect(find.text('Note Down Expenses'), findsOneWidget);

    // Vuốt sang trái để chuyển sang trang tiếp theo
    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pumpAndSettle();

    // Kiểm tra đã chuyển sang trang thứ hai
    expect(find.text('Note Down Expenses'), findsNothing);
    expect(find.text('Simple Money Management'), findsOneWidget);
  });

  testWidgets('Nhấn LET\'S GO ở trang cuối sẽ điều hướng sang trang đăng nhập',
      (WidgetTester tester) async {
    // Tạo navigatorObserver để theo dõi điều hướng
    final mockObserver = MockNavigatorObserver();

    await tester.pumpWidget(MaterialApp(
      home: const OnboardingPage(),
      navigatorObservers: [mockObserver],
      onGenerateRoute: (settings) {
        if (settings.name == RouteConstants.login) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('Login Page')),
            settings: settings,
          );
        }
        return null;
      },
    ));

    // Chuyển đến trang cuối
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();

    // Nhấn nút LET'S GO
    await tester.tap(find.text('LET\'S GO'));
    await tester.pumpAndSettle();

    // Xác minh có sự chuyển hướng (không thể test chính xác tên route trong Flutter test)
    expect(find.text('Login Page'), findsOneWidget);
  });
}

// Mock Navigator Observer
class MockNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>?> pushedRoutes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }
}
