import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/summary_data.dart';
import '../entities/time_range.dart';
import '../repositories/summary_repository.dart';

class GetSummaryByTimeRangeUseCase
    implements UseCase<SummaryData, TimeRangeParams> {
  final SummaryRepository repository;

  GetSummaryByTimeRangeUseCase(this.repository);

  @override
  Future<Either<Failure, SummaryData>> call(TimeRangeParams params) async {
    return await repository.getSummaryByTimeRange(
      params.timeRange,
      userId: params.userId,
      referenceDate: params.referenceDate,
    );
  }
}

class TimeRangeParams extends Equatable {
  final TimeRange timeRange;
  final String? userId;
  final DateTime? referenceDate;

  const TimeRangeParams({
    required this.timeRange,
    this.userId,
    this.referenceDate,
  });

  @override
  List<Object?> get props => [timeRange, userId, referenceDate];
}
