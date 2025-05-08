import 'package:money_mate/features/authentication/domain/entities/user_entity.dart';
import 'package:money_mate/features/authentication/domain/repositories/auth_repository.dart';
import './register_with_google_usecase.dart' show NoParams;

/// Use case để lắng nghe sự thay đổi trạng thái xác thực
class GetAuthStateChangesUseCase {
  final AuthRepository repository;

  GetAuthStateChangesUseCase(this.repository);

  /// Gọi use case để nhận Stream các thay đổi trạng thái người dùng
  Stream<UserEntity?> call(NoParams params) {
    return repository.authStateChanges;
  }
} 