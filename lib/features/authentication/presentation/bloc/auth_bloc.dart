import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_mate/core/errors/auth_failure.dart';
// Import từ barrel files
import 'package:money_mate/features/authentication/domain/entities/user_entity.dart'; 
import 'package:money_mate/features/authentication/domain/usecases/usecases.dart'; 

part 'auth_event.dart';
part 'auth_state.dart';

// Các import cho Params và các use case cụ thể có thể không cần nữa
// vì chúng đã được export từ usecases.dart

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterWithEmailUseCase _registerWithEmailUseCase;
  final RegisterWithGoogleUseCase _registerWithGoogleUseCase;
  final LoginWithEmailPasswordUseCase _loginWithEmailPasswordUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  final GetAuthStateChangesUseCase _getAuthStateChangesUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;

  StreamSubscription<UserEntity?>? _authStateChangesSubscription;

  AuthBloc({
    required RegisterWithEmailUseCase registerWithEmailUseCase,
    required RegisterWithGoogleUseCase registerWithGoogleUseCase,
    required LoginWithEmailPasswordUseCase loginWithEmailPasswordUseCase,
    required LoginWithGoogleUseCase loginWithGoogleUseCase,
    required GetAuthStateChangesUseCase getAuthStateChangesUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _registerWithEmailUseCase = registerWithEmailUseCase,
        _registerWithGoogleUseCase = registerWithGoogleUseCase,
        _loginWithEmailPasswordUseCase = loginWithEmailPasswordUseCase,
        _loginWithGoogleUseCase = loginWithGoogleUseCase,
        _getAuthStateChangesUseCase = getAuthStateChangesUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _logoutUseCase = logoutUseCase,
        super(AuthInitial()) {
    on<GetCurrentUserRequested>(_onGetCurrentUserRequested);
    on<AuthStateChanged>(_onAuthStateChanged);
    on<RegisterWithEmailEvent>(_onRegisterWithEmail);
    on<RegisterWithGoogleEvent>(_onRegisterWithGoogle);
    on<LoginWithEmailPasswordRequested>(_onLoginWithEmailPasswordRequested);
    on<LoginWithGoogleRequested>(_onLoginWithGoogleRequested);
    on<LogoutRequested>(_onLogoutRequested);

    _startListeningToAuthStateChanges();
  }

  void _startListeningToAuthStateChanges() {
    _authStateChangesSubscription?.cancel();
    _authStateChangesSubscription = _getAuthStateChangesUseCase(const NoParams()).listen(
      (user) {
        add(AuthStateChanged(user: user));
      },
      onError: (error) {
        // Trong trường hợp stream báo lỗi, coi như không có user.
        // Một chiến lược khác có thể là emit một AuthError cụ thể nếu `error` là một Failure.
        add(const AuthStateChanged(user: null));
      },
    );
  }

  Future<void> _onGetCurrentUserRequested(
    GetCurrentUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Chỉ emit AuthLoading nếu trạng thái hiện tại là AuthInitial.
    // Nếu đã Authenticated hoặc Unauthenticated, không cần loading khi chỉ kiểm tra.
    if (state is AuthInitial) {
       emit(AuthLoading());
    }
    final result = await _getCurrentUserUseCase(const NoParams());
    result.fold(
      (failure) => emit(const Unauthenticated()), // Nếu lỗi hoặc không có user, coi như Unauthenticated
      (user) => emit(user != null ? Authenticated(user: user) : const Unauthenticated()),
    );
  }

  void _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(Authenticated(user: event.user!));
    } else {
      emit(const Unauthenticated());
    }
  }

  Future<void> _onRegisterWithEmail(
    RegisterWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _registerWithEmailUseCase(
      RegisterParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthError(failure: failure)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onRegisterWithGoogle(
    RegisterWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _registerWithGoogleUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure: failure)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onLoginWithEmailPasswordRequested(
    LoginWithEmailPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _loginWithEmailPasswordUseCase(
      LoginEmailPasswordParams(email: event.email, password: event.password), // Sử dụng LoginEmailPasswordParams
    );
    result.fold(
      (failure) => emit(AuthError(failure: failure)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onLoginWithGoogleRequested(
    LoginWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _loginWithGoogleUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure: failure)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _logoutUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure: failure)),
      (_) => emit(const Unauthenticated()),
    );
  }

  @override
  Future<void> close() {
    _authStateChangesSubscription?.cancel();
    return super.close();
  }
} 