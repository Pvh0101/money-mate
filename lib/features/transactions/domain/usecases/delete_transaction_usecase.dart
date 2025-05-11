import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/transaction_repository.dart';

class DeleteTransactionUseCase
    implements UseCase<void, DeleteTransactionParams> {
  final TransactionRepository repository;

  DeleteTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteTransactionParams params) {
    return repository.deleteTransaction(params.id);
  }
}

class DeleteTransactionParams extends Equatable {
  final String id;

  const DeleteTransactionParams({required this.id});

  @override
  List<Object> get props => [id];
}
