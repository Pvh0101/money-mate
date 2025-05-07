import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/auth_failure.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

/// Use case đăng ký người dùng mới bằng email và mật khẩu
class RegisterWithEmailUseCase {
  final AuthRepository repository;
  
  RegisterWithEmailUseCase(this.repository);
  
  /// Gọi use case để đăng ký người dùng mới
  /// 
  /// [params] chứa email và mật khẩu của người dùng
  Future<Either<AuthFailure, UserEntity>> call(RegisterParams params) {
    return repository.registerWithEmail(params.email, params.password);
  }
}

/// Params cho use case RegisterWithEmail
class RegisterParams extends Equatable {
  final String email;
  final String password;
  
  const RegisterParams({
    required this.email, 
    required this.password,
  });
  
  @override
  List<Object?> get props => [email, password];
} 