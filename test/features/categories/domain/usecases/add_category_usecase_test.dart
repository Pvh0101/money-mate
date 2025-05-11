import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_mate/core/enums/category_type.dart';
import 'package:money_mate/core/errors/failures.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';
import 'package:money_mate/features/categories/domain/repositories/category_repository.dart';
import 'package:money_mate/features/categories/domain/usecases/add_category_usecase.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late AddCategoryUseCase usecase;
  late MockCategoryRepository mockCategoryRepository;

  setUpAll(() {
    registerFallbackValue(
      Category(
        id: 'test_id',
        name: 'Test Category',
        iconName: 'test_icon',
        type: CategoryType.expense,
      ),
    );
  });

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    usecase = AddCategoryUseCase(mockCategoryRepository);
  });

  final tCategory = Category(
    id: 'test_id',
    name: 'Test Category',
    iconName: 'test_icon',
    type: CategoryType.expense,
  );

  test(
    'nên thêm category mới khi gọi repository thành công',
    () async {
      // arrange
      when(() => mockCategoryRepository.addCategory(tCategory))
          .thenAnswer((_) async => Right(tCategory));

      // act
      final result = await usecase(tCategory);

      // assert
      expect(result, Right(tCategory));
      verify(() => mockCategoryRepository.addCategory(tCategory)).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    },
  );

  test(
    'nên trả về NetworkFailure khi repository thất bại',
    () async {
      // arrange
      when(() => mockCategoryRepository.addCategory(tCategory))
          .thenAnswer((_) async => Left(NetworkFailure()));

      // act
      final result = await usecase(tCategory);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Expected Left with NetworkFailure'),
      );
      verify(() => mockCategoryRepository.addCategory(tCategory)).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    },
  );
}
