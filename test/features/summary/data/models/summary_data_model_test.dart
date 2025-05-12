import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/features/summary/data/models/summary_data_model.dart';
import 'package:money_mate/features/summary/domain/entities/summary_data.dart';

void main() {
  final DateTime testStartDate = DateTime(2023, 6, 1);
  final DateTime testEndDate = DateTime(2023, 6, 30, 23, 59, 59);

  final testSummaryDataModel = SummaryDataModel(
    startDate: testStartDate,
    endDate: testEndDate,
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

  final Map<String, dynamic> testJson = {
    'startDate': testStartDate.millisecondsSinceEpoch,
    'endDate': testEndDate.millisecondsSinceEpoch,
    'totalExpense': 1500000,
    'totalIncome': 5000000,
    'expenseByCategory': {
      'food': 500000,
      'transport': 300000,
      'entertainment': 700000,
    },
    'incomeByCategory': {
      'salary': 4500000,
      'bonus': 500000,
    },
    'expenseByDate': {
      DateTime(2023, 6, 5).millisecondsSinceEpoch.toString(): 200000,
      DateTime(2023, 6, 10).millisecondsSinceEpoch.toString(): 800000,
      DateTime(2023, 6, 20).millisecondsSinceEpoch.toString(): 500000,
    },
    'incomeByDate': {
      DateTime(2023, 6, 1).millisecondsSinceEpoch.toString(): 4500000,
      DateTime(2023, 6, 15).millisecondsSinceEpoch.toString(): 500000,
    },
  };

  group('SummaryDataModel Tests', () {
    test('SummaryDataModel nên là một subclass của SummaryData', () {
      // assert
      expect(testSummaryDataModel, isA<SummaryData>());
    });

    group('fromJson', () {
      test('nên trả về một SummaryDataModel hợp lệ khi JSON hợp lệ', () {
        // act
        final result = SummaryDataModel.fromJson(testJson);

        // assert
        expect(result, isA<SummaryDataModel>());
        expect(result.startDate, equals(testStartDate));
        expect(result.endDate, equals(testEndDate));
        expect(result.totalExpense, equals(1500000));
        expect(result.totalIncome, equals(5000000));

        // Kiểm tra expenseByCategory
        expect(result.expenseByCategory.length, equals(3));
        expect(result.expenseByCategory['food'], equals(500000));
        expect(result.expenseByCategory['transport'], equals(300000));
        expect(result.expenseByCategory['entertainment'], equals(700000));

        // Kiểm tra incomeByCategory
        expect(result.incomeByCategory.length, equals(2));
        expect(result.incomeByCategory['salary'], equals(4500000));
        expect(result.incomeByCategory['bonus'], equals(500000));

        // Kiểm tra expenseByDate
        expect(result.expenseByDate.length, equals(3));
        final expectedDates = [
          DateTime(2023, 6, 5),
          DateTime(2023, 6, 10),
          DateTime(2023, 6, 20),
        ];
        for (var date in expectedDates) {
          expect(
              result.expenseByDate.keys.any((key) =>
                  key.year == date.year &&
                  key.month == date.month &&
                  key.day == date.day),
              isTrue);
        }

        // Kiểm tra incomeByDate
        expect(result.incomeByDate.length, equals(2));
        final expectedIncomeDates = [
          DateTime(2023, 6, 1),
          DateTime(2023, 6, 15),
        ];
        for (var date in expectedIncomeDates) {
          expect(
              result.incomeByDate.keys.any((key) =>
                  key.year == date.year &&
                  key.month == date.month &&
                  key.day == date.day),
              isTrue);
        }
      });

      test('nên xử lý JSON với các trường null hoặc thiếu', () {
        // arrange
        final incompleteJson = {
          'startDate': testStartDate.millisecondsSinceEpoch,
          'endDate': testEndDate.millisecondsSinceEpoch,
          // Thiếu totalExpense và totalIncome
          'expenseByCategory': null, // null
          // Thiếu incomeByCategory
        };

        // act
        final result = SummaryDataModel.fromJson(incompleteJson);

        // assert
        expect(result, isA<SummaryDataModel>());
        expect(result.totalExpense, 0.0);
        expect(result.totalIncome, 0.0);
        expect(result.expenseByCategory, isEmpty);
        expect(result.incomeByCategory, isEmpty);
        expect(result.expenseByDate, isEmpty);
        expect(result.incomeByDate, isEmpty);
      });
    });

    group('toJson', () {
      test('nên trả về JSON map với các trường chính xác', () {
        // act
        final result = testSummaryDataModel.toJson();

        // assert
        expect(result, isA<Map<String, dynamic>>());
        expect(
            result['startDate'], equals(testStartDate.millisecondsSinceEpoch));
        expect(result['endDate'], equals(testEndDate.millisecondsSinceEpoch));
        expect(result['totalExpense'], equals(1500000));
        expect(result['totalIncome'], equals(5000000));

        // Kiểm tra expenseByCategory
        expect(result['expenseByCategory'], isA<Map<String, double>>());
        expect(result['expenseByCategory']['food'], equals(500000));

        // Kiểm tra expenseByDate (đã chuyển đổi DateTime sang string)
        expect(result['expenseByDate'], isA<Map<String, double>>());
        expect(result['expenseByDate'].length, equals(3));
      });
    });
  });
}
