import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/core/errors/auth_failure.dart';
import 'package:money_mate/data/datasources/firebase_auth_datasource.dart';
import 'package:money_mate/data/models/user_model.dart';
import 'package:money_mate/data/repositories/auth_repository_impl.dart';
import 'package:money_mate/domain/entities/user_entity.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([FirebaseAuthDataSource, FirebaseAuthDataSourceImpl])
void main() {
  late AuthRepositoryImpl repository;
  late MockFirebaseAuthDataSource mockFirebaseAuthDataSource;
  late MockFirebaseAuthDataSourceImpl mockFirebaseAuthDataSourceImpl;

  setUp(() {
    mockFirebaseAuthDataSource = MockFirebaseAuthDataSource();
    mockFirebaseAuthDataSourceImpl = MockFirebaseAuthDataSourceImpl();
    repository = AuthRepositoryImpl(
      authDataSource: mockFirebaseAuthDataSourceImpl,
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
  
  final tAuthCredential = GoogleAuthProvider.credential(
    idToken: 'id-token',
    accessToken: 'access-token',
  );
  
  group('registerWithEmail', () {
    test('should return UserEntity when registration is successful', () async {
      // arrange
      when(mockFirebaseAuthDataSourceImpl.registerWithEmail(any, any))
          .thenAnswer((_) async => tUserModel);
      when(mockFirebaseAuthDataSourceImpl.saveUserToFirestore(any))
          .thenAnswer((_) async => {});
      
      // act
      final result = await repository.registerWithEmail(tEmail, tPassword);
      
      // assert
      expect(result, Right<AuthFailure, UserEntity>(tUserModel));
      verify(mockFirebaseAuthDataSourceImpl.registerWithEmail(tEmail, tPassword)).called(1);
      verify(mockFirebaseAuthDataSourceImpl.saveUserToFirestore(tUserModel)).called(1);
      verifyNoMoreInteractions(mockFirebaseAuthDataSourceImpl);
    });

    test('should return AuthFailure when registration fails', () async {
      // arrange
      when(mockFirebaseAuthDataSourceImpl.registerWithEmail(any, any))
          .thenThrow(FirebaseAuthException(code: 'email-already-in-use'));
      
      // act
      final result = await repository.registerWithEmail(tEmail, tPassword);
      
      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Email đã được sử dụng bởi tài khoản khác'),
        (_) => fail('Should return a failure'),
      );
      verify(mockFirebaseAuthDataSourceImpl.registerWithEmail(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockFirebaseAuthDataSourceImpl);
    });
  });
  
  group('registerWithGoogle', () {
    test('should return UserEntity when Google registration is successful', () async {
      // arrange
      when(mockFirebaseAuthDataSourceImpl.getGoogleAuthCredential())
          .thenAnswer((_) async => tAuthCredential);
      when(mockFirebaseAuthDataSourceImpl.signInWithCredential(any))
          .thenAnswer((_) async => tUserModel);
      when(mockFirebaseAuthDataSourceImpl.saveUserToFirestore(any))
          .thenAnswer((_) async => {});
      
      // act
      final result = await repository.registerWithGoogle();
      
      // assert
      expect(result, Right<AuthFailure, UserEntity>(tUserModel));
      verify(mockFirebaseAuthDataSourceImpl.getGoogleAuthCredential()).called(1);
      verify(mockFirebaseAuthDataSourceImpl.signInWithCredential(tAuthCredential)).called(1);
      verify(mockFirebaseAuthDataSourceImpl.saveUserToFirestore(tUserModel)).called(1);
    });

    test('should return AuthFailure when user cancels Google Sign In', () async {
      // arrange
      when(mockFirebaseAuthDataSourceImpl.getGoogleAuthCredential())
          .thenAnswer((_) async => null);
      
      // act
      final result = await repository.registerWithGoogle();
      
      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Người dùng đã hủy thao tác'),
        (_) => fail('Should return a failure'),
      );
      verify(mockFirebaseAuthDataSourceImpl.getGoogleAuthCredential()).called(1);
      verifyNoMoreInteractions(mockFirebaseAuthDataSourceImpl);
    });

    test('should return AuthFailure when Google Sign In fails', () async {
      // arrange
      when(mockFirebaseAuthDataSourceImpl.getGoogleAuthCredential())
          .thenThrow(FirebaseAuthException(code: 'google-sign-in-failed'));
      
      // act
      final result = await repository.registerWithGoogle();
      
      // assert
      expect(result.isLeft(), true);
      verify(mockFirebaseAuthDataSourceImpl.getGoogleAuthCredential()).called(1);
      verifyNoMoreInteractions(mockFirebaseAuthDataSourceImpl);
    });
  });
  
  group('logout', () {
    test('should return Right(null) when logout is successful', () async {
      // arrange
      when(mockFirebaseAuthDataSourceImpl.signOut())
          .thenAnswer((_) async => {});
      
      // act
      final result = await repository.logout();
      
      // assert
      expect(result, equals(const Right<AuthFailure, void>(null)));
      verify(mockFirebaseAuthDataSourceImpl.signOut()).called(1);
      verifyNoMoreInteractions(mockFirebaseAuthDataSourceImpl);
    });

    test('should return Left(AuthFailure) when logout fails', () async {
      // arrange
      when(mockFirebaseAuthDataSourceImpl.signOut())
          .thenThrow(Exception('Logout failed'));
      
      // act
      final result = await repository.logout();
      
      // assert
      expect(result.isLeft(), true);
      verify(mockFirebaseAuthDataSourceImpl.signOut()).called(1);
      verifyNoMoreInteractions(mockFirebaseAuthDataSourceImpl);
    });
  });
  
  group('AuthFailure mapping', () {
    test('should map FirebaseAuthException to correct AuthFailure', () async {
      // arrange
      when(mockFirebaseAuthDataSourceImpl.registerWithEmail(any, any))
          .thenThrow(FirebaseAuthException(code: 'email-already-in-use'));
      
      // act
      final result = await repository.registerWithEmail(tEmail, tPassword);
      
      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Email đã được sử dụng bởi tài khoản khác'),
        (_) => fail('Should return a failure'),
      );
    });
    
    test('should map invalid-email to correct AuthFailure', () async {
      // arrange
      when(mockFirebaseAuthDataSourceImpl.registerWithEmail(any, any))
          .thenThrow(FirebaseAuthException(code: 'invalid-email'));
      
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
      when(mockFirebaseAuthDataSourceImpl.registerWithEmail(any, any))
          .thenThrow(FirebaseAuthException(code: 'weak-password'));
      
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
      when(mockFirebaseAuthDataSourceImpl.registerWithEmail(any, any))
          .thenThrow(FirebaseAuthException(code: 'unknown-code'));
      
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
} 