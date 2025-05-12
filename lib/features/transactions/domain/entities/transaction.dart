import 'package:equatable/equatable.dart';
import '../../../../core/enums/transaction_type.dart';

// Thêm enum PaymentMethod
enum PaymentMethod {
  cash,
  bankTransfer,
  card,
  momo,
  zalopay,
  other,
}

class Transaction extends Equatable {
  final String id;
  final double amount;
  final DateTime date;
  final String categoryId;
  final String note;
  final TransactionType type;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? vatAmount;
  final double? vatRate;
  final bool includeVat;
  final PaymentMethod paymentMethod;

  const Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.categoryId,
    required this.type,
    this.note = '',
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.vatAmount,
    this.vatRate,
    this.includeVat = false,
    this.paymentMethod = PaymentMethod.cash,
  });

  // Tính toán số tiền trước thuế
  double get amountBeforeVat =>
      includeVat ? (amount / (1 + (vatRate ?? 0) / 100)) : amount;

  // Tính toán số tiền sau thuế
  double get amountAfterVat =>
      includeVat ? amount : (amount + (vatAmount ?? 0));

  // Tính toán số tiền VAT nếu chưa nhập trực tiếp
  double get calculatedVatAmount =>
      vatAmount ?? (vatRate != null ? amountBeforeVat * vatRate! / 100 : 0);

  @override
  List<Object?> get props => [
        id,
        amount,
        date,
        categoryId,
        note,
        type,
        userId,
        createdAt,
        updatedAt,
        vatAmount,
        vatRate,
        includeVat,
        paymentMethod,
      ];
}
