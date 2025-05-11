import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class AddTransactionUseCase implements UseCase<Transaction, Transaction> {
  final TransactionRepository repository;

  AddTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, Transaction>> call(Transaction params) {
    return repository.addTransaction(params);
  }
}
