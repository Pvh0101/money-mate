import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/features/summary/domain/entities/time_range.dart';

void main() {
  group('TimeRange Extension Tests', () {
    // Test cho các display name
    test('displayName trả về đúng tên tiếng Việt', () {
      expect(TimeRange.day.displayName, 'Ngày');
      expect(TimeRange.week.displayName, 'Tuần');
      expect(TimeRange.month.displayName, 'Tháng');
      expect(TimeRange.year.displayName, 'Năm');
    });

    // Reference date: Thứ 4, ngày 15/3/2023
    final referenceDate = DateTime(2023, 3, 15);

    group('getStartDate', () {
      test('TimeRange.day trả về đầu ngày hiện tại', () {
        final result = TimeRange.day.getStartDate(referenceDate);
        expect(result, DateTime(2023, 3, 15));
      });

      test('TimeRange.week trả về đầu tuần (thứ 2)', () {
        final result = TimeRange.week.getStartDate(referenceDate);
        expect(result, DateTime(2023, 3, 13)); // Thứ 2, 13/3/2023
      });

      test('TimeRange.month trả về ngày đầu tháng', () {
        final result = TimeRange.month.getStartDate(referenceDate);
        expect(result, DateTime(2023, 3, 1));
      });

      test('TimeRange.year trả về ngày đầu năm', () {
        final result = TimeRange.year.getStartDate(referenceDate);
        expect(result, DateTime(2023, 1, 1));
      });
    });

    group('getEndDate', () {
      test('TimeRange.day trả về cuối ngày hiện tại', () {
        final result = TimeRange.day.getEndDate(referenceDate);
        expect(result, DateTime(2023, 3, 15, 23, 59, 59, 999));
      });

      test('TimeRange.week trả về cuối tuần (chủ nhật)', () {
        final result = TimeRange.week.getEndDate(referenceDate);
        expect(result,
            DateTime(2023, 3, 19, 23, 59, 59, 999)); // Chủ nhật, 19/3/2023
      });

      test('TimeRange.month trả về ngày cuối tháng', () {
        final result = TimeRange.month.getEndDate(referenceDate);
        expect(result, DateTime(2023, 3, 31, 23, 59, 59, 999));
      });

      test('TimeRange.year trả về ngày cuối năm', () {
        final result = TimeRange.year.getEndDate(referenceDate);
        expect(result, DateTime(2023, 12, 31, 23, 59, 59, 999));
      });
    });

    // Test cho các tháng đặc biệt
    group('Tháng đặc biệt', () {
      test('Cuối tháng 2 năm nhuận', () {
        final leapYear = DateTime(2024, 2, 15);
        final result = TimeRange.month.getEndDate(leapYear);
        expect(result, DateTime(2024, 2, 29, 23, 59, 59, 999));
      });

      test('Cuối tháng 2 năm không nhuận', () {
        final nonLeapYear = DateTime(2023, 2, 15);
        final result = TimeRange.month.getEndDate(nonLeapYear);
        expect(result, DateTime(2023, 2, 28, 23, 59, 59, 999));
      });
    });
  });
}
