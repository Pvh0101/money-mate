import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class UpdateTransactionUseCase implements UseCase<Transaction, Transaction> {
  final TransactionRepository repository;

  UpdateTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, Transaction>> call(Transaction params) {
    return repository.updateTransaction(params);
  }
}
