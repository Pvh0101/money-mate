import 'package:hive/hive.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/hive_config.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../../transactions/data/datasources/transaction_local_datasource.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/data/models/transaction_model.dart';
import '../../domain/entities/time_range.dart';
import '../models/summary_data_model.dart';
import '../models/summary_hive_model.dart';

abstract class SummaryLocalDataSource {
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

  /// Lưu dữ liệu thống kê vào local storage
  Future<void> cacheSummary(SummaryDataModel summary);

  /// Xóa tất cả dữ liệu thống kê
  Future<void> clearSummaries();
}

class HiveSummaryLocalDataSource implements SummaryLocalDataSource {
  final TransactionLocalDataSource transactionLocalDataSource;
  final Box summaryBox;

  HiveSummaryLocalDataSource({
    required this.transactionLocalDataSource,
    required this.summaryBox,
  });

  @override
  Future<void> cacheSummary(SummaryDataModel summary) async {
    try {
      final summaryHive = SummaryHiveModel.fromEntity(summary);
      final id = SummaryHiveModel.createId(summary.startDate, summary.endDate);

      await summaryBox.put(id, summaryHive);
      print('SummaryLocalDataSource: Cached summary with ID: $id');
    } catch (e) {
      print('SummaryLocalDataSource: Error caching summary: ${e.toString()}');
      throw CacheException('Không thể lưu dữ liệu thống kê: ${e.toString()}');
    }
  }

  @override
  Future<void> clearSummaries() async {
    try {
      await summaryBox.clear();
      print('SummaryLocalDataSource: Cleared all summaries');
    } catch (e) {
      print(
          'SummaryLocalDataSource: Error clearing summaries: ${e.toString()}');
      // Xử lý lỗi nhưng không ném ngoại lệ nữa
      // Chỉ ghi log để theo dõi
    }
  }

