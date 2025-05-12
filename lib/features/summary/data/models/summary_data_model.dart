import '../../domain/entities/summary_data.dart';

class SummaryDataModel extends SummaryData {
  const SummaryDataModel({
    required DateTime startDate,
    required DateTime endDate,
    required double totalExpense,
    required double totalIncome,
    required Map<String, double> expenseByCategory,
    required Map<String, double> incomeByCategory,
    required Map<DateTime, double> expenseByDate,
    required Map<DateTime, double> incomeByDate,
  }) : super(
          startDate: startDate,
          endDate: endDate,
          totalExpense: totalExpense,
          totalIncome: totalIncome,
          expenseByCategory: expenseByCategory,
          incomeByCategory: incomeByCategory,
          expenseByDate: expenseByDate,
          incomeByDate: incomeByDate,
        );

  /// Tạo SummaryDataModel từ JSON (map).
  /// Lưu ý JSON từ Firebase không hỗ trợ trực tiếp kiểu DateTime và Map có key không phải String.
  factory SummaryDataModel.fromJson(Map<String, dynamic> json) {
    // Chuyển đổi thời gian từ timestamp
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(json['startDate']);
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(json['endDate']);

    // Trích xuất tổng chi tiêu và thu nhập
    final double totalExpense = (json['totalExpense'] is int)
        ? (json['totalExpense'] as int).toDouble()
        : json['totalExpense'] ?? 0.0;
    final double totalIncome = (json['totalIncome'] is int)
        ? (json['totalIncome'] as int).toDouble()
        : json['totalIncome'] ?? 0.0;

    // Chuyển đổi dữ liệu chi tiêu theo danh mục
    final Map<String, double> expenseByCategory =
        _convertCategoryMap(json['expenseByCategory']);

    // Chuyển đổi dữ liệu thu nhập theo danh mục
    final Map<String, double> incomeByCategory =
        _convertCategoryMap(json['incomeByCategory']);

    // Chuyển đổi dữ liệu chi tiêu theo ngày
    final Map<DateTime, double> expenseByDate =
        _convertDateMap(json['expenseByDate']);

    // Chuyển đổi dữ liệu thu nhập theo ngày
    final Map<DateTime, double> incomeByDate =
        _convertDateMap(json['incomeByDate']);

    return SummaryDataModel(
      startDate: startDate,
      endDate: endDate,
      totalExpense: totalExpense,
      totalIncome: totalIncome,
      expenseByCategory: expenseByCategory,
      incomeByCategory: incomeByCategory,
      expenseByDate: expenseByDate,
      incomeByDate: incomeByDate,
    );
  }

  /// Chuyển đổi SummaryDataModel thành JSON (map) để lưu vào Firebase.
  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'totalExpense': totalExpense,
      'totalIncome': totalIncome,
      'expenseByCategory': _convertToStringMap(expenseByCategory),
      'incomeByCategory': _convertToStringMap(incomeByCategory),
      'expenseByDate': _convertDateToStringMap(expenseByDate),
      'incomeByDate': _convertDateToStringMap(incomeByDate),
    };
  }

  /// Phương thức hỗ trợ để chuyển đổi Map<String, dynamic> thành Map<String, double>
  static Map<String, double> _convertCategoryMap(dynamic map) {
    if (map == null) return {};

    final Map<String, double> result = {};
    (map as Map<String, dynamic>).forEach((key, value) {
      result[key] = (value is int) ? value.toDouble() : (value as double);
    });
    return result;
  }

  /// Phương thức hỗ trợ để chuyển đổi Map<String, dynamic> thành Map<DateTime, double>
  /// Trong đó key là chuỗi ngày được chuyển sang DateTime
  static Map<DateTime, double> _convertDateMap(dynamic map) {
    if (map == null) return {};

    final Map<DateTime, double> result = {};
    (map as Map<String, dynamic>).forEach((key, value) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(key));
      result[dateTime] = (value is int) ? value.toDouble() : (value as double);
    });
    return result;
  }

  /// Phương thức hỗ trợ để chuyển đổi Map<DateTime, double> thành Map<String, double>
  /// Trong đó key DateTime được chuyển thành chuỗi timestamp
  static Map<String, double> _convertDateToStringMap(
      Map<DateTime, double> map) {
    final Map<String, double> result = {};
    map.forEach((key, value) {
      result[key.millisecondsSinceEpoch.toString()] = value;
    });
    return result;
  }

  /// Phương thức hỗ trợ để chuyển đổi Map<String, double> thành Map<String, double>
  /// Đảm bảo các giá trị đều là double
  static Map<String, double> _convertToStringMap(Map<String, double> map) {
    return map.map((key, value) => MapEntry(key, value));
  }
}
