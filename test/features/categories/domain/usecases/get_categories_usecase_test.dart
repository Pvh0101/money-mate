import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_mate/core/enums/category_type.dart';
import 'package:money_mate/core/errors/failures.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';
import 'package:money_mate/features/categories/domain/repositories/category_repository.dart';
import 'package:money_mate/features/categories/domain/usecases/get_categories_usecase.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late GetCategoriesUseCase usecase;
  late MockCategoryRepository mockCategoryRepository;

  setUpAll(() {
    registerFallbackValue(CategoryType.income);
  });

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    usecase = GetCategoriesUseCase(mockCategoryRepository);
  });

  final tCategoryType = CategoryType.income;
  final tCategories = [
    Category(
      id: 'test_id_1',
      name: 'Test Category 1',
      iconName: 'test_icon',
      type: CategoryType.income,
    ),
    Category(
      id: 'test_id_2',
      name: 'Test Category 2',
      iconName: 'test_icon',
      type: CategoryType.income,
    ),
  ];

  test(
    'nên trả về danh sách categories khi gọi repository thành công',
    () async {
      // arrange
      when(() => mockCategoryRepository.getCategories(tCategoryType))
          .thenAnswer((_) async => Right(tCategories));

      // act
      final result = await usecase(tCategoryType);

      // assert
      expect(result, Right(tCategories));
      verify(() => mockCategoryRepository.getCategories(tCategoryType))
          .called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    },
  );

  test(
    'nên trả về ServerFailure khi repository thất bại',
    () async {
      // arrange
      when(() => mockCategoryRepository.getCategories(tCategoryType))
          .thenAnswer((_) async => Left(ServerFailure()));

      // act
      final result = await usecase(tCategoryType);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left with ServerFailure'),
      );
      verify(() => mockCategoryRepository.getCategories(tCategoryType))
          .called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    },
  );
}
