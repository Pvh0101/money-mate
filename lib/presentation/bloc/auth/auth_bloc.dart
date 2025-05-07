import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_mate/domain/entities/user_entity.dart';
import 'package:money_mate/domain/usecases/auth/register_with_email_usecase.dart';
import 'package:money_mate/domain/usecases/auth/register_with_google_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterWithEmailUseCase registerWithEmailUseCase;
  final RegisterWithGoogleUseCase registerWithGoogleUseCase;

  AuthBloc({
    required this.registerWithEmailUseCase,
    required this.registerWithGoogleUseCase,
  }) : super(AuthInitial()) {
    on<RegisterWithEmailEvent>(_onRegisterWithEmail);
    on<RegisterWithGoogleEvent>(_onRegisterWithGoogle);
  }

  Future<void> _onRegisterWithEmail(
    RegisterWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await registerWithEmailUseCase(
      RegisterParams(
        email: event.email,
        password: event.password,
      ),
    );
    
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> _onRegisterWithGoogle(
    RegisterWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await registerWithGoogleUseCase(
      const NoParams(),
    );
    
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }
} 