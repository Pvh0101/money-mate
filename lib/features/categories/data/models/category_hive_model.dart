import 'package:hive/hive.dart';
import 'package:money_mate/core/enums/category_type.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';

part 'category_hive_model.g.dart';

@HiveType(typeId: 2)
class CategoryHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String iconName;

  @HiveField(3)
  final String type; // Lưu dưới dạng string vì enum không được hỗ trợ trực tiếp

  @HiveField(4)
  final String? userId;

  @HiveField(5)
  final bool isDefault;

  CategoryHiveModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.type,
    this.userId,
    required this.isDefault,
  });

  // Từ domain entity sang Hive model
  factory CategoryHiveModel.fromEntity(Category category) {
    return CategoryHiveModel(
      id: category.id,
      name: category.name,
      iconName: category.iconName,
      type: category.type.name,
      userId: category.userId,
      isDefault: category.isDefault,
    );
  }

  // Từ Hive model sang domain entity
  Category toEntity() {
    return Category(
      id: id,
      name: name,
      iconName: iconName,
      type: CategoryType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => CategoryType.expense,
      ),
      userId: userId,
      isDefault: isDefault,
    );
  }
}
