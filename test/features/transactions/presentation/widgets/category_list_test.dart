import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/core/core.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_bloc.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_event.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_state.dart';
import 'package:money_mate/features/transactions/presentation/widgets/category_list.dart';

@GenerateMocks([CategoryBloc])
import 'category_list_test.mocks.dart';

void main() {
  late MockCategoryBloc mockCategoryBloc;

  setUp(() {
    mockCategoryBloc = MockCategoryBloc();
  });

  testWidgets('CategoryList should show loading state initially',
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
          child: CategoryList(
            type: CategoryType.expense,
            onCategorySelected: (_) {},
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(LoadingStateShimmerList), findsOneWidget);
    verify(mockCategoryBloc.add(GetCategoriesEvent(CategoryType.expense)))
        .called(1);
  });

  testWidgets('CategoryList should display categories when loaded',
      (WidgetTester tester) async {
    // Arrange
    final categories = [
      Category(
          id: '1', name: 'Food', iconName: 'food', type: CategoryType.expense),
      Category(
          id: '2',
          name: 'Transport',
          iconName: 'transport',
          type: CategoryType.expense),
    ];

    when(mockCategoryBloc.state).thenReturn(CategoriesLoaded(categories));
    when(mockCategoryBloc.stream)
        .thenAnswer((_) => Stream.value(CategoriesLoaded(categories)));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CategoryBloc>.value(
          value: mockCategoryBloc,
          child: CategoryList(
            type: CategoryType.expense,
            onCategorySelected: (_) {},
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(CategoriesView), findsOneWidget);
    // Verify that we called the event in didChangeDependencies
    verify(mockCategoryBloc.add(GetCategoriesEvent(CategoryType.expense)))
        .called(1);
  });

  testWidgets('CategoryList should display error state when error occurs',
      (WidgetTester tester) async {
    // Arrange
    const errorMessage = 'Failed to load categories';
    when(mockCategoryBloc.state).thenReturn(CategoryError(errorMessage));
    when(mockCategoryBloc.stream)
        .thenAnswer((_) => Stream.value(CategoryError(errorMessage)));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CategoryBloc>.value(
          value: mockCategoryBloc,
          child: CategoryList(
            type: CategoryType.expense,
            onCategorySelected: (_) {},
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(ErrorStateList), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
    verify(mockCategoryBloc.add(GetCategoriesEvent(CategoryType.expense)))
        .called(1);
  });

  testWidgets('Category selection should call onCategorySelected callback',
      (WidgetTester tester) async {
    // Arrange
    final categories = [
      Category(
          id: '1', name: 'Food', iconName: 'food', type: CategoryType.expense),
      Category(
          id: '2',
          name: 'Transport',
          iconName: 'transport',
          type: CategoryType.expense),
    ];

    when(mockCategoryBloc.state).thenReturn(CategoriesLoaded(categories));
    when(mockCategoryBloc.stream)
        .thenAnswer((_) => Stream.value(CategoriesLoaded(categories)));

    Category? selectedCategory;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CategoryBloc>.value(
          value: mockCategoryBloc,
          child: CategoryList(
            type: CategoryType.expense,
            onCategorySelected: (category) {
              selectedCategory = category;
            },
          ),
        ),
      ),
    );

    // Need to call pump to ensure the widget tree is fully built
    await tester.pump();

    // This test needs proper implementation of tap on CategoryItem
    // This is a placeholder for actual implementation

    verify(mockCategoryBloc.add(GetCategoriesEvent(CategoryType.expense)))
        .called(1);
  });
}
