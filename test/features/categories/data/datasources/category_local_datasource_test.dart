import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/constants/default_categories.dart';
import 'package:money_mate/core/enums/category_type.dart';
import 'package:money_mate/features/categories/data/datasources/category_datasource.dart';

void main() {
  late CategoryLocalDataSource dataSource;

  setUp(() {
    dataSource = CategoryLocalDataSource();
  });

  group('getCategories', () {
    test(
      'nên trả về danh sách categories thu nhập mặc định khi type là income',
      () async {
        // act
        final result = await dataSource.getCategories(CategoryType.income);

        // assert
        expect(result, equals(defaultIncomeCategories));
      },
    );

    test(
      'nên trả về danh sách categories chi tiêu mặc định khi type là expense',
      () async {
        // act
        final result = await dataSource.getCategories(CategoryType.expense);

        // assert
        expect(result, equals(defaultExpenseCategories));
      },
    );
  });

  test(
    'addCategory nên throw UnimplementedError',
    () async {
      // act & assert
      expect(
        () => dataSource.addCategory(defaultIncomeCategories[0]),
        throwsA(isA<UnimplementedError>()),
      );
    },
  );
}
