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

class MockCategoryLocalDataSource extends Mock
    implements CategoryLocalDataSource {}

class MockCategoryRemoteDataSource extends Mock
    implements CategoryRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late CategoryRepositoryImpl repository;
  late MockCategoryLocalDataSource mockLocalDataSource;
  late MockCategoryRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(CategoryType.expense);
    registerFallbackValue(
      CategoryModel(
        id: 'test_id',
        name: 'Test Category',
        iconName: 'test_icon',
        type: CategoryType.expense,
      ),
    );
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

  group('getCategories', () {
    final tCategoryType = CategoryType.expense;
    final tLocalCategories = [
      CategoryModel(
        id: '1',
        name: 'Local Category 1',
        iconName: 'icon1',
        type: CategoryType.expense,
      ),
    ];
    final tRemoteCategories = [
      CategoryModel(
        id: '2',
        name: 'Remote Category 1',
        iconName: 'icon2',
        type: CategoryType.expense,
      ),
    ];
    final tAllCategories = [...tLocalCategories, ...tRemoteCategories];

    test(
      'nên kiểm tra kết nối internet',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockLocalDataSource.getCategories(any()))
            .thenAnswer((_) async => tLocalCategories);
        when(() => mockRemoteDataSource.getCategories(any()))
            .thenAnswer((_) async => tRemoteCategories);

        // act
        await repository.getCategories(tCategoryType);

        // assert
        verify(() => mockNetworkInfo.isConnected).called(1);
      },
    );

    group('thiết bị online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'nên trả về cả local và remote categories khi có kết nối internet',
        () async {
          // arrange
          when(() => mockLocalDataSource.getCategories(any()))
              .thenAnswer((_) async => tLocalCategories);
          when(() => mockRemoteDataSource.getCategories(any()))
              .thenAnswer((_) async => tRemoteCategories);

          // act
          final result = await repository.getCategories(tCategoryType);

          // assert
          verify(() => mockLocalDataSource.getCategories(tCategoryType))
              .called(1);
          verify(() => mockRemoteDataSource.getCategories(tCategoryType))
              .called(1);
          expect(result.isRight(), true);
          final categories = result.fold((l) => [], (r) => r);
          expect(categories.length, tAllCategories.length);
        },
      );

      test(
        'nên trả về ServerFailure khi lấy dữ liệu thất bại',
        () async {
          // arrange
          when(() => mockLocalDataSource.getCategories(any()))
              .thenThrow(ServerException());

          // act
          final result = await repository.getCategories(tCategoryType);

          // assert
          verify(() => mockLocalDataSource.getCategories(tCategoryType))
              .called(1);
          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('Expected Left with ServerFailure'),
          );
        },
      );
    });

    group('thiết bị offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'nên trả về dữ liệu local khi không có kết nối internet',
        () async {
          // arrange
          when(() => mockLocalDataSource.getCategories(any()))
              .thenAnswer((_) async => tLocalCategories);

          // act
          final result = await repository.getCategories(tCategoryType);

          // assert
          verify(() => mockLocalDataSource.getCategories(tCategoryType))
              .called(1);
          verifyNever(() => mockRemoteDataSource.getCategories(any()));
          expect(result, equals(Right(tLocalCategories)));
        },
      );
    });
  });

  group('addCategory', () {
    final tCategory = CategoryModel(
      id: '1',
      name: 'Test Category',
      iconName: 'test_icon',
      type: CategoryType.income,
    );

    test(
      'nên trả về Category khi thêm thành công',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.addCategory(tCategory))
            .thenAnswer((_) async => tCategory);

        // act
        final result = await repository.addCategory(tCategory);

        // assert
        verify(() => mockRemoteDataSource.addCategory(tCategory)).called(1);
        expect(result, equals(Right(tCategory)));
      },
    );

    test(
      'nên trả về NetworkFailure khi không có kết nối internet',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // act
        final result = await repository.addCategory(tCategory);

        // assert
        verifyNever(() => mockRemoteDataSource.addCategory(any()));
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (_) => fail('Expected Left with NetworkFailure'),
        );
      },
    );

    test(
      'nên trả về ServerFailure khi remote data source thất bại',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.addCategory(tCategory))
            .thenThrow(ServerException());

        // act
        final result = await repository.addCategory(tCategory);

        // assert
        verify(() => mockRemoteDataSource.addCategory(tCategory)).called(1);
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Expected Left with ServerFailure'),
        );
      },
    );
  });
}
