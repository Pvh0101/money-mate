import 'package:dartz/dartz.dart';
import '../../../../core/enums/category_type.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_datasource.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;
  final CategoryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CategoryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Category>>> getCategories(
      CategoryType type) async {
    try {
      if (await networkInfo.isConnected) {
        // Lấy tất cả category từ local (default) và remote
        final localCategories = await localDataSource.getCategories(type);
        final remoteCategories = await remoteDataSource.getCategories(type);

        final allCategories = [...localCategories, ...remoteCategories];
        return Right(allCategories);
      } else {
        // Nếu không có internet, chỉ lấy từ local
        final localCategories = await localDataSource.getCategories(type);
        return Right(localCategories);
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Category>> addCategory(Category category) async {
    try {
      if (await networkInfo.isConnected) {
        final categoryModel = CategoryModel.fromEntity(category);
        final newCategory = await remoteDataSource.addCategory(categoryModel);
        return Right(newCategory);
      } else {
        return Left(NetworkFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
