enum TransactionType {
  income,
  expense,
}

extension TransactionTypeExtension on TransactionType {
  String get displayName {
    switch (this) {
      case TransactionType.income:
        return 'Thu nhập';
      case TransactionType.expense:
        return 'Chi tiêu';
    }
  }
}
