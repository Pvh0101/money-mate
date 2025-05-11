import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/enums/category_type.dart';
import 'package:money_mate/features/categories/data/models/category_model.dart';
import 'package:money_mate/features/categories/domain/entities/category.dart';

void main() {
  const tCategoryModel = CategoryModel(
    id: 'test_id',
    name: 'Test Category',
    iconName: 'test_icon',
    type: CategoryType.expense,
    isDefault: false,
    userId: 'user123',
  );

  test('nên là một lớp con của Category entity', () {
    // assert
    expect(tCategoryModel, isA<Category>());
  });

  group('fromJson', () {
    test('nên trả về một CategoryModel hợp lệ khi JSON hợp lệ', () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        'id': 'test_id',
        'name': 'Test Category',
        'iconName': 'test_icon',
        'type': 'expense',
        'isDefault': false,
        'userId': 'user123',
      };

      // act
      final result = CategoryModel.fromJson(jsonMap);

      // assert
      expect(result, tCategoryModel);
    });

    test(
        'nên trả về một CategoryModel với isDefault là false khi thiếu trường isDefault trong JSON',
        () {
      // arrange
      final Map<String, dynamic> jsonMap = {
        'id': 'test_id',
        'name': 'Test Category',
        'iconName': 'test_icon',
        'type': 'expense',
        'userId': 'user123',
      };

      // act
      final result = CategoryModel.fromJson(jsonMap);

      // assert
      expect(result, tCategoryModel);
    });
  });

  group('toJson', () {
    test('nên trả về một JSON Map chứa dữ liệu phù hợp', () {
      // act
      final result = tCategoryModel.toJson();

      // assert
      final expectedMap = {
        'id': 'test_id',
        'name': 'Test Category',
        'iconName': 'test_icon',
        'type': 'expense',
        'isDefault': false,
        'userId': 'user123',
      };
      expect(result, expectedMap);
    });
  });

  group('fromEntity', () {
    test('nên trả về CategoryModel khi chuyển đổi từ Category entity', () {
      // arrange
      const category = Category(
        id: 'test_id',
        name: 'Test Category',
        iconName: 'test_icon',
        type: CategoryType.expense,
        isDefault: false,
        userId: 'user123',
      );

      // act
      final result = CategoryModel.fromEntity(category);

      // assert
      expect(result, tCategoryModel);
    });
  });
}
