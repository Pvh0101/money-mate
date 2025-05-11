import 'package:flutter/material.dart';
import '../../../../../features/categories/domain/entities/category.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final Function(Category) onCategorySelected;

  const CategoryItem({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onCategorySelected(category),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        elevation: 0,
      ),
      child: Text(
        category.name,
        style: TextStyle(
            fontSize: 12,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
