import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'dart:async';
import '../../../../core/errors/auth_failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _authDataSource;
  
  AuthRepositoryImpl({
    required FirebaseAuthDataSource authDataSource,
  }) : _authDataSource = authDataSource;
  
  @override
  Future<Either<AuthFailure, UserEntity>> registerWithEmail(String email, String password) async {
    try {
      final userModel = await _authDataSource.registerWithEmail(email, password);
      await _authDataSource.saveUserToFirestore(userModel);
      return Right(userModel);
    } on auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthExceptionToFailure(e));
    } catch (e) {
      return Left(AuthFailure('Đăng ký thất bại: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<AuthFailure, UserEntity>> registerWithGoogle() async {
    try {
      final credential = await (_authDataSource as FirebaseAuthDataSourceImpl)
          .getGoogleAuthCredential();
      
      if (credential == null) {
        return Left(AuthFailure.userCancelled());
      }
      
      final userModel = await _authDataSource.signInWithCredential(credential);
      
      await _authDataSource.saveUserToFirestore(userModel);
      
      return Right(userModel);
    } on auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthExceptionToFailure(e));
    } catch (e) {
      return Left(AuthFailure('Đăng ký/Đăng nhập với Google thất bại: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<AuthFailure, void>> logout() async {
    try {
      await _authDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Đăng xuất thất bại: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<AuthFailure, UserEntity>> loginWithEmailPassword(String email, String password) async {
    try {
      final userModel = await _authDataSource.signInWithEmailPassword(email, password);
      return Right(userModel);
    } on auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthExceptionToFailure(e));
    } catch (e) {
      return Left(AuthFailure('Đăng nhập thất bại: ${e.toString()}'));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> loginWithGoogle() async {
    try {
      final credential = await (_authDataSource as FirebaseAuthDataSourceImpl)
          .getGoogleAuthCredential();
      
      if (credential == null) {
        return Left(AuthFailure.userCancelled());
      }
      
      final userModel = await _authDataSource.signInWithCredential(credential);
      
      await _authDataSource.saveUserToFirestore(userModel);
      
      return Right(userModel);
    } on auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthExceptionToFailure(e));
    } catch (e) {
      return Left(AuthFailure('Đăng nhập Google thất bại: ${e.toString()}'));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _authDataSource.authStateChanges.map((firebaseUser) {
      if (firebaseUser == null) {
        return null;
      } else {
        return UserModel.fromFirebaseUser(firebaseUser);
      }
    });
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = _authDataSource.getCurrentFirebaseUser();
    if (firebaseUser == null) {
      return null;
    } else {
      return UserModel.fromFirebaseUser(firebaseUser);
    }
  }
  
  AuthFailure _mapFirebaseAuthExceptionToFailure(auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return AuthFailure.emailAlreadyInUse();
      case 'invalid-email':
        return AuthFailure.invalidEmail();
      case 'weak-password':
        return AuthFailure.weakPassword();
      case 'operation-not-allowed':
        return AuthFailure.operationNotAllowed();
      case 'user-not-found':
        return AuthFailure.userNotFound();
      case 'wrong-password':
        return AuthFailure.wrongPassword();
      case 'user-disabled':
        return AuthFailure.userDisabled();
      case 'account-exists-with-different-credential':
        return AuthFailure.accountExistsWithDifferentCredential();
      case 'requires-recent-login':
        return AuthFailure.requiresRecentLogin();
      case 'google-sign-in-failed':
        return AuthFailure('Đăng nhập Google thất bại: ${e.message ?? e.code}');
      case 'user-cancelled':
        return AuthFailure.userCancelled();
      default:
        return AuthFailure(e.message ?? 'Lỗi xác thực không xác định: ${e.code}');
    }
  }
} 