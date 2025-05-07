import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String icon;
  final String type; // "income" hoặc "expense"

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
  });

  @override
  List<Object> get props => [id, name, icon, type];
}
