import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionsByDateRangeUseCase
    implements UseCase<List<Transaction>, DateRangeParams> {
  final TransactionRepository repository;

  GetTransactionsByDateRangeUseCase(this.repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(DateRangeParams params) {
    return repository.getTransactionsByDateRange(
      params.start,
      params.end,
      userId: params.userId,
    );
  }
}

class DateRangeParams extends Equatable {
  final DateTime start;
  final DateTime end;
  final String? userId;

  const DateRangeParams({
    required this.start,
    required this.end,
    this.userId,
  });

  @override
  List<Object?> get props => [start, end, userId];
}
