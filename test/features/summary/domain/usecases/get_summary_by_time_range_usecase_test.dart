import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/features/summary/domain/entities/summary_data.dart';
import 'package:money_mate/features/summary/domain/entities/time_range.dart';
import 'package:money_mate/features/summary/domain/repositories/summary_repository.dart';
import 'package:money_mate/features/summary/domain/usecases/get_summary_by_time_range_usecase.dart';

import 'get_summary_by_time_range_usecase_test.mocks.dart';

@GenerateMocks([SummaryRepository])
void main() {
  late GetSummaryByTimeRangeUseCase usecase;
  late MockSummaryRepository mockRepository;

  setUp(() {
    mockRepository = MockSummaryRepository();
    usecase = GetSummaryByTimeRangeUseCase(mockRepository);
  });

  final testTimeRange = TimeRange.month;
  final testUserId = 'test-user-id';
  final testReferenceDate = DateTime(2023, 6, 15);

  final testSummaryData = SummaryData(
    startDate: DateTime(2023, 6, 1),
    endDate: DateTime(2023, 6, 30, 23, 59, 59),
    totalExpense: 1500000,
    totalIncome: 5000000,
    expenseByCategory: {
      'food': 500000,
      'transport': 300000,
      'entertainment': 700000
    },
    incomeByCategory: {'salary': 4500000, 'bonus': 500000},
    expenseByDate: {
      DateTime(2023, 6, 5): 200000,
      DateTime(2023, 6, 10): 800000,
      DateTime(2023, 6, 20): 500000,
    },
    incomeByDate: {
      DateTime(2023, 6, 1): 4500000,
      DateTime(2023, 6, 15): 500000,
    },
  );

  test(
    'Gọi repository.getSummaryByTimeRange với tham số đúng',
    () async {
      // arrange
      when(mockRepository.getSummaryByTimeRange(
        testTimeRange,
        userId: testUserId,
        referenceDate: testReferenceDate,
      )).thenAnswer((_) async => Right(testSummaryData));

      // act
      final result = await usecase(TimeRangeParams(
        timeRange: testTimeRange,
        userId: testUserId,
        referenceDate: testReferenceDate,
      ));

      // assert
      expect(result, Right(testSummaryData));
      verify(mockRepository.getSummaryByTimeRange(
        testTimeRange,
        userId: testUserId,
        referenceDate: testReferenceDate,
      ));
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
