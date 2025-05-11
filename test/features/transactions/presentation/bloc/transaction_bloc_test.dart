import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_mate/core/enums/transaction_type.dart';
import 'package:money_mate/core/errors/failures.dart';
import 'package:money_mate/features/transactions/domain/entities/transaction.dart';
import 'package:money_mate/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:money_mate/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:money_mate/features/transactions/domain/usecases/get_transaction_by_id_usecase.dart';
import 'package:money_mate/features/transactions/domain/usecases/get_transactions_by_category_usecase.dart';
import 'package:money_mate/features/transactions/domain/usecases/get_transactions_by_date_range_usecase.dart';
import 'package:money_mate/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:money_mate/features/transactions/domain/usecases/get_total_by_type_usecase.dart';
import 'package:money_mate/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:money_mate/features/transactions/presentation/bloc/transaction_state.dart';

class MockGetTransactionsUseCase extends Mock
    implements GetTransactionsUseCase {}

class MockGetTransactionsByDateRangeUseCase extends Mock
    implements GetTransactionsByDateRangeUseCase {}

class MockGetTransactionsByCategoryUseCase extends Mock
    implements GetTransactionsByCategoryUseCase {}

class MockGetTransactionByIdUseCase extends Mock
    implements GetTransactionByIdUseCase {}

class MockAddTransactionUseCase extends Mock implements AddTransactionUseCase {}

class MockUpdateTransactionUseCase extends Mock
    implements UpdateTransactionUseCase {}

class MockDeleteTransactionUseCase extends Mock
    implements DeleteTransactionUseCase {}

class MockGetTotalByTypeUseCase extends Mock implements GetTotalByTypeUseCase {}

