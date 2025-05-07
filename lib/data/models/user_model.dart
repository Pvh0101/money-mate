import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:money_mate/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String email,
    required String name,
    String? photoUrl,
  }) : super(
          id: id,
          email: email,
          name: name,
          photoUrl: photoUrl,
        );

  factory UserModel.fromFirebaseUser(auth.User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? user.email?.split('@').first ?? '',
      photoUrl: user.photoURL,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLoginAt': FieldValue.serverTimestamp(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
} 