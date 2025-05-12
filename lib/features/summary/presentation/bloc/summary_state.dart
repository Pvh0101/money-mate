import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/summary_data.dart';
import '../../domain/entities/time_range.dart';

abstract class SummaryState extends Equatable {
  const SummaryState();

  @override
  List<Object?> get props => [];
}

class SummaryInitial extends SummaryState {}

class SummaryLoading extends SummaryState {}

class SummaryLoaded extends SummaryState {
  final SummaryData summaryData;
  final TimeRange currentTimeRange;

  const SummaryLoaded({
    required this.summaryData,
    required this.currentTimeRange,
  });

  @override
  List<Object> get props => [summaryData, currentTimeRange];
}

class SummaryError extends SummaryState {
  final Failure failure;

  const SummaryError({required this.failure});

  String get message => failure.message;

  @override
  List<Object> get props => [failure];
}

class SummaryTimeRangeChanged extends SummaryState {
  final TimeRange timeRange;
  final DateTime? referenceDate;

  const SummaryTimeRangeChanged({
    required this.timeRange,
    this.referenceDate,
  });

  @override
  List<Object?> get props => [timeRange, referenceDate];
}
