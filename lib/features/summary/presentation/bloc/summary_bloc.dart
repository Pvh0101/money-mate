import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/time_range.dart';
import '../../domain/usecases/clear_summary_cache_usecase.dart';
import '../../domain/usecases/get_summary_by_date_range_usecase.dart';
import '../../domain/usecases/get_summary_by_time_range_usecase.dart';
import 'summary_event.dart';
import 'summary_state.dart';
import 'dart:developer' as developer;

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final GetSummaryByTimeRangeUseCase getSummaryByTimeRange;
  final GetSummaryByDateRangeUseCase getSummaryByDateRange;
  final ClearSummaryCacheUseCase clearSummaryCache;

  SummaryBloc({
    required this.getSummaryByTimeRange,
    required this.getSummaryByDateRange,
    required this.clearSummaryCache,
  }) : super(SummaryInitial()) {
    on<GetSummaryByTimeRangeEvent>(_onGetSummaryByTimeRange);
    on<GetSummaryByDateRangeEvent>(_onGetSummaryByDateRange);
    on<ChangeTimeRangeEvent>(_onChangeTimeRange);
    on<RefreshSummaryEvent>(_onRefreshSummary);
    on<ClearSummaryCacheEvent>(_onClearSummaryCache);

    // Log state changes to help debug
    developer.log('SummaryBloc initialized. Current state: $state');
  }

  @override
  void onTransition(Transition<SummaryEvent, SummaryState> transition) {
    super.onTransition(transition);
    developer.log(
        'SummaryBloc transition: ${transition.currentState} -> ${transition.nextState} from event ${transition.event}');
  }

  void _onGetSummaryByTimeRange(
    GetSummaryByTimeRangeEvent event,
    Emitter<SummaryState> emit,
  ) async {
    developer
        .log('Processing GetSummaryByTimeRangeEvent: ${event.timeRange.name}');
    emit(SummaryLoading());

    final result = await getSummaryByTimeRange(TimeRangeParams(
      timeRange: event.timeRange,
      userId: event.userId,
      referenceDate: event.referenceDate,
    ));

    result.fold(
      (failure) {
        developer
            .log('Error loading summary by time range: ${failure.message}');
        emit(SummaryError(failure: failure));
      },
      (summaryData) {
        developer.log(
            'Summary data loaded by time range. Income=${summaryData.totalIncome}, Expense=${summaryData.totalExpense}');
        emit(SummaryLoaded(
          summaryData: summaryData,
          currentTimeRange: event.timeRange,
        ));
      },
    );
  }

  void _onGetSummaryByDateRange(
    GetSummaryByDateRangeEvent event,
    Emitter<SummaryState> emit,
  ) async {
    developer.log(
        'Processing GetSummaryByDateRangeEvent: ${event.startDate} to ${event.endDate}');
    emit(SummaryLoading());

    final result = await getSummaryByDateRange(DateRangeParams(
      startDate: event.startDate,
      endDate: event.endDate,
      userId: event.userId,
    ));

    result.fold(
      (failure) {
        developer
            .log('Error loading summary by date range: ${failure.message}');
        emit(SummaryError(failure: failure));
      },
      (summaryData) {
        developer.log(
            'Summary data loaded by date range. Income=${summaryData.totalIncome}, Expense=${summaryData.totalExpense}');
        emit(SummaryLoaded(
          summaryData: summaryData,
          currentTimeRange: TimeRange.month, // Default
        ));
      },
    );
  }

  void _onChangeTimeRange(
    ChangeTimeRangeEvent event,
    Emitter<SummaryState> emit,
  ) {
    developer.log('Processing ChangeTimeRangeEvent: ${event.timeRange.name}');
    final now = DateTime.now();
    final startDate = event.timeRange.getStartDate(now);
    final endDate = event.timeRange.getEndDate(now);

    emit(SummaryTimeRangeChanged(
      timeRange: event.timeRange,
      referenceDate: now,
    ));

    add(GetSummaryByDateRangeEvent(
      startDate: startDate,
      endDate: endDate,
    ));
  }

  void _onRefreshSummary(
    RefreshSummaryEvent event,
    Emitter<SummaryState> emit,
  ) {
    developer.log('Processing RefreshSummaryEvent');
    final now = DateTime.now();

    final currentState = state;
    if (currentState is SummaryLoaded) {
      final timeRange = currentState.currentTimeRange;
      final startDate = timeRange.getStartDate(now);
      final endDate = timeRange.getEndDate(now);

      developer
          .log('Refreshing summary with current time range: ${timeRange.name}');
      add(GetSummaryByDateRangeEvent(
        startDate: startDate,
        endDate: endDate,
      ));
    } else {
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      developer.log(
          'Current state is not SummaryLoaded, refreshing with month range');
      add(GetSummaryByDateRangeEvent(
        startDate: firstDayOfMonth,
        endDate: lastDayOfMonth,
      ));
    }
  }

  void _onClearSummaryCache(
    ClearSummaryCacheEvent event,
    Emitter<SummaryState> emit,
  ) async {
    developer.log('Processing ClearSummaryCacheEvent');
    emit(SummaryLoading());

    final result = await clearSummaryCache(NoParams());

    result.fold(
      (failure) {
        developer.log('Error clearing summary cache: ${failure.message}');
        emit(SummaryError(failure: failure));
      },
      (success) {
        developer.log('Summary cache cleared successfully');
        // Sau khi xóa cache, tự động làm mới dữ liệu
        add(const RefreshSummaryEvent());
      },
    );
  }
}
