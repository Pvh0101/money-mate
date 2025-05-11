import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/core/core.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_bloc.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_state.dart';
import 'package:money_mate/features/transactions/presentation/widgets/category_list/add_category_dialog.dart';

import 'category_list_test.mocks.dart';

void main() {
  late MockCategoryBloc mockCategoryBloc;

  setUp(() {
    mockCategoryBloc = MockCategoryBloc();
    when(mockCategoryBloc.state).thenReturn(CategoryLoading());
    when(mockCategoryBloc.stream)
        .thenAnswer((_) => Stream.value(CategoryLoading()));
  });

  testWidgets('AddCategoryDialog renders correctly',
      (WidgetTester tester) async {
    // Arrange & Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<CategoryBloc>.value(
            value: mockCategoryBloc,
            child: const AddCategoryDialog(
              categoryType: CategoryType.expense,
            ),
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Add New Expense Category'), findsOneWidget);
    expect(find.text('Category Name'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
  });

  testWidgets('AddCategoryDialog shows income title when income type',
      (WidgetTester tester) async {
    // Arrange & Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<CategoryBloc>.value(
            value: mockCategoryBloc,
            child: const AddCategoryDialog(
              categoryType: CategoryType.income,
            ),
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Add New Income Category'), findsOneWidget);
  });

  testWidgets('AddCategoryDialog validates empty input',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<CategoryBloc>.value(
            value: mockCategoryBloc,
            child: const AddCategoryDialog(
              categoryType: CategoryType.expense,
            ),
          ),
        ),
      ),
    );

    // Act
    await tester.tap(find.text('Add'));
    await tester.pump();

    // Assert
    expect(find.text('Please enter a category name'), findsOneWidget);
  });

  testWidgets('AddCategoryDialog closes on cancel',
      (WidgetTester tester) async {
    // Create a builder to provide navigator context
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => BlocProvider<CategoryBloc>.value(
                    value: mockCategoryBloc,
                    child: const AddCategoryDialog(
                      categoryType: CategoryType.expense,
                    ),
                  ),
                );
              },
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      ),
    );

    // Open the dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Verify dialog is showing
    expect(find.text('Add New Expense Category'), findsOneWidget);

    // Tap cancel
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Dialog should be closed
    expect(find.text('Add New Expense Category'), findsNothing);
  });
}
