enum CategoryType {
  income,
  expense,
}

extension CategoryTypeExtension on CategoryType {
  String get displayName {
    switch (this) {
      case CategoryType.income:
        return 'Thu nhập';
      case CategoryType.expense:
        return 'Chi tiêu';
    }
  }
}
