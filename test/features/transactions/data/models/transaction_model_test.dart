import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/enums/transaction_type.dart';
import 'package:money_mate/features/transactions/data/models/transaction_model.dart';
import 'package:money_mate/features/transactions/domain/entities/transaction.dart';

void main() {
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
    vatAmount: 10000,
    vatRate: 10,
    includeVat: true,
  );

  group('TransactionModel', () {
    test('nên là một lớp con của Transaction entity', () {
      // assert
      expect(tTransactionModel, isA<Transaction>());
    });

    group('fromJson', () {
      test('nên trả về một TransactionModel hợp lệ khi JSON hợp lệ', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': 'test_id',
          'amount': 100000,
          'date': Timestamp.fromDate(testDate),
          'categoryId': 'category_id',
          'note': 'Test note',
          'type': 'expense',
          'userId': 'user_id',
          'createdAt': Timestamp.fromDate(createdAt),
          'updatedAt': Timestamp.fromDate(updatedAt),
          'vatAmount': 10000,
          'vatRate': 10,
          'includeVat': true,
        };

        // act
        final result = TransactionModel.fromJson(jsonMap);

        // assert
        expect(result, tTransactionModel);
      });

      test('nên xử lý chuyển đổi kiểu int sang double cho số tiền', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': 'test_id',
          'amount': 100000, // int
          'date': Timestamp.fromDate(testDate),
          'categoryId': 'category_id',
          'note': 'Test note',
          'type': 'expense',
          'userId': 'user_id',
          'createdAt': Timestamp.fromDate(createdAt),
          'updatedAt': Timestamp.fromDate(updatedAt),
          'vatAmount': 10000, // int
          'vatRate': 10, // int
          'includeVat': true,
        };

        // act
        final result = TransactionModel.fromJson(jsonMap);

        // assert
        expect(result.amount, isA<double>());
        expect(result.vatAmount, isA<double>());
        expect(result.vatRate, isA<double>());
      });

      test('nên xử lý trường note là null trong JSON', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': 'test_id',
          'amount': 100000,
          'date': Timestamp.fromDate(testDate),
          'categoryId': 'category_id',
          'type': 'expense',
          'userId': 'user_id',
          'createdAt': Timestamp.fromDate(createdAt),
          'updatedAt': Timestamp.fromDate(updatedAt),
          'vatAmount': 10000,
          'vatRate': 10,
          'includeVat': true,
          'note': null,
        };

        // act
        final result = TransactionModel.fromJson(jsonMap);

        // assert
        expect(result.note, '');
      });
    });

    group('toJson', () {
      test('nên trả về một Map<String, dynamic> chứa dữ liệu đúng', () {
        // act
        final result = tTransactionModel.toJson();

        // assert
        final expectedMap = {
          'id': 'test_id',
          'amount': 100000.0,
          'date': Timestamp.fromDate(testDate),
          'categoryId': 'category_id',
          'note': 'Test note',
          'type': 'expense',
          'userId': 'user_id',
          'createdAt': Timestamp.fromDate(createdAt),
          'updatedAt': Timestamp.fromDate(updatedAt),
          'vatAmount': 10000.0,
          'vatRate': 10.0,
          'includeVat': true,
        };

        expect(result, expectedMap);
      });
    });

    group('fromEntity', () {
      test('nên chuyển đổi từ entity sang model đúng cách', () {
        // arrange
        final tTransaction = Transaction(
          id: 'test_id',
          amount: 100000,
          date: testDate,
          categoryId: 'category_id',
          type: TransactionType.expense,
          note: 'Test note',
          userId: 'user_id',
          createdAt: createdAt,
          updatedAt: updatedAt,
          vatAmount: 10000,
          vatRate: 10,
          includeVat: true,
        );

        // act
        final result = TransactionModel.fromEntity(tTransaction);

        // assert
        expect(result, tTransactionModel);
      });
    });
  });
}
