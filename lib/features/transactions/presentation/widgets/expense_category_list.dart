import 'package:flutter/material.dart';
import '../models/category_ui_data.dart';

class ExpenseCategoryList extends StatelessWidget {
  final List<CategoryUIData> categories;
  final String? selectedCategory;
  final Function(String) onCategorySelected;
  final VoidCallback onAddNewCategory;

  const ExpenseCategoryList({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onCategorySelected,
    required this.onAddNewCategory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expense Category', // Changed title
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 55,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              if (index == categories.length) {
                return _buildAddNewCategoryChip(context, theme, isDarkMode);
              }
              final category = categories[index];
              final bool isSelected = category.label == selectedCategory;
              return _buildCategoryChip(
                  context, category, isSelected, theme, isDarkMode);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    CategoryUIData category,
    bool isSelected,
    ThemeData theme,
    bool isDarkMode,
  ) {
    final chipColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];
    final selectedChipColor =
        theme.colorScheme.error; // Use error color for expense selection
    final textColor = isSelected
        ? theme.colorScheme.onError // Use onError for selected expense text
        : (isDarkMode ? Colors.white70 : Colors.black87);

    return ChoiceChip(
      label: Text(category.label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          onCategorySelected(category.label);
        }
      },
      backgroundColor: chipColor,
      selectedColor: selectedChipColor,
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: BorderSide(
          color: isSelected
              ? selectedChipColor
              : (isDarkMode ? Colors.grey[600]! : Colors.grey[400]!),
          width: 1.5,
        ),
      ),
      showCheckmark: false,
      elevation: isSelected ? 2.0 : 0.5,
    );
  }

  Widget _buildAddNewCategoryChip(
      BuildContext context, ThemeData theme, bool isDarkMode) {
    final chipColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];
    // Consider using theme.colorScheme.error or a variant for the add new expense chip
    final Color iconColor =
        isDarkMode ? Colors.redAccent.shade100 : theme.colorScheme.error;
    final Color textColor =
        isDarkMode ? Colors.redAccent.shade100 : theme.colorScheme.error;

    return ActionChip(
      avatar:
          Icon(Icons.add_circle_outline_rounded, color: iconColor, size: 20),
      label: Text('Add New'),
      onPressed: onAddNewCategory,
      backgroundColor: chipColor,
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: BorderSide(
          color: iconColor,
          width: 1.5,
        ),
      ),
      elevation: 0.5,
    );
  }
}
