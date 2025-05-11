import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionsByCategoryUseCase
    implements UseCase<List<Transaction>, CategoryParams> {
  final TransactionRepository repository;

  GetTransactionsByCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(CategoryParams params) {
    return repository.getTransactionsByCategory(
      params.categoryId,
      userId: params.userId,
    );
  }
}

class CategoryParams extends Equatable {
  final String categoryId;
  final String? userId;

  const CategoryParams({
    required this.categoryId,
    this.userId,
  });

  @override
  List<Object?> get props => [categoryId, userId];
}
