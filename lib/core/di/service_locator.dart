import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:uuid/uuid.dart';

import '../../features/authentication/data/datasources/firebase_auth_datasource.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';

import '../../features/authentication/domain/usecases/usecases.dart';

import '../../features/authentication/presentation/bloc/auth_bloc.dart';

// Category imports
import '../../features/categories/data/datasources/category_datasource.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/add_category_usecase.dart';
import '../../features/categories/domain/usecases/get_categories_usecase.dart';
import '../../features/categories/presentation/bloc/category_bloc.dart';
import '../network/network_info.dart';

// Transaction dependencies import
import 'transaction_di.dart';

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
    () => CategoryLocalDataSource(),
  );
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSource(firestore: sl()),
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

  // Khởi tạo dependencies cho Transaction
  initTransactionDependencies(sl);
}
