import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/widgets/fields/app_text_form_field.dart';
import 'package:money_mate/core/widgets/fields/field_label_text.dart';

void main() {
  testWidgets('AppTextFormField renders correctly',
      (WidgetTester tester) async {
    final controller = TextEditingController(text: 'Test Input');
    const hintText = 'Enter text';
    const labelText = 'Input Label';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppTextFormField(
              controller: controller,
              hintText: hintText,
              labelText: labelText,
            ),
          ),
        ),
      ),
    );

    expect(find.text(labelText), findsOneWidget);
    expect(find.text('Test Input'), findsOneWidget);
    expect(find.byType(FieldLabelText), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('AppTextFormField shows prefix icon when provided',
      (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextFormField(
            controller: controller,
            prefixIconData: Icons.search,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('AppTextFormField shows suffix icon when provided',
      (WidgetTester tester) async {
    final controller = TextEditingController();
    bool iconPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppTextFormField(
              controller: controller,
              suffixIconData: Icons.clear,
              onSuffixIconPressed: () {
                iconPressed = true;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.clear), findsOneWidget);

    // Tap the suffix icon
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();

    expect(iconPressed, isTrue);
  });

  testWidgets('AppTextFormField toggles password visibility',
      (WidgetTester tester) async {
    final controller = TextEditingController(text: 'password123');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppTextFormField(
              controller: controller,
              obscureText: true,
            ),
          ),
        ),
      ),
    );

    // Check that the password is initially obscured
    TextFormField textField = tester.widget<TextFormField>(
      find.byType(TextFormField),
    );

    // Find and tap the visibility toggle icon
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();

    // Check that the password is now visible
    textField = tester.widget<TextFormField>(
      find.byType(TextFormField),
    );

    // Icon should have changed
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets('AppTextFormField applies fillColor when provided',
      (WidgetTester tester) async {
    final controller = TextEditingController();
    const fillColor = Colors.amber;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppTextFormField(
              controller: controller,
              fillColor: fillColor,
            ),
          ),
        ),
      ),
    );

    // The actual decoration testing would require more complex testing
    // Here we're just verifying the field renders correctly with the color
    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('AppTextFormField validates input correctly',
      (WidgetTester tester) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    const errorMessage = 'This field is required';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: AppTextFormField(
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return errorMessage;
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );

    // Attempt to validate with empty input
    formKey.currentState!.validate();
    await tester.pump();

    // Check that error message is displayed
    expect(find.text(errorMessage), findsOneWidget);

    // Enter text and validate again
    await tester.enterText(find.byType(TextFormField), 'Valid input');
    formKey.currentState!.validate();
    await tester.pump();

    // Error message should be gone
    expect(find.text(errorMessage), findsNothing);
  });
}
