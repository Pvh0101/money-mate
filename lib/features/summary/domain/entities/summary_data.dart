import 'package:equatable/equatable.dart';
import 'package:money_mate/core/enums/transaction_type.dart';

/// Entity đại diện cho dữ liệu thống kê tổng hợp chi tiêu và thu nhập
class SummaryData extends Equatable {
  /// Khoảng thời gian bắt đầu của thống kê
  final DateTime startDate;

  /// Khoảng thời gian kết thúc của thống kê
  final DateTime endDate;

  /// Tổng số tiền chi tiêu trong khoảng thời gian
  final double totalExpense;

  /// Tổng số tiền thu nhập trong khoảng thời gian
  final double totalIncome;

  /// Phân bổ chi tiêu theo danh mục (Map với key là categoryId, value là số tiền)
  final Map<String, double> expenseByCategory;

  /// Phân bổ thu nhập theo danh mục (Map với key là categoryId, value là số tiền)
  final Map<String, double> incomeByCategory;

  /// Dữ liệu chi tiêu theo ngày (Map với key là ngày, value là số tiền)
  final Map<DateTime, double> expenseByDate;

  /// Dữ liệu thu nhập theo ngày (Map với key là ngày, value là số tiền)
  final Map<DateTime, double> incomeByDate;

  const SummaryData({
    required this.startDate,
    required this.endDate,
    required this.totalExpense,
    required this.totalIncome,
    required this.expenseByCategory,
    required this.incomeByCategory,
    required this.expenseByDate,
    required this.incomeByDate,
  });

  /// Tính số dư (thu - chi)
  double get balance => totalIncome - totalExpense;

  /// Tổng tiền theo loại (thu hoặc chi)
  double getTotalByType(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return totalIncome;
      case TransactionType.expense:
        return totalExpense;
    }
  }

  /// Phân bổ tiền theo danh mục dựa vào loại giao dịch
  Map<String, double> getCategoryDistributionByType(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return incomeByCategory;
      case TransactionType.expense:
        return expenseByCategory;
    }
  }

  /// Dữ liệu theo ngày dựa vào loại giao dịch
  Map<DateTime, double> getDateDistributionByType(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return incomeByDate;
      case TransactionType.expense:
        return expenseByDate;
    }
  }

  /// Tạo SummaryData trống
  factory SummaryData.empty() {
    final now = DateTime.now();
    return SummaryData(
      startDate: now,
      endDate: now,
      totalExpense: 0,
      totalIncome: 0,
      expenseByCategory: const {},
      incomeByCategory: const {},
      expenseByDate: const {},
      incomeByDate: const {},
    );
  }

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        totalExpense,
        totalIncome,
        expenseByCategory,
        incomeByCategory,
        expenseByDate,
        incomeByDate,
      ];
}
