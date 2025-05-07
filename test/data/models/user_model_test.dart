import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/features/authentication/data/models/user_model.dart';
import 'package:money_mate/features/authentication/domain/entities/user_entity.dart';

import 'user_model_test.mocks.dart';

@GenerateMocks([auth.User])
void main() {
  const tId = 'test-id';
  const tEmail = 'test@example.com';
  const tName = 'Test User';
  const tPhotoUrl = 'https://example.com/photo.jpg';

  group('UserModel', () {
    test('should be a subclass of UserEntity', () {
      // arrange
      final userModel = UserModel(
        id: tId,
        email: tEmail,
        name: tName,
        photoUrl: tPhotoUrl,
      );

      // assert
      expect(userModel, isA<UserEntity>());
    });

    test('should create a valid UserModel from JSON', () {
      // arrange
      final json = {
        'id': tId,
        'email': tEmail,
        'name': tName,
        'photoUrl': tPhotoUrl,
      };

      // act
      final result = UserModel.fromJson(json);

      // assert
      expect(result.id, tId);
      expect(result.email, tEmail);
      expect(result.name, tName);
      expect(result.photoUrl, tPhotoUrl);
    });

    test('should convert UserModel to JSON with timestamps', () {
      // arrange
      final userModel = UserModel(
        id: tId,
        email: tEmail,
        name: tName,
        photoUrl: tPhotoUrl,
      );

      // act
      final result = userModel.toJson();

      // assert
      expect(result['id'], tId);
      expect(result['email'], tEmail);
      expect(result['name'], tName);
      expect(result['photoUrl'], tPhotoUrl);
      expect(result['createdAt'], isA<FieldValue>());
      expect(result['lastLoginAt'], isA<FieldValue>());
    });

    group('fromFirebaseUser', () {
      late MockUser mockUser;

      setUp(() {
        mockUser = MockUser();
      });

      test('should create a valid UserModel from Firebase User with all fields',
          () {
        // arrange
        when(mockUser.uid).thenReturn(tId);
        when(mockUser.email).thenReturn(tEmail);
        when(mockUser.displayName).thenReturn(tName);
        when(mockUser.photoURL).thenReturn(tPhotoUrl);

        // act
        final result = UserModel.fromFirebaseUser(mockUser);

        // assert
        expect(result.id, tId);
        expect(result.email, tEmail);
        expect(result.name, tName);
        expect(result.photoUrl, tPhotoUrl);
      });

      test(
          'should create a valid UserModel from Firebase User with minimal fields',
          () {
        // arrange
        when(mockUser.uid).thenReturn(tId);
        when(mockUser.email).thenReturn(tEmail);
        when(mockUser.displayName).thenReturn(null);
        when(mockUser.photoURL).thenReturn(null);

        // act
        final result = UserModel.fromFirebaseUser(mockUser);

        // assert
        expect(result.id, tId);
        expect(result.email, tEmail);
        expect(result.name, 'test'); // Uses first part of email
        expect(result.photoUrl, isNull);
      });

      test('should use empty email and create name if email is null', () {
        // arrange
        when(mockUser.uid).thenReturn(tId);
        when(mockUser.email).thenReturn(null);
        when(mockUser.displayName).thenReturn(null);
        when(mockUser.photoURL).thenReturn(null);

        // act
        final result = UserModel.fromFirebaseUser(mockUser);

        // assert
        expect(result.id, tId);
        expect(result.email, '');
        expect(result.name, '');
        expect(result.photoUrl, isNull);
      });
    });

    test('copyWith should return a new UserModel with updated fields', () {
      // arrange
      final userModel = UserModel(
        id: tId,
        email: tEmail,
        name: tName,
        photoUrl: tPhotoUrl,
      );

      // act
      final updatedModel = userModel.copyWith(
        name: 'New Name',
        photoUrl: 'new-photo.jpg',
      );

      // assert
      expect(updatedModel.id, tId);
      expect(updatedModel.email, tEmail);
      expect(updatedModel.name, 'New Name');
      expect(updatedModel.photoUrl, 'new-photo.jpg');
    });

    test('copyWith should not change fields when not provided', () {
      // arrange
      final userModel = UserModel(
        id: tId,
        email: tEmail,
        name: tName,
        photoUrl: tPhotoUrl,
      );

      // act
      final updatedModel = userModel.copyWith();

      // assert
      expect(updatedModel.id, tId);
      expect(updatedModel.email, tEmail);
      expect(updatedModel.name, tName);
      expect(updatedModel.photoUrl, tPhotoUrl);
    });
  });
}
