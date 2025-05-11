import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionsUseCase
    implements UseCase<List<Transaction>, GetTransactionsParams> {
  final TransactionRepository repository;

  GetTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(
      GetTransactionsParams params) {
    return repository.getTransactions(userId: params.userId);
  }
}

class GetTransactionsParams extends Equatable {
  final String? userId;

  const GetTransactionsParams({this.userId});

  @override
  List<Object?> get props => [userId];
}
