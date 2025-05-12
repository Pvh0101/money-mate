import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:uuid/uuid.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/authentication/data/datasources/firebase_auth_datasource.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';

import '../../features/authentication/domain/usecases/usecases.dart';

import '../../features/authentication/presentation/bloc/auth_bloc.dart';

// Category imports
import '../../features/categories/data/datasources/category_local_datasource.dart';
import '../../features/categories/data/datasources/category_remote_datasource.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/add_category_usecase.dart';
import '../../features/categories/domain/usecases/get_categories_usecase.dart';
import '../../features/categories/presentation/bloc/category_bloc.dart';
import '../network/network_info.dart';
import '../storage/hive_config.dart';
import '../storage/hive_service.dart';

// Transaction dependencies import
import 'transaction_di.dart';

// Summary dependencies import
import 'summary_di.dart';

final sl = GetIt.instance;

/// Khởi tạo các dependencies
Future<void> init() async {
  //! External
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton(() => Uuid());

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! Local Storage
  // Lưu ý: Chỉ lấy các box đã được khởi tạo trong HiveService.init()
  // Không đăng ký mới ở đây để tránh lỗi
  if (!sl.isRegistered<Box>(instanceName: HiveBoxes.categoriesBox)) {
    sl.registerLazySingleton<Box>(
      () => HiveService.getBox(HiveBoxes.categoriesBox),
      instanceName: HiveBoxes.categoriesBox,
    );
  }

  if (!sl.isRegistered<Box>(instanceName: HiveBoxes.transactionsBox)) {
    sl.registerLazySingleton<Box>(
      () => HiveService.getBox(HiveBoxes.transactionsBox),
      instanceName: HiveBoxes.transactionsBox,
    );
  }

  if (!sl.isRegistered<Box>(instanceName: HiveBoxes.userBox)) {
    sl.registerLazySingleton<Box>(
      () => HiveService.getBox(HiveBoxes.userBox),
      instanceName: HiveBoxes.userBox,
    );
  }

  if (!sl.isRegistered<Box>(instanceName: HiveBoxes.settingsBox)) {
    sl.registerLazySingleton<Box>(
      () => HiveService.getBox(HiveBoxes.settingsBox),
      instanceName: HiveBoxes.settingsBox,
    );
  }

  if (!sl.isRegistered<Box>(instanceName: HiveBoxes.summaryBox)) {
    sl.registerLazySingleton<Box>(
      () => HiveService.getBox(HiveBoxes.summaryBox),
      instanceName: HiveBoxes.summaryBox,
    );
  }

  //! Data sources - Auth
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      googleSignIn: sl(),
    ),
  );

  //! Data sources - Category
  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => HiveCategoryLocalDataSource(
      categoriesBox: sl<Box>(instanceName: HiveBoxes.categoriesBox),
    ),
  );
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => FirebaseCategoryRemoteDataSource(firestore: sl()),
  );

  //! Repositories - Auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authDataSource: sl(),
    ),
  );

  //! Repositories - Category
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //! Use cases - Auth
  sl.registerLazySingleton(() => RegisterWithEmailUseCase(sl()));
  sl.registerLazySingleton(() => RegisterWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithEmailPasswordUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => GetAuthStateChangesUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  //! Use cases - Category
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => AddCategoryUseCase(sl()));

  //! BLoC - Auth
  sl.registerFactory(
    () => AuthBloc(
      registerWithEmailUseCase: sl(),
      registerWithGoogleUseCase: sl(),
      loginWithEmailPasswordUseCase: sl(),
      loginWithGoogleUseCase: sl(),
      getAuthStateChangesUseCase: sl(),
      getCurrentUserUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  //! BLoC - Category
  sl.registerFactory(
    () => CategoryBloc(
      getCategoriesUseCase: sl(),
      addCategoryUseCase: sl(),
      uuid: sl(),
    ),
  );

  // Thứ tự khởi tạo rất quan trọng
  // 1. Đầu tiên khởi tạo Transaction dependencies
  print('Initializing Transaction dependencies');
  initTransactionDependencies(sl);

  // 2. Sau đó mới khởi tạo Summary dependencies vì nó phụ thuộc vào Transaction
  print('Initializing Summary dependencies');
  initSummaryDependencies(sl);
}
