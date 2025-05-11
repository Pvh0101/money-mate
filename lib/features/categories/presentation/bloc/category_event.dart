import 'package:equatable/equatable.dart';
import '../../../../core/enums/category_type.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class GetCategoriesEvent extends CategoryEvent {
  final CategoryType type;

  const GetCategoriesEvent(this.type);

  @override
  List<Object?> get props => [type];
}

class AddCategoryEvent extends CategoryEvent {
  final String name;
  final String iconName;
  final CategoryType type;
  final String? userId;

  const AddCategoryEvent({
    required this.name,
    required this.iconName,
    required this.type,
    this.userId,
  });

  @override
  List<Object?> get props => [name, iconName, type, userId];
}