void main() {
  late TransactionBloc transactionBloc;
  late MockGetTransactionsUseCase mockGetTransactionsUseCase;
  late MockGetTransactionsByDateRangeUseCase
      mockGetTransactionsByDateRangeUseCase;
  late MockGetTransactionsByCategoryUseCase
      mockGetTransactionsByCategoryUseCase;
  late MockGetTransactionByIdUseCase mockGetTransactionByIdUseCase;
  late MockAddTransactionUseCase mockAddTransactionUseCase;
  late MockUpdateTransactionUseCase mockUpdateTransactionUseCase;
  late MockDeleteTransactionUseCase mockDeleteTransactionUseCase;
  late MockGetTotalByTypeUseCase mockGetTotalByTypeUseCase;

  setUp(() {
    mockGetTransactionsUseCase = MockGetTransactionsUseCase();
    mockGetTransactionsByDateRangeUseCase =
        MockGetTransactionsByDateRangeUseCase();
    mockGetTransactionsByCategoryUseCase =
        MockGetTransactionsByCategoryUseCase();
    mockGetTransactionByIdUseCase = MockGetTransactionByIdUseCase();
    mockAddTransactionUseCase = MockAddTransactionUseCase();
    mockUpdateTransactionUseCase = MockUpdateTransactionUseCase();
    mockDeleteTransactionUseCase = MockDeleteTransactionUseCase();
    mockGetTotalByTypeUseCase = MockGetTotalByTypeUseCase();

    // Đăng ký fallback values
    registerFallbackValue(const GetTransactionsParams(userId: 'user_id'));
    registerFallbackValue(DateRangeParams(
      start: DateTime(2023, 1, 1),
      end: DateTime(2023, 12, 31),
      userId: 'user_id',
    ));
    registerFallbackValue(CategoryParams(
      categoryId: 'category_id',
      userId: 'user_id',
    ));
    registerFallbackValue(const TransactionIdParams(id: 'transaction_id'));
    registerFallbackValue(const DeleteTransactionParams(id: 'transaction_id'));
    registerFallbackValue(Transaction(
      id: 'transaction_id',
      amount: 100.0,
      date: DateTime(2023, 1, 1),
      categoryId: 'category_id',
      note: 'Test note',
      type: TransactionType.expense,
      userId: 'user_id',
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
    ));
    registerFallbackValue(TotalByTypeParams(
      type: TransactionType.expense,
      userId: 'user_id',
    ));

    transactionBloc = TransactionBloc(
      getTransactions: mockGetTransactionsUseCase,
      getTransactionsByDateRange: mockGetTransactionsByDateRangeUseCase,
      getTransactionsByCategory: mockGetTransactionsByCategoryUseCase,
      getTransactionById: mockGetTransactionByIdUseCase,
      addTransaction: mockAddTransactionUseCase,
      updateTransaction: mockUpdateTransactionUseCase,
      deleteTransaction: mockDeleteTransactionUseCase,
      getTotalByType: mockGetTotalByTypeUseCase,
    );
  });

  tearDown(() {
    transactionBloc.close();
  });

  // Các dữ liệu kiểm thử
  final tTransaction = Transaction(
    id: 'transaction_id',
    amount: 100.0,
    date: DateTime(2023, 1, 1),
    categoryId: 'category_id',
    note: 'Test note',
    type: TransactionType.expense,
    userId: 'user_id',
    createdAt: DateTime(2023, 1, 1),
    updatedAt: DateTime(2023, 1, 1),
  );

  final tTransactionsList = [tTransaction];
  final tUserId = 'user_id';
  final tStartDate = DateTime(2023, 1, 1);
  final tEndDate = DateTime(2023, 12, 31);
  final tCategoryId = 'category_id';
  final tTransactionId = 'transaction_id';
  final tTotal = 100.0;

  test('trạng thái ban đầu nên là TransactionInitial', () {
    expect(transactionBloc.state, equals(TransactionInitial()));
  });

  group('GetTransactionsEvent', () {
    blocTest<TransactionBloc, TransactionState>(
      'nên phát ra [TransactionLoading, TransactionsLoaded] khi thành công',
      build: () {
        when(() => mockGetTransactionsUseCase(any()))
            .thenAnswer((_) async => Right(tTransactionsList));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(GetTransactionsEvent(userId: tUserId)),
      expect: () => [
        TransactionLoading(),
        TransactionsLoaded(transactions: tTransactionsList),
      ],
      verify: (_) {
        verify(() => mockGetTransactionsUseCase(
              GetTransactionsParams(userId: tUserId),
            )).called(1);
      },
    );

    blocTest<TransactionBloc, TransactionState>(
      'nên phát ra [TransactionLoading, TransactionFailure] khi thất bại',
      build: () {
        when(() => mockGetTransactionsUseCase(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(GetTransactionsEvent(userId: tUserId)),
      expect: () => [
        TransactionLoading(),
        isA<TransactionFailure>(),
      ],
      verify: (_) {
        verify(() => mockGetTransactionsUseCase(
              GetTransactionsParams(userId: tUserId),
            )).called(1);
      },
    );
  });

  group('GetTransactionsByDateRangeEvent', () {
    blocTest<TransactionBloc, TransactionState>(
      'nên phát ra [TransactionLoading, TransactionsLoaded] khi thành công',
      build: () {
        when(() => mockGetTransactionsByDateRangeUseCase(any()))
            .thenAnswer((_) async => Right(tTransactionsList));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(GetTransactionsByDateRangeEvent(
        start: tStartDate,
        end: tEndDate,
        userId: tUserId,
      )),
      expect: () => [
        TransactionLoading(),
        TransactionsLoaded(transactions: tTransactionsList),
      ],
      verify: (_) {
        verify(() => mockGetTransactionsByDateRangeUseCase(
              DateRangeParams(
                start: tStartDate,
                end: tEndDate,
                userId: tUserId,
              ),
            )).called(1);
      },
    );

    blocTest<TransactionBloc, TransactionState>(
      'nên phát ra [TransactionLoading, TransactionFailure] khi thất bại',
      build: () {
        when(() => mockGetTransactionsByDateRangeUseCase(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(GetTransactionsByDateRangeEvent(
        start: tStartDate,
        end: tEndDate,
        userId: tUserId,
      )),
      expect: () => [
        TransactionLoading(),
        isA<TransactionFailure>(),
      ],
      verify: (_) {
        verify(() => mockGetTransactionsByDateRangeUseCase(
              DateRangeParams(
                start: tStartDate,
                end: tEndDate,
                userId: tUserId,
              ),
            )).called(1);
      },
    );
  });

  group('GetTransactionsByCategoryEvent', () {
    blocTest<TransactionBloc, TransactionState>(
      'nên phát ra [TransactionLoading, TransactionsLoaded] khi thành công',
      build: () {
        when(() => mockGetTransactionsByCategoryUseCase(any()))
            .thenAnswer((_) async => Right(tTransactionsList));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(GetTransactionsByCategoryEvent(
        categoryId: tCategoryId,
        userId: tUserId,
      )),
      expect: () => [
        TransactionLoading(),
        TransactionsLoaded(transactions: tTransactionsList),
      ],
      verify: (_) {
        verify(() => mockGetTransactionsByCategoryUseCase(
              CategoryParams(
                categoryId: tCategoryId,
                userId: tUserId,
              ),
            )).called(1);
      },
    );
  });

  group('GetTransactionByIdEvent', () {
    blocTest<TransactionBloc, TransactionState>(
      'nên phát ra [TransactionLoading, TransactionLoaded] khi thành công',
      build: () {
        when(() => mockGetTransactionByIdUseCase(any()))
            .thenAnswer((_) async => Right(tTransaction));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(GetTransactionByIdEvent(id: tTransactionId)),
      expect: () => [
        TransactionLoading(),
        TransactionLoaded(transaction: tTransaction),
      ],
      verify: (_) {
        verify(() => mockGetTransactionByIdUseCase(
              TransactionIdParams(id: tTransactionId),
            )).called(1);
      },
    );
  });

  group('AddTransactionEvent', () {
    blocTest<TransactionBloc, TransactionState>(
      'nên phát ra [TransactionLoading, TransactionOperationSuccess] khi thành công',
      build: () {
        when(() => mockAddTransactionUseCase(any()))
            .thenAnswer((_) async => Right(tTransaction));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(AddTransactionEvent(transaction: tTransaction)),
      expect: () => [
        TransactionLoading(),
        TransactionOperationSuccess(
          message: 'Thêm giao dịch thành công',
          transaction: tTransaction,
        ),
      ],
      verify: (_) {
        verify(() => mockAddTransactionUseCase(any())).called(1);
      },
    );

    blocTest<TransactionBloc, TransactionState>(
      'nên tạo ID mới khi transaction.id rỗng',
      build: () {
        final transactionWithoutId = Transaction(
          id: '',
          amount: 100.0,
          date: DateTime(2023, 1, 1),
          categoryId: 'category_id',
          note: 'Test note',
          type: TransactionType.expense,
          userId: 'user_id',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        when(() => mockAddTransactionUseCase(any()))
            .thenAnswer((_) async => Right(tTransaction));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(AddTransactionEvent(
        transaction: Transaction(
          id: '',
          amount: 100.0,
          date: DateTime(2023, 1, 1),
          categoryId: 'category_id',
          note: 'Test note',
          type: TransactionType.expense,
          userId: 'user_id',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        ),
      )),
      expect: () => [
        TransactionLoading(),
        TransactionOperationSuccess(
          message: 'Thêm giao dịch thành công',
          transaction: tTransaction,
        ),
      ],
      verify: (_) {
        verify(() => mockAddTransactionUseCase(any())).called(1);
      },
    );
  });

  group('UpdateTransactionEvent', () {
    blocTest<TransactionBloc, TransactionState>(
      'nên phát ra [TransactionLoading, TransactionOperationSuccess] khi thành công',
      build: () {
        when(() => mockUpdateTransactionUseCase(any()))
            .thenAnswer((_) async => Right(tTransaction));
        return transactionBloc;
      },
      act: (bloc) =>
          bloc.add(UpdateTransactionEvent(transaction: tTransaction)),
      expect: () => [
        TransactionLoading(),
        TransactionOperationSuccess(
          message: 'Cập nhật giao dịch thành công',
          transaction: tTransaction,
        ),
      ],
      verify: (_) {
        verify(() => mockUpdateTransactionUseCase(tTransaction)).called(1);
      },
    );
  });

  group('DeleteTransactionEvent', () {
    blocTest<TransactionBloc, TransactionState>(
      'nên phát ra [TransactionLoading, TransactionOperationSuccess] khi thành công',
      build: () {
        when(() => mockDeleteTransactionUseCase(any()))
            .thenAnswer((_) async => const Right(unit));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(DeleteTransactionEvent(id: tTransactionId)),
      expect: () => [
        TransactionLoading(),
        const TransactionOperationSuccess(
          message: 'Xóa giao dịch thành công',
        ),
      ],
      verify: (_) {
        verify(() => mockDeleteTransactionUseCase(
              DeleteTransactionParams(id: tTransactionId),
            )).called(1);
      },
    );
  });

  group('GetTotalByTypeEvent', () {
    blocTest<TransactionBloc, TransactionState>(
      'nên phát ra [TransactionLoading, TotalAmountLoaded] khi thành công',
      build: () {
        when(() => mockGetTotalByTypeUseCase(any()))
            .thenAnswer((_) async => Right(tTotal));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(GetTotalByTypeEvent(
        type: TransactionType.expense,
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
      )),
      expect: () => [
        TransactionLoading(),
        TotalAmountLoaded(total: tTotal),
      ],
      verify: (_) {
        verify(() => mockGetTotalByTypeUseCase(
              TotalByTypeParams(
                type: TransactionType.expense,
                userId: tUserId,
                start: tStartDate,
                end: tEndDate,
              ),
            )).called(1);
      },
    );

    blocTest<TransactionBloc, TransactionState>(
      'nên phát ra [TransactionLoading, TransactionFailure] khi thất bại',
      build: () {
        when(() => mockGetTotalByTypeUseCase(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        return transactionBloc;
      },
      act: (bloc) => bloc.add(GetTotalByTypeEvent(
        type: TransactionType.expense,
        userId: tUserId,
      )),
      expect: () => [
        TransactionLoading(),
        isA<TransactionFailure>(),
      ],
      verify: (_) {
        verify(() => mockGetTotalByTypeUseCase(
              TotalByTypeParams(
                type: TransactionType.expense,
                userId: tUserId,
              ),
            )).called(1);
      },
    );
  });
}
