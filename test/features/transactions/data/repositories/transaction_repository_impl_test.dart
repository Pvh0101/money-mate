import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_mate/core/enums/transaction_type.dart';
import 'package:money_mate/core/errors/failures.dart';
import 'package:money_mate/core/network/network_info.dart';
import 'package:money_mate/features/transactions/data/datasources/transaction_datasource.dart';
import 'package:money_mate/features/transactions/data/models/transaction_model.dart';
import 'package:money_mate/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:money_mate/features/transactions/domain/entities/transaction.dart';

class MockTransactionRemoteDataSource extends Mock
    implements TransactionRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockTransactionModel extends Mock implements TransactionModel {}

// Fake classes for Mocktail's registerFallbackValue
class FakeTransactionModel extends Fake implements TransactionModel {}

class FakeTransaction extends Fake implements Transaction {}

void main() {
  late TransactionRepositoryImpl repository;
  late MockTransactionRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(FakeTransactionModel());
    registerFallbackValue(FakeTransaction());
    registerFallbackValue(TransactionType.expense);
  });

  setUp(() {
    mockRemoteDataSource = MockTransactionRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TransactionRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final testDate = DateTime(2023, 6, 15);
  final createdAt = DateTime(2023, 6, 15, 10, 0);
  final updatedAt = DateTime(2023, 6, 15, 10, 0);

  final tTransactionModel = TransactionModel(
    id: 'test_id',
    amount: 100000,
    date: testDate,
    categoryId: 'category_id',
    type: TransactionType.expense,
    userId: 'user_id',
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  final tTransactionsList = [tTransactionModel];
  const tUserId = 'user_id';
  const tCategoryId = 'category_id';

  group('getTransactions', () {
    test(
      'nên kiểm tra xem thiết bị có kết nối internet hay không',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getTransactions(
                userId: any(named: 'userId')))
            .thenAnswer((_) async => tTransactionsList);

        // act
        await repository.getTransactions(userId: tUserId);

        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    group('thiết bị online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'nên trả về danh sách giao dịch khi gọi remote data source thành công',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getTransactions(
                  userId: any(named: 'userId')))
              .thenAnswer((_) async => tTransactionsList);

          // act
          final result = await repository.getTransactions(userId: tUserId);

          // assert
          verify(() => mockRemoteDataSource.getTransactions(userId: tUserId));
          expect(result, equals(Right(tTransactionsList)));
        },
      );

      test(
        'nên trả về server failure khi gọi remote data source thất bại',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getTransactions(
              userId: any(named: 'userId'))).thenThrow(Exception());

          // act
          final result = await repository.getTransactions(userId: tUserId);

          // assert
          verify(() => mockRemoteDataSource.getTransactions(userId: tUserId));
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('Expected Left with ServerFailure'),
          );
        },
      );
    });

    group('thiết bị offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'nên trả về NetworkFailure khi thiết bị offline',
        () async {
          // act
          final result = await repository.getTransactions(userId: tUserId);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (_) => fail('Expected Left with NetworkFailure'),
          );
        },
      );
    });
  });

  group('addTransaction', () {
    final tTransaction = Transaction(
      id: 'test_id',
      amount: 100000,
      date: testDate,
      categoryId: 'category_id',
      type: TransactionType.expense,
      userId: 'user_id',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    test('nên kiểm tra xem thiết bị có kết nối internet hay không', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.addTransaction(any()))
          .thenAnswer((_) async => tTransactionModel);

      // act
      await repository.addTransaction(tTransaction);

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('thiết bị online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'nên thêm giao dịch khi gọi remote data source thành công',
        () async {
          // arrange
          when(() => mockRemoteDataSource.addTransaction(any()))
              .thenAnswer((_) async => tTransactionModel);

          // act
          final result = await repository.addTransaction(tTransaction);

          // assert
          verify(() => mockRemoteDataSource.addTransaction(any()));
          expect(result, equals(Right(tTransactionModel)));
        },
      );

      test(
        'nên trả về server failure khi gọi remote data source thất bại',
        () async {
          // arrange
          when(() => mockRemoteDataSource.addTransaction(any()))
              .thenThrow(Exception());

          // act
          final result = await repository.addTransaction(tTransaction);

          // assert
          verify(() => mockRemoteDataSource.addTransaction(any()));
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('Expected Left with ServerFailure'),
          );
        },
      );
    });

    group('thiết bị offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'nên trả về NetworkFailure khi thiết bị offline',
        () async {
          // act
          final result = await repository.addTransaction(tTransaction);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (_) => fail('Expected Left with NetworkFailure'),
          );
        },
      );
    });
  });

  group('updateTransaction', () {
    final tTransaction = Transaction(
      id: 'test_id',
      amount: 100000,
      date: testDate,
      categoryId: 'category_id',
      type: TransactionType.expense,
      userId: 'user_id',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    test('nên kiểm tra xem thiết bị có kết nối internet hay không', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.updateTransaction(any()))
          .thenAnswer((_) async => tTransactionModel);

      // act
      await repository.updateTransaction(tTransaction);

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('thiết bị online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'nên cập nhật giao dịch khi gọi remote data source thành công',
        () async {
          // arrange
          when(() => mockRemoteDataSource.updateTransaction(any()))
              .thenAnswer((_) async => tTransactionModel);

          // act
          final result = await repository.updateTransaction(tTransaction);

          // assert
          verify(() => mockRemoteDataSource.updateTransaction(any()));
          expect(result, equals(Right(tTransactionModel)));
        },
      );

      test(
        'nên trả về server failure khi gọi remote data source thất bại',
        () async {
          // arrange
          when(() => mockRemoteDataSource.updateTransaction(any()))
              .thenThrow(Exception());

          // act
          final result = await repository.updateTransaction(tTransaction);

          // assert
          verify(() => mockRemoteDataSource.updateTransaction(any()));
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('Expected Left with ServerFailure'),
          );
        },
      );
    });

    group('thiết bị offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'nên trả về NetworkFailure khi thiết bị offline',
        () async {
          // act
          final result = await repository.updateTransaction(tTransaction);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (_) => fail('Expected Left with NetworkFailure'),
          );
        },
      );
    });
  });

  group('deleteTransaction', () {
    const tId = 'test_id';

    test('nên kiểm tra xem thiết bị có kết nối internet hay không', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.deleteTransaction(any()))
          .thenAnswer((_) async => {});

      // act
      await repository.deleteTransaction(tId);

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('thiết bị online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'nên xóa giao dịch khi gọi remote data source thành công',
        () async {
          // arrange
          when(() => mockRemoteDataSource.deleteTransaction(any()))
              .thenAnswer((_) async => {});

          // act
          final result = await repository.deleteTransaction(tId);

          // assert
          verify(() => mockRemoteDataSource.deleteTransaction(tId));
          expect(result, equals(const Right(null)));
        },
      );

      test(
        'nên trả về server failure khi gọi remote data source thất bại',
        () async {
          // arrange
          when(() => mockRemoteDataSource.deleteTransaction(any()))
              .thenThrow(Exception());

          // act
          final result = await repository.deleteTransaction(tId);

          // assert
          verify(() => mockRemoteDataSource.deleteTransaction(tId));
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('Expected Left with ServerFailure'),
          );
        },
      );
    });

    group('thiết bị offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'nên trả về NetworkFailure khi thiết bị offline',
        () async {
          // act
          final result = await repository.deleteTransaction(tId);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (_) => fail('Expected Left with NetworkFailure'),
          );
        },
      );
    });
  });

  group('getTransactionById', () {
    const tId = 'test_id';

    test('nên kiểm tra xem thiết bị có kết nối internet hay không', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getTransactionById(any()))
          .thenAnswer((_) async => tTransactionModel);

      // act
      await repository.getTransactionById(tId);

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('thiết bị online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'nên trả về giao dịch khi gọi remote data source thành công',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getTransactionById(any()))
              .thenAnswer((_) async => tTransactionModel);

          // act
          final result = await repository.getTransactionById(tId);

          // assert
          verify(() => mockRemoteDataSource.getTransactionById(tId));
          expect(result, equals(Right(tTransactionModel)));
        },
      );

      test(
        'nên trả về server failure khi gọi remote data source thất bại',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getTransactionById(any()))
              .thenThrow(Exception());

          // act
          final result = await repository.getTransactionById(tId);

          // assert
          verify(() => mockRemoteDataSource.getTransactionById(tId));
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('Expected Left with ServerFailure'),
          );
        },
      );
    });

    group('thiết bị offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'nên trả về NetworkFailure khi thiết bị offline',
        () async {
          // act
          final result = await repository.getTransactionById(tId);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (_) => fail('Expected Left with NetworkFailure'),
          );
        },
      );
    });
  });

  group('getTransactionsByDateRange', () {
    final startDate = DateTime(2023, 6, 1);
    final endDate = DateTime(2023, 6, 30);
    const userId = 'user_id';

    test('nên kiểm tra xem thiết bị có kết nối internet hay không', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getTransactionsByDateRange(any(), any(),
              userId: any(named: 'userId')))
          .thenAnswer((_) async => tTransactionsList);

      // act
      await repository.getTransactionsByDateRange(
        startDate,
        endDate,
        userId: userId,
      );

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('thiết bị online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'nên trả về danh sách giao dịch khi gọi remote data source thành công',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getTransactionsByDateRange(
                  any(), any(), userId: any(named: 'userId')))
              .thenAnswer((_) async => tTransactionsList);

          // act
          final result = await repository.getTransactionsByDateRange(
            startDate,
            endDate,
            userId: userId,
          );

          // assert
          verify(() => mockRemoteDataSource
              .getTransactionsByDateRange(startDate, endDate, userId: userId));
          expect(result, equals(Right(tTransactionsList)));
        },
      );

      test(
        'nên trả về server failure khi gọi remote data source thất bại',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getTransactionsByDateRange(
                  any(), any(), userId: any(named: 'userId')))
              .thenThrow(Exception());

          // act
          final result = await repository.getTransactionsByDateRange(
            startDate,
            endDate,
            userId: userId,
          );

          // assert
          verify(() => mockRemoteDataSource
              .getTransactionsByDateRange(startDate, endDate, userId: userId));
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('Expected Left with ServerFailure'),
          );
        },
      );
    });

    group('thiết bị offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'nên trả về NetworkFailure khi thiết bị offline',
        () async {
          // act
          final result = await repository.getTransactionsByDateRange(
            startDate,
            endDate,
            userId: userId,
          );

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (_) => fail('Expected Left with NetworkFailure'),
          );
        },
      );
    });
  });

  group('getTransactionsByCategory', () {
    const categoryId = 'category_id';
    const userId = 'user_id';

    test('nên kiểm tra xem thiết bị có kết nối internet hay không', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getTransactionsByCategory(any(),
              userId: any(named: 'userId')))
          .thenAnswer((_) async => tTransactionsList);

      // act
      await repository.getTransactionsByCategory(
        categoryId,
        userId: userId,
      );

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('thiết bị online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'nên trả về danh sách giao dịch khi gọi remote data source thành công',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getTransactionsByCategory(any(),
                  userId: any(named: 'userId')))
              .thenAnswer((_) async => tTransactionsList);

          // act
          final result = await repository.getTransactionsByCategory(
            categoryId,
            userId: userId,
          );

          // assert
          verify(() => mockRemoteDataSource
              .getTransactionsByCategory(categoryId, userId: userId));
          expect(result, equals(Right(tTransactionsList)));
        },
      );

      test(
        'nên trả về server failure khi gọi remote data source thất bại',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getTransactionsByCategory(any(),
              userId: any(named: 'userId'))).thenThrow(Exception());

          // act
          final result = await repository.getTransactionsByCategory(
            categoryId,
            userId: userId,
          );

          // assert
          verify(() => mockRemoteDataSource
              .getTransactionsByCategory(categoryId, userId: userId));
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('Expected Left with ServerFailure'),
          );
        },
      );
    });

    group('thiết bị offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'nên trả về NetworkFailure khi thiết bị offline',
        () async {
          // act
          final result = await repository.getTransactionsByCategory(
            categoryId,
            userId: userId,
          );

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (_) => fail('Expected Left with NetworkFailure'),
          );
        },
      );
    });
  });

  group('getTotalByType', () {
    final startDate = DateTime(2023, 6, 1);
    final endDate = DateTime(2023, 6, 30);
    const userId = 'user_id';
    const type = TransactionType.expense;
    const total = 150000.0;

    test('nên kiểm tra xem thiết bị có kết nối internet hay không', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getTotalByType(any(),
          userId: any(named: 'userId'),
          start: any(named: 'start'),
          end: any(named: 'end'))).thenAnswer((_) async => total);

      // act
      await repository.getTotalByType(
        type,
        userId: userId,
        start: startDate,
        end: endDate,
      );

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('thiết bị online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'nên trả về tổng số tiền khi gọi remote data source thành công',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getTotalByType(any(),
              userId: any(named: 'userId'),
              start: any(named: 'start'),
              end: any(named: 'end'))).thenAnswer((_) async => total);

          // act
          final result = await repository.getTotalByType(
            type,
            userId: userId,
            start: startDate,
            end: endDate,
          );

          // assert
          verify(() => mockRemoteDataSource.getTotalByType(type,
              userId: userId, start: startDate, end: endDate));
          expect(result, equals(Right(total)));
        },
      );

      test(
        'nên trả về server failure khi gọi remote data source thất bại',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getTotalByType(any(),
              userId: any(named: 'userId'),
              start: any(named: 'start'),
              end: any(named: 'end'))).thenThrow(Exception());

          // act
          final result = await repository.getTotalByType(
            type,
            userId: userId,
            start: startDate,
            end: endDate,
          );

          // assert
          verify(() => mockRemoteDataSource.getTotalByType(type,
              userId: userId, start: startDate, end: endDate));
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('Expected Left with ServerFailure'),
          );
        },
      );
    });

    group('thiết bị offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'nên trả về NetworkFailure khi thiết bị offline',
        () async {
          // act
          final result = await repository.getTotalByType(
            type,
            userId: userId,
            start: startDate,
            end: endDate,
          );

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (_) => fail('Expected Left with NetworkFailure'),
          );
        },
      );
    });
  });
}
