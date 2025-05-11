import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/enums/transaction_type.dart';
import '../models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
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
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore firestore;

  TransactionRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<TransactionModel>> getTransactions({String? userId}) async {
    try {
      Query query = firestore.collection('transactions');

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) =>
              TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByCategory(String categoryId,
      {String? userId}) async {
    try {
      Query query = firestore
          .collection('transactions')
          .where('categoryId', isEqualTo: categoryId);

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) =>
              TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching transactions by category: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(
      DateTime start, DateTime end,
      {String? userId}) async {
    try {
      Query query = firestore
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end));

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) =>
              TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching transactions by date range: $e');
    }
  }

  @override
  Future<TransactionModel> getTransactionById(String id) async {
    try {
      final docSnapshot =
          await firestore.collection('transactions').doc(id).get();

      if (!docSnapshot.exists) {
        throw Exception('Transaction not found');
      }

      return TransactionModel.fromJson(
          docSnapshot.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error fetching transaction by id: $e');
    }
  }

  @override
  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    try {
      await firestore
          .collection('transactions')
          .doc(transaction.id)
          .set(transaction.toJson());

      return transaction;
    } catch (e) {
      throw Exception('Error adding transaction: $e');
    }
  }

  @override
  Future<TransactionModel> updateTransaction(
      TransactionModel transaction) async {
    try {
      await firestore
          .collection('transactions')
          .doc(transaction.id)
          .update(transaction.toJson());

      return transaction;
    } catch (e) {
      throw Exception('Error updating transaction: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await firestore.collection('transactions').doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting transaction: $e');
    }
  }

  @override
  Future<double> getTotalByType(TransactionType type,
      {String? userId, DateTime? start, DateTime? end}) async {
    try {
      Query query = firestore
          .collection('transactions')
          .where('type', isEqualTo: type.name);

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      if (start != null && end != null) {
        query = query
            .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
            .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end));
      }

      final querySnapshot = await query.get();

      double total = 0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final amount = data['amount'] is int
            ? (data['amount'] as int).toDouble()
            : data['amount'] as double;
        total += amount;
      }

      return total;
    } catch (e) {
      throw Exception('Error calculating total by type: $e');
    }
  }
}
