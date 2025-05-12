import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../domain/entities/time_range.dart';
import '../models/summary_data_model.dart';

abstract class SummaryRemoteDataSource {
  /// Lấy dữ liệu thống kê theo khoảng thời gian
  Future<SummaryDataModel> getSummaryByTimeRange(
    TimeRange timeRange, {
    String? userId,
    DateTime? referenceDate,
  });

  /// Lấy dữ liệu thống kê theo khoảng thời gian tùy chỉnh
  Future<SummaryDataModel> getSummaryByDateRange(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  });
}

class SummaryRemoteDataSourceImpl implements SummaryRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  SummaryRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  // Phương thức chung để tính toán dữ liệu thống kê từ danh sách giao dịch
  Future<SummaryDataModel> _calculateSummaryFromTransactions(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  }) async {
    try {
      // Xác định userId nhưng không bắt buộc
      final String uid = userId ?? firebaseAuth.currentUser?.uid ?? '';

      // Query giao dịch trong khoảng thời gian
      var query = firestore
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));

      // Thêm filter userId nếu có
      if (uid.isNotEmpty) {
        query = query.where('userId', isEqualTo: uid);
      }

      final transactionsSnapshot = await query.get();

      // Khởi tạo các giá trị thống kê
      double totalExpense = 0;
      double totalIncome = 0;
      Map<String, double> expenseByCategory = {};
      Map<String, double> incomeByCategory = {};
      Map<DateTime, double> expenseByDate = {};
      Map<DateTime, double> incomeByDate = {};

      // Tính toán thống kê từ danh sách giao dịch
      for (var doc in transactionsSnapshot.docs) {
        final data = doc.data();
        final amount = (data['amount'] as num).toDouble();
        final type =
            data['type'] == 'income'
                ? TransactionType.income
                : TransactionType.expense;
        final categoryId = data['categoryId'] as String;
        final date = (data['date'] as Timestamp).toDate();
        // Chuẩn hóa ngày (chỉ lấy ngày, tháng, năm - loại bỏ giờ phút giây)
        final normalizedDate = DateTime(date.year, date.month, date.day);

        if (type == TransactionType.expense) {
          // Cập nhật tổng chi tiêu
          totalExpense += amount;
          // Cập nhật chi tiêu theo danh mục
          expenseByCategory[categoryId] =
              (expenseByCategory[categoryId] ?? 0) + amount;
          // Cập nhật chi tiêu theo ngày
          expenseByDate[normalizedDate] =
              (expenseByDate[normalizedDate] ?? 0) + amount;
        } else {
          // Cập nhật tổng thu nhập
          totalIncome += amount;
          // Cập nhật thu nhập theo danh mục
          incomeByCategory[categoryId] =
              (incomeByCategory[categoryId] ?? 0) + amount;
          // Cập nhật thu nhập theo ngày
          incomeByDate[normalizedDate] =
              (incomeByDate[normalizedDate] ?? 0) + amount;
        }
      }

      // Tạo và trả về model summary data
      return SummaryDataModel(
        startDate: startDate,
        endDate: endDate,
        totalExpense: totalExpense,
        totalIncome: totalIncome,
        expenseByCategory: expenseByCategory,
        incomeByCategory: incomeByCategory,
        expenseByDate: expenseByDate,
        incomeByDate: incomeByDate,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<SummaryDataModel> getSummaryByTimeRange(
    TimeRange timeRange, {
    String? userId,
    DateTime? referenceDate,
  }) async {
    final startDate = timeRange.getStartDate(referenceDate);
    final endDate = timeRange.getEndDate(referenceDate);
    return _calculateSummaryFromTransactions(
      startDate,
      endDate,
      userId: userId,
    );
  }

  @override
  Future<SummaryDataModel> getSummaryByDateRange(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  }) async {
    return _calculateSummaryFromTransactions(
      startDate,
      endDate,
      userId: userId,
    );
  }
}
