import 'package:dartz/dartz.dart';
import 'package:money_mate/core/errors/auth_failure.dart';
import 'package:money_mate/features/authentication/domain/repositories/auth_repository.dart';
import './register_with_google_usecase.dart' show NoParams;

/// Use case đăng xuất người dùng
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  /// Gọi use case để đăng xuất
  Future<Either<AuthFailure, void>> call(NoParams params) {
    return repository.logout();
  }
} 