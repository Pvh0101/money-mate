import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_mate/core/enums/category_type.dart';
import 'package:money_mate/core/errors/exceptions.dart';
import 'package:money_mate/core/errors/failures.dart';
import 'package:money_mate/core/network/network_info.dart';
import 'package:money_mate/features/categories/data/datasources/category_datasource.dart';
import 'package:money_mate/features/categories/data/models/category_model.dart';
import 'package:money_mate/features/categories/data/repositories/category_repository_impl.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';

class MockCategoryLocalDataSource extends Mock
    implements CategoryLocalDataSource {}

class MockCategoryRemoteDataSource extends Mock
    implements CategoryRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

// Extension cho Either để dễ dàng truy cập giá trị
extension EitherX<L, R> on Either<L, R> {
  R getRight() => (this as Right<L, R>).value;
  L getLeft() => (this as Left<L, R>).value;
}

void main() {
  late CategoryRepositoryImpl repository;
  late MockCategoryLocalDataSource mockLocalDataSource;
  late MockCategoryRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(CategoryType.expense);
    registerFallbackValue(const CategoryModel(
      id: 'dummy_id',
      name: 'Dummy Category',
      iconName: 'dummy_icon',
      type: CategoryType.expense,
    ));
  });

  setUp(() {
    mockLocalDataSource = MockCategoryLocalDataSource();
    mockRemoteDataSource = MockCategoryRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CategoryRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tCategoryType = CategoryType.expense;
  const tCategoryModel = CategoryModel(
    id: 'test_id',
    name: 'Test Category',
    iconName: 'test_icon',
    type: CategoryType.expense,
  );
  const tCategory = tCategoryModel;
  final tLocalCategories = [tCategoryModel];
  final tRemoteCategories = [
    const CategoryModel(
      id: 'remote_id',
      name: 'Remote Category',
      iconName: 'remote_icon',
      type: CategoryType.expense,
    ),
  ];

  group('getCategories', () {
    test(
      'nên kiểm tra kết nối internet',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockLocalDataSource.getCategories(tCategoryType))
            .thenAnswer((_) async => tLocalCategories);
        when(() => mockRemoteDataSource.getCategories(tCategoryType))
            .thenAnswer((_) async => tRemoteCategories);

        // act
        await repository.getCategories(tCategoryType);

        // assert
        verify(() => mockNetworkInfo.isConnected).called(1);
      },
    );

    group('thiết bị trực tuyến', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'nên trả về danh sách categories từ cả local và remote khi có kết nối internet',
        () async {
          // arrange
          when(() => mockLocalDataSource.getCategories(tCategoryType))
              .thenAnswer((_) async => tLocalCategories);
          when(() => mockRemoteDataSource.getCategories(tCategoryType))
              .thenAnswer((_) async => tRemoteCategories);

          // act
          final result = await repository.getCategories(tCategoryType);

          // assert
          verify(() => mockLocalDataSource.getCategories(tCategoryType))
              .called(1);
          verify(() => mockRemoteDataSource.getCategories(tCategoryType))
              .called(1);
          expect(result.isRight(), true);
          final categories = result.getRight();
          expect(categories.length,
              equals(tLocalCategories.length + tRemoteCategories.length));
        },
      );

      test(
        'nên trả về ServerFailure khi gọi remote data source thất bại',
        () async {
          // arrange
          when(() => mockLocalDataSource.getCategories(tCategoryType))
              .thenAnswer((_) async => tLocalCategories);
          when(() => mockRemoteDataSource.getCategories(tCategoryType))
              .thenThrow(Exception());

          // act
          final result = await repository.getCategories(tCategoryType);

          // assert
          verify(() => mockLocalDataSource.getCategories(tCategoryType))
              .called(1);
          verify(() => mockRemoteDataSource.getCategories(tCategoryType))
              .called(1);
          expect(result.isLeft(), true);
          expect(
              result.fold(
                (failure) => failure,
                (_) => null,
              ),
              isA<ServerFailure>());
        },
      );
    });

    group('thiết bị ngoại tuyến', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'nên trả về danh sách categories chỉ từ local khi không có kết nối internet',
        () async {
          // arrange
          when(() => mockLocalDataSource.getCategories(tCategoryType))
              .thenAnswer((_) async => tLocalCategories);

          // act
          final result = await repository.getCategories(tCategoryType);

          // assert
          verify(() => mockLocalDataSource.getCategories(tCategoryType))
              .called(1);
          verifyNever(() => mockRemoteDataSource.getCategories(tCategoryType));
          expect(result, Right(tLocalCategories));
        },
      );

      test(
        'nên trả về ServerFailure khi gọi local data source thất bại',
        () async {
          // arrange
          when(() => mockLocalDataSource.getCategories(tCategoryType))
              .thenThrow(Exception());

          // act
          final result = await repository.getCategories(tCategoryType);

          // assert
          verify(() => mockLocalDataSource.getCategories(tCategoryType))
              .called(1);
          verifyNever(() => mockRemoteDataSource.getCategories(tCategoryType));
          expect(result.isLeft(), true);
          expect(
              result.fold(
                (failure) => failure,
                (_) => null,
              ),
              isA<ServerFailure>());
        },
      );
    });
  });

  group('addCategory', () {
    test(
      'nên kiểm tra kết nối internet',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.addCategory(any()))
            .thenAnswer((_) async => tCategoryModel);

        // act
        await repository.addCategory(tCategory);

        // assert
        verify(() => mockNetworkInfo.isConnected).called(1);
      },
    );

    group('thiết bị trực tuyến', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'nên trả về category khi thêm category thành công',
        () async {
          // arrange
          when(() => mockRemoteDataSource.addCategory(any()))
              .thenAnswer((_) async => tCategoryModel);

          // act
          final result = await repository.addCategory(tCategory);

          // assert
          verify(() => mockRemoteDataSource.addCategory(any())).called(1);
          expect(result.isRight(), true);
          expect(result.getRight(), equals(tCategory));
        },
      );

      test(
        'nên trả về ServerFailure khi thêm category thất bại',
        () async {
          // arrange
          when(() => mockRemoteDataSource.addCategory(any()))
              .thenThrow(Exception());

          // act
          final result = await repository.addCategory(tCategory);

          // assert
          verify(() => mockRemoteDataSource.addCategory(any())).called(1);
          expect(result.isLeft(), true);
          expect(
              result.fold(
                (failure) => failure,
                (_) => null,
              ),
              isA<ServerFailure>());
        },
      );
    });

    group('thiết bị ngoại tuyến', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'nên trả về NetworkFailure khi không có kết nối internet',
        () async {
          // act
          final result = await repository.addCategory(tCategory);

          // assert
          verifyNever(() => mockRemoteDataSource.addCategory(any()));
          expect(result.isLeft(), true);
          expect(
              result.fold(
                (failure) => failure,
                (_) => null,
              ),
              isA<NetworkFailure>());
        },
      );
    });
  });
}
