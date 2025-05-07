import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../../core/errors/auth_failure.dart';

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
} 