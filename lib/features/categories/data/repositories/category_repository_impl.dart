import 'package:dartz/dartz.dart';
import '../../../../core/enums/category_type.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_datasource.dart';
import '../datasources/category_remote_datasource.dart';
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
      // Offline-first: Luôn lấy dữ liệu từ local trước
      final localCategoryModels = await localDataSource.getCategories(type);

      // Đồng bộ với remote trong nền nếu có kết nối
      _syncWithRemoteIfConnected(type);

      // Chuyển đổi từ CategoryModel (data layer) sang Category (domain layer)
      final categories = localCategoryModels
          .map((model) => Category(
                id: model.id,
                name: model.name,
                iconName: model.iconName,
                type: model.type,
                isDefault: model.isDefault,
                userId: model.userId,
              ))
          .toList();

      // Trả về entities (domain objects) thay vì models (data objects)
      return Right(categories);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  // Phương thức đồng bộ dữ liệu với remote trong nền
  Future<void> _syncWithRemoteIfConnected(CategoryType type) async {
    if (await networkInfo.isConnected) {
      try {
        // Lấy dữ liệu từ remote
        final remoteCategoryModels = await remoteDataSource.getCategories(type);

        // Lấy dữ liệu từ local để xác định các category mặc định
        final localCategoryModels = await localDataSource.getCategories(type);

        // Lọc ra các category mặc định từ local
        final defaultCategories = localCategoryModels
            .where((category) => category.isDefault)
            .toList();

        // Lọc ra các category không phải mặc định từ remote
        final nonDefaultRemoteCategories = remoteCategoryModels
            .where((category) => !category.isDefault)
            .toList();

        // Cập nhật cache với dữ liệu mới từ remote
        if (nonDefaultRemoteCategories.isNotEmpty) {
          await localDataSource.cacheCategories(nonDefaultRemoteCategories);
        }
      } catch (e) {
        // Xử lý lỗi đồng bộ trong nền, không ảnh hưởng đến user flow
        print('Lỗi đồng bộ dữ liệu với remote: $e');
      }
    }
  }

  @override
  Future<Either<Failure, Category>> addCategory(Category category) async {
    try {
      // Chuyển đổi từ domain entity sang data model
      final categoryModel = CategoryModel.fromEntity(category);

      // Offline-first: Luôn thêm vào local trước
      final savedCategoryModel =
          await localDataSource.addCategory(categoryModel);

      // Đồng bộ với remote trong nền nếu có kết nối
      _syncAddedCategoryWithRemote(savedCategoryModel);

      // Chuyển đổi lại từ model (data layer) sang entity (domain layer)
      final savedCategory = Category(
        id: savedCategoryModel.id,
        name: savedCategoryModel.name,
        iconName: savedCategoryModel.iconName,
        type: savedCategoryModel.type,
        isDefault: savedCategoryModel.isDefault,
        userId: savedCategoryModel.userId,
      );

      // Trả về entity cho domain layer
      return Right(savedCategory);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  // Phương thức đồng bộ category mới thêm với remote trong nền
  Future<void> _syncAddedCategoryWithRemote(CategoryModel categoryModel) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addCategory(categoryModel);
      } catch (e) {
        // Xử lý lỗi đồng bộ trong nền, không ảnh hưởng đến user flow
        print('Lỗi đồng bộ category mới với remote: $e');
      }
    }
  }
}
