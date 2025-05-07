import 'failures.dart';

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Lỗi xác thực']) : super(message);
  
  // Factory constructors cho các loại lỗi cụ thể
  factory AuthFailure.emailAlreadyInUse() => 
      const AuthFailure('Email đã được sử dụng bởi tài khoản khác');
      
  factory AuthFailure.invalidEmail() => 
      const AuthFailure('Email không hợp lệ');
      
  factory AuthFailure.weakPassword() => 
      const AuthFailure('Mật khẩu quá yếu');
      
  factory AuthFailure.operationNotAllowed() => 
      const AuthFailure('Hoạt động không được cho phép');
      
  factory AuthFailure.userCancelled() => 
      const AuthFailure('Người dùng đã hủy thao tác');
      
  factory AuthFailure.serverError() => 
      const AuthFailure('Lỗi máy chủ, vui lòng thử lại sau');
      
  factory AuthFailure.passwordsDoNotMatch() => 
      const AuthFailure('Mật khẩu không khớp');
      
  factory AuthFailure.userNotFound() => 
      const AuthFailure('Không tìm thấy người dùng');
      
  factory AuthFailure.wrongPassword() => 
      const AuthFailure('Mật khẩu không đúng');
} 