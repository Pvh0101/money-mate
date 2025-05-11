import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/enums/category_type.dart';
import 'package:money_mate/features/categories/data/datasources/category_datasource.dart';
import 'package:money_mate/features/categories/data/models/category_model.dart';

void main() {
  late CategoryRemoteDataSource dataSource;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    dataSource = CategoryRemoteDataSource(firestore: fakeFirestore);
  });

  group('getCategories', () {
    final tCategories = [
      CategoryModel(
        id: 'test_1',
        name: 'Test 1',
        iconName: 'test_icon',
        type: CategoryType.expense,
        isDefault: false,
      ),
      CategoryModel(
        id: 'test_2',
        name: 'Test 2',
        iconName: 'test_icon',
        type: CategoryType.expense,
        isDefault: false,
      ),
    ];

    test(
      'nên trả về danh sách categories từ Firestore',
      () async {
        // arrange
        for (var category in tCategories) {
          await fakeFirestore
              .collection('categories')
              .doc(category.id)
              .set(category.toJson());
        }

        // act
        final result = await dataSource.getCategories(CategoryType.expense);

        // assert
        expect(result.length, equals(tCategories.length));
        expect(result[0].id, equals(tCategories[0].id));
        expect(result[1].id, equals(tCategories[1].id));
      },
    );
  });

  group('addCategory', () {
    final tCategory = CategoryModel(
      id: 'test_id',
      name: 'Test Category',
      iconName: 'test_icon',
      type: CategoryType.income,
    );

    test(
      'nên thêm category mới vào Firestore',
      () async {
        // act
        await dataSource.addCategory(tCategory);

        // assert
        final docSnapshot = await fakeFirestore
            .collection('categories')
            .doc(tCategory.id)
            .get();

        expect(docSnapshot.exists, isTrue);
        expect(docSnapshot.data()?['name'], equals(tCategory.name));
      },
    );
  });
}
