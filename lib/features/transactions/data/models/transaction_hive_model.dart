import 'package:hive/hive.dart';
import 'package:money_mate/core/enums/transaction_type.dart';
import 'package:money_mate/features/transactions/domain/entities/transaction.dart';

part 'transaction_hive_model.g.dart';

@HiveType(typeId: 1)
class TransactionHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String categoryId;

  @HiveField(4)
  final String note;

  @HiveField(5)
  final String type; // Lưu dưới dạng string vì enum không được hỗ trợ trực tiếp

  @HiveField(6)
  final String userId;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime updatedAt;

  @HiveField(9)
  final bool includeVat;

  @HiveField(10)
  final String paymentMethod; // Lưu dưới dạng string

  @HiveField(11)
  final double? vatAmount;

  @HiveField(12)
  final double? vatRate;

  TransactionHiveModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.categoryId,
    required this.note,
    required this.type,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.includeVat,
    required this.paymentMethod,
    this.vatAmount,
    this.vatRate,
  });

  // Từ domain entity sang Hive model
  factory TransactionHiveModel.fromEntity(Transaction transaction) {
    return TransactionHiveModel(
      id: transaction.id,
      amount: transaction.amount,
      date: transaction.date,
      categoryId: transaction.categoryId,
      note: transaction.note,
      type: transaction.type.name,
      userId: transaction.userId,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
      includeVat: transaction.includeVat,
      paymentMethod: transaction.paymentMethod.name,
      vatAmount: transaction.vatAmount,
      vatRate: transaction.vatRate,
    );
  }

  // Từ Hive model sang domain entity
  Transaction toEntity() {
    return Transaction(
      id: id,
      amount: amount,
      date: date,
      categoryId: categoryId,
      note: note,
      type: TransactionType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => TransactionType.expense,
      ),
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      includeVat: includeVat,
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == paymentMethod,
        orElse: () => PaymentMethod.cash,
      ),
      vatAmount: vatAmount,
      vatRate: vatRate,
    );
  }
}
