import 'package:hive/hive.dart';
import '../../../../core/enums/transaction_type.dart';
import '../models/transaction_model.dart';
import '../models/transaction_hive_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getTransactions({String? userId});
  Future<List<TransactionModel>> getTransactionsByCategory(String categoryId,
      {String? userId});
  Future<List<TransactionModel>> getTransactionsByDateRange(
      DateTime start, DateTime end,
      {String? userId});
  Future<TransactionModel> getTransactionById(String id);
  Future<TransactionModel> addTransaction(TransactionModel transaction);
  Future<TransactionModel> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<double> getTotalByType(TransactionType type,
      {String? userId, DateTime? start, DateTime? end});
  Future<void> cacheTransactions(List<TransactionModel> transactions);
  Future<void> clearCache();
}

class HiveTransactionLocalDataSource implements TransactionLocalDataSource {
  final Box transactionsBox;

  HiveTransactionLocalDataSource({required this.transactionsBox});

  @override
  Future<List<TransactionModel>> getTransactions({String? userId}) async {
    try {
      final transactionEntries = transactionsBox.values.where((model) {
        if (model is TransactionHiveModel) {
          return userId == null || model.userId == userId;
        }
        return false;
      }).toList();

      final transactions = transactionEntries.map((model) {
        final transaction = (model as TransactionHiveModel).toEntity();
        return TransactionModel.fromEntity(transaction);
      }).toList();

      return transactions;
    } catch (e) {
      throw Exception('Không thể lấy danh sách giao dịch từ local storage: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByCategory(String categoryId,
      {String? userId}) async {
    try {
      final transactionEntries = transactionsBox.values.where((model) {
        if (model is TransactionHiveModel) {
          bool matchesCategory = model.categoryId == categoryId;
          bool matchesUser = userId == null || model.userId == userId;
          return matchesCategory && matchesUser;
        }
        return false;
      }).toList();

      final transactions = transactionEntries.map((model) {
        final transaction = (model as TransactionHiveModel).toEntity();
        return TransactionModel.fromEntity(transaction);
      }).toList();

      return transactions;
    } catch (e) {
      throw Exception(
          'Không thể lấy giao dịch theo danh mục từ local storage: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(
      DateTime start, DateTime end,
      {String? userId}) async {
    try {
      final transactionEntries = transactionsBox.values.where((model) {
        if (model is TransactionHiveModel) {
          bool matchesUser = userId == null || model.userId == userId;
          bool matchesDateRange =
              model.date.isAfter(start.subtract(const Duration(days: 1))) &&
                  model.date.isBefore(end.add(const Duration(days: 1)));
          return matchesUser && matchesDateRange;
        }
        return false;
      }).toList();

      final transactions = transactionEntries.map((model) {
        final transaction = (model as TransactionHiveModel).toEntity();
        return TransactionModel.fromEntity(transaction);
      }).toList();

      return transactions;
    } catch (e) {
      throw Exception(
          'Không thể lấy giao dịch theo khoảng thời gian từ local storage: $e');
    }
  }

  @override
  Future<TransactionModel> getTransactionById(String id) async {
    try {
      final model = transactionsBox.get(id);

      if (model == null) {
        throw Exception('Không tìm thấy giao dịch');
      }

      final transaction = (model as TransactionHiveModel).toEntity();
      return TransactionModel.fromEntity(transaction);
    } catch (e) {
      throw Exception('Không thể lấy giao dịch theo ID từ local storage: $e');
    }
  }

  @override
  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    try {
      final hiveModel = TransactionHiveModel.fromEntity(transaction);

      await transactionsBox.put(transaction.id, hiveModel);

      return transaction;
    } catch (e) {
      throw Exception('Không thể thêm giao dịch vào local storage: $e');
    }
  }

  @override
  Future<TransactionModel> updateTransaction(
      TransactionModel transaction) async {
    try {
      final hiveModel = TransactionHiveModel.fromEntity(transaction);

      await transactionsBox.put(transaction.id, hiveModel);

      return transaction;
    } catch (e) {
      throw Exception('Không thể cập nhật giao dịch trong local storage: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await transactionsBox.delete(id);
    } catch (e) {
      throw Exception('Không thể xóa giao dịch từ local storage: $e');
    }
  }

  @override
  Future<double> getTotalByType(TransactionType type,
      {String? userId, DateTime? start, DateTime? end}) async {
    try {
      final transactionEntries = transactionsBox.values.where((model) {
        if (model is TransactionHiveModel) {
          bool matchesType = TransactionType.values.byName(model.type) == type;
          bool matchesUser = userId == null || model.userId == userId;
          bool matchesDateRange = true;

          if (start != null && end != null) {
            matchesDateRange =
                model.date.isAfter(start.subtract(const Duration(days: 1))) &&
                    model.date.isBefore(end.add(const Duration(days: 1)));
          }

          return matchesType && matchesUser && matchesDateRange;
        }
        return false;
      }).toList();

      double total = 0;

      for (var model in transactionEntries) {
        final transactionHive = model as TransactionHiveModel;
        total += transactionHive.amount;
      }

      return total;
    } catch (e) {
      throw Exception('Không thể tính tổng theo loại từ local storage: $e');
    }
  }

  @override
  Future<void> cacheTransactions(List<TransactionModel> transactions) async {
    try {
      for (var transaction in transactions) {
        final hiveModel = TransactionHiveModel.fromEntity(transaction);
        await transactionsBox.put(transaction.id, hiveModel);
      }
    } catch (e) {
      throw Exception('Không thể cache danh sách giao dịch: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await transactionsBox.clear();
    } catch (e) {
      throw Exception('Không thể xóa cache giao dịch: $e');
    }
  }
}
