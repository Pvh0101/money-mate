import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_mate/core/enums/transaction_type.dart';
import 'package:money_mate/features/transactions/data/datasources/transaction_datasource.dart';
import 'package:money_mate/features/transactions/data/models/transaction_model.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late TransactionRemoteDataSourceImpl dataSource;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollectionReference;
  late MockQuery mockQuery;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockDocumentReference mockDocumentReference;
  late MockDocumentSnapshot mockDocumentSnapshot;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollectionReference = MockCollectionReference();
    mockQuery = MockQuery();
    mockQuerySnapshot = MockQuerySnapshot();
    mockDocumentReference = MockDocumentReference();
    mockDocumentSnapshot = MockDocumentSnapshot();
    dataSource = TransactionRemoteDataSourceImpl(firestore: mockFirestore);

    // Mặc định hành vi cho hầu hết các test
    when(() => mockFirestore.collection('transactions'))
        .thenReturn(mockCollectionReference);
    when(() => mockCollectionReference.doc(any()))
        .thenReturn(mockDocumentReference);
  });

  final testDate = DateTime(2023, 6, 15);
  final createdAt = DateTime(2023, 6, 15, 10, 0);
  final updatedAt = DateTime(2023, 6, 15, 10, 0);

  final tTransactionModel = TransactionModel(
    id: 'test_id',
    amount: 100000,
    date: testDate,
    categoryId: 'category_id',
    type: TransactionType.expense,
    note: 'Test note',
    userId: 'user_id',
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  final tTransactionJson = {
    'id': 'test_id',
    'amount': 100000,
    'date': Timestamp.fromDate(testDate),
    'categoryId': 'category_id',
    'note': 'Test note',
    'type': 'expense',
    'userId': 'user_id',
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
    'vatAmount': null,
    'vatRate': null,
    'includeVat': false,
  };

  group('getTransactions', () {
    final tQueryDocumentSnapshots = [
      MockQueryDocumentSnapshot(),
    ];

    test('nên trả về danh sách TransactionModel khi gọi thành công', () async {
      // arrange
      when(() => mockCollectionReference.get())
          .thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn(tQueryDocumentSnapshots);
      when(() => tQueryDocumentSnapshots[0].data())
          .thenReturn(tTransactionJson);

      // act
      final result = await dataSource.getTransactions();

      // assert
      verify(() => mockFirestore.collection('transactions')).called(1);
      verify(() => mockCollectionReference.get()).called(1);
      expect(result, isA<List<TransactionModel>>());
      expect(result.length, 1);
    });

    test('nên lọc theo userId khi userId được truyền vào', () async {
      // arrange
      when(() => mockCollectionReference.where('userId', isEqualTo: 'user_id'))
          .thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn(tQueryDocumentSnapshots);
      when(() => tQueryDocumentSnapshots[0].data())
          .thenReturn(tTransactionJson);

      // act
      final result = await dataSource.getTransactions(userId: 'user_id');

      // assert
      verify(() =>
              mockCollectionReference.where('userId', isEqualTo: 'user_id'))
          .called(1);
      expect(result, isA<List<TransactionModel>>());
      expect(result.length, 1);
    });

    test('nên ném Exception khi gọi thất bại', () async {
      // arrange
      when(() => mockCollectionReference.get()).thenThrow(Exception());

      // act & assert
      expect(() => dataSource.getTransactions(), throwsException);
    });
  });

  group('getTransactionsByDateRange', () {
    final startDate = DateTime(2023, 6, 1);
    final endDate = DateTime(2023, 6, 30);
    final tQueryDocumentSnapshots = [
      MockQueryDocumentSnapshot(),
    ];

    test('nên trả về danh sách giao dịch trong khoảng thời gian khi thành công',
        () async {
      // arrange
      when(() => mockCollectionReference.where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate)))
          .thenReturn(mockQuery);
      when(() => mockQuery.where('date',
              isLessThanOrEqualTo: Timestamp.fromDate(endDate)))
          .thenReturn(mockQuery);
      when(() => mockQuery.where('userId', isEqualTo: 'user_id'))
          .thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn(tQueryDocumentSnapshots);
      when(() => tQueryDocumentSnapshots[0].data())
          .thenReturn(tTransactionJson);

      // act
      final result = await dataSource.getTransactionsByDateRange(
        startDate,
        endDate,
        userId: 'user_id',
      );

      // assert
      verify(() => mockCollectionReference.where('date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))).called(1);
      verify(() => mockQuery.where('date',
          isLessThanOrEqualTo: Timestamp.fromDate(endDate))).called(1);
      verify(() => mockQuery.where('userId', isEqualTo: 'user_id')).called(1);
      expect(result, isA<List<TransactionModel>>());
      expect(result.length, 1);
    });

    test('nên không yêu cầu userId nếu không được cung cấp', () async {
      // arrange
      when(() => mockCollectionReference.where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate)))
          .thenReturn(mockQuery);
      when(() => mockQuery.where('date',
              isLessThanOrEqualTo: Timestamp.fromDate(endDate)))
          .thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn(tQueryDocumentSnapshots);
      when(() => tQueryDocumentSnapshots[0].data())
          .thenReturn(tTransactionJson);

      // act
      final result = await dataSource.getTransactionsByDateRange(
        startDate,
        endDate,
      );

      // assert
      verify(() => mockCollectionReference.where('date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))).called(1);
      verify(() => mockQuery.where('date',
          isLessThanOrEqualTo: Timestamp.fromDate(endDate))).called(1);
      verifyNever(
          () => mockQuery.where('userId', isEqualTo: any(named: 'isEqualTo')));
      expect(result, isA<List<TransactionModel>>());
    });

    test('nên ném Exception khi gọi thất bại', () async {
      // arrange
      when(() => mockCollectionReference.where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate)))
          .thenReturn(mockQuery);
      when(() => mockQuery.where('date',
              isLessThanOrEqualTo: Timestamp.fromDate(endDate)))
          .thenThrow(Exception());

      // act & assert
      expect(
          () => dataSource.getTransactionsByDateRange(
                startDate,
                endDate,
              ),
          throwsException);
    });
  });

  group('getTransactionsByCategory', () {
    final tQueryDocumentSnapshots = [
      MockQueryDocumentSnapshot(),
    ];

    test('nên trả về danh sách giao dịch theo categoryId khi thành công',
        () async {
      // arrange
      when(() => mockCollectionReference.where('categoryId',
          isEqualTo: 'category_id')).thenReturn(mockQuery);
      when(() => mockQuery.where('userId', isEqualTo: 'user_id'))
          .thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn(tQueryDocumentSnapshots);
      when(() => tQueryDocumentSnapshots[0].data())
          .thenReturn(tTransactionJson);

      // act
      final result = await dataSource.getTransactionsByCategory(
        'category_id',
        userId: 'user_id',
      );

      // assert
      verify(() => mockCollectionReference.where('categoryId',
          isEqualTo: 'category_id')).called(1);
      verify(() => mockQuery.where('userId', isEqualTo: 'user_id')).called(1);
      expect(result, isA<List<TransactionModel>>());
      expect(result.length, 1);
    });

    test('nên không yêu cầu userId nếu không được cung cấp', () async {
      // arrange
      when(() => mockCollectionReference.where('categoryId',
          isEqualTo: 'category_id')).thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn(tQueryDocumentSnapshots);
      when(() => tQueryDocumentSnapshots[0].data())
          .thenReturn(tTransactionJson);

      // act
      final result = await dataSource.getTransactionsByCategory(
        'category_id',
      );

      // assert
      verify(() => mockCollectionReference.where('categoryId',
          isEqualTo: 'category_id')).called(1);
      verifyNever(
          () => mockQuery.where('userId', isEqualTo: any(named: 'isEqualTo')));
      expect(result, isA<List<TransactionModel>>());
    });

    test('nên ném Exception khi gọi thất bại', () async {
      // arrange
      when(() => mockCollectionReference.where('categoryId',
          isEqualTo: 'category_id')).thenThrow(Exception());

      // act & assert
      expect(
          () => dataSource.getTransactionsByCategory(
                'category_id',
              ),
          throwsException);
    });
  });

  group('addTransaction', () {
    test('nên thêm transaction và trả về TransactionModel khi thành công',
        () async {
      // arrange
      when(() => mockDocumentReference.set(any())).thenAnswer((_) async => {});

      // act
      final result = await dataSource.addTransaction(tTransactionModel);

      // assert
      verify(() => mockFirestore.collection('transactions')).called(1);
      verify(() => mockCollectionReference.doc(tTransactionModel.id)).called(1);
      verify(() => mockDocumentReference.set(any())).called(1);
      expect(result, equals(tTransactionModel));
    });

    test('nên ném Exception khi thêm thất bại', () async {
      // arrange
      when(() => mockDocumentReference.set(any())).thenThrow(Exception());

      // act & assert
      expect(
          () => dataSource.addTransaction(tTransactionModel), throwsException);
    });
  });

  group('updateTransaction', () {
    test('nên cập nhật transaction và trả về TransactionModel khi thành công',
        () async {
      // arrange
      when(() => mockDocumentReference.update(any()))
          .thenAnswer((_) async => {});

      // act
      final result = await dataSource.updateTransaction(tTransactionModel);

      // assert
      verify(() => mockFirestore.collection('transactions')).called(1);
      verify(() => mockCollectionReference.doc(tTransactionModel.id)).called(1);
      verify(() => mockDocumentReference.update(any())).called(1);
      expect(result, equals(tTransactionModel));
    });

    test('nên ném Exception khi cập nhật thất bại', () async {
      // arrange
      when(() => mockDocumentReference.update(any())).thenThrow(Exception());

      // act & assert
      expect(() => dataSource.updateTransaction(tTransactionModel),
          throwsException);
    });
  });

  group('deleteTransaction', () {
    test('nên xóa transaction khi thành công', () async {
      // arrange
      when(() => mockDocumentReference.delete()).thenAnswer((_) async => {});

      // act
      await dataSource.deleteTransaction('test_id');

      // assert
      verify(() => mockFirestore.collection('transactions')).called(1);
      verify(() => mockCollectionReference.doc('test_id')).called(1);
      verify(() => mockDocumentReference.delete()).called(1);
    });

    test('nên ném Exception khi xóa thất bại', () async {
      // arrange
      when(() => mockDocumentReference.delete()).thenThrow(Exception());

      // act & assert
      expect(() => dataSource.deleteTransaction('test_id'), throwsException);
    });
  });

  group('getTransactionById', () {
    test('nên trả về TransactionModel khi tìm thấy transaction', () async {
      // arrange
      when(() => mockDocumentReference.get())
          .thenAnswer((_) async => mockDocumentSnapshot);
      when(() => mockDocumentSnapshot.exists).thenReturn(true);
      when(() => mockDocumentSnapshot.data()).thenReturn(tTransactionJson);

      // act
      final result = await dataSource.getTransactionById('test_id');

      // assert
      verify(() => mockFirestore.collection('transactions')).called(1);
      verify(() => mockCollectionReference.doc('test_id')).called(1);
      verify(() => mockDocumentReference.get()).called(1);
      expect(result, isA<TransactionModel>());
    });

    test('nên ném Exception khi không tìm thấy transaction', () async {
      // arrange
      when(() => mockDocumentReference.get())
          .thenAnswer((_) async => mockDocumentSnapshot);
      when(() => mockDocumentSnapshot.exists).thenReturn(false);

      // act & assert
      expect(() => dataSource.getTransactionById('test_id'), throwsException);
    });

    test('nên ném Exception khi gọi thất bại', () async {
      // arrange
      when(() => mockDocumentReference.get()).thenThrow(Exception());

      // act & assert
      expect(() => dataSource.getTransactionById('test_id'), throwsException);
    });
  });

  group('getTotalByType', () {
    final startDate = DateTime(2023, 6, 1);
    final endDate = DateTime(2023, 6, 30);
    final tQueryDocumentSnapshots = [
      MockQueryDocumentSnapshot(),
      MockQueryDocumentSnapshot(),
    ];

    test('nên trả về tổng số tiền cho loại giao dịch cụ thể', () async {
      // arrange
      when(() => mockCollectionReference.where('type', isEqualTo: 'expense'))
          .thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn(tQueryDocumentSnapshots);

      final transactionData1 = Map<String, dynamic>.from(tTransactionJson);
      transactionData1['amount'] = 100000;

      final transactionData2 = Map<String, dynamic>.from(tTransactionJson);
      transactionData2['amount'] = 50000;

      when(() => tQueryDocumentSnapshots[0].data())
          .thenReturn(transactionData1);
      when(() => tQueryDocumentSnapshots[1].data())
          .thenReturn(transactionData2);

      // act
      final result = await dataSource.getTotalByType(TransactionType.expense);

      // assert
      verify(() => mockCollectionReference.where('type', isEqualTo: 'expense'))
          .called(1);
      expect(result, 150000.0);
    });

    test('nên lọc theo userId khi userId được cung cấp', () async {
      // arrange
      when(() => mockCollectionReference.where('type', isEqualTo: 'expense'))
          .thenReturn(mockQuery);
      when(() => mockQuery.where('userId', isEqualTo: 'user_id'))
          .thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn(tQueryDocumentSnapshots);

      when(() => tQueryDocumentSnapshots[0].data())
          .thenReturn({'amount': 100000});
      when(() => tQueryDocumentSnapshots[1].data())
          .thenReturn({'amount': 50000});

      // act
      final result = await dataSource.getTotalByType(
        TransactionType.expense,
        userId: 'user_id',
      );

      // assert
      verify(() => mockCollectionReference.where('type', isEqualTo: 'expense'))
          .called(1);
      verify(() => mockQuery.where('userId', isEqualTo: 'user_id')).called(1);
      expect(result, 150000.0);
    });

    test('nên lọc theo khoảng thời gian khi start và end được cung cấp',
        () async {
      // arrange
      when(() => mockCollectionReference.where('type', isEqualTo: 'expense'))
          .thenReturn(mockQuery);
      when(() => mockQuery.where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate)))
          .thenReturn(mockQuery);
      when(() => mockQuery.where('date',
              isLessThanOrEqualTo: Timestamp.fromDate(endDate)))
          .thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn(tQueryDocumentSnapshots);

      when(() => tQueryDocumentSnapshots[0].data())
          .thenReturn({'amount': 100000});
      when(() => tQueryDocumentSnapshots[1].data())
          .thenReturn({'amount': 50000});

      // act
      final result = await dataSource.getTotalByType(
        TransactionType.expense,
        start: startDate,
        end: endDate,
      );

      // assert
      verify(() => mockCollectionReference.where('type', isEqualTo: 'expense'))
          .called(1);
      verify(() => mockQuery.where('date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))).called(1);
      verify(() => mockQuery.where('date',
          isLessThanOrEqualTo: Timestamp.fromDate(endDate))).called(1);
      expect(result, 150000.0);
    });

    test('nên xử lý trường hợp không có giao dịch', () async {
      // arrange
      when(() => mockCollectionReference.where('type', isEqualTo: 'expense'))
          .thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(() => mockQuerySnapshot.docs).thenReturn([]);

      // act
      final result = await dataSource.getTotalByType(TransactionType.expense);

      // assert
      verify(() => mockCollectionReference.where('type', isEqualTo: 'expense'))
          .called(1);
      expect(result, 0.0);
    });

    test('nên ném Exception khi gọi thất bại', () async {
      // arrange
      when(() => mockCollectionReference.where('type', isEqualTo: 'expense'))
          .thenThrow(Exception());

      // act & assert
      expect(() => dataSource.getTotalByType(TransactionType.expense),
          throwsException);
    });
  });
}
