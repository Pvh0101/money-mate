import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/default_categories.dart';
import '../../../../core/enums/category_type.dart';
import '../models/category_model.dart';

abstract class CategoryDataSource {
  Future<List<CategoryModel>> getCategories(CategoryType type);
  Future<CategoryModel> addCategory(CategoryModel category);
}

class CategoryLocalDataSource implements CategoryDataSource {
  @override
  Future<List<CategoryModel>> getCategories(CategoryType type) async {
    try {
      final categories = type == CategoryType.income
          ? defaultIncomeCategories
          : defaultExpenseCategories;
      return Future.value(categories);
    } catch (e) {
      throw Exception('Không thể lấy danh sách category từ local');
    }
  }

  @override
  Future<CategoryModel> addCategory(CategoryModel category) {
    throw UnimplementedError('Local data source không hỗ trợ thêm category');
  }
}

class CategoryRemoteDataSource implements CategoryDataSource {
  final FirebaseFirestore firestore;

  CategoryRemoteDataSource({required this.firestore});

  @override
  Future<List<CategoryModel>> getCategories(CategoryType type) async {
    try {
      final snapshot = await firestore
          .collection('categories')
          .where('type', isEqualTo: type.name)
          .where('isDefault', isEqualTo: false)
          .get();

      return snapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách category từ server');
    }
  }

  @override
  Future<CategoryModel> addCategory(CategoryModel category) async {
    try {
      await firestore
          .collection('categories')
          .doc(category.id)
          .set(category.toJson());
      return category;
    } catch (e) {
      throw Exception('Không thể thêm category vào server');
    }
  }
}
