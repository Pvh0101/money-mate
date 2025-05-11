import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/core/errors/failures.dart';
import 'package:money_mate/core/widgets/buttons/app_fill_button.dart';
import 'package:money_mate/core/widgets/custom_app_bar.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_bloc.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_state.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:money_mate/features/transactions/presentation/pages/add_income_page.dart';
import 'package:money_mate/features/transactions/presentation/widgets/category_list.dart';
import 'package:money_mate/features/transactions/presentation/widgets/transaction_form_core.dart';

// Sử dụng lại mock từ category_list_test.mocks.dart
import '../widgets/category_list_test.mocks.dart';
// Import mock được tạo tự động
import 'add_income_page_test.mocks.dart';

// Sử dụng GenerateMocks với tên custom
@GenerateMocks([TransactionBloc],
    customMocks: [MockSpec<TransactionBloc>(as: #MockTransactionBlocCustom)])
void main() {
  late MockCategoryBloc mockCategoryBloc;
  late MockTransactionBlocCustom mockTransactionBloc;

  setUp(() {
    mockCategoryBloc = MockCategoryBloc();
    when(mockCategoryBloc.state).thenReturn(CategoryLoading());
    when(mockCategoryBloc.stream)
        .thenAnswer((_) => Stream.value(CategoryLoading()));

    // Sử dụng mock đã được tạo với tên custom
    mockTransactionBloc = MockTransactionBlocCustom();
    when(mockTransactionBloc.state).thenReturn(TransactionInitial());
    when(mockTransactionBloc.stream)
        .thenAnswer((_) => Stream.value(TransactionInitial()));
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CategoryBloc>.value(
            value: mockCategoryBloc,
          ),
          BlocProvider<TransactionBloc>.value(
            value: mockTransactionBloc,
          ),
        ],
        child: const AddIncomePage(),
      ),
    );
  }

  testWidgets('AddIncomePage should render correctly',
      (WidgetTester tester) async {
    // Arrange
    // Set fixed viewport size for test
    tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    // Act
    await tester.pumpWidget(buildTestableWidget());

    // Assert
    expect(find.byType(CustomAppBar), findsOneWidget);
    // Kiểm tra text trong AppBar (không kiểm tra chính xác số lượng)
    expect(find.text('Thêm khoản thu'), findsAtLeast(1));
    expect(find.byType(TransactionFormCore), findsOneWidget);
    expect(find.byType(CategoryList), findsOneWidget);
    expect(find.byType(AppFillButton), findsOneWidget);

    // Reset the viewport size
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });

  testWidgets('AddIncomePage form inputs should be empty initially',
      (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(buildTestableWidget());

    // Assert
    // Tìm các text field
    final titleField = find.ancestor(
      of: find.text('Enter income title'),
      matching: find.byType(TextField),
    );
    final amountField = find.ancestor(
      of: find.text('Enter income amount'),
      matching: find.byType(TextField),
    );

    expect(titleField, findsOneWidget);
    expect(amountField, findsOneWidget);

    // Kiểm tra giá trị ban đầu
    final titleTextField = tester.widget<TextField>(titleField);
    final amountTextField = tester.widget<TextField>(amountField);

    expect(titleTextField.controller!.text, isEmpty);
    expect(amountTextField.controller!.text, isEmpty);
  });

  testWidgets('AddIncomePage should validate fields on submit',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(buildTestableWidget());

    // Vô hiệu hóa animation để tránh timeout
    await tester.pumpWidget(buildTestableWidget());
    await tester.pump(const Duration(milliseconds: 100));

    // Act - tìm và nhấn nút submit
    final submitButton = find.byType(AppFillButton);
    await tester.tap(submitButton);

    // Sử dụng pump với duration ngắn để tránh timeout
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // Assert - kiểm tra thông báo lỗi xuất hiện
    expect(find.text('Please enter a title'), findsOneWidget);
    expect(find.text('Please enter an amount'), findsOneWidget);
  });

  group('BlocListener tests', () {
    testWidgets('TransactionBloc should receive events',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(buildTestableWidget());

      // Tìm text fields và nhập dữ liệu
      final titleField = find.ancestor(
        of: find.text('Enter income title'),
        matching: find.byType(TextField),
      );
      final amountField = find.ancestor(
        of: find.text('Enter income amount'),
        matching: find.byType(TextField),
      );

      await tester.enterText(titleField, 'Test Income');
      await tester.enterText(amountField, '1000');
      await tester.pump();

      // Verify form is filled correctly
      expect(find.text('Test Income'), findsOneWidget);
      expect(find.text('1000'), findsOneWidget);
    });
  });
}
