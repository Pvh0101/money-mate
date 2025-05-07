part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RegisterWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const RegisterWithEmailEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class RegisterWithGoogleEvent extends AuthEvent {
  const RegisterWithGoogleEvent();
} 