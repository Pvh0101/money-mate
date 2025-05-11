import 'package:flutter_test/flutter_test.dart';
import 'package:money_mate/core/enums/transaction_type.dart';
import 'package:money_mate/features/transactions/domain/entities/transaction.dart';

void main() {
  final testDate = DateTime(2023, 6, 15);
  final createdAt = DateTime(2023, 6, 15, 10, 0);
  final updatedAt = DateTime(2023, 6, 15, 10, 0);

  group('Transaction Entity', () {
    test('nên có thuộc tính đúng khi khởi tạo', () {
      // arrange
      final transaction = Transaction(
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

      // assert
      expect(transaction.id, 'test_id');
      expect(transaction.amount, 100000);
      expect(transaction.date, testDate);
      expect(transaction.categoryId, 'category_id');
      expect(transaction.type, TransactionType.expense);
      expect(transaction.note, 'Test note');
      expect(transaction.userId, 'user_id');
      expect(transaction.createdAt, createdAt);
      expect(transaction.updatedAt, updatedAt);
      expect(transaction.vatAmount, isNull);
      expect(transaction.vatRate, isNull);
      expect(transaction.includeVat, false);
    });

    test('nên tính toán amountBeforeVat đúng khi includeVat = true', () {
      // arrange
      final transaction = Transaction(
        id: 'test_id',
        amount: 110000,
        date: testDate,
        categoryId: 'category_id',
        type: TransactionType.expense,
        userId: 'user_id',
        createdAt: createdAt,
        updatedAt: updatedAt,
        vatRate: 10,
        includeVat: true,
      );

      // assert
      expect(transaction.amountBeforeVat, closeTo(100000, 0.01));
    });

    test('nên tính toán amountAfterVat đúng khi includeVat = false', () {
      // arrange
      final transaction = Transaction(
        id: 'test_id',
        amount: 100000,
        date: testDate,
        categoryId: 'category_id',
        type: TransactionType.expense,
        userId: 'user_id',
        createdAt: createdAt,
        updatedAt: updatedAt,
        vatAmount: 10000,
        includeVat: false,
      );

      // assert
      expect(transaction.amountAfterVat, 110000);
    });

    test(
        'nên tính toán calculatedVatAmount từ vatRate khi vatAmount chưa được đặt',
        () {
      // arrange
      final transaction = Transaction(
        id: 'test_id',
        amount: 100000,
        date: testDate,
        categoryId: 'category_id',
        type: TransactionType.expense,
        userId: 'user_id',
        createdAt: createdAt,
        updatedAt: updatedAt,
        vatRate: 10,
        includeVat: false,
      );

      // assert
      expect(transaction.calculatedVatAmount, 10000);
    });

    test('nên ưu tiên dùng vatAmount nếu đã được đặt', () {
      // arrange
      final transaction = Transaction(
        id: 'test_id',
        amount: 100000,
        date: testDate,
        categoryId: 'category_id',
        type: TransactionType.expense,
        userId: 'user_id',
        createdAt: createdAt,
        updatedAt: updatedAt,
        vatAmount: 12000,
        vatRate: 10,
        includeVat: false,
      );

      // assert
      expect(transaction.calculatedVatAmount, 12000);
    });
  });
}
