import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/constants/default_categories.dart';
import 'package:money_mate/core/enums/category_type.dart';
import 'package:money_mate/features/categories/data/datasources/category_datasource.dart';
import 'package:money_mate/features/categories/data/models/category_model.dart';

void main() {
  late CategoryLocalDataSource dataSource;

  setUp(() {
    dataSource = CategoryLocalDataSource();
  });

  group('getCategories', () {
    test(
      'nên trả về danh sách defaultIncomeCategories khi type là income',
      () async {
        // act
        final result = await dataSource.getCategories(CategoryType.income);

        // assert
        expect(result, equals(defaultIncomeCategories));
      },
    );

    test(
      'nên trả về danh sách defaultExpenseCategories khi type là expense',
      () async {
        // act
        final result = await dataSource.getCategories(CategoryType.expense);

        // assert
        expect(result, equals(defaultExpenseCategories));
      },
    );
  });

  group('addCategory', () {
    test(
      'nên ném UnimplementedError khi gọi addCategory',
      () async {
        // act
        final call = dataSource.addCategory;

        // assert
        expect(
          () => call(const CategoryModel(
            id: 'test_id',
            name: 'Test Category',
            iconName: 'test_icon',
            type: CategoryType.expense,
          )),
          throwsA(isA<UnimplementedError>()),
        );
      },
    );
  });
}
