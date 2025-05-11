import 'package:flutter/material.dart';
import '../../../../../core/core.dart';
import '../../../../../core/widgets/empty_state_list.dart';
import '../../../../../features/categories/domain/entities/category.dart';
import 'add_category_item.dart';
import 'category_item.dart';

class CategoriesView extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategoryId;
  final Function(Category) onCategorySelected;
  final VoidCallback onAddCategory;
  final CategoryType categoryType;

  const CategoriesView({
    Key? key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    required this.onAddCategory,
    required this.categoryType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const EmptyStateList(
        imageAssetName: 'assets/images/empty.png',
        title: 'No categories available',
        description: 'Tap the button below to add a new category',
      );
    }

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (index == 0) {
            return AddCategoryItem(onAddCategory: onAddCategory);
          }
          final category = categories[index - 1];
          final bool isSelected = category.id == selectedCategoryId;
          return CategoryItem(
            category: category,
            isSelected: isSelected,
            onCategorySelected: onCategorySelected,
          );
        },
      ),
    );
  }
}
