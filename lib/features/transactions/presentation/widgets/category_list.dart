import 'package:flutter/material.dart';
import '../models/category_ui_data.dart'; // Updated import path

class CategoryList extends StatelessWidget {
  final List<CategoryUIData> categories;
  final String? selectedCategory;
  final Function(String) onCategorySelected;
  final VoidCallback onAddNewCategory;

  const CategoryList({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onCategorySelected,
    required this.onAddNewCategory,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length + 1,
      separatorBuilder: (context, index) => const SizedBox(width: 10),
      itemBuilder: (context, index) {
        if (index == 0) {
          // Index 0 is now Add New
          return _buildAddNewCategoryChip(
            context,
          );
        }
        final category = categories[index - 1]; // Adjust index for categories
        final bool isSelected = category.label == selectedCategory;
        return _buildCategoryChip(
          context,
          category,
          isSelected,
        );
      },
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    CategoryUIData category,
    bool isSelected,
  ) {
    return ElevatedButton(
      onPressed: () {
        onCategorySelected(category.label);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primaryFixed
            : Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        elevation: 0,
      ),
      child: Text(category.label,
          style: TextStyle(
              fontSize: 12,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface)),
    );
  }

  Widget _buildAddNewCategoryChip(
    BuildContext context,
  ) {
    return ElevatedButton(
      onPressed: onAddNewCategory, // Use the passed callback
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
          style: BorderStyle.solid,
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      ),
      child: Icon(
        Icons.add,
        size: 24,
        color: Theme.of(context).colorScheme.secondaryFixed,
      ),
    );
  }
}
