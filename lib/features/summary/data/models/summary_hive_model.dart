import 'package:hive/hive.dart';
import 'package:money_mate/core/enums/transaction_type.dart';
import 'package:money_mate/features/summary/domain/entities/summary_data.dart';

part 'summary_hive_model.g.dart';

@HiveType(typeId: 5) // ID mới cho Summary - cần thêm vào HiveTypeIds
class SummaryHiveModel extends HiveObject {
  @HiveField(0)
  final int startDateMillis;

  @HiveField(1)
  final int endDateMillis;

  @HiveField(2)
  final double totalExpense;

  @HiveField(3)
  final double totalIncome;

  @HiveField(4)
  final Map<String, double> expenseByCategory;

  @HiveField(5)
  final Map<String, double> incomeByCategory;

  @HiveField(6)
  final Map<String, double>
      expenseByDate; // key là millisecondsSinceEpoch dạng String

  @HiveField(7)
  final Map<String, double>
      incomeByDate; // key là millisecondsSinceEpoch dạng String

  @HiveField(8)
  final String id; // Sử dụng startDate_endDate để làm ID

  SummaryHiveModel({
    required this.startDateMillis,
    required this.endDateMillis,
    required this.totalExpense,
    required this.totalIncome,
    required this.expenseByCategory,
    required this.incomeByCategory,
    required this.expenseByDate,
    required this.incomeByDate,
    required this.id,
  });

  // Tạo ID từ startDate và endDate
  static String createId(DateTime startDate, DateTime endDate) {
    return '${startDate.millisecondsSinceEpoch}_${endDate.millisecondsSinceEpoch}';
  }

  // Chuyển từ domain entity sang Hive model
  factory SummaryHiveModel.fromEntity(SummaryData entity) {
    final expenseByDate = <String, double>{};
    entity.expenseByDate.forEach((key, value) {
      expenseByDate[key.millisecondsSinceEpoch.toString()] = value;
    });

    final incomeByDate = <String, double>{};
    entity.incomeByDate.forEach((key, value) {
      incomeByDate[key.millisecondsSinceEpoch.toString()] = value;
    });

    return SummaryHiveModel(
      startDateMillis: entity.startDate.millisecondsSinceEpoch,
      endDateMillis: entity.endDate.millisecondsSinceEpoch,
      totalExpense: entity.totalExpense,
      totalIncome: entity.totalIncome,
      expenseByCategory: Map<String, double>.from(entity.expenseByCategory),
      incomeByCategory: Map<String, double>.from(entity.incomeByCategory),
      expenseByDate: expenseByDate,
      incomeByDate: incomeByDate,
      id: createId(entity.startDate, entity.endDate),
    );
  }

  // Chuyển từ Hive model sang domain entity
  SummaryData toEntity() {
    final startDate = DateTime.fromMillisecondsSinceEpoch(startDateMillis);
    final endDate = DateTime.fromMillisecondsSinceEpoch(endDateMillis);

    final Map<DateTime, double> convertedExpenseByDate = {};
    expenseByDate.forEach((key, value) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(key));
      convertedExpenseByDate[dateTime] = value;
    });

    final Map<DateTime, double> convertedIncomeByDate = {};
    incomeByDate.forEach((key, value) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(key));
      convertedIncomeByDate[dateTime] = value;
    });

    return SummaryData(
      startDate: startDate,
      endDate: endDate,
      totalExpense: totalExpense,
      totalIncome: totalIncome,
      expenseByCategory: Map<String, double>.from(expenseByCategory),
      incomeByCategory: Map<String, double>.from(incomeByCategory),
      expenseByDate: convertedExpenseByDate,
      incomeByDate: convertedIncomeByDate,
    );
  }
}
