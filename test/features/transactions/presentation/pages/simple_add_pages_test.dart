import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/core/widgets/custom_app_bar.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_bloc.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_state.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:money_mate/features/transactions/presentation/pages/add_expense_page.dart';
import 'package:money_mate/features/transactions/presentation/pages/add_income_page.dart';
import 'package:money_mate/features/transactions/presentation/widgets/transaction_form_core.dart';

class MockCategoryBloc extends Mock implements CategoryBloc {
  @override
  CategoryState get state => CategoryInitial();

  @override
  Stream<CategoryState> get stream => Stream.value(CategoryInitial());
}

class MockTransactionBloc extends Mock implements TransactionBloc {
  @override
  TransactionState get state => TransactionInitial();

  @override
  Stream<TransactionState> get stream => Stream.value(TransactionInitial());
}

void main() {
  testWidgets('AddIncomePage - kiểm tra các thành phần UI cơ bản',
      (WidgetTester tester) async {
    final mockCategoryBloc = MockCategoryBloc();
    final mockTransactionBloc = MockTransactionBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<CategoryBloc>.value(value: mockCategoryBloc),
            BlocProvider<TransactionBloc>.value(value: mockTransactionBloc),
          ],
          child: const AddIncomePage(),
        ),
      ),
    );

    // Kiểm tra có AppBar với CustomAppBar
    expect(find.byType(CustomAppBar), findsOneWidget);

    // Kiểm tra có text "Thêm khoản thu" ít nhất một lần (cho AppBar và button)
    expect(find.text('Thêm khoản thu'), findsAtLeast(1));

    // Kiểm tra có TextFormField cho nhập thông tin
    expect(find.byType(TextFormField), findsAtLeast(1));
  });

  testWidgets('AddExpensePage - kiểm tra các thành phần UI cơ bản',
      (WidgetTester tester) async {
    final mockCategoryBloc = MockCategoryBloc();
    final mockTransactionBloc = MockTransactionBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<CategoryBloc>.value(value: mockCategoryBloc),
            BlocProvider<TransactionBloc>.value(value: mockTransactionBloc),
          ],
          child: const AddExpensePage(),
        ),
      ),
    );

    // Kiểm tra có AppBar với CustomAppBar
    expect(find.byType(CustomAppBar), findsOneWidget);

    // Kiểm tra có text "Thêm khoản chi" ít nhất một lần (cho AppBar và button)
    expect(find.text('Thêm khoản chi'), findsAtLeast(1));

    // Kiểm tra có TextFormField cho nhập thông tin
    expect(find.byType(TextFormField), findsAtLeast(1));
  });
}
