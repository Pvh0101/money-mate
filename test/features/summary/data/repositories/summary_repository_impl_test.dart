import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/core/errors/exceptions.dart';
import 'package:money_mate/core/errors/failures.dart';
import 'package:money_mate/core/network/network_info.dart';
import 'package:money_mate/features/summary/data/datasources/summary_datasource.dart';
import 'package:money_mate/features/summary/data/models/summary_data_model.dart';
import 'package:money_mate/features/summary/data/repositories/summary_repository_impl.dart';
import 'package:money_mate/features/summary/domain/entities/time_range.dart';

import 'summary_repository_impl_test.mocks.dart';

@GenerateMocks([SummaryRemoteDataSource, NetworkInfo])
void main() {
  late SummaryRepositoryImpl repository;
  late MockSummaryRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockSummaryRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = SummaryRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final testStartDate = DateTime(2023, 1, 1);
  final testEndDate = DateTime(2023, 1, 31, 23, 59, 59);
  final testTimeRange = TimeRange.month;
  final testReferenceDate = DateTime(2023, 1, 15);
  final testUserId = 'test-user-id';

  final testSummaryDataModel = SummaryDataModel(
    startDate: testStartDate,
    endDate: testEndDate,
    totalExpense: 1200000,
    totalIncome: 4000000,
    expenseByCategory: {
      'food': 400000,
      'transport': 300000,
      'entertainment': 500000
    },
    incomeByCategory: {'salary': 4000000},
    expenseByDate: {
      DateTime(2023, 1, 5): 150000,
      DateTime(2023, 1, 15): 550000,
      DateTime(2023, 1, 25): 500000,
    },
    incomeByDate: {
      DateTime(2023, 1, 1): 4000000,
    },
  );

  group('getSummaryByTimeRange', () {
    test('nên kiểm tra xem thiết bị có kết nối hay không', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getSummaryByTimeRange(
        testTimeRange,
        userId: testUserId,
        referenceDate: testReferenceDate,
      )).thenAnswer((_) async => testSummaryDataModel);

      // act
      await repository.getSummaryByTimeRange(
        testTimeRange,
        userId: testUserId,
        referenceDate: testReferenceDate,
      );

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('thiết bị online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('nên trả về SummaryData khi remote data source thành công',
          () async {
        // arrange
        when(mockRemoteDataSource.getSummaryByTimeRange(
          testTimeRange,
          userId: testUserId,
          referenceDate: testReferenceDate,
        )).thenAnswer((_) async => testSummaryDataModel);

        // act
        final result = await repository.getSummaryByTimeRange(
          testTimeRange,
          userId: testUserId,
          referenceDate: testReferenceDate,
        );

        // assert
        expect(result, Right(testSummaryDataModel));
        verify(mockRemoteDataSource.getSummaryByTimeRange(
          testTimeRange,
          userId: testUserId,
          referenceDate: testReferenceDate,
        ));
      });

      test(
        'nên trả về ServerFailure khi remote data source gặp ServerException',
        () async {
          // arrange
          when(mockRemoteDataSource.getSummaryByTimeRange(
            testTimeRange,
            userId: testUserId,
            referenceDate: testReferenceDate,
          )).thenThrow(ServerException('Lỗi server'));

          // act
          final result = await repository.getSummaryByTimeRange(
            testTimeRange,
            userId: testUserId,
            referenceDate: testReferenceDate,
          );

          // assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
              expect(failure.message, 'Lỗi server');
            },
            (_) => fail('Should be a Left'),
          );
          verify(mockRemoteDataSource.getSummaryByTimeRange(
            testTimeRange,
            userId: testUserId,
            referenceDate: testReferenceDate,
          ));
        },
      );
    });

    group('thiết bị offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('nên trả về NetworkFailure khi không có kết nối mạng', () async {
        // act
        final result = await repository.getSummaryByTimeRange(
          testTimeRange,
          userId: testUserId,
          referenceDate: testReferenceDate,
        );

        // assert
        expect(result, Left(const NetworkFailure()));
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });

  group('getSummaryByDateRange', () {
    test('nên kiểm tra xem thiết bị có kết nối hay không', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getSummaryByDateRange(
        testStartDate,
        testEndDate,
        userId: testUserId,
      )).thenAnswer((_) async => testSummaryDataModel);

      // act
      await repository.getSummaryByDateRange(
        testStartDate,
        testEndDate,
        userId: testUserId,
      );

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('thiết bị online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('nên trả về SummaryData khi remote data source thành công',
          () async {
        // arrange
        when(mockRemoteDataSource.getSummaryByDateRange(
          testStartDate,
          testEndDate,
          userId: testUserId,
        )).thenAnswer((_) async => testSummaryDataModel);

        // act
        final result = await repository.getSummaryByDateRange(
          testStartDate,
          testEndDate,
          userId: testUserId,
        );

        // assert
        expect(result, Right(testSummaryDataModel));
        verify(mockRemoteDataSource.getSummaryByDateRange(
          testStartDate,
          testEndDate,
          userId: testUserId,
        ));
      });

      test(
        'nên trả về ServerFailure khi remote data source gặp ServerException',
        () async {
          // arrange
          when(mockRemoteDataSource.getSummaryByDateRange(
            testStartDate,
            testEndDate,
            userId: testUserId,
          )).thenThrow(ServerException('Lỗi server'));

          // act
          final result = await repository.getSummaryByDateRange(
            testStartDate,
            testEndDate,
            userId: testUserId,
          );

          // assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) {
              expect(failure, isA<ServerFailure>());
              expect(failure.message, 'Lỗi server');
            },
            (_) => fail('Should be a Left'),
          );
          verify(mockRemoteDataSource.getSummaryByDateRange(
            testStartDate,
            testEndDate,
            userId: testUserId,
          ));
        },
      );
    });

    group('thiết bị offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('nên trả về NetworkFailure khi không có kết nối mạng', () async {
        // act
        final result = await repository.getSummaryByDateRange(
          testStartDate,
          testEndDate,
          userId: testUserId,
        );

        // assert
        expect(result, Left(const NetworkFailure()));
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });
}