  @override
  Future<SummaryDataModel> getSummaryByDateRange(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  }) async {
    try {
      final id = SummaryHiveModel.createId(startDate, endDate);
      print(
          'SummaryLocalDataSource: Getting summary by date range with ID: $id');

      // Kiểm tra cache
      final cachedSummary = summaryBox.get(id);
      if (cachedSummary != null && cachedSummary is SummaryHiveModel) {
        print('SummaryLocalDataSource: Found cached summary with ID: $id');
        final summary = cachedSummary.toEntity();
        return SummaryDataModel(
          startDate: summary.startDate,
          endDate: summary.endDate,
          totalExpense: summary.totalExpense,
          totalIncome: summary.totalIncome,
          expenseByCategory: summary.expenseByCategory,
          incomeByCategory: summary.incomeByCategory,
          expenseByDate: summary.expenseByDate,
          incomeByDate: summary.incomeByDate,
        );
      }

      print(
          'SummaryLocalDataSource: No cached summary found with ID: $id, calculating from transactions');

      // Nếu không có trong cache, tính toán từ giao dịch local
      try {
        return await _calculateSummaryFromTransactions(startDate, endDate,
            userId: userId);
      } catch (e) {
        print(
            'SummaryLocalDataSource: Error calculating summary: ${e.toString()}');
        // Thay vì ném lỗi, trả về SummaryDataModel trống
        return SummaryDataModel(
          startDate: startDate,
          endDate: endDate,
          totalExpense: 0,
          totalIncome: 0,
          expenseByCategory: {},
          incomeByCategory: {},
          expenseByDate: {},
          incomeByDate: {},
        );
      }
    } catch (e) {
      print(
          'SummaryLocalDataSource: Error getting summary by date range: ${e.toString()}');
      // Thay vì ném lỗi, trả về SummaryDataModel trống
      return SummaryDataModel(
        startDate: startDate,
        endDate: endDate,
        totalExpense: 0,
        totalIncome: 0,
        expenseByCategory: {},
        incomeByCategory: {},
        expenseByDate: {},
        incomeByDate: {},
      );
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
    print(
        'SummaryLocalDataSource: Getting summary for time range: ${timeRange.name}, startDate: $startDate, endDate: $endDate');
    return getSummaryByDateRange(startDate, endDate, userId: userId);
  }

  // Phương thức để tính toán thống kê từ các giao dịch trong Hive
  Future<SummaryDataModel> _calculateSummaryFromTransactions(
    DateTime startDate,
    DateTime endDate, {
    String? userId,
  }) async {
    try {
      print(
          'SummaryLocalDataSource: Calculating summary from transactions for date range: $startDate to $endDate');

      // Sử dụng getTransactionsByDateRange thay vì getTransactions để tối ưu hiệu suất
      final transactions = await transactionLocalDataSource
          .getTransactionsByDateRange(startDate, endDate, userId: userId);

      print(
          'SummaryLocalDataSource: Transactions in date range: ${transactions.length}');

      // Debug print transactions
      for (var tx in transactions) {
        print(
            'SummaryLocalDataSource: Transaction: ${tx.id}, date: ${tx.date}, amount: ${tx.amount}, type: ${tx.type}');
      }

      // Tính toán thống kê
      double totalExpense = 0;
      double totalIncome = 0;
      Map<String, double> expenseByCategory = {};
      Map<String, double> incomeByCategory = {};
      Map<DateTime, double> expenseByDate = {};
      Map<DateTime, double> incomeByDate = {};

      for (var transaction in transactions) {
        final amount = transaction.amount;
        final type = transaction.type;
        final categoryId = transaction.categoryId;
        // Chuẩn hóa ngày (chỉ lấy ngày, tháng, năm - loại bỏ giờ phút giây)
        final normalizedDate = DateTime(transaction.date.year,
            transaction.date.month, transaction.date.day);

        print(
            'SummaryLocalDataSource: Processing transaction: ${transaction.id}, type: ${type.name}, amount: $amount, categoryId: $categoryId');

        if (type == TransactionType.expense) {
          // Cập nhật tổng chi tiêu
          totalExpense += amount;
          // Cập nhật chi tiêu theo danh mục
          expenseByCategory[categoryId] =
              (expenseByCategory[categoryId] ?? 0) + amount;
          // Cập nhật chi tiêu theo ngày
          expenseByDate[normalizedDate] =
              (expenseByDate[normalizedDate] ?? 0) + amount;

          print(
              'SummaryLocalDataSource: Added $amount to expense, new total: $totalExpense');
        } else if (type == TransactionType.income) {
          // Cập nhật tổng thu nhập
          totalIncome += amount;
          // Cập nhật thu nhập theo danh mục
          incomeByCategory[categoryId] =
              (incomeByCategory[categoryId] ?? 0) + amount;
          // Cập nhật thu nhập theo ngày
          incomeByDate[normalizedDate] =
              (incomeByDate[normalizedDate] ?? 0) + amount;

          print(
              'SummaryLocalDataSource: Added $amount to income, new total: $totalIncome');
        } else {
          print(
              'SummaryLocalDataSource: Unknown transaction type: ${type.name}');
        }
      }

      print(
          'SummaryLocalDataSource: Calculation results: totalIncome=$totalIncome, totalExpense=$totalExpense');
      print('SummaryLocalDataSource: ExpenseByCategory: $expenseByCategory');
      print('SummaryLocalDataSource: IncomeByCategory: $incomeByCategory');

      // Tạo model summary data
      final summary = SummaryDataModel(
        startDate: startDate,
        endDate: endDate,
        totalExpense: totalExpense,
        totalIncome: totalIncome,
        expenseByCategory: expenseByCategory,
        incomeByCategory: incomeByCategory,
        expenseByDate: expenseByDate,
        incomeByDate: incomeByDate,
      );

      // Cache lại kết quả
      await cacheSummary(summary);

      return summary;
    } catch (e) {
      print(
          'SummaryLocalDataSource: Error calculating summary: ${e.toString()}');
      throw CacheException('Không thể tính toán thống kê: ${e.toString()}');
    }
  }
}
