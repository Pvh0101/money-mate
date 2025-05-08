import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/core/errors/auth_failure.dart';
import 'package:money_mate/features/authentication/data/datasources/firebase_auth_datasource.dart';
import 'package:money_mate/features/authentication/data/models/user_model.dart';
import 'package:money_mate/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:money_mate/features/authentication/domain/entities/user_entity.dart';

import 'dart:async'; // For StreamController
import '../datasources/firebase_auth_datasource_test.mocks.dart'; // Import datasource mocks for MockUser
import 'auth_repository_impl_test.mocks.dart'; // Import repository mocks

@GenerateMocks([FirebaseAuthDataSource])
void main() {
  late AuthRepositoryImpl repository;
  late MockFirebaseAuthDataSource mockFirebaseAuthDataSource;

  setUp(() {
    mockFirebaseAuthDataSource = MockFirebaseAuthDataSource();
    repository = AuthRepositoryImpl(
      authDataSource: mockFirebaseAuthDataSource,
    );
  });

  const tEmail = 'test@example.com';
  const tPassword = 'Password123!';

  final tUserModel = UserModel(
    id: 'test-id',
    email: tEmail,
    name: 'Test User',
    photoUrl: null,
  );

  final UserEntity tUserEntity = tUserModel;

  final mockFirebaseUser = MockUser();

  setUp(() {
    when(mockFirebaseUser.uid).thenReturn('firebase-uid');
    when(mockFirebaseUser.email).thenReturn('firebase@test.com');
    when(mockFirebaseUser.displayName).thenReturn('Firebase User');
    when(mockFirebaseUser.photoURL).thenReturn('firebase-photo-url');
  });

  group('registerWithEmail', () {
    test('should return UserEntity when registration is successful', () async {
      // arrange
      when(mockFirebaseAuthDataSource.registerWithEmail(any, any))
          .thenAnswer((_) async => tUserModel);
      when(mockFirebaseAuthDataSource.saveUserToFirestore(any))
          .thenAnswer((_) async => {});

      // act
      final result = await repository.registerWithEmail(tEmail, tPassword);

      // assert
      expect(result, Right<AuthFailure, UserEntity>(tUserModel));
      verify(mockFirebaseAuthDataSource.registerWithEmail(
              tEmail, tPassword))
          .called(1);
      verify(mockFirebaseAuthDataSource.saveUserToFirestore(tUserModel))
          .called(1);
      verifyNoMoreInteractions(mockFirebaseAuthDataSource);
    });

    test('should return AuthFailure when registration fails', () async {
      // arrange
      when(mockFirebaseAuthDataSource.registerWithEmail(any, any))
          .thenThrow(auth.FirebaseAuthException(code: 'email-already-in-use'));

      // act
      final result = await repository.registerWithEmail(tEmail, tPassword);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) =>
            expect(failure.message, 'Email đã được sử dụng bởi tài khoản khác'),
        (_) => fail('Should return a failure'),
      );
      verify(mockFirebaseAuthDataSource.registerWithEmail(
              tEmail, tPassword))
          .called(1);
      verifyNoMoreInteractions(mockFirebaseAuthDataSource);
    });
  });

  group('registerWithGoogle', () {
    test('should return UserEntity when Google registration is successful',
        () async {
      final tAuthCredential = auth.GoogleAuthProvider.credential(idToken: 't', accessToken: 't');
      when(mockFirebaseAuthDataSource.getGoogleAuthCredential())
          .thenAnswer((_) async => tAuthCredential);
      when(mockFirebaseAuthDataSource.signInWithCredential(any))
          .thenAnswer((_) async => tUserModel);
      when(mockFirebaseAuthDataSource.saveUserToFirestore(any))
          .thenAnswer((_) async => {});

      // act
      final result = await repository.registerWithGoogle();

      // assert
      expect(result, Right<AuthFailure, UserEntity>(tUserModel));
      verify(mockFirebaseAuthDataSource.signInWithCredential(tAuthCredential));
      verify(mockFirebaseAuthDataSource.saveUserToFirestore(tUserModel));
      verifyNoMoreInteractions(mockFirebaseAuthDataSource);
    });

    test('should return AuthFailure.userCancelled when user cancels Google Sign In',
        () async {
      when(mockFirebaseAuthDataSource.getGoogleAuthCredential())
          .thenAnswer((_) async => null);

      // act
      final result = await repository.registerWithGoogle();

      // assert
      expect(result, Left(AuthFailure.userCancelled()));
      verifyNoMoreInteractions(mockFirebaseAuthDataSource);
    });

    test('should return AuthFailure when Google registration fails with FirebaseAuthException', () async {
      final tException = auth.FirebaseAuthException(code: 'google-sign-in-failed');
      when(mockFirebaseAuthDataSource.getGoogleAuthCredential())
          .thenThrow(tException);

      // act
      final result = await repository.registerWithGoogle();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message.contains('Đăng ký/Đăng nhập với Google thất bại'), isTrue),
        (_) => fail('Expected a failure'),
      );
      verifyNoMoreInteractions(mockFirebaseAuthDataSource);
    });
  });

  group('logout', () {
    test('should return Right(null) when logout is successful', () async {
      // arrange
      when(mockFirebaseAuthDataSource.signOut())
          .thenAnswer((_) async => {});

      // act
      final result = await repository.logout();

      // assert
      expect(result, equals(const Right<AuthFailure, void>(null)));
      verify(mockFirebaseAuthDataSource.signOut()).called(1);
      verifyNoMoreInteractions(mockFirebaseAuthDataSource);
    });

    test('should return Left(AuthFailure) when logout fails', () async {
      // arrange
      when(mockFirebaseAuthDataSource.signOut())
          .thenThrow(Exception('Logout failed'));

      // act
      final result = await repository.logout();

      // assert
      expect(result.isLeft(), true);
      verify(mockFirebaseAuthDataSource.signOut()).called(1);
      verifyNoMoreInteractions(mockFirebaseAuthDataSource);
    });
  });

  group('AuthFailure mapping', () {
    test('should map FirebaseAuthException to correct AuthFailure', () async {
      // arrange
      when(mockFirebaseAuthDataSource.registerWithEmail(any, any))
          .thenThrow(auth.FirebaseAuthException(code: 'email-already-in-use'));

      // act
      final result = await repository.registerWithEmail(tEmail, tPassword);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) =>
            expect(failure.message, 'Email đã được sử dụng bởi tài khoản khác'),
        (_) => fail('Should return a failure'),
      );
    });

    test('should map invalid-email to correct AuthFailure', () async {
      // arrange
      when(mockFirebaseAuthDataSource.registerWithEmail(any, any))
          .thenThrow(auth.FirebaseAuthException(code: 'invalid-email'));

      // act
      final result = await repository.registerWithEmail(tEmail, tPassword);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Email không hợp lệ'),
        (_) => fail('Should return a failure'),
      );
    });

    test('should map weak-password to correct AuthFailure', () async {
      // arrange
      when(mockFirebaseAuthDataSource.registerWithEmail(any, any))
          .thenThrow(auth.FirebaseAuthException(code: 'weak-password'));

      // act
      final result = await repository.registerWithEmail(tEmail, tPassword);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Mật khẩu quá yếu'),
        (_) => fail('Should return a failure'),
      );
    });

    test('should handle unknown error codes', () async {
      // arrange
      when(mockFirebaseAuthDataSource.registerWithEmail(any, any))
          .thenThrow(auth.FirebaseAuthException(code: 'unknown-code'));

      // act
      final result = await repository.registerWithEmail(tEmail, tPassword);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('unknown-code')),
        (_) => fail('Should return a failure'),
      );
    });
  });

  group('loginWithEmailPassword', () {
    test('should return UserEntity when login is successful', () async {
      // arrange
      when(mockFirebaseAuthDataSource.signInWithEmailPassword(any, any))
          .thenAnswer((_) async => tUserModel);
      // act
      final result = await repository.loginWithEmailPassword(tEmail, tPassword);
      // assert
      expect(result, Right(tUserEntity));
      verify(mockFirebaseAuthDataSource.signInWithEmailPassword(tEmail, tPassword));
      verifyNoMoreInteractions(mockFirebaseAuthDataSource);
    });

    test('should return AuthFailure when login fails with FirebaseAuthException', () async {
      // arrange
      final tException = auth.FirebaseAuthException(code: 'user-not-found');
      when(mockFirebaseAuthDataSource.signInWithEmailPassword(any, any))
          .thenThrow(tException);
      // act
      final result = await repository.loginWithEmailPassword(tEmail, tPassword);
      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, AuthFailure.userNotFound()),
        (_) => fail('Expected a failure'),
      );
      verify(mockFirebaseAuthDataSource.signInWithEmailPassword(tEmail, tPassword));
      verifyNoMoreInteractions(mockFirebaseAuthDataSource);
    });

     test('should return AuthFailure for other exceptions', () async {
      // arrange
      when(mockFirebaseAuthDataSource.signInWithEmailPassword(any, any))
          .thenThrow(Exception('Network error'));
      // act
      final result = await repository.loginWithEmailPassword(tEmail, tPassword);
      // assert
       expect(result, Left(AuthFailure('Đăng nhập thất bại: Exception: Network error')));
       verify(mockFirebaseAuthDataSource.signInWithEmailPassword(tEmail, tPassword));
       verifyNoMoreInteractions(mockFirebaseAuthDataSource);
    });
  });

  group('loginWithGoogle', () {
    final tAuthCredential = auth.GoogleAuthProvider.credential(idToken: 't', accessToken: 't');

    test('should return UserEntity when Google login is successful', () async {
      // arrange
      when(mockFirebaseAuthDataSource.getGoogleAuthCredential())
          .thenAnswer((_) async => tAuthCredential);
      when(mockFirebaseAuthDataSource.signInWithCredential(any))
          .thenAnswer((_) async => tUserModel);
      when(mockFirebaseAuthDataSource.saveUserToFirestore(any))
          .thenAnswer((_) async => {});
      // act
      final result = await repository.loginWithGoogle();
      // assert
      expect(result, Right(tUserEntity));
      verify(mockFirebaseAuthDataSource.signInWithCredential(tAuthCredential));
      verify(mockFirebaseAuthDataSource.saveUserToFirestore(tUserModel));
      verifyNoMoreInteractions(mockFirebaseAuthDataSource);
    });

    test('should return AuthFailure.userCancelled when user cancels Google Sign In', () async {
      // arrange
       when(mockFirebaseAuthDataSource.getGoogleAuthCredential())
          .thenAnswer((_) async => null);
      // act
      final result = await repository.loginWithGoogle();
      // assert
      expect(result, Left(AuthFailure.userCancelled()));
      verifyNoMoreInteractions(mockFirebaseAuthDataSource);
    });

    test('should return AuthFailure when Google login fails with FirebaseAuthException', () async {
      // arrange
      final tException = auth.FirebaseAuthException(code: 'google-sign-in-failed');
       when(mockFirebaseAuthDataSource.getGoogleAuthCredential())
          .thenThrow(tException);
      // act
      final result = await repository.loginWithGoogle();
      // assert
       expect(result.isLeft(), true);
       result.fold(
         (failure) => expect(failure.message.contains('Đăng nhập Google thất bại'), isTrue),
         (_) => fail('Expected a failure'),
       );
      verifyNoMoreInteractions(mockFirebaseAuthDataSource);
    });
  });

  group('authStateChanges', () {
    test('should emit UserEntity? stream based on datasource stream', () {
      // arrange
      final controller = StreamController<auth.User?>();
      when(mockFirebaseAuthDataSource.authStateChanges).thenAnswer((_) => controller.stream);

      // act
      final resultStream = repository.authStateChanges;

      // assert
      expectLater(resultStream, emitsInOrder([
        isNull, // Khi datasource emit null
        isA<UserEntity>().having((u) => u.id, 'id', 'firebase-uid'), // Khi datasource emit mockFirebaseUser
        isNull, // Khi datasource emit null lần nữa
      ]));

      // Simulate emissions from datasource
      controller.add(null);
      controller.add(mockFirebaseUser);
      controller.add(null);

      controller.close();
    });
  });

  group('getCurrentUser', () {
    test('should return UserEntity when datasource returns a Firebase user', () async {
      // arrange
      when(mockFirebaseAuthDataSource.getCurrentFirebaseUser()).thenReturn(mockFirebaseUser);
      // act
      final result = await repository.getCurrentUser();
      // assert
      expect(result, isA<UserEntity>());
      expect(result?.id, 'firebase-uid');
      verify(mockFirebaseAuthDataSource.getCurrentFirebaseUser());
      verifyNoMoreInteractions(mockFirebaseAuthDataSource);
    });

    test('should return null when datasource returns null', () async {
      // arrange
      when(mockFirebaseAuthDataSource.getCurrentFirebaseUser()).thenReturn(null);
      // act
      final result = await repository.getCurrentUser();
      // assert
      expect(result, isNull);
      verify(mockFirebaseAuthDataSource.getCurrentFirebaseUser());
      verifyNoMoreInteractions(mockFirebaseAuthDataSource);
    });
  });
}
