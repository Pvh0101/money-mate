import 'package:hive/hive.dart';
import '../../../../core/constants/default_categories.dart';
import '../../../../core/enums/category_type.dart';
import '../models/category_model.dart';
import '../models/category_hive_model.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getCategories(CategoryType type);
  Future<CategoryModel> addCategory(CategoryModel category);
  Future<void> cacheCategories(List<CategoryModel> categories);
  Future<void> clearCache();
}

class HiveCategoryLocalDataSource implements CategoryLocalDataSource {
  final Box categoriesBox;

  HiveCategoryLocalDataSource({required this.categoriesBox});

  @override
  Future<List<CategoryModel>> getCategories(CategoryType type) async {
    try {
      // Lấy các category từ Hive
      final categoryEntries = categoriesBox.values.where((model) {
        if (model is CategoryHiveModel) {
          final categoryType = CategoryType.values.firstWhere(
            (e) => e.name == model.type,
            orElse: () => CategoryType.expense,
          );
          return categoryType == type;
        }
        return false;
      }).toList();

      // Nếu không có dữ liệu trong Hive, sử dụng danh sách mặc định
      if (categoryEntries.isEmpty) {
        final defaultCategories = type == CategoryType.income
            ? defaultIncomeCategories
            : defaultExpenseCategories;

        // Lưu danh sách mặc định vào Hive
        await cacheCategories(defaultCategories);

        return defaultCategories;
      }

      // Chuyển đổi từ CategoryHiveModel sang CategoryModel
      final categories = categoryEntries.map((model) {
        final category = (model as CategoryHiveModel).toEntity();
        return CategoryModel.fromEntity(category);
      }).toList();

      return categories;
    } catch (e) {
      // Nếu có lỗi, trả về danh sách mặc định
      return type == CategoryType.income
          ? defaultIncomeCategories
          : defaultExpenseCategories;
    }
  }

  @override
  Future<CategoryModel> addCategory(CategoryModel category) async {
    try {
      // Chuyển đổi CategoryModel thành CategoryHiveModel để lưu vào Hive
      final hiveModel = CategoryHiveModel.fromEntity(category);

      // Lưu vào Hive
      await categoriesBox.put(category.id, hiveModel);

      return category;
    } catch (e) {
      throw Exception('Không thể thêm category vào local storage');
    }
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    try {
      // Xóa các category cũ có cùng loại với category đầu tiên trong danh sách
      if (categories.isNotEmpty) {
        final type = categories.first.type;

        // Lấy các key của categories cần xóa
        final keysToDelete = categoriesBox.values
            .where((model) {
              if (model is CategoryHiveModel) {
                final categoryType = CategoryType.values.firstWhere(
                  (e) => e.name == model.type,
                  orElse: () => CategoryType.expense,
                );
                return categoryType == type && !(model.isDefault);
              }
              return false;
            })
            .map((model) => (model as CategoryHiveModel).id)
            .toList();

        // Xóa các category cũ
        for (var key in keysToDelete) {
          await categoriesBox.delete(key);
        }
      }

      // Lưu danh sách categories mới
      for (var category in categories) {
        await addCategory(category);
      }
    } catch (e) {
      throw Exception('Không thể cache danh sách categories: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await categoriesBox.clear();
    } catch (e) {
      throw Exception('Không thể xóa cache categories: $e');
    }
  }
}
