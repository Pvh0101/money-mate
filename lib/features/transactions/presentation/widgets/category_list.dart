import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../../core/widgets/loading_state_circular_progress.dart';
import '../../../../core/widgets/error_state_list.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../../../features/categories/presentation/bloc/category_bloc.dart';
import '../../../../features/categories/presentation/bloc/category_event.dart';
import '../../../../features/categories/presentation/bloc/category_state.dart';
import 'category_list/index.dart';

// Single Responsibility: Component just for displaying list of categories
class CategoryList extends StatefulWidget {
  final CategoryType type;
  final String? selectedCategoryId;
  final Function(Category) onCategorySelected;

  const CategoryList({
    super.key,
    required this.type,
    this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCategories();
  }

  // Single Responsibility: Method focused on loading categories
  void _loadCategories() {
    if (!_isInitialized) {
      try {
        context.read<CategoryBloc>().add(GetCategoriesEvent(widget.type));
        _isInitialized = true;
      } catch (e) {
        // Using a logger would be better than print in production code
        debugPrint("Error accessing CategoryBloc: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const LoadingStateShimmerList();
        } else if (state is CategoriesLoaded) {
          return CategoriesView(
            categories: state.categories,
            selectedCategoryId: widget.selectedCategoryId,
            onCategorySelected: widget.onCategorySelected,
            onAddCategory: _showAddCategoryDialog,
            categoryType: widget.type,
          );
        } else if (state is CategoryError) {
          return ErrorStateList(
            imageAssetName: 'assets/images/error.png',
            errorMessage: state.message,
            onRetry: () => context
                .read<CategoryBloc>()
                .add(GetCategoriesEvent(widget.type)),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // Single Responsibility: Method focused on showing add category dialog
  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AddCategoryDialog(
        categoryType: widget.type,
      ),
    );
  }
}
