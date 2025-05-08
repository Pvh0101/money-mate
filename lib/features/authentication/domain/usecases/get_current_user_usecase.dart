import 'package:dartz/dartz.dart';
import 'package:money_mate/core/errors/auth_failure.dart';
import 'package:money_mate/features/authentication/domain/entities/user_entity.dart';
import 'package:money_mate/features/authentication/domain/repositories/auth_repository.dart';
// Import NoParams từ register_with_google_usecase.dart
// Đường dẫn có thể cần điều chỉnh nếu cấu trúc file của bạn khác
import './register_with_google_usecase.dart' show NoParams;

/// Use case để lấy thông tin người dùng hiện tại
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  /// Gọi use case để lấy người dùng hiện tại
  Future<Either<AuthFailure, UserEntity?>> call(NoParams params) async {
    try {
      final user = await repository.getCurrentUser();
      // Nếu repository.getCurrentUser() trả về null khi không có user,
      // Right(user) vẫn hợp lệ vì UserEntity? cho phép null.
      return Right(user);
    } catch (e) {
      // Chuyển đổi lỗi từ repository thành AuthFailure nếu cần.
      // Đây là một cách xử lý lỗi đơn giản.
      // Trong thực tế, bạn có thể muốn AuthRepository trả về Either trực tiếp.
      if (e is AuthFailure) {
        return Left(e);
      }
      // Hoặc nếu repository ném một exception chung, bạn map nó:
      // Ví dụ: return Left(AuthFailure.serverError());
      return Left(const AuthFailure('Không thể lấy người dùng hiện tại'));
    }
  }
}

// Xóa định nghĩa NoParams cục bộ 