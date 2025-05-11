import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/core/widgets/buttons/app_fill_button.dart';
import 'package:money_mate/core/widgets/custom_app_bar.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_bloc.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_state.dart';
import 'package:money_mate/features/transactions/presentation/pages/add_expense_page.dart';
import 'package:money_mate/features/transactions/presentation/widgets/category_list.dart';
import 'package:money_mate/features/transactions/presentation/widgets/transaction_form_core.dart';

@GenerateMocks([CategoryBloc])
import 'add_expense_page_test.mocks.dart';

void main() {
  late MockCategoryBloc mockCategoryBloc;

  setUp(() {
    mockCategoryBloc = MockCategoryBloc();
  });

  testWidgets('AddExpensePage should render correctly',
      (WidgetTester tester) async {
    // Arrange
    when(mockCategoryBloc.state).thenReturn(CategoryLoading());
    when(mockCategoryBloc.stream)
        .thenAnswer((_) => Stream.value(CategoryLoading()));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CategoryBloc>.value(
          value: mockCategoryBloc,
          child: const AddExpensePage(),
        ),
      ),
    );

    // Assert
    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.text('Add Expense'), findsOneWidget);
    expect(find.byType(TransactionFormCore), findsOneWidget);
    expect(find.byType(CategoryList), findsOneWidget);
    expect(find.byType(AppFillButton), findsOneWidget);
  });

  testWidgets(
      'Should show validation message when form is submitted without category',
      (WidgetTester tester) async {
    // Arrange
    when(mockCategoryBloc.state).thenReturn(CategoryLoading());
    when(mockCategoryBloc.stream)
        .thenAnswer((_) => Stream.value(CategoryLoading()));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CategoryBloc>.value(
          value: mockCategoryBloc,
          child: const AddExpensePage(),
        ),
      ),
    );

    // Find and tap the submit button
    await tester.tap(find.byType(AppFillButton));
    await tester.pump(); // Process the tap
    await tester.pump(const Duration(seconds: 1)); // Process SnackBar animation

    // Assert
    expect(find.text('Please select a category'), findsOneWidget);
  });

  // Additional tests would include:
  // 1. Testing form validation for all fields
  // 2. Testing category selection
  // 3. Testing date selection
  // 4. Testing successful form submission
}
