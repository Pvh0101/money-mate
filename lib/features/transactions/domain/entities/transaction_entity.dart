import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String id;
  final String title;
  final String? note;
  final double amount;
  final DateTime date;
  final String categoryId;
  final String type; // "income", "expense"
  final String paymentMethod; // "Google Pay", "Cash", "Paytm"
  final double vat; // Phần trăm VAT

  const TransactionEntity({
    required this.id,
    required this.title,
    this.note,
    required this.amount,
    required this.date,
    required this.categoryId,
    required this.type,
    required this.paymentMethod,
    required this.vat,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    note,
    amount,
    date,
    categoryId,
    type,
    paymentMethod,
    vat,
  ];
}
