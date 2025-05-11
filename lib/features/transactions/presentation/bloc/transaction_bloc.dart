import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/add_transaction_usecase.dart';
import '../../domain/usecases/delete_transaction_usecase.dart';
import '../../domain/usecases/get_transaction_by_id_usecase.dart';
import '../../domain/usecases/get_transactions_by_category_usecase.dart';
import '../../domain/usecases/get_transactions_by_date_range_usecase.dart';
import '../../domain/usecases/get_transactions_usecase.dart';
import '../../domain/usecases/get_total_by_type_usecase.dart';
import '../../domain/usecases/update_transaction_usecase.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactionsUseCase getTransactions;
  final GetTransactionsByDateRangeUseCase getTransactionsByDateRange;
  final GetTransactionsByCategoryUseCase getTransactionsByCategory;
  final GetTransactionByIdUseCase getTransactionById;
  final AddTransactionUseCase addTransaction;
  final UpdateTransactionUseCase updateTransaction;
  final DeleteTransactionUseCase deleteTransaction;
  final GetTotalByTypeUseCase getTotalByType;

  TransactionBloc({
    required this.getTransactions,
    required this.getTransactionsByDateRange,
    required this.getTransactionsByCategory,
    required this.getTransactionById,
    required this.addTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
    required this.getTotalByType,
  }) : super(TransactionInitial()) {
    on<GetTransactionsEvent>(_onGetTransactions);
    on<GetTransactionsByDateRangeEvent>(_onGetTransactionsByDateRange);
    on<GetTransactionsByCategoryEvent>(_onGetTransactionsByCategory);
    on<GetTransactionByIdEvent>(_onGetTransactionById);
    on<AddTransactionEvent>(_onAddTransaction);
    on<UpdateTransactionEvent>(_onUpdateTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
    on<GetTotalByTypeEvent>(_onGetTotalByType);
  }

  void _onGetTransactions(
    GetTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final result =
        await getTransactions(GetTransactionsParams(userId: event.userId));
    result.fold(
      (failure) => emit(TransactionFailure(failure: failure)),
      (transactions) => emit(TransactionsLoaded(transactions: transactions)),
    );
  }

  void _onGetTransactionsByDateRange(
    GetTransactionsByDateRangeEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final result = await getTransactionsByDateRange(DateRangeParams(
      start: event.start,
      end: event.end,
      userId: event.userId,
    ));
    result.fold(
      (failure) => emit(TransactionFailure(failure: failure)),
      (transactions) => emit(TransactionsLoaded(transactions: transactions)),
    );
  }

  void _onGetTransactionsByCategory(
    GetTransactionsByCategoryEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final result = await getTransactionsByCategory(CategoryParams(
      categoryId: event.categoryId,
      userId: event.userId,
    ));
    result.fold(
      (failure) => emit(TransactionFailure(failure: failure)),
      (transactions) => emit(TransactionsLoaded(transactions: transactions)),
    );
  }

  void _onGetTransactionById(
    GetTransactionByIdEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final result = await getTransactionById(TransactionIdParams(id: event.id));
    result.fold(
      (failure) => emit(TransactionFailure(failure: failure)),
      (transaction) => emit(TransactionLoaded(transaction: transaction)),
    );
  }

  void _onAddTransaction(
    AddTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    // Nếu transaction không có ID, tạo ID mới
    final transaction = event.transaction.id.isEmpty
        ? _createTransactionWithId(event.transaction)
        : event.transaction;

    final result = await addTransaction(transaction);
    result.fold(
      (failure) => emit(TransactionFailure(failure: failure)),
      (newTransaction) => emit(TransactionOperationSuccess(
        message: 'Thêm giao dịch thành công',
        transaction: newTransaction,
      )),
    );
  }

  void _onUpdateTransaction(
    UpdateTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final result = await updateTransaction(event.transaction);
    result.fold(
      (failure) => emit(TransactionFailure(failure: failure)),
      (updatedTransaction) => emit(TransactionOperationSuccess(
        message: 'Cập nhật giao dịch thành công',
        transaction: updatedTransaction,
      )),
    );
  }

  void _onDeleteTransaction(
    DeleteTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final result =
        await deleteTransaction(DeleteTransactionParams(id: event.id));
    result.fold(
      (failure) => emit(TransactionFailure(failure: failure)),
      (_) => emit(const TransactionOperationSuccess(
        message: 'Xóa giao dịch thành công',
      )),
    );
  }

  void _onGetTotalByType(
    GetTotalByTypeEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final result = await getTotalByType(TotalByTypeParams(
      type: event.type,
      userId: event.userId,
      start: event.startDate,
      end: event.endDate,
    ));
    result.fold(
      (failure) => emit(TransactionFailure(failure: failure)),
      (total) => emit(TotalAmountLoaded(total: total)),
    );
  }

  // Helper method to create a transaction with a new UUID
  Transaction _createTransactionWithId(Transaction transaction) {
    final uuid = const Uuid().v4();
    final now = DateTime.now();

    return Transaction(
      id: uuid,
      amount: transaction.amount,
      date: transaction.date,
      categoryId: transaction.categoryId,
      note: transaction.note,
      type: transaction.type,
      userId: transaction.userId,
      createdAt: now,
      updatedAt: now,
      vatAmount: transaction.vatAmount,
      vatRate: transaction.vatRate,
      includeVat: transaction.includeVat,
    );
  }
}
