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

class LoginWithEmailPasswordRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginWithEmailPasswordRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class LoginWithGoogleRequested extends AuthEvent {
  const LoginWithGoogleRequested();
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class AuthStateChanged extends AuthEvent {
  final UserEntity? user; // User có thể là null khi logout

  const AuthStateChanged({this.user});

  @override
  List<Object?> get props => [user];
}

class GetCurrentUserRequested extends AuthEvent {
  const GetCurrentUserRequested();
} 