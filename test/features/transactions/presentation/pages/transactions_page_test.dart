import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_mate/core/errors/failures.dart';
import 'package:money_mate/core/widgets/empty_state_list.dart';
import 'package:money_mate/core/widgets/error_state_list.dart';
import 'package:money_mate/core/widgets/loading_state_shimmer_list.dart';
import 'package:money_mate/features/transactions/domain/entities/transaction.dart';
import 'package:money_mate/core/enums/transaction_type.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:money_mate/features/transactions/presentation/pages/transactions_page.dart';
import 'package:money_mate/features/transactions/presentation/widgets/transaction_item.dart';

class MockTransactionBloc extends Mock implements TransactionBloc {}

// Hàm đơn giản hóa để thay thế network_image_mock
Future<void> mockNetworkImagesFor(Future<void> Function() callback) async {
  // Chỉ gọi callback trực tiếp vì đây là môi trường test đơn giản
  await callback();
}

void main() {
  late MockTransactionBloc mockTransactionBloc;

  setUp(() {
    mockTransactionBloc = MockTransactionBloc();
  });

  Widget createTestableWidget() {
    return MaterialApp(
      home: BlocProvider<TransactionBloc>(
        create: (context) => mockTransactionBloc,
        child: const TransactionsPage(),
      ),
    );
  }

  testWidgets('shows LoadingStateShimmerList when state is TransactionLoading',
      (WidgetTester tester) async {
    // Giả lập bloc trả về TransactionLoading state
    when(() => mockTransactionBloc.state).thenReturn(TransactionLoading());

    // Render widget
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(createTestableWidget());
    });

    // Kiểm tra xem LoadingStateShimmerList có hiển thị không
    expect(find.byType(LoadingStateShimmerList), findsOneWidget);
  });

  testWidgets('shows EmptyStateList when transactions list is empty',
      (WidgetTester tester) async {
    // Giả lập bloc trả về TransactionsLoaded state với danh sách rỗng
    when(() => mockTransactionBloc.state)
        .thenReturn(const TransactionsLoaded(transactions: []));

    // Render widget
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(createTestableWidget());
    });

    // Kiểm tra xem EmptyStateList có hiển thị không
    expect(find.byType(EmptyStateList), findsOneWidget);
    expect(find.text('Không có giao dịch nào'), findsOneWidget);
  });

  testWidgets('shows ErrorStateList when state is TransactionFailure',
      (WidgetTester tester) async {
    // Giả lập bloc trả về TransactionFailure state
    when(() => mockTransactionBloc.state)
        .thenReturn(TransactionFailure(failure: ServerFailure()));

    // Render widget
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(createTestableWidget());
    });

    // Kiểm tra xem ErrorStateList có hiển thị không
    expect(find.byType(ErrorStateList), findsOneWidget);
    expect(find.textContaining('Đã xảy ra lỗi'), findsOneWidget);
  });

  testWidgets('shows transactions list when there are transactions',
      (WidgetTester tester) async {
    // Tạo một danh sách test transaction
    final testTransactions = [
      Transaction(
        id: '1',
        amount: 100.0,
        date: DateTime(2023, 6, 15),
        categoryId: 'category1',
        note: 'Giao dịch 1',
        type: TransactionType.expense,
        userId: 'user1',
        createdAt: DateTime(2023, 6, 15),
        updatedAt: DateTime(2023, 6, 15),
      ),
      Transaction(
        id: '2',
        amount: 200.0,
        date: DateTime(2023, 6, 15),
        categoryId: 'category2',
        note: 'Giao dịch 2',
        type: TransactionType.income,
        userId: 'user1',
        createdAt: DateTime(2023, 6, 15),
        updatedAt: DateTime(2023, 6, 15),
      ),
    ];

    // Giả lập bloc trả về TransactionsLoaded state với danh sách transactions
    when(() => mockTransactionBloc.state)
        .thenReturn(TransactionsLoaded(transactions: testTransactions));

    // Render widget
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(createTestableWidget());
    });

    // Kiểm tra xem danh sách TransactionItem có hiển thị không
    expect(find.byType(TransactionItem), findsNWidgets(2));
    expect(find.text('Giao dịch 1'), findsOneWidget);
    expect(find.text('Giao dịch 2'), findsOneWidget);
  });
}
