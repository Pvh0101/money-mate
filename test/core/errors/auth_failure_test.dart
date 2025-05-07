import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/errors/auth_failure.dart';

void main() {
  group('AuthFailure', () {
    test('should create AuthFailure with default message', () {
      // arrange & act
      const failure = AuthFailure();
      
      // assert
      expect(failure.message, 'Lỗi xác thực');
    });

    test('should create AuthFailure with custom message', () {
      // arrange & act
      const failure = AuthFailure('Lỗi tùy chỉnh');
      
      // assert
      expect(failure.message, 'Lỗi tùy chỉnh');
    });
    
    test('emailAlreadyInUse factory should return correct message', () {
      // arrange & act
      final failure = AuthFailure.emailAlreadyInUse();
      
      // assert
      expect(failure.message, 'Email đã được sử dụng bởi tài khoản khác');
    });
    
    test('invalidEmail factory should return correct message', () {
      // arrange & act
      final failure = AuthFailure.invalidEmail();
      
      // assert
      expect(failure.message, 'Email không hợp lệ');
    });
    
    test('weakPassword factory should return correct message', () {
      // arrange & act
      final failure = AuthFailure.weakPassword();
      
      // assert
      expect(failure.message, 'Mật khẩu quá yếu');
    });
    
    test('operationNotAllowed factory should return correct message', () {
      // arrange & act
      final failure = AuthFailure.operationNotAllowed();
      
      // assert
      expect(failure.message, 'Hoạt động không được cho phép');
    });
    
    test('userCancelled factory should return correct message', () {
      // arrange & act
      final failure = AuthFailure.userCancelled();
      
      // assert
      expect(failure.message, 'Người dùng đã hủy thao tác');
    });
    
    test('serverError factory should return correct message', () {
      // arrange & act
      final failure = AuthFailure.serverError();
      
      // assert
      expect(failure.message, 'Lỗi máy chủ, vui lòng thử lại sau');
    });
    
    test('passwordsDoNotMatch factory should return correct message', () {
      // arrange & act
      final failure = AuthFailure.passwordsDoNotMatch();
      
      // assert
      expect(failure.message, 'Mật khẩu không khớp');
    });
    
    test('userNotFound factory should return correct message', () {
      // arrange & act
      final failure = AuthFailure.userNotFound();
      
      // assert
      expect(failure.message, 'Không tìm thấy người dùng');
    });
    
    test('wrongPassword factory should return correct message', () {
      // arrange & act
      final failure = AuthFailure.wrongPassword();
      
      // assert
      expect(failure.message, 'Mật khẩu không đúng');
    });
  });
} 