import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/core/errors/failures.dart';
import 'package:money_mate/features/summary/domain/entities/summary_data.dart';
import 'package:money_mate/features/summary/domain/entities/time_range.dart';
import 'package:money_mate/features/summary/domain/usecases/get_summary_by_date_range_usecase.dart';
import 'package:money_mate/features/summary/domain/usecases/get_summary_by_time_range_usecase.dart';
import 'package:money_mate/features/summary/presentation/bloc/summary_bloc.dart';
import 'package:money_mate/features/summary/presentation/bloc/summary_event.dart';
import 'package:money_mate/features/summary/presentation/bloc/summary_state.dart';

import 'summary_bloc_test.mocks.dart';

@GenerateMocks([GetSummaryByTimeRangeUseCase, GetSummaryByDateRangeUseCase])
void main() {
  late SummaryBloc bloc;
  late MockGetSummaryByTimeRangeUseCase mockGetSummaryByTimeRange;
  late MockGetSummaryByDateRangeUseCase mockGetSummaryByDateRange;

  setUp(() {
    mockGetSummaryByTimeRange = MockGetSummaryByTimeRangeUseCase();
    mockGetSummaryByDateRange = MockGetSummaryByDateRangeUseCase();
    bloc = SummaryBloc(
      getSummaryByTimeRange: mockGetSummaryByTimeRange,
      getSummaryByDateRange: mockGetSummaryByDateRange,
    );
  });

  final testTimeRange = TimeRange.month;
  final testReferenceDate = DateTime(2023, 1, 15);
  final testStartDate = DateTime(2023, 1, 1);
  final testEndDate = DateTime(2023, 1, 31, 23, 59, 59);
  final testUserId = 'test-user-id';

  final testSummaryData = SummaryData(
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

  test('initial state nên là SummaryInitial', () {
    // assert
    expect(bloc.state, equals(SummaryInitial()));
  });

  group('GetSummaryByTimeRangeEvent', () {
    test(
      'nên gọi use case với tham số đúng',
      () async {
        // arrange
        when(mockGetSummaryByTimeRange(any))
            .thenAnswer((_) async => Right(testSummaryData));

        // act
        bloc.add(GetSummaryByTimeRangeEvent(
          timeRange: testTimeRange,
          userId: testUserId,
          referenceDate: testReferenceDate,
        ));
        await untilCalled(mockGetSummaryByTimeRange(any));

        // assert
        verify(mockGetSummaryByTimeRange(TimeRangeParams(
          timeRange: testTimeRange,
          userId: testUserId,
          referenceDate: testReferenceDate,
        )));
      },
    );

    test(
      'nên emit [SummaryLoading, SummaryLoaded] khi use case thành công',
      () async {
        // arrange
        when(mockGetSummaryByTimeRange(any))
            .thenAnswer((_) async => Right(testSummaryData));

        // assert later
        final expected = [
          SummaryLoading(),
          SummaryLoaded(
            summaryData: testSummaryData,
            currentTimeRange: testTimeRange,
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetSummaryByTimeRangeEvent(
          timeRange: testTimeRange,
          userId: testUserId,
          referenceDate: testReferenceDate,
        ));
      },
    );

    test(
      'nên emit [SummaryLoading, SummaryError] khi use case thất bại',
      () async {
        // arrange
        when(mockGetSummaryByTimeRange(any))
            .thenAnswer((_) async => Left(ServerFailure('Lỗi server')));

        // assert later
        expectLater(
            bloc.stream,
            emitsInOrder([
              isA<SummaryLoading>(),
              predicate<SummaryError>((state) =>
                  state.failure is ServerFailure &&
                  state.failure.message == 'Lỗi server'),
            ]));

        // act
        bloc.add(GetSummaryByTimeRangeEvent(
          timeRange: testTimeRange,
          userId: testUserId,
          referenceDate: testReferenceDate,
        ));
      },
    );
  });

  group('GetSummaryByDateRangeEvent', () {
    test(
      'nên gọi use case với tham số đúng',
      () async {
        // arrange
        when(mockGetSummaryByDateRange(any))
            .thenAnswer((_) async => Right(testSummaryData));

        // act
        bloc.add(GetSummaryByDateRangeEvent(
          startDate: testStartDate,
          endDate: testEndDate,
          userId: testUserId,
        ));
        await untilCalled(mockGetSummaryByDateRange(any));

        // assert
        verify(mockGetSummaryByDateRange(DateRangeParams(
          startDate: testStartDate,
          endDate: testEndDate,
          userId: testUserId,
        )));
      },
    );

    test(
      'nên emit [SummaryLoading, SummaryLoaded] khi use case thành công',
      () async {
        // arrange
        when(mockGetSummaryByDateRange(any))
            .thenAnswer((_) async => Right(testSummaryData));

        // assert later
        final expected = [
          SummaryLoading(),
          SummaryLoaded(
            summaryData: testSummaryData,
            currentTimeRange: TimeRange.month,
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));

        // act
        bloc.add(GetSummaryByDateRangeEvent(
          startDate: testStartDate,
          endDate: testEndDate,
          userId: testUserId,
        ));
      },
    );

    test(
      'nên emit [SummaryLoading, SummaryError] khi use case thất bại',
      () async {
        // arrange
        when(mockGetSummaryByDateRange(any))
            .thenAnswer((_) async => Left(ServerFailure('Lỗi server')));

        // assert later
        expectLater(
            bloc.stream,
            emitsInOrder([
              isA<SummaryLoading>(),
              predicate<SummaryError>((state) =>
                  state.failure is ServerFailure &&
                  state.failure.message == 'Lỗi server'),
            ]));

        // act
        bloc.add(GetSummaryByDateRangeEvent(
          startDate: testStartDate,
          endDate: testEndDate,
          userId: testUserId,
        ));
      },
    );
  });

  group('ChangeTimeRangeEvent', () {
    test(
      'nên emit [SummaryTimeRangeChanged] và thêm GetSummaryByTimeRangeEvent mới',
      () async {
        // arrange
        when(mockGetSummaryByTimeRange(any))
            .thenAnswer((_) async => Right(testSummaryData));

        // act
        bloc.add(const ChangeTimeRangeEvent(timeRange: TimeRange.week));

        // assert
        await untilCalled(mockGetSummaryByTimeRange(any));
        verify(mockGetSummaryByTimeRange(any)).called(1);
      },
    );
  });
}
