import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/transaction.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionsLoaded extends TransactionState {
  final List<Transaction> transactions;

  const TransactionsLoaded({required this.transactions});

  @override
  List<Object> get props => [transactions];
}

class TransactionLoaded extends TransactionState {
  final Transaction transaction;

  const TransactionLoaded({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class TransactionOperationSuccess extends TransactionState {
  final String message;
  final Transaction? transaction;

  const TransactionOperationSuccess({
    required this.message,
    this.transaction,
  });

  @override
  List<Object?> get props => [message, transaction];
}

class TransactionFailure extends TransactionState {
  final Failure failure;

  const TransactionFailure({required this.failure});

  String get message {
    if (failure is ServerFailure) {
      return 'Lỗi server';
    } else if (failure is NetworkFailure) {
      return 'Lỗi kết nối mạng';
    } else if (failure is ValidationFailure) {
      return (failure as ValidationFailure).message;
    } else {
      return 'Lỗi không xác định';
    }
  }

  @override
  List<Object> get props => [failure];
}

class TotalAmountLoaded extends TransactionState {
  final double total;

  const TotalAmountLoaded({required this.total});

  @override
  List<Object> get props => [total];
}
