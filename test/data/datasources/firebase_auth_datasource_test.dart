import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/features/authentication/data/datasources/firebase_auth_datasource.dart';
import 'package:money_mate/features/authentication/data/models/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'firebase_auth_datasource_test.mocks.dart';

@GenerateMocks([
  auth.FirebaseAuth,
  auth.User,
  auth.UserCredential,
  FirebaseFirestore,
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
])
void main() {
  late FirebaseAuthDataSourceImpl dataSource;
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirestore;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late MockGoogleSignInAccount mockGoogleSignInAccount;
  late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;

  const tEmail = 'test@example.com';
  const tPassword = 'Password123!';
  const tUid = 'test-uid';
  const tDisplayName = 'Test User';
  const tPhotoUrl = 'test-photo-url';

  final tUserModel = UserModel(
    id: tUid,
    email: tEmail,
    name: tDisplayName,
    photoUrl: tPhotoUrl,
  );

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeFirestore = FakeFirebaseFirestore();
    mockGoogleSignIn = MockGoogleSignIn();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();

    dataSource = FirebaseAuthDataSourceImpl(
      firebaseAuth: mockFirebaseAuth,
      firestore: fakeFirestore,
      googleSignIn: mockGoogleSignIn,
    );

    when(mockUser.uid).thenReturn(tUid);
    when(mockUser.email).thenReturn(tEmail);
    when(mockUser.displayName).thenReturn(tDisplayName);
    when(mockUser.photoURL).thenReturn(tPhotoUrl);
  });

  group('registerWithEmail', () {
    setUp(() {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);
    });

    test(
        'should call FirebaseAuth.createUserWithEmailAndPassword with correct parameters',
        () async {
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
        throwsA(isA<auth.FirebaseAuthException>().having(
          (e) => e.code,
          'code',
          'null-user',
        )),
      );
    });

    test(
        'should rethrow FirebaseAuthException when createUserWithEmailAndPassword fails',
        () async {
      // arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(auth.FirebaseAuthException(code: 'email-already-in-use'));

      // act & assert
      expect(
        () => dataSource.registerWithEmail(tEmail, tPassword),
        throwsA(isA<auth.FirebaseAuthException>().having(
          (e) => e.code,
          'code',
          'email-already-in-use',
        )),
      );
    });
  });

  group('signInWithCredential', () {
    final tAuthCredential = auth.GoogleAuthProvider.credential(
      idToken: 'id-token',
      accessToken: 'access-token',
    );

    setUp(() {
      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);
    });

    test(
        'should call FirebaseAuth.signInWithCredential with correct credential',
        () async {
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
        throwsA(isA<auth.FirebaseAuthException>().having(
          (e) => e.code,
          'code',
          'null-user',
        )),
      );
    });
  });

  group('saveUserToFirestore', () {
    test('should call Firestore with correct parameters', () async {
      // act
      await dataSource.saveUserToFirestore(tUserModel);

      // assert
      final doc = await fakeFirestore.collection('users').doc(tUid).get();
      expect(doc.exists, isTrue);
      expect(doc.data()?['email'], tEmail);
    });

    test('should throw Exception (mapped to FirebaseAuthException) when Firestore operation fails during sign in flow',
        () async {
       // Arrange: Mock signInWithCredential để throw lỗi Firestore bị bắt và map lại
       when(mockFirebaseAuth.signInWithCredential(any))
         .thenThrow(auth.FirebaseAuthException(code: 'unknown', message: 'Lỗi Firestore khi đăng nhập')); // Giả lập lỗi đã được map

       // act & assert
       expect(
         // Test thông qua một flow gọi đến nó, ví dụ signInWithCredential
         () => dataSource.signInWithCredential(auth.GoogleAuthProvider.credential(idToken: 't', accessToken: 't')), 
         // Mong đợi FirebaseAuthException với code 'unknown' vì lỗi Firestore bị bắt và map lại trong signInWithCredential
         throwsA(isA<auth.FirebaseAuthException>().having((e) => e.code, 'code', 'unknown')),
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
      when(mockGoogleSignInAuthentication.accessToken)
          .thenReturn('access-token');
    });

    test('should return AuthCredential when Google Sign In is successful',
        () async {
      // act
      final result = await dataSource.getGoogleAuthCredential();

      // assert
      expect(result, isA<auth.AuthCredential>());
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

    test('should throw FirebaseAuthException when Google Sign In fails',
        () async {
      // arrange
      when(mockGoogleSignIn.signIn())
          .thenThrow(Exception('Google Sign In failed'));

      // act & assert
      expect(
        () => dataSource.getGoogleAuthCredential(),
        throwsA(isA<auth.FirebaseAuthException>().having(
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

  group('signInWithEmailPassword', () {
    setUp(() {
       when(mockUserCredential.user).thenReturn(mockUser);
    });

    test('should call FirebaseAuth.signInWithEmailAndPassword and return UserModel on success', () async {
      // arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(email: tEmail, password: tPassword))
          .thenAnswer((_) async => mockUserCredential);
      // act
      final result = await dataSource.signInWithEmailPassword(tEmail, tPassword);
      // assert
      expect(result, isA<UserModel>());
      expect(result.id, tUid);
      verify(mockFirebaseAuth.signInWithEmailAndPassword(email: tEmail, password: tPassword));
      // Verify Firestore update for lastLoginAt (using FakeFirestore)
      final userDoc = await fakeFirestore.collection('users').doc(tUid).get();
      expect(userDoc.exists, true);
      expect(userDoc.data()?['lastLoginAt'], isNotNull); 
    });

    test('should throw FirebaseAuthException with code "null-user" when userCredential.user is null', () async {
      // arrange
      when(mockUserCredential.user).thenReturn(null); // Simulate null user
      when(mockFirebaseAuth.signInWithEmailAndPassword(email: tEmail, password: tPassword))
          .thenAnswer((_) async => mockUserCredential);
      // act & assert
      final call = dataSource.signInWithEmailPassword;
      expect(() => call(tEmail, tPassword), throwsA(isA<auth.FirebaseAuthException>().having((e) => e.code, 'code', 'null-user')));
    });

    test('should re-throw specific FirebaseAuthException from FirebaseAuth', () async {
      // arrange
      final tException = auth.FirebaseAuthException(code: 'user-not-found');
      when(mockFirebaseAuth.signInWithEmailAndPassword(email: tEmail, password: tPassword))
          .thenThrow(tException);
      // act & assert
      final call = dataSource.signInWithEmailPassword;
      expect(() => call(tEmail, tPassword), throwsA(isA<auth.FirebaseAuthException>().having((e) => e.code, 'code', 'user-not-found')));
    });

    test('should throw FirebaseAuthException with code "unknown-sign-in-error" for other exceptions', () async {
      // arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(email: tEmail, password: tPassword))
          .thenThrow(Exception('Some random error'));
      // act & assert
      final call = dataSource.signInWithEmailPassword;
      expect(() => call(tEmail, tPassword), throwsA(isA<auth.FirebaseAuthException>().having((e) => e.code, 'code', 'unknown-sign-in-error')));
    });
  });

  group('authStateChanges', () {
    test('should return the stream from FirebaseAuth.authStateChanges', () {
      // arrange
      final expectedStream = Stream<auth.User?>.value(mockUser);
      when(mockFirebaseAuth.authStateChanges()).thenAnswer((_) => expectedStream);
      // act
      final result = dataSource.authStateChanges;
      // assert
      expect(result, equals(expectedStream));
      verify(mockFirebaseAuth.authStateChanges());
    });
  });

  group('getCurrentFirebaseUser', () {
    test('should return the user from FirebaseAuth.currentUser when user is logged in', () {
      // arrange
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      // act
      final result = dataSource.getCurrentFirebaseUser();
      // assert
      expect(result, equals(mockUser));
      verify(mockFirebaseAuth.currentUser);
    });

     test('should return null from FirebaseAuth.currentUser when user is not logged in', () {
      // arrange
      when(mockFirebaseAuth.currentUser).thenReturn(null);
      // act
      final result = dataSource.getCurrentFirebaseUser();
      // assert
      expect(result, isNull);
      verify(mockFirebaseAuth.currentUser);
    });
  });
}
