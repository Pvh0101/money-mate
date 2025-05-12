// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SummaryHiveModelAdapter extends TypeAdapter<SummaryHiveModel> {
  @override
  final int typeId = 5;

  @override
  SummaryHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SummaryHiveModel(
      startDateMillis: fields[0] as int,
      endDateMillis: fields[1] as int,
      totalExpense: fields[2] as double,
      totalIncome: fields[3] as double,
      expenseByCategory: (fields[4] as Map).cast<String, double>(),
      incomeByCategory: (fields[5] as Map).cast<String, double>(),
      expenseByDate: (fields[6] as Map).cast<String, double>(),
      incomeByDate: (fields[7] as Map).cast<String, double>(),
      id: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SummaryHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.startDateMillis)
      ..writeByte(1)
      ..write(obj.endDateMillis)
      ..writeByte(2)
      ..write(obj.totalExpense)
      ..writeByte(3)
      ..write(obj.totalIncome)
      ..writeByte(4)
      ..write(obj.expenseByCategory)
      ..writeByte(5)
      ..write(obj.incomeByCategory)
      ..writeByte(6)
      ..write(obj.expenseByDate)
      ..writeByte(7)
      ..write(obj.incomeByDate)
      ..writeByte(8)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SummaryHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
