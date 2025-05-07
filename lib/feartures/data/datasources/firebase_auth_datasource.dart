import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

abstract class FirebaseAuthDataSource {
  /// Đăng ký người dùng mới bằng email và mật khẩu
  Future<UserModel> registerWithEmail(String email, String password);
  
  /// Đăng ký người dùng với credential từ provider
  Future<UserModel> signInWithCredential(AuthCredential credential);
  
  /// Đăng xuất người dùng hiện tại
  Future<void> signOut();
  
  /// Lưu thông tin người dùng vào Firestore
  Future<void> saveUserToFirestore(UserModel user);
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  
  FirebaseAuthDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _googleSignIn = googleSignIn;
  
  @override
  Future<UserModel> registerWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw FirebaseAuthException(
          code: 'null-user',
          message: 'Không thể tạo tài khoản người dùng',
        );
      }
      
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'Đã xảy ra lỗi không xác định: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<UserModel> signInWithCredential(AuthCredential credential) async {
    try {
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user == null) {
        throw FirebaseAuthException(
          code: 'null-user',
          message: 'Không thể đăng nhập với tài khoản này',
        );
      }
      
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'Đã xảy ra lỗi không xác định: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
  
  @override
  Future<void> saveUserToFirestore(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(
        user.toJson(),
        SetOptions(merge: true),
      );
    } catch (e) {
      throw FirebaseException(
        plugin: 'firestore',
        code: 'write-error',
        message: 'Không thể lưu thông tin người dùng: ${e.toString()}',
      );
    }
  }
  
  /// Lấy GoogleAuthCredential từ quá trình đăng nhập với Google
  Future<AuthCredential?> getGoogleAuthCredential() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // Người dùng đã hủy đăng nhập
        return null;
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      return GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    } catch (e) {
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: 'Đăng nhập Google thất bại: ${e.toString()}',
      );
    }
  }
} 