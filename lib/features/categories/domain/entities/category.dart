import 'package:equatable/equatable.dart';
import '../../../../core/enums/category_type.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String iconName;
  final CategoryType type;
  final bool isDefault;
  final String? userId;

  const Category({
    required this.id,
    required this.name,
    required this.iconName,
    required this.type,
    this.isDefault = false,
    this.userId,
  });

  @override
  List<Object?> get props => [id, name, iconName, type, isDefault, userId];
}
