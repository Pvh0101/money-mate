import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_mate/core/enums/transaction_type.dart';
import 'package:money_mate/core/errors/failures.dart';
import 'package:money_mate/features/transactions/domain/entities/transaction.dart';
import 'package:money_mate/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:money_mate/features/transactions/domain/usecases/get_transactions_usecase.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late GetTransactionsUseCase usecase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    usecase = GetTransactionsUseCase(mockRepository);
  });

  final testDate = DateTime(2023, 6, 15);
  final createdAt = DateTime(2023, 6, 15, 10, 0);
  final updatedAt = DateTime(2023, 6, 15, 10, 0);

  final tTransactions = [
    Transaction(
      id: '1',
      amount: 100000,
      date: testDate,
      categoryId: 'cat1',
      type: TransactionType.expense,
      userId: 'user1',
      createdAt: createdAt,
      updatedAt: updatedAt,
    ),
    Transaction(
      id: '2',
      amount: 50000,
      date: testDate,
      categoryId: 'cat2',
      type: TransactionType.income,
      userId: 'user1',
      createdAt: createdAt,
      updatedAt: updatedAt,
    ),
  ];

  const tUserId = 'user1';

  test(
    'nên lấy danh sách giao dịch từ repository',
    () async {
      // arrange
      when(() => mockRepository.getTransactions(userId: any(named: 'userId')))
          .thenAnswer((_) async => Right(tTransactions));

      // act
      final result =
          await usecase(const GetTransactionsParams(userId: tUserId));

      // assert
      expect(result, Right(tTransactions));
      verify(() => mockRepository.getTransactions(userId: tUserId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'nên trả về ServerFailure khi repository thất bại',
    () async {
      // arrange
      when(() => mockRepository.getTransactions(userId: any(named: 'userId')))
          .thenAnswer((_) async => Left(ServerFailure()));

      // act
      final result =
          await usecase(const GetTransactionsParams(userId: tUserId));

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left with ServerFailure'),
      );
      verify(() => mockRepository.getTransactions(userId: tUserId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
