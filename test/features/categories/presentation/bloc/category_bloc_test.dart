import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_mate/core/enums/category_type.dart';
import 'package:money_mate/core/errors/failures.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';
import 'package:money_mate/features/categories/domain/usecases/add_category_usecase.dart';
import 'package:money_mate/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_bloc.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_event.dart';
import 'package:money_mate/features/categories/presentation/bloc/category_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:uuid/uuid.dart';

class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

class MockAddCategoryUseCase extends Mock implements AddCategoryUseCase {}

class MockUuid extends Mock implements Uuid {}

void main() {
  late CategoryBloc bloc;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockAddCategoryUseCase mockAddCategoryUseCase;
  late MockUuid mockUuid;

  setUpAll(() {
    registerFallbackValue(CategoryType.expense);
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
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockAddCategoryUseCase = MockAddCategoryUseCase();
    mockUuid = MockUuid();

    // Mặc định các mock để tránh lỗi null
    when(() => mockGetCategoriesUseCase(any()))
        .thenAnswer((_) async => const Right([]));
    when(() => mockAddCategoryUseCase(any()))
        .thenAnswer((_) async => Right(Category(
              id: 'default',
              name: 'Default',
              iconName: 'default_icon',
              type: CategoryType.expense,
            )));
    when(() => mockUuid.v4()).thenReturn('default-uuid');

    bloc = CategoryBloc(
      getCategoriesUseCase: mockGetCategoriesUseCase,
      addCategoryUseCase: mockAddCategoryUseCase,
      uuid: mockUuid,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initialState nên là CategoryInitial', () {
    // assert
    expect(bloc.state, equals(CategoryInitial()));
  });

  group('GetCategoriesEvent', () {
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

    blocTest<CategoryBloc, CategoryState>(
      'nên phát ra [CategoryLoading, CategoriesLoaded] khi thành công',
      build: () {
        when(() => mockGetCategoriesUseCase(tCategoryType))
            .thenAnswer((_) async => Right(tCategories));
        return bloc;
      },
      act: (bloc) => bloc.add(GetCategoriesEvent(tCategoryType)),
      expect: () => [
        CategoryLoading(),
        CategoriesLoaded(tCategories),
      ],
      verify: (_) {
        verify(() => mockGetCategoriesUseCase(tCategoryType)).called(1);
      },
    );

    blocTest<CategoryBloc, CategoryState>(
      'nên phát ra [CategoryLoading, CategoryError] khi thất bại',
      build: () {
        when(() => mockGetCategoriesUseCase(tCategoryType))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetCategoriesEvent(tCategoryType)),
      expect: () => [
        CategoryLoading(),
        CategoryError('Lỗi server'),
      ],
      verify: (_) {
        verify(() => mockGetCategoriesUseCase(tCategoryType)).called(1);
      },
    );
  });

  group('AddCategoryEvent', () {
    final tName = 'Test Category';
    final tIconName = 'test_icon';
    final tCategoryType = CategoryType.expense;
    final tUuid = 'test-uuid';

    final tCategory = Category(
      id: tUuid,
      name: tName,
      iconName: tIconName,
      type: tCategoryType,
      isDefault: false,
    );

    blocTest<CategoryBloc, CategoryState>(
      'nên phát ra [CategoryLoading, CategoryAdded, CategoryLoading, CategoriesLoaded] khi thành công',
      build: () {
        when(() => mockUuid.v4()).thenReturn(tUuid);
        when(() => mockAddCategoryUseCase(any()))
            .thenAnswer((_) async => Right(tCategory));
        when(() => mockGetCategoriesUseCase(tCategoryType))
            .thenAnswer((_) async => Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(AddCategoryEvent(
        name: tName,
        iconName: tIconName,
        type: tCategoryType,
      )),
      expect: () => [
        CategoryLoading(),
        CategoryAdded(tCategory),
        CategoryLoading(),
        CategoriesLoaded([]),
      ],
      verify: (_) {
        verify(() => mockUuid.v4()).called(1);
        verify(() => mockAddCategoryUseCase(any())).called(1);
        verify(() => mockGetCategoriesUseCase(tCategoryType)).called(1);
      },
    );

    blocTest<CategoryBloc, CategoryState>(
      'nên phát ra [CategoryLoading, CategoryError] khi thất bại',
      build: () {
        when(() => mockUuid.v4()).thenReturn(tUuid);
        when(() => mockAddCategoryUseCase(any()))
            .thenAnswer((_) async => Left(NetworkFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(AddCategoryEvent(
        name: tName,
        iconName: tIconName,
        type: tCategoryType,
      )),
      expect: () => [
        CategoryLoading(),
        CategoryError('Lỗi kết nối'),
      ],
      verify: (_) {
        verify(() => mockUuid.v4()).called(1);
        verify(() => mockAddCategoryUseCase(any())).called(1);
        verifyNever(() => mockGetCategoriesUseCase(any()));
      },
    );
  });
}
