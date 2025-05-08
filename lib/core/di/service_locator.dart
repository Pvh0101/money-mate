import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/authentication/data/datasources/firebase_auth_datasource.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';

import '../../features/authentication/domain/usecases/usecases.dart';

import '../../features/authentication/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

/// Khởi tạo các dependencies
Future<void> init() async {
  //! External
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn());

  //! Data sources
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(), // Firestore có thể không cần cho FirebaseAuthDataSourceImpl trực tiếp, tùy thuộc vào implementation của bạn
      googleSignIn: sl(),
    ),
  );

  //! Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authDataSource: sl(),
    ),
  );

  //! Use cases
  // Đăng ký sử dụng tên class từ barrel file
  sl.registerLazySingleton(() => RegisterWithEmailUseCase(sl()));
  sl.registerLazySingleton(() => RegisterWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithEmailPasswordUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => GetAuthStateChangesUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  //! BLoC
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
}
