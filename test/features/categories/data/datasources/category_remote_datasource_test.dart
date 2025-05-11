import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_mate/core/enums/category_type.dart';
import 'package:money_mate/features/categories/data/datasources/category_datasource.dart';
import 'package:money_mate/features/categories/data/models/category_model.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late CategoryRemoteDataSource dataSource;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollectionReference;
  late MockQuery mockQuery;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockDocumentReference mockDocumentReference;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollectionReference = MockCollectionReference();
    mockQuery = MockQuery();
    mockQuerySnapshot = MockQuerySnapshot();
    mockDocumentReference = MockDocumentReference();

    dataSource = CategoryRemoteDataSource(firestore: mockFirestore);
  });

  const tCategoryType = CategoryType.expense;
  const tCategoryModel = CategoryModel(
    id: 'test_id',
    name: 'Test Category',
    iconName: 'test_icon',
    type: CategoryType.expense,
  );

  group('getCategories', () {
    final tDocumentSnapshots = [
      MockQueryDocumentSnapshot(),
      MockQueryDocumentSnapshot(),
    ];

    setUp(() {
      when(() => mockFirestore.collection('categories'))
          .thenReturn(mockCollectionReference);
      when(() => mockCollectionReference.where('type',
          isEqualTo: tCategoryType.name)).thenReturn(mockQuery);
      when(() => mockQuery.where('isDefault', isEqualTo: false))
          .thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn(tDocumentSnapshots);

      // Cấu hình dữ liệu giả cho document snapshots
      when(() => tDocumentSnapshots[0].data()).thenReturn({
        'id': 'test_id_1',
        'name': 'Test Category 1',
        'iconName': 'test_icon_1',
        'type': 'expense',
        'isDefault': false,
      });
      when(() => tDocumentSnapshots[1].data()).thenReturn({
        'id': 'test_id_2',
        'name': 'Test Category 2',
        'iconName': 'test_icon_2',
        'type': 'expense',
        'isDefault': false,
      });
    });

    test(
      'nên trả về danh sách categories khi gọi thành công',
      () async {
        // act
        final result = await dataSource.getCategories(tCategoryType);

        // assert
        verify(() => mockFirestore.collection('categories')).called(1);
        verify(() => mockCollectionReference.where('type',
            isEqualTo: tCategoryType.name)).called(1);
        verify(() => mockQuery.where('isDefault', isEqualTo: false)).called(1);
        verify(() => mockQuery.get()).called(1);
        expect(result.length, 2);
        expect(result[0].id, 'test_id_1');
        expect(result[0].name, 'Test Category 1');
        expect(result[1].id, 'test_id_2');
        expect(result[1].name, 'Test Category 2');
      },
    );

    test(
      'nên ném Exception khi gọi thất bại',
      () async {
        // arrange
        when(() => mockQuery.get()).thenThrow(Exception());

        // act
        final call = dataSource.getCategories;

        // assert
        expect(
          () => call(tCategoryType),
          throwsA(isA<Exception>()),
        );
      },
    );
  });

  group('addCategory', () {
    setUp(() {
      when(() => mockFirestore.collection('categories'))
          .thenReturn(mockCollectionReference);
      when(() => mockCollectionReference.doc(any()))
          .thenReturn(mockDocumentReference);
      when(() => mockDocumentReference.set(any())).thenAnswer((_) async => {});
    });

    test(
      'nên trả về CategoryModel khi thêm thành công',
      () async {
        // act
        final result = await dataSource.addCategory(tCategoryModel);

        // assert
        verify(() => mockFirestore.collection('categories')).called(1);
        verify(() => mockCollectionReference.doc(tCategoryModel.id)).called(1);
        verify(() => mockDocumentReference.set(tCategoryModel.toJson()))
            .called(1);
        expect(result, tCategoryModel);
      },
    );

    test(
      'nên ném Exception khi thêm thất bại',
      () async {
        // arrange
        when(() => mockDocumentReference.set(any())).thenThrow(Exception());

        // act
        final call = dataSource.addCategory;

        // assert
        expect(
          () => call(tCategoryModel),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
