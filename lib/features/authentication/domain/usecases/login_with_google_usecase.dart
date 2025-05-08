import 'package:dartz/dartz.dart';
import 'package:money_mate/core/errors/auth_failure.dart';
import 'package:money_mate/features/authentication/domain/entities/user_entity.dart';
import 'package:money_mate/features/authentication/domain/repositories/auth_repository.dart';
import './register_with_google_usecase.dart' show NoParams;

/// Use case đăng nhập người dùng bằng tài khoản Google
class LoginWithGoogleUseCase {
  final AuthRepository repository;

  LoginWithGoogleUseCase(this.repository);

  /// Gọi use case để đăng nhập người dùng bằng Google
  Future<Either<AuthFailure, UserEntity>> call(NoParams params) {
    return repository.loginWithGoogle();
  }
} 