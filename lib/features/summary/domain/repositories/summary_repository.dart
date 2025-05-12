import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/summary_data.dart';
import '../entities/time_range.dart';

abstract class SummaryRepository {
  /// Lấy dữ liệu thống kê theo khoảng thời gian
  Future<Either<Failure, SummaryData>> getSummaryByTimeRange(
    TimeRange timeRange, {
    String? userId,
    DateTime? referenceDate,
  });

  /// Lấy dữ liệu thống kê theo khoảng thời gian tùy chỉnh
  Future<Either<Failure, SummaryData>> getSummaryByDateRange(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  });

  /// Xóa tất cả dữ liệu thống kê đã cache
  Future<Either<Failure, bool>> clearSummaryCache();
}
