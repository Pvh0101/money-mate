import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/core/errors/auth_failure.dart';
import 'package:money_mate/feartures/authentication/domain/entities/user_entity.dart';
import 'package:money_mate/feartures/authentication/domain/usecases/auth/register_with_email_usecase.dart';
import 'package:money_mate/feartures/authentication/domain/usecases/auth/register_with_google_usecase.dart';
import 'package:money_mate/feartures/authentication/presentation/bloc/auth_bloc.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([RegisterWithEmailUseCase, RegisterWithGoogleUseCase])
void main() {
  late MockRegisterWithEmailUseCase mockRegisterWithEmailUseCase;
  late MockRegisterWithGoogleUseCase mockRegisterWithGoogleUseCase;
  late AuthBloc authBloc;

  setUp(() {
    mockRegisterWithEmailUseCase = MockRegisterWithEmailUseCase();
    mockRegisterWithGoogleUseCase = MockRegisterWithGoogleUseCase();
    authBloc = AuthBloc(
      registerWithEmailUseCase: mockRegisterWithEmailUseCase,
      registerWithGoogleUseCase: mockRegisterWithGoogleUseCase,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  // Định nghĩa dữ liệu test
  const tEmail = 'test@example.com';
  const tPassword = 'Password123!';
  
  final tUserEntity = UserEntity(
    id: 'test-id',
    email: tEmail,
    name: 'Test User',
    photoUrl: null,
  );

  const tAuthFailure = AuthFailure('Lỗi xác thực');

  test('initial state should be AuthInitial', () {
    expect(authBloc.state, isA<AuthInitial>());
  });

  group('RegisterWithEmailEvent', () {
    final tRegisterParams = RegisterParams(
      email: tEmail,
      password: tPassword,
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when registration is successful',
      build: () {
        when(mockRegisterWithEmailUseCase(tRegisterParams))
            .thenAnswer((_) async => Right(tUserEntity));
        return authBloc;
      },
      act: (bloc) => bloc.add(const RegisterWithEmailEvent(
        email: tEmail,
        password: tPassword,
      )),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>(),
      ],
      verify: (_) {
        verify(mockRegisterWithEmailUseCase(tRegisterParams)).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when registration fails',
      build: () {
        when(mockRegisterWithEmailUseCase(tRegisterParams))
            .thenAnswer((_) async => Left(tAuthFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(const RegisterWithEmailEvent(
        email: tEmail,
        password: tPassword,
      )),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
      verify: (_) {
        verify(mockRegisterWithEmailUseCase(tRegisterParams)).called(1);
      },
    );
  });

  group('RegisterWithGoogleEvent', () {
    const tNoParams = NoParams();

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when Google registration is successful',
      build: () {
        when(mockRegisterWithGoogleUseCase(tNoParams))
            .thenAnswer((_) async => Right(tUserEntity));
        return authBloc;
      },
      act: (bloc) => bloc.add(const RegisterWithGoogleEvent()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>(),
      ],
      verify: (_) {
        verify(mockRegisterWithGoogleUseCase(tNoParams)).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when Google registration fails',
      build: () {
        when(mockRegisterWithGoogleUseCase(tNoParams))
            .thenAnswer((_) async => Left(tAuthFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(const RegisterWithGoogleEvent()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
      verify: (_) {
        verify(mockRegisterWithGoogleUseCase(tNoParams)).called(1);
      },
    );
  });
} 