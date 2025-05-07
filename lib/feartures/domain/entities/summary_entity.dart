import 'package:equatable/equatable.dart';

class SummaryEntity extends Equatable {
  final double totalExpenses;
  final double totalIncome;
  final double balance; // Số dư (thu - chi)
  final DateTime periodStart; // Thời điểm bắt đầu kỳ báo cáo
  final DateTime periodEnd; // Thời điểm kết thúc kỳ báo cáo

  const SummaryEntity({
    required this.totalExpenses,
    required this.totalIncome,
    required this.balance,
    required this.periodStart,
    required this.periodEnd,
  });

  @override
  List<Object> get props => [
    totalExpenses,
    totalIncome,
    balance,
    periodStart,
    periodEnd,
  ];
}
