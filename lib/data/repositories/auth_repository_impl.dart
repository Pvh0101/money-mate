import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_mate/core/errors/auth_failure.dart';
import 'package:money_mate/domain/entities/user_entity.dart';
import 'package:money_mate/domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _authDataSource;
  
  AuthRepositoryImpl({
    required FirebaseAuthDataSource authDataSource,
  }) : _authDataSource = authDataSource;
  
  @override
  Future<Either<AuthFailure, UserEntity>> registerWithEmail(String email, String password) async {
    try {
      final user = await _authDataSource.registerWithEmail(email, password);
      await _authDataSource.saveUserToFirestore(user);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthExceptionToFailure(e));
    } catch (e) {
      return Left(AuthFailure('Đăng ký thất bại: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<AuthFailure, UserEntity>> registerWithGoogle() async {
    try {
      // Lấy Google credential
      final credential = await (_authDataSource as FirebaseAuthDataSourceImpl)
          .getGoogleAuthCredential();
      
      if (credential == null) {
        return Left(AuthFailure.userCancelled());
      }
      
      // Đăng nhập với credential
      final user = await _authDataSource.signInWithCredential(credential);
      
      // Lưu thông tin người dùng vào Firestore
      await _authDataSource.saveUserToFirestore(user);
      
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthExceptionToFailure(e));
    } catch (e) {
      return Left(AuthFailure('Đăng ký với Google thất bại: ${e.toString()}'));
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
  
  /// Ánh xạ FirebaseAuthException sang AuthFailure tương ứng
  AuthFailure _mapFirebaseAuthExceptionToFailure(FirebaseAuthException e) {
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
      case 'google-sign-in-failed':
      case 'account-exists-with-different-credential':
        return AuthFailure('Đăng nhập Google thất bại: ${e.message ?? e.code}');
      default:
        return AuthFailure(e.message ?? 'Lỗi không xác định: ${e.code}');
    }
  }
} 