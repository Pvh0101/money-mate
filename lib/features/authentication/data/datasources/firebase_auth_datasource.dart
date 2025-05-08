import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

abstract class FirebaseAuthDataSource {
  /// Đăng ký người dùng mới bằng email và mật khẩu
  Future<UserModel> registerWithEmail(String email, String password);
  
  /// Đăng ký người dùng với credential từ provider
  Future<UserModel> signInWithCredential(auth.AuthCredential credential);
  
  /// Đăng xuất người dùng hiện tại
  Future<void> signOut();
  
  /// Lưu thông tin người dùng vào Firestore
  Future<void> saveUserToFirestore(UserModel user);

  /// Đăng nhập người dùng bằng email và mật khẩu
  Future<UserModel> signInWithEmailPassword(String email, String password);

  /// Lắng nghe sự thay đổi trạng thái xác thực từ Firebase
  Stream<auth.User?> get authStateChanges;

  /// Lấy Firebase User hiện tại đang đăng nhập
  auth.User? getCurrentFirebaseUser();

  /// Lấy GoogleAuthCredential (thường được dùng cho đăng nhập/đăng ký Google)
  Future<auth.AuthCredential?> getGoogleAuthCredential();
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  
  FirebaseAuthDataSourceImpl({
    required auth.FirebaseAuth firebaseAuth,
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
        throw auth.FirebaseAuthException(
          code: 'null-user',
          message: 'Không thể tạo tài khoản người dùng',
        );
      }
      
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on auth.FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw auth.FirebaseAuthException(
        code: 'unknown',
        message: 'Đã xảy ra lỗi không xác định: ${e.toString()}',
      );
    }
  }
  
  @override
  Future<UserModel> signInWithCredential(auth.AuthCredential credential) async {
    try {
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user == null) {
        throw auth.FirebaseAuthException(
          code: 'null-user',
          message: 'Không thể đăng nhập với tài khoản này',
        );
      }
      
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on auth.FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw auth.FirebaseAuthException(
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
  @override
  Future<auth.AuthCredential?> getGoogleAuthCredential() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // Người dùng đã hủy đăng nhập
        return null;
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      return auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    } catch (e) {
      throw auth.FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: 'Đăng nhập Google thất bại: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel> signInWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw auth.FirebaseAuthException(
          code: 'null-user',
          message: 'Đăng nhập không thành công, không có thông tin người dùng.',
        );
      }
      // Cập nhật lastLoginAt trong Firestore sau khi đăng nhập thành công
      // Lưu ý: Việc này có thể làm chậm quá trình trả về UserModel một chút
      // Bạn có thể chọn thực hiện việc này một cách bất đồng bộ mà không cần await
      try {
         await _firestore.collection('users').doc(userCredential.user!.uid).set(
           {'lastLoginAt': FieldValue.serverTimestamp()},
           SetOptions(merge: true),
         );
      } catch (firestoreError) {
         // Ghi log lỗi cập nhật Firestore nhưng không làm gián đoạn luồng đăng nhập
         print('Lỗi cập nhật lastLoginAt: $firestoreError');
      }

      return UserModel.fromFirebaseUser(userCredential.user!); 
    } on auth.FirebaseAuthException catch (e) {
      // Re-throw specific Firebase exceptions for the repository to map
      throw e;
    } catch (e) {
      // Catch-all for other potential errors
      throw auth.FirebaseAuthException(
        code: 'unknown-sign-in-error',
        message: 'Đã xảy ra lỗi không xác định khi đăng nhập: ${e.toString()}',
      );
    }
  }

  @override
  Stream<auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  auth.User? getCurrentFirebaseUser() => _firebaseAuth.currentUser;
} 