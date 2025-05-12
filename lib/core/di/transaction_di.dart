import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../network/network_info.dart';
import '../storage/hive_config.dart';
import '../../features/transactions/data/datasources/transaction_remote_datasource.dart';
import '../../features/transactions/data/datasources/transaction_local_datasource.dart';
import '../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../features/transactions/domain/usecases/add_transaction_usecase.dart';
import '../../features/transactions/domain/usecases/delete_transaction_usecase.dart';
import '../../features/transactions/domain/usecases/get_transaction_by_id_usecase.dart';
import '../../features/transactions/domain/usecases/get_transactions_by_category_usecase.dart';
import '../../features/transactions/domain/usecases/get_transactions_by_date_range_usecase.dart';
import '../../features/transactions/domain/usecases/get_transactions_usecase.dart';
import '../../features/transactions/domain/usecases/get_total_by_type_usecase.dart';
import '../../features/transactions/domain/usecases/update_transaction_usecase.dart';
import '../../features/transactions/presentation/bloc/transaction_bloc.dart';

void initTransactionDependencies(GetIt sl) {
  // Bloc
  sl.registerFactory(
    () => TransactionBloc(
      getTransactions: sl(),
      getTransactionsByDateRange: sl(),
      getTransactionsByCategory: sl(),
      getTransactionById: sl(),
      addTransaction: sl(),
      updateTransaction: sl(),
      deleteTransaction: sl(),
      getTotalByType: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTransactionsUseCase(sl()));
  sl.registerLazySingleton(() => GetTransactionsByDateRangeUseCase(sl()));
  sl.registerLazySingleton(() => GetTransactionsByCategoryUseCase(sl()));
  sl.registerLazySingleton(() => GetTransactionByIdUseCase(sl()));
  sl.registerLazySingleton(() => AddTransactionUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTransactionUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTransactionUseCase(sl()));
  sl.registerLazySingleton(() => GetTotalByTypeUseCase(sl()));

  // Repository
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(
      firestore: sl(),
    ),
  );

  // Local data source with Hive
  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => HiveTransactionLocalDataSource(
      transactionsBox: sl<Box>(instanceName: HiveBoxes.transactionsBox),
    ),
  );

  // External
  // Firestore được đăng ký ở main.dart hoặc injection.dart chung
  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton(() => FirebaseFirestore.instance);
  }

  // NetworkInfo và InternetConnectionChecker được đăng ký ở main.dart hoặc injection.dart chung
  if (!sl.isRegistered<InternetConnectionChecker>()) {
    sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  }

  if (!sl.isRegistered<NetworkInfo>()) {
    sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(sl<InternetConnectionChecker>()));
  }
}
