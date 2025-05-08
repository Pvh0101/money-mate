part of 'auth_bloc.dart';

// UserEntity và AuthFailure sẽ được import trong auth_bloc.dart

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

// Đổi tên AuthSuccess thành Authenticated
class Authenticated extends AuthState {
  final UserEntity user;
  
  const Authenticated({required this.user});
  
  @override
  List<Object?> get props => [user];
}

// Thêm trạng thái Unauthenticated
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

// Sửa AuthError để nhận AuthFailure
class AuthError extends AuthState {
  final AuthFailure failure;
  
  const AuthError({required this.failure});
  
  @override
  List<Object?> get props => [failure];
} 