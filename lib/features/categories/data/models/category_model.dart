import '../../../../core/enums/category_type.dart';
import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required String id,
    required String name,
    required String iconName,
    required CategoryType type,
    bool isDefault = false,
    String? userId,
  }) : super(
          id: id,
          name: name,
          iconName: iconName,
          type: type,
          isDefault: isDefault,
          userId: userId,
        );

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      iconName: category.iconName,
      type: category.type,
      isDefault: category.isDefault,
      userId: category.userId,
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      iconName: json['iconName'],
      type: CategoryType.values.byName(json['type']),
      isDefault: json['isDefault'] ?? false,
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'type': type.name,
      'isDefault': isDefault,
      'userId': userId,
    };
  }
}
