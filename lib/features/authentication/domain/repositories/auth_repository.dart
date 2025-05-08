import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../../../../core/errors/auth_failure.dart';

abstract class AuthRepository {
  /// Đăng ký người dùng với email và mật khẩu
  /// 
  /// Trả về [UserEntity] nếu thành công hoặc [AuthFailure] nếu thất bại
  Future<Either<AuthFailure, UserEntity>> registerWithEmail(String email, String password);
  
  /// Đăng ký người dùng với tài khoản Google
  /// 
  /// Trả về [UserEntity] nếu thành công hoặc [AuthFailure] nếu thất bại
  Future<Either<AuthFailure, UserEntity>> registerWithGoogle();
  
  /// Đăng xuất người dùng hiện tại
  ///
  /// Trả về void nếu thành công hoặc [AuthFailure] nếu thất bại
  Future<Either<AuthFailure, void>> logout();

  /// Đăng nhập người dùng với email và mật khẩu
  /// 
  /// Trả về [UserEntity] nếu thành công hoặc [AuthFailure] nếu thất bại
  Future<Either<AuthFailure, UserEntity>> loginWithEmailPassword(String email, String password);

  /// Đăng nhập người dùng với tài khoản Google
  /// 
  /// Trả về [UserEntity] nếu thành công hoặc [AuthFailure] nếu thất bại
  Future<Either<AuthFailure, UserEntity>> loginWithGoogle();

  /// Lắng nghe sự thay đổi trạng thái xác thực người dùng
  /// 
  /// Trả về một Stream của [UserEntity] (nullable)
  Stream<UserEntity?> get authStateChanges;

  /// Lấy thông tin người dùng hiện tại đang đăng nhập (nếu có)
  ///
  /// Trả về [UserEntity] (nullable)
  Future<UserEntity?> getCurrentUser();
} 