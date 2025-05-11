import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import '../../../../core/enums/transaction_type.dart';
import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required String id,
    required double amount,
    required DateTime date,
    required String categoryId,
    required TransactionType type,
    String note = '',
    required String userId,
    required DateTime createdAt,
    required DateTime updatedAt,
    double? vatAmount,
    double? vatRate,
    bool includeVat = false,
  }) : super(
          id: id,
          amount: amount,
          date: date,
          categoryId: categoryId,
          note: note,
          type: type,
          userId: userId,
          createdAt: createdAt,
          updatedAt: updatedAt,
          vatAmount: vatAmount,
          vatRate: vatRate,
          includeVat: includeVat,
        );

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: json['amount'] is int
          ? (json['amount'] as int).toDouble()
          : json['amount'],
      date: (json['date'] as Timestamp).toDate(),
      categoryId: json['categoryId'],
      note: json['note'] ?? '',
      type: TransactionType.values.byName(json['type']),
      userId: json['userId'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      vatAmount: json['vatAmount'] != null
          ? (json['vatAmount'] is int
              ? (json['vatAmount'] as int).toDouble()
              : json['vatAmount'])
          : null,
      vatRate: json['vatRate'] != null
          ? (json['vatRate'] is int
              ? (json['vatRate'] as int).toDouble()
              : json['vatRate'])
          : null,
      includeVat: json['includeVat'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'categoryId': categoryId,
      'note': note,
      'type': type.name,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'vatAmount': vatAmount,
      'vatRate': vatRate,
      'includeVat': includeVat,
    };
  }

  factory TransactionModel.fromEntity(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      amount: entity.amount,
      date: entity.date,
      categoryId: entity.categoryId,
      note: entity.note,
      type: entity.type,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      vatAmount: entity.vatAmount,
      vatRate: entity.vatRate,
      includeVat: entity.includeVat,
    );
  }
}
