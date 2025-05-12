import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/summary/data/datasources/summary_remote_datasource.dart';
import '../../features/summary/data/datasources/summary_local_datasource.dart';
import '../../features/summary/data/repositories/summary_repository_impl.dart';
import '../../features/summary/domain/repositories/summary_repository.dart';
import '../../features/summary/domain/usecases/clear_summary_cache_usecase.dart';
import '../../features/summary/domain/usecases/get_summary_by_date_range_usecase.dart';
import '../../features/summary/domain/usecases/get_summary_by_time_range_usecase.dart';
import '../../features/summary/presentation/bloc/summary_bloc.dart';
import '../../features/summary/data/models/summary_hive_model.dart';
import '../storage/hive_config.dart';
import '../../features/transactions/data/datasources/transaction_local_datasource.dart';
import '../network/network_info.dart';

/// Khởi tạo dependencies cho tính năng Summary
void initSummaryDependencies(GetIt sl) {
  // Đảm bảo box được mở
  if (!Hive.isBoxOpen(HiveBoxes.summaryBox)) {
    Hive.openBox(HiveBoxes.summaryBox);
  }

  // Đăng ký box summary nếu chưa
  if (!sl.isRegistered<Box>(instanceName: HiveBoxes.summaryBox)) {
    sl.registerLazySingleton<Box>(
      () => Hive.box(HiveBoxes.summaryBox),
      instanceName: HiveBoxes.summaryBox,
    );
  }

  //! Data sources
  sl.registerLazySingleton<SummaryRemoteDataSource>(
    () => SummaryRemoteDataSourceImpl(
      firestore: sl<FirebaseFirestore>(),
      firebaseAuth: sl<FirebaseAuth>(),
    ),
  );

  // Đảm bảo TransactionLocalDataSource đã được đăng ký trước khi sử dụng cho Summary
  // Kiểm tra xem TransactionLocalDataSource đã được đăng ký chưa
  if (!sl.isRegistered<TransactionLocalDataSource>()) {
    print(
        'Warning: TransactionLocalDataSource not registered before SummaryLocalDataSource');
  } else {
    print('TransactionLocalDataSource is properly registered');
  }

  sl.registerLazySingleton<SummaryLocalDataSource>(
    () => HiveSummaryLocalDataSource(
      transactionLocalDataSource: sl<TransactionLocalDataSource>(),
      summaryBox: sl<Box>(instanceName: HiveBoxes.summaryBox),
    ),
  );

  //! Repositories
  sl.registerLazySingleton<SummaryRepository>(
    () => SummaryRepositoryImpl(
      remoteDataSource: sl<SummaryRemoteDataSource>(),
      localDataSource: sl<SummaryLocalDataSource>(),
      networkInfo: sl(),
    ),
  );

  //! Use cases
  sl.registerLazySingleton(
      () => GetSummaryByTimeRangeUseCase(sl<SummaryRepository>()));
  sl.registerLazySingleton(
      () => GetSummaryByDateRangeUseCase(sl<SummaryRepository>()));
  sl.registerLazySingleton(
      () => ClearSummaryCacheUseCase(sl<SummaryRepository>()));

  //! BLoC
  sl.registerFactory(
    () => SummaryBloc(
      getSummaryByTimeRange: sl<GetSummaryByTimeRangeUseCase>(),
      getSummaryByDateRange: sl<GetSummaryByDateRangeUseCase>(),
      clearSummaryCache: sl<ClearSummaryCacheUseCase>(),
    ),
  );
}
