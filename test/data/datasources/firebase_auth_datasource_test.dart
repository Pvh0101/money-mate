import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/feartures/authentication/data/datasources/firebase_auth_datasource.dart';
import 'package:money_mate/feartures/authentication/data/models/user_model.dart';

import 'firebase_auth_datasource_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  UserCredential,
  User,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
])
void main() {
  late FirebaseAuthDataSourceImpl dataSource;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockGoogleSignInAccount mockGoogleSignInAccount;
  late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockGoogleSignIn = MockGoogleSignIn();
    mockCollectionReference = MockCollectionReference<Map<String, dynamic>>();
    mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
    
    dataSource = FirebaseAuthDataSourceImpl(
      firebaseAuth: mockFirebaseAuth,
      firestore: mockFirestore,
      googleSignIn: mockGoogleSignIn,
    );
    
    // Mocking chung
    when(mockFirestore.collection(any)).thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
    when(mockDocumentReference.set(any, any)).thenAnswer((_) async => {});
  });

  const tEmail = 'test@example.com';
  const tPassword = 'Password123!';
  const tDisplayName = 'Test User';
  const tPhotoUrl = 'https://example.com/photo.jpg';
  const tUid = 'test-uid';
  
  group('registerWithEmail', () {
    setUp(() {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn(tUid);
      when(mockUser.email).thenReturn(tEmail);
      when(mockUser.displayName).thenReturn(tDisplayName);
      when(mockUser.photoURL).thenReturn(tPhotoUrl);
    });

    test('should call FirebaseAuth.createUserWithEmailAndPassword with correct parameters', () async {
      // act
      await dataSource.registerWithEmail(tEmail, tPassword);
      
      // assert
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      )).called(1);
    });
    
    test('should return UserModel with correct data when successful', () async {
      // act
      final result = await dataSource.registerWithEmail(tEmail, tPassword);
      
      // assert
      expect(result, isA<UserModel>());
      expect(result.id, tUid);
      expect(result.email, tEmail);
      expect(result.name, tDisplayName);
      expect(result.photoUrl, tPhotoUrl);
    });
    
    test('should throw FirebaseAuthException when user is null', () async {
      // arrange
      when(mockUserCredential.user).thenReturn(null);
      
      // act & assert
      expect(
        () => dataSource.registerWithEmail(tEmail, tPassword),
        throwsA(isA<FirebaseAuthException>().having(
          (e) => e.code,
          'code',
          'null-user',
        )),
      );
    });
    
    test('should rethrow FirebaseAuthException when createUserWithEmailAndPassword fails', () async {
      // arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));
      
      // act & assert
      expect(
        () => dataSource.registerWithEmail(tEmail, tPassword),
        throwsA(isA<FirebaseAuthException>().having(
          (e) => e.code,
          'code',
          'email-already-in-use',
        )),
      );
    });
  });
  
  group('signInWithCredential', () {
    final tAuthCredential = GoogleAuthProvider.credential(
      idToken: 'id-token',
      accessToken: 'access-token',
    );
    
    setUp(() {
      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn(tUid);
      when(mockUser.email).thenReturn(tEmail);
      when(mockUser.displayName).thenReturn(tDisplayName);
      when(mockUser.photoURL).thenReturn(tPhotoUrl);
    });
    
    test('should call FirebaseAuth.signInWithCredential with correct credential', () async {
      // act
      await dataSource.signInWithCredential(tAuthCredential);
      
      // assert
      verify(mockFirebaseAuth.signInWithCredential(tAuthCredential)).called(1);
    });
    
    test('should return UserModel with correct data when successful', () async {
      // act
      final result = await dataSource.signInWithCredential(tAuthCredential);
      
      // assert
      expect(result, isA<UserModel>());
      expect(result.id, tUid);
      expect(result.email, tEmail);
      expect(result.name, tDisplayName);
      expect(result.photoUrl, tPhotoUrl);
    });
    
    test('should throw FirebaseAuthException when user is null', () async {
      // arrange
      when(mockUserCredential.user).thenReturn(null);
      
      // act & assert
      expect(
        () => dataSource.signInWithCredential(tAuthCredential),
        throwsA(isA<FirebaseAuthException>().having(
          (e) => e.code,
          'code',
          'null-user',
        )),
      );
    });
  });
  
  group('saveUserToFirestore', () {
    final tUserModel = UserModel(
      id: tUid,
      email: tEmail,
      name: tDisplayName,
      photoUrl: tPhotoUrl,
    );
    
    test('should call Firestore with correct parameters', () async {
      // act
      await dataSource.saveUserToFirestore(tUserModel);
      
      // assert
      verify(mockFirestore.collection('users')).called(1);
      verify(mockCollectionReference.doc(tUid)).called(1);
      verify(mockDocumentReference.set(any, any)).called(1);
    });
    
    test('should throw FirebaseException when Firestore operation fails', () async {
      // arrange
      when(mockDocumentReference.set(any, any))
          .thenThrow(FirebaseException(plugin: 'firestore', code: 'write-error'));
      
      // act & assert
      expect(
        () => dataSource.saveUserToFirestore(tUserModel),
        throwsA(isA<FirebaseException>().having(
          (e) => e.code,
          'code',
          'write-error',
        )),
      );
    });
  });
  
  group('getGoogleAuthCredential', () {
    setUp(() {
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(mockGoogleSignInAuthentication.idToken).thenReturn('id-token');
      when(mockGoogleSignInAuthentication.accessToken).thenReturn('access-token');
    });
    
    test('should return AuthCredential when Google Sign In is successful', () async {
      // act
      final result = await dataSource.getGoogleAuthCredential();
      
      // assert
      expect(result, isA<AuthCredential>());
      verify(mockGoogleSignIn.signIn()).called(1);
      verify(mockGoogleSignInAccount.authentication).called(1);
    });
    
    test('should return null when user cancels Google Sign In', () async {
      // arrange
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);
      
      // act
      final result = await dataSource.getGoogleAuthCredential();
      
      // assert
      expect(result, isNull);
      verify(mockGoogleSignIn.signIn()).called(1);
    });
    
    test('should throw FirebaseAuthException when Google Sign In fails', () async {
      // arrange
      when(mockGoogleSignIn.signIn()).thenThrow(Exception('Google Sign In failed'));
      
      // act & assert
      expect(
        () => dataSource.getGoogleAuthCredential(),
        throwsA(isA<FirebaseAuthException>().having(
          (e) => e.code,
          'code',
          'google-sign-in-failed',
        )),
      );
    });
  });
  
  group('signOut', () {
    test('should call signOut on FirebaseAuth and GoogleSignIn', () async {
      // arrange
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async => {});
      when(mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
      
      // act
      await dataSource.signOut();
      
      // assert
      verify(mockGoogleSignIn.signOut()).called(1);
      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });
} 