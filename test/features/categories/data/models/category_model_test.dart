import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/enums/category_type.dart';
import 'package:money_mate/features/categories/data/models/category_model.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';

void main() {
  final tCategoryModel = CategoryModel(
    id: 'test_id',
    name: 'Test Category',
    iconName: 'test_icon',
    type: CategoryType.expense,
    isDefault: false,
  );

  test(
    'nên là một lớp con của Category entity',
    () async {
      // assert
      expect(tCategoryModel, isA<Category>());
    },
  );

  group('fromJson', () {
    test(
      'nên trả về một CategoryModel hợp lệ khi JSON chứa dữ liệu hợp lệ',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': 'test_id',
          'name': 'Test Category',
          'iconName': 'test_icon',
          'type': 'expense',
          'isDefault': false,
        };

        // act
        final result = CategoryModel.fromJson(jsonMap);

        // assert
        expect(result.id, tCategoryModel.id);
        expect(result.name, tCategoryModel.name);
        expect(result.iconName, tCategoryModel.iconName);
        expect(result.type, tCategoryModel.type);
        expect(result.isDefault, tCategoryModel.isDefault);
      },
    );
  });

  group('toJson', () {
    test(
      'nên trả về JSON map chứa dữ liệu đúng',
      () async {
        // act
        final result = tCategoryModel.toJson();

        // assert
        final expectedMap = {
          'id': 'test_id',
          'name': 'Test Category',
          'iconName': 'test_icon',
          'type': 'expense',
          'isDefault': false,
          'userId': null,
        };
        expect(result, equals(expectedMap));
      },
    );
  });

  group('fromEntity', () {
    test(
      'nên trả về một CategoryModel từ entity',
      () async {
        // arrange
        final tEntity = Category(
          id: 'test_id',
          name: 'Test Category',
          iconName: 'test_icon',
          type: CategoryType.expense,
          isDefault: false,
        );

        // act
        final result = CategoryModel.fromEntity(tEntity);

        // assert
        expect(result, isA<CategoryModel>());
        expect(result.id, tEntity.id);
        expect(result.name, tEntity.name);
        expect(result.iconName, tEntity.iconName);
        expect(result.type, tEntity.type);
        expect(result.isDefault, tEntity.isDefault);
      },
    );
  });
}
