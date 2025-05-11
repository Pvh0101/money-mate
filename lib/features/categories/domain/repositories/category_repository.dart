import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/enums/category_type.dart';
import '../entities/category.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories(CategoryType type);
  Future<Either<Failure, Category>> addCategory(Category category);
}
