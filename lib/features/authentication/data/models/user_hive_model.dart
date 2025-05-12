import 'package:hive/hive.dart';
import 'package:money_mate/features/authentication/domain/entities/user_entity.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 3)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String? photoUrl;

  UserHiveModel({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
  });

  // Từ domain entity sang Hive model
  factory UserHiveModel.fromEntity(UserEntity user) {
    return UserHiveModel(
      id: user.id,
      email: user.email,
      name: user.name,
      photoUrl: user.photoUrl,
    );
  }

  // Từ Hive model sang domain entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
    );
  }
}
