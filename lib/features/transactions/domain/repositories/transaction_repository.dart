import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/enums/transaction_type.dart';
import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<Transaction>>> getTransactions({String? userId});
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(
      String categoryId,
      {String? userId});
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(
      DateTime start, DateTime end,
      {String? userId});
  Future<Either<Failure, Transaction>> getTransactionById(String id);
  Future<Either<Failure, Transaction>> addTransaction(Transaction transaction);
  Future<Either<Failure, Transaction>> updateTransaction(
      Transaction transaction);
  Future<Either<Failure, void>> deleteTransaction(String id);
  Future<Either<Failure, double>> getTotalByType(TransactionType type,
      {String? userId, DateTime? start, DateTime? end});
}
