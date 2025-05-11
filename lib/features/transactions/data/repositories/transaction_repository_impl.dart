import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions(
      {String? userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final transactions =
            await remoteDataSource.getTransactions(userId: userId);
        return Right(transactions);
      } catch (e) {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(
      String categoryId,
      {String? userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final transactions = await remoteDataSource
            .getTransactionsByCategory(categoryId, userId: userId);
        return Right(transactions);
      } catch (e) {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(
      DateTime start, DateTime end,
      {String? userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final transactions = await remoteDataSource
            .getTransactionsByDateRange(start, end, userId: userId);
        return Right(transactions);
      } catch (e) {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final transaction = await remoteDataSource.getTransactionById(id);
        return Right(transaction);
      } catch (e) {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Transaction>> addTransaction(
      Transaction transaction) async {
    if (await networkInfo.isConnected) {
      try {
        final transactionModel = TransactionModel.fromEntity(transaction);
        final newTransaction =
            await remoteDataSource.addTransaction(transactionModel);
        return Right(newTransaction);
      } catch (e) {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Transaction>> updateTransaction(
      Transaction transaction) async {
    if (await networkInfo.isConnected) {
      try {
        final transactionModel = TransactionModel.fromEntity(transaction);
        final updatedTransaction =
            await remoteDataSource.updateTransaction(transactionModel);
        return Right(updatedTransaction);
      } catch (e) {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteTransaction(id);
        return const Right(null);
      } catch (e) {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, double>> getTotalByType(TransactionType type,
      {String? userId, DateTime? start, DateTime? end}) async {
    if (await networkInfo.isConnected) {
      try {
        final total = await remoteDataSource.getTotalByType(type,
            userId: userId, start: start, end: end);
        return Right(total);
      } catch (e) {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
