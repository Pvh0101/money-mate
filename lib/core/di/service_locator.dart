import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth/register_with_email_usecase.dart';
import '../../domain/usecases/auth/register_with_google_usecase.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';

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
      firestore: sl(),
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
  sl.registerLazySingleton(() => RegisterWithEmailUseCase(sl()));
  sl.registerLazySingleton(() => RegisterWithGoogleUseCase(sl()));

  //! BLoC
  sl.registerFactory(
    () => AuthBloc(
      registerWithEmailUseCase: sl(),
      registerWithGoogleUseCase: sl(),
    ),
  );
} 