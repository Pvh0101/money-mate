import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/summary_data.dart';
import '../repositories/summary_repository.dart';

class GetSummaryByDateRangeUseCase
    implements UseCase<SummaryData, DateRangeParams> {
  final SummaryRepository repository;

  GetSummaryByDateRangeUseCase(this.repository);

  @override
  Future<Either<Failure, SummaryData>> call(DateRangeParams params) async {
    return await repository.getSummaryByDateRange(
      params.startDate,
      params.endDate,
      userId: params.userId,
    );
  }
}

class DateRangeParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final String? userId;

  const DateRangeParams({
    required this.startDate,
    required this.endDate,
    this.userId,
  });

  @override
  List<Object?> get props => [startDate, endDate, userId];
}
