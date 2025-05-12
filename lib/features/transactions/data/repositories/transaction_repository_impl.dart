import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_datasource.dart';
import '../datasources/transaction_local_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final TransactionLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions(
      {String? userId}) async {
    try {
      // Offline-first: Luôn lấy dữ liệu từ local trước
      final transactionModels =
          await localDataSource.getTransactions(userId: userId);

      // Đồng bộ với remote trong nền nếu có kết nối
      _syncTransactionsWithRemoteIfConnected(userId);

      // Chuyển đổi từ model sang entity
      final transactions = transactionModels
          .map((model) => Transaction(
                id: model.id,
                amount: model.amount,
                date: model.date,
                categoryId: model.categoryId,
                note: model.note,
                type: model.type,
                userId: model.userId,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt,
                vatAmount: model.vatAmount,
                vatRate: model.vatRate,
                includeVat: model.includeVat,
                paymentMethod: model.paymentMethod,
              ))
          .toList();

      return Right(transactions);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  // Đồng bộ giao dịch với remote trong nền
  Future<void> _syncTransactionsWithRemoteIfConnected(String? userId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTransactions =
            await remoteDataSource.getTransactions(userId: userId);
        await localDataSource.cacheTransactions(remoteTransactions);
      } catch (e) {
        // Xử lý lỗi đồng bộ trong nền, không ảnh hưởng đến user flow
        print('Lỗi đồng bộ giao dịch với remote: $e');
      }
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(
      String categoryId,
      {String? userId}) async {
    try {
      // Offline-first: Luôn lấy dữ liệu từ local trước
      final transactionModels = await localDataSource
          .getTransactionsByCategory(categoryId, userId: userId);

      // Đồng bộ với remote trong nền
      _syncTransactionsByCategoryWithRemoteIfConnected(categoryId, userId);

      // Chuyển đổi từ model sang entity
      final transactions = transactionModels
          .map((model) => Transaction(
                id: model.id,
                amount: model.amount,
                date: model.date,
                categoryId: model.categoryId,
                note: model.note,
                type: model.type,
                userId: model.userId,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt,
                vatAmount: model.vatAmount,
                vatRate: model.vatRate,
                includeVat: model.includeVat,
                paymentMethod: model.paymentMethod,
              ))
          .toList();

      return Right(transactions);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  // Đồng bộ giao dịch theo danh mục với remote trong nền
  Future<void> _syncTransactionsByCategoryWithRemoteIfConnected(
      String categoryId, String? userId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTransactions = await remoteDataSource
            .getTransactionsByCategory(categoryId, userId: userId);
        await localDataSource.cacheTransactions(remoteTransactions);
      } catch (e) {
        // Xử lý lỗi đồng bộ trong nền
        print('Lỗi đồng bộ giao dịch theo danh mục với remote: $e');
      }
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(
      DateTime start, DateTime end,
      {String? userId}) async {
    try {
      // Offline-first: Luôn lấy dữ liệu từ local trước
      final transactionModels = await localDataSource
          .getTransactionsByDateRange(start, end, userId: userId);

      // Đồng bộ với remote trong nền
      _syncTransactionsByDateRangeWithRemoteIfConnected(start, end, userId);

      // Chuyển đổi từ model sang entity
      final transactions = transactionModels
          .map((model) => Transaction(
                id: model.id,
                amount: model.amount,
                date: model.date,
                categoryId: model.categoryId,
                note: model.note,
                type: model.type,
                userId: model.userId,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt,
                vatAmount: model.vatAmount,
                vatRate: model.vatRate,
                includeVat: model.includeVat,
                paymentMethod: model.paymentMethod,
              ))
          .toList();

      return Right(transactions);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  // Đồng bộ giao dịch theo khoảng thời gian với remote trong nền
  Future<void> _syncTransactionsByDateRangeWithRemoteIfConnected(
      DateTime start, DateTime end, String? userId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTransactions = await remoteDataSource
            .getTransactionsByDateRange(start, end, userId: userId);
        await localDataSource.cacheTransactions(remoteTransactions);
      } catch (e) {
        // Xử lý lỗi đồng bộ trong nền
        print('Lỗi đồng bộ giao dịch theo khoảng thời gian với remote: $e');
      }
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById(String id) async {
    try {
      // Offline-first: Luôn lấy dữ liệu từ local trước
      TransactionModel transactionModel;

      try {
        transactionModel = await localDataSource.getTransactionById(id);
      } catch (e) {
        // Nếu không tìm thấy trong local, thử lấy từ remote
        if (await networkInfo.isConnected) {
          transactionModel = await remoteDataSource.getTransactionById(id);
          // Cache lại vào local
          await localDataSource.addTransaction(transactionModel);
        } else {
          return const Left(ServerFailure());
        }
      }

      // Chuyển đổi sang entity
      final transaction = Transaction(
        id: transactionModel.id,
        amount: transactionModel.amount,
        date: transactionModel.date,
        categoryId: transactionModel.categoryId,
        note: transactionModel.note,
        type: transactionModel.type,
        userId: transactionModel.userId,
        createdAt: transactionModel.createdAt,
        updatedAt: transactionModel.updatedAt,
        vatAmount: transactionModel.vatAmount,
        vatRate: transactionModel.vatRate,
        includeVat: transactionModel.includeVat,
        paymentMethod: transactionModel.paymentMethod,
      );

      return Right(transaction);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Transaction>> addTransaction(
      Transaction transaction) async {
    try {
      // Chuyển đổi từ entity sang model
      final transactionModel = TransactionModel.fromEntity(transaction);

      // Offline-first: Luôn thêm vào local trước
      await localDataSource.addTransaction(transactionModel);

      // Đồng bộ với remote trong nền
      _syncAddedTransactionWithRemote(transactionModel);

      // Trả về transaction entity
      return Right(transaction);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  // Đồng bộ giao dịch mới thêm với remote
  Future<void> _syncAddedTransactionWithRemote(
      TransactionModel transaction) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addTransaction(transaction);
      } catch (e) {
        // Xử lý lỗi đồng bộ trong nền
        print('Lỗi đồng bộ giao dịch mới với remote: $e');
      }
    }
  }

  @override
  Future<Either<Failure, Transaction>> updateTransaction(
      Transaction transaction) async {
    try {
      // Chuyển đổi từ entity sang model
      final transactionModel = TransactionModel.fromEntity(transaction);

      // Offline-first: Luôn cập nhật local trước
      await localDataSource.updateTransaction(transactionModel);

      // Đồng bộ với remote trong nền
      _syncUpdatedTransactionWithRemote(transactionModel);

      // Trả về transaction entity
      return Right(transaction);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  // Đồng bộ giao dịch đã cập nhật với remote
  Future<void> _syncUpdatedTransactionWithRemote(
      TransactionModel transaction) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateTransaction(transaction);
      } catch (e) {
        // Xử lý lỗi đồng bộ trong nền
        print('Lỗi đồng bộ giao dịch đã cập nhật với remote: $e');
      }
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      // Offline-first: Luôn xóa từ local trước
      await localDataSource.deleteTransaction(id);

      // Đồng bộ với remote trong nền
      _syncDeletedTransactionWithRemote(id);

      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  // Đồng bộ việc xóa giao dịch với remote
  Future<void> _syncDeletedTransactionWithRemote(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteTransaction(id);
      } catch (e) {
        // Xử lý lỗi đồng bộ trong nền
        print('Lỗi đồng bộ việc xóa giao dịch với remote: $e');
      }
    }
  }

  @override
  Future<Either<Failure, double>> getTotalByType(TransactionType type,
      {String? userId, DateTime? start, DateTime? end}) async {
    try {
      // Offline-first: Luôn lấy dữ liệu từ local trước
      final total = await localDataSource.getTotalByType(type,
          userId: userId, start: start, end: end);

      // Đồng bộ dữ liệu trong nền để đảm bảo tính chính xác
      if (userId != null) {
        _syncTransactionsWithRemoteIfConnected(userId);
      }

      return Right(total);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
