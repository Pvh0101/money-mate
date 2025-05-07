import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/core/errors/auth_failure.dart';
import 'package:money_mate/features/authentication/domain/entities/user_entity.dart';
import 'package:money_mate/features/authentication/domain/repositories/auth_repository.dart';
import 'package:money_mate/features/authentication/domain/usecases/auth/register_with_google_usecase.dart';

import 'register_with_google_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late RegisterWithGoogleUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = RegisterWithGoogleUseCase(mockAuthRepository);
  });

  final tUserEntity = UserEntity(
    id: 'test-id',
    email: 'test@example.com',
    name: 'Test User',
  );

  group('RegisterWithGoogleUseCase', () {
    test('should register user with Google from the repository', () async {
      // arrange
      when(mockAuthRepository.registerWithGoogle())
          .thenAnswer((_) async => Right(tUserEntity));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, Right(tUserEntity));
      verify(mockAuthRepository.registerWithGoogle()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthFailure when repository fails', () async {
      // arrange
      final failure = AuthFailure.userCancelled();
      when(mockAuthRepository.registerWithGoogle())
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, Left(failure));
      verify(mockAuthRepository.registerWithGoogle()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });

  group('NoParams', () {
    test('should return true when comparing two NoParams instances', () {
      // arrange
      const params1 = NoParams();
      const params2 = NoParams();

      // act & assert
      expect(params1 == params2, true);
    });

    test('should have empty props list', () {
      // arrange
      const params = NoParams();

      // act & assert
      expect(params.props, []);
    });
  });
}
