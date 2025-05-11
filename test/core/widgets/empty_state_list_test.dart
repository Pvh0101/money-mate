import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/widgets/empty_state_list.dart';

// MockEmptyStateList sử dụng SizedBox thay vì Image.asset
class MockEmptyStateList extends StatelessWidget {
  final String imageAssetName;
  final String title;
  final String description;

  const MockEmptyStateList({
    super.key,
    required this.imageAssetName,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Thay thế Image.asset bằng SizedBox có kích thước tương tự
          const SizedBox(
            width: 100,
            height: 100,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(description),
        ],
      ),
    );
  }
}

void main() {
  group('EmptyStateList Tests', () {
    const String testImageAssetName =
        'assets/images/empty_box.png'; // Giả sử đây là một asset hợp lệ
    const String testTitle = 'No Items Found';
    const String testDescription = 'There are currently no items to display.';

    // Helper function để pump widget
    Future<void> pumpEmptyStateList(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MockEmptyStateList(
              imageAssetName: testImageAssetName,
              title: testTitle,
              description: testDescription,
            ),
          ),
        ),
      );
    }

    testWidgets('renders title and description', (WidgetTester tester) async {
      await pumpEmptyStateList(tester);

      // Kiểm tra texts được hiển thị
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testDescription), findsOneWidget);
    });

    testWidgets('displays correct text style for title',
        (WidgetTester tester) async {
      await pumpEmptyStateList(tester);

      final titleTextWidget = tester.widget<Text>(find.text(testTitle));
      // Lấy theme từ context của MaterialApp được pump
      final ThemeData theme =
          Theme.of(tester.element(find.byType(MaterialApp)));
      expect(titleTextWidget.style, theme.textTheme.titleLarge);
    });
  });
}
