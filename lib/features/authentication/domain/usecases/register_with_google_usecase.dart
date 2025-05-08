import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/auth_failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case đăng ký người dùng mới bằng tài khoản Google
class RegisterWithGoogleUseCase {
  final AuthRepository repository;
  
  RegisterWithGoogleUseCase(this.repository);
  
  /// Gọi use case để đăng ký người dùng mới bằng Google
  Future<Either<AuthFailure, UserEntity>> call(NoParams params) {
    return repository.registerWithGoogle();
  }
}

/// Sử dụng cho các use case không yêu cầu parameters
class NoParams extends Equatable {
  const NoParams();
  
  @override
  List<Object?> get props => [];
} 