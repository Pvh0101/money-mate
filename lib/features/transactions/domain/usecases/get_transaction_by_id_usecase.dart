import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionByIdUseCase
    implements UseCase<Transaction, TransactionIdParams> {
  final TransactionRepository repository;

  GetTransactionByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Transaction>> call(TransactionIdParams params) {
    return repository.getTransactionById(params.id);
  }
}

class TransactionIdParams extends Equatable {
  final String id;

  const TransactionIdParams({required this.id});

  @override
  List<Object> get props => [id];
}
