import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/core/errors/auth_failure.dart';
import 'package:money_mate/feartures/domain/entities/user_entity.dart';
import 'package:money_mate/feartures/domain/repositories/auth_repository.dart';
import 'package:money_mate/feartures/domain/usecases/auth/register_with_email_usecase.dart';

import 'register_with_email_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late RegisterWithEmailUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = RegisterWithEmailUseCase(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'Password123!';
  
  final tUserEntity = UserEntity(
    id: 'test-id',
    email: tEmail,
    name: 'Test User',
  );

  test('should register user with email and password from the repository', () async {
    // arrange
    when(mockAuthRepository.registerWithEmail(any, any))
        .thenAnswer((_) async => Right(tUserEntity));
    
    // act
    final result = await usecase(const RegisterParams(
      email: tEmail,
      password: tPassword,
    ));
    
    // assert
    expect(result, Right(tUserEntity));
    verify(mockAuthRepository.registerWithEmail(tEmail, tPassword)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return AuthFailure when repository fails', () async {
    // arrange
    final failure = AuthFailure.invalidEmail();
    when(mockAuthRepository.registerWithEmail(any, any))
        .thenAnswer((_) async => Left(failure));
    
    // act
    final result = await usecase(const RegisterParams(
      email: tEmail,
      password: tPassword,
    ));
    
    // assert
    expect(result, Left(failure));
    verify(mockAuthRepository.registerWithEmail(tEmail, tPassword)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
  
  group('RegisterParams', () {
    test('should return true when comparing two identical RegisterParams', () {
      // arrange
      const params1 = RegisterParams(email: tEmail, password: tPassword);
      const params2 = RegisterParams(email: tEmail, password: tPassword);
      
      // act & assert
      expect(params1 == params2, true);
    });
    
    test('should return false when comparing two different RegisterParams', () {
      // arrange
      const params1 = RegisterParams(email: tEmail, password: tPassword);
      const params2 = RegisterParams(email: 'different@example.com', password: tPassword);
      
      // act & assert
      expect(params1 == params2, false);
    });
  });
} 