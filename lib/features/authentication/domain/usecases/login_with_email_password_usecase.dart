import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/auth_failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case đăng nhập người dùng bằng email và mật khẩu
class LoginWithEmailPasswordUseCase {
  final AuthRepository repository;

  LoginWithEmailPasswordUseCase(this.repository);

  /// Gọi use case để đăng nhập người dùng
  ///
  /// [params] chứa email và mật khẩu của người dùng
  Future<Either<AuthFailure, UserEntity>> call(LoginEmailPasswordParams params) {
    return repository.loginWithEmailPassword(params.email, params.password);
  }
}

/// Params cho use case LoginWithEmailPassword
class LoginEmailPasswordParams extends Equatable {
  final String email;
  final String password;

  const LoginEmailPasswordParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
} 