import 'package:equatable/equatable.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../domain/entities/transaction.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class GetTransactionsEvent extends TransactionEvent {
  final String? userId;

  const GetTransactionsEvent({this.userId});

  @override
  List<Object?> get props => [userId];
}

class GetTransactionsByDateRangeEvent extends TransactionEvent {
  final DateTime start;
  final DateTime end;
  final String? userId;

  const GetTransactionsByDateRangeEvent({
    required this.start,
    required this.end,
    this.userId,
  });

  @override
  List<Object?> get props => [start, end, userId];
}

class GetTransactionsByCategoryEvent extends TransactionEvent {
  final String categoryId;
  final String? userId;

  const GetTransactionsByCategoryEvent({
    required this.categoryId,
    this.userId,
  });

  @override
  List<Object?> get props => [categoryId, userId];
}

class GetTransactionByIdEvent extends TransactionEvent {
  final String id;

  const GetTransactionByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class AddTransactionEvent extends TransactionEvent {
  final Transaction transaction;

  const AddTransactionEvent({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class UpdateTransactionEvent extends TransactionEvent {
  final Transaction transaction;

  const UpdateTransactionEvent({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class DeleteTransactionEvent extends TransactionEvent {
  final String id;

  const DeleteTransactionEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class GetTotalByTypeEvent extends TransactionEvent {
  final TransactionType type;
  final String? userId;
  final DateTime? startDate;
  final DateTime? endDate;

  const GetTotalByTypeEvent({
    required this.type,
    this.userId,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [type, userId, startDate, endDate];
}
