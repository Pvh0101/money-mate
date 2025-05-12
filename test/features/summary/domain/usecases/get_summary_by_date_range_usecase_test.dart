import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/features/summary/domain/entities/summary_data.dart';
import 'package:money_mate/features/summary/domain/repositories/summary_repository.dart';
import 'package:money_mate/features/summary/domain/usecases/get_summary_by_date_range_usecase.dart';

import 'get_summary_by_date_range_usecase_test.mocks.dart';

@GenerateMocks([SummaryRepository])
void main() {
  late GetSummaryByDateRangeUseCase usecase;
  late MockSummaryRepository mockRepository;

  setUp(() {
    mockRepository = MockSummaryRepository();
    usecase = GetSummaryByDateRangeUseCase(mockRepository);
  });

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

  test(
    'Gọi repository.getSummaryByDateRange với tham số đúng',
    () async {
      // arrange
      when(mockRepository.getSummaryByDateRange(
        testStartDate,
        testEndDate,
        userId: testUserId,
      )).thenAnswer((_) async => Right(testSummaryData));

      // act
      final result = await usecase(DateRangeParams(
        startDate: testStartDate,
        endDate: testEndDate,
        userId: testUserId,
      ));

      // assert
      expect(result, Right(testSummaryData));
      verify(mockRepository.getSummaryByDateRange(
        testStartDate,
        testEndDate,
        userId: testUserId,
      ));
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
