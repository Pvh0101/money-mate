// Mocks generated by Mockito 5.4.5 from annotations
// in money_mate/test/data/repositories/auth_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:firebase_auth/firebase_auth.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:money_mate/features/authentication/data/datasources/firebase_auth_datasource.dart'
    as _i3;
import 'package:money_mate/features/authentication/data/models/user_model.dart'
    as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeUserModel_0 extends _i1.SmartFake implements _i2.UserModel {
  _FakeUserModel_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [FirebaseAuthDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseAuthDataSource extends _i1.Mock
    implements _i3.FirebaseAuthDataSource {
  MockFirebaseAuthDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<_i5.User?> get authStateChanges => (super.noSuchMethod(
        Invocation.getter(#authStateChanges),
        returnValue: _i4.Stream<_i5.User?>.empty(),
      ) as _i4.Stream<_i5.User?>);

  @override
  _i4.Future<_i2.UserModel> registerWithEmail(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #registerWithEmail,
          [
            email,
            password,
          ],
        ),
        returnValue: _i4.Future<_i2.UserModel>.value(_FakeUserModel_0(
          this,
          Invocation.method(
            #registerWithEmail,
            [
              email,
              password,
            ],
          ),
        )),
      ) as _i4.Future<_i2.UserModel>);

  @override
  _i4.Future<_i2.UserModel> signInWithCredential(
          _i5.AuthCredential? credential) =>
      (super.noSuchMethod(
        Invocation.method(
          #signInWithCredential,
          [credential],
        ),
        returnValue: _i4.Future<_i2.UserModel>.value(_FakeUserModel_0(
          this,
          Invocation.method(
            #signInWithCredential,
            [credential],
          ),
        )),
      ) as _i4.Future<_i2.UserModel>);

  @override
  _i4.Future<void> signOut() => (super.noSuchMethod(
        Invocation.method(
          #signOut,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> saveUserToFirestore(_i2.UserModel? user) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveUserToFirestore,
          [user],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<_i2.UserModel> signInWithEmailPassword(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #signInWithEmailPassword,
          [
            email,
            password,
          ],
        ),
        returnValue: _i4.Future<_i2.UserModel>.value(_FakeUserModel_0(
          this,
          Invocation.method(
            #signInWithEmailPassword,
            [
              email,
              password,
            ],
          ),
        )),
      ) as _i4.Future<_i2.UserModel>);

  @override
  _i4.Future<_i5.AuthCredential?> getGoogleAuthCredential() =>
      (super.noSuchMethod(
        Invocation.method(
          #getGoogleAuthCredential,
          [],
        ),
        returnValue: _i4.Future<_i5.AuthCredential?>.value(),
      ) as _i4.Future<_i5.AuthCredential?>);
}
