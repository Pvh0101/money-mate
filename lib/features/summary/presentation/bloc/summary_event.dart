import 'package:equatable/equatable.dart';
import '../../domain/entities/time_range.dart';

abstract class SummaryEvent extends Equatable {
  const SummaryEvent();

  @override
  List<Object?> get props => [];
}

class GetSummaryByTimeRangeEvent extends SummaryEvent {
  final TimeRange timeRange;
  final String? userId;
  final DateTime? referenceDate;

  const GetSummaryByTimeRangeEvent({
    required this.timeRange,
    this.userId,
    this.referenceDate,
  });

  @override
  List<Object?> get props => [timeRange, userId, referenceDate];
}

class GetSummaryByDateRangeEvent extends SummaryEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String? userId;

  const GetSummaryByDateRangeEvent({
    required this.startDate,
    required this.endDate,
    this.userId,
  });

  @override
  List<Object?> get props => [startDate, endDate, userId];
}

class ChangeTimeRangeEvent extends SummaryEvent {
  final TimeRange timeRange;

  const ChangeTimeRangeEvent({required this.timeRange});

  @override
  List<Object> get props => [timeRange];
}

/// Sự kiện được kích hoạt khi cần làm mới dữ liệu tổng hợp
/// Ví dụ: sau khi thêm, sửa hoặc xóa giao dịch
class RefreshSummaryEvent extends SummaryEvent {
  const RefreshSummaryEvent();
}

/// Sự kiện để xóa toàn bộ cache summary
class ClearSummaryCacheEvent extends SummaryEvent {
  const ClearSummaryCacheEvent();
}
