import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/widgets/action_card_item.dart';

// Mock SvgPicture.asset để tránh lỗi MissingPluginException trong môi trường test thuần túy
// Hoặc đảm bảo bạn có một cách để cung cấp SVG thực sự (ví dụ: thông qua package flutter_svg_test)
// Ở đây, chúng ta sẽ giả định rằng việc tìm thấy SvgPicture là đủ.

void main() {
  group('ActionCardItem Tests', () {
    const String testTitle = 'Test Action';
    const String testIconPath =
        'assets/icons/test_icon.svg'; // Giả sử asset này tồn tại

    testWidgets('renders title and icon, and handles tap',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionCardItem(
              title: testTitle,
              iconPath: testIconPath,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Kiểm tra title được hiển thị
      expect(find.text(testTitle), findsOneWidget);

      // Kiểm tra SvgPicture được hiển thị (chúng ta không kiểm tra nội dung SVG)
      expect(find.byType(SvgPicture), findsOneWidget);
      final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
      // expect(svgPicture.bytesLoader, isA<SvgAssetLoader>()); // Kiểm tra sâu hơn nếu cần
      // if (svgPicture.bytesLoader is SvgAssetLoader) {
      //   expect((svgPicture.bytesLoader as SvgAssetLoader).assetName, testIconPath);
      // }

      // Kiểm tra onTap
      await tester.tap(find.byType(ActionCardItem));
      await tester.pump(); // Chờ xử lý tap
      expect(tapped, isTrue);
    });

    testWidgets('displays default style when not highlighted',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
              brightness: Brightness.light), // Cung cấp theme để test style
          home: Scaffold(
            body: ActionCardItem(
              title: testTitle,
              iconPath: testIconPath,
              isHighlighted: false,
            ),
          ),
        ),
      );

      // Kiểm tra màu chữ (textColor)
      final textWidget = tester.widget<Text>(find.text(testTitle));
      final ThemeData theme =
          Theme.of(tester.element(find.byType(MaterialApp)));
      expect(textWidget.style?.color, theme.colorScheme.onSurface);
    });

    testWidgets('displays highlighted style when isHighlighted is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
              brightness: Brightness.light), // Cung cấp theme để test style
          home: Scaffold(
            body: ActionCardItem(
              title: testTitle,
              iconPath: testIconPath,
              isHighlighted: true,
            ),
          ),
        ),
      );

      // Kiểm tra màu chữ (textColor)
      final textWidget = tester.widget<Text>(find.text(testTitle));
      expect(textWidget.style?.color, Colors.white);
    });
  });
}
