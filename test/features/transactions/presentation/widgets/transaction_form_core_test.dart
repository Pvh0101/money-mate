import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/widgets/date_picker_section.dart';
import 'package:money_mate/core/widgets/fields/app_text_form_field.dart';
import 'package:money_mate/features/transactions/presentation/widgets/transaction_form_core.dart';

void main() {
  Widget buildTestableWidget({
    required bool isIncome,
    DateTime? initialDate,
    GlobalKey<FormState>? formKey,
    Function(DateTime?)? onDateSelected = null,
    TextEditingController? titleController,
    TextEditingController? amountController,
  }) {
    final key = formKey ?? GlobalKey<FormState>();
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: TransactionFormCore(
            formKey: key,
            initialDate: initialDate,
            onDateSelected: onDateSelected ?? (date) {},
            categorySection: Container(), // Mock category section
            isIncome: isIncome,
            titleController: titleController,
            amountController: amountController,
          ),
        ),
      ),
    );
  }

  testWidgets('TransactionFormCore renders all components',
      (WidgetTester tester) async {
    // Arrange
    final formKey = GlobalKey<FormState>();

    // Act
    await tester.pumpWidget(buildTestableWidget(
      isIncome: false,
      formKey: formKey,
    ));

    // Assert
    expect(find.byType(DatePickerSection), findsOneWidget);
    expect(find.byType(AppTextFormField),
        findsNWidgets(2)); // Title and Amount fields
    expect(find.text('Expense Title'), findsOneWidget);
    expect(find.text('Amount'), findsOneWidget);
    expect(find.text('Expense Category'), findsOneWidget);
  });

  testWidgets('TransactionFormCore shows income labels when isIncome is true',
      (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(buildTestableWidget(
      isIncome: true,
    ));

    // Assert
    expect(find.text('Income Title'), findsOneWidget);
    expect(find.text('Income Category'), findsOneWidget);
  });

  testWidgets('TransactionFormCore validates fields correctly when empty',
      (WidgetTester tester) async {
    // Arrange
    final formKey = GlobalKey<FormState>();

    // Act
    await tester.pumpWidget(buildTestableWidget(
      isIncome: false,
      formKey: formKey,
    ));

    // Try to validate the form
    final isValid = formKey.currentState!.validate();

    // Assert
    expect(isValid, false); // Form should be invalid
    await tester.pump(); // Process build after validation messages appear
    expect(find.text('Please enter a title'), findsOneWidget);
    expect(find.text('Please enter an amount'), findsOneWidget);
  });

  testWidgets('TransactionFormCore validates amount field with non-number',
      (WidgetTester tester) async {
    // Arrange
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController(text: 'abc');

    // Act
    await tester.pumpWidget(buildTestableWidget(
      isIncome: false,
      formKey: formKey,
      amountController: amountController,
    ));

    // Try to validate the form
    final isValid = formKey.currentState!.validate();

    // Assert
    expect(isValid, false);
    await tester.pump();
    expect(find.text('Please enter a valid number'), findsOneWidget);
  });

  testWidgets('TransactionFormCore validates amount field with zero value',
      (WidgetTester tester) async {
    // Arrange
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController(text: '0');

    // Act
    await tester.pumpWidget(buildTestableWidget(
      isIncome: false,
      formKey: formKey,
      amountController: amountController,
    ));

    // Try to validate the form
    final isValid = formKey.currentState!.validate();

    // Assert
    expect(isValid, false);
    await tester.pump();
    expect(find.text('Amount must be greater than zero'), findsOneWidget);
  });

  testWidgets('TransactionFormCore passes validation with valid inputs',
      (WidgetTester tester) async {
    // Arrange
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: 'Lunch');
    final amountController = TextEditingController(text: '15.50');

    // Act
    await tester.pumpWidget(buildTestableWidget(
      isIncome: false,
      formKey: formKey,
      titleController: titleController,
      amountController: amountController,
    ));

    // Try to validate the form
    final isValid = formKey.currentState!.validate();

    // Assert
    expect(isValid, true); // Form should be valid with proper input
  });
}
