import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/core.dart';
import '../../../../../features/categories/presentation/bloc/category_bloc.dart';
import '../../../../../features/categories/presentation/bloc/category_event.dart';

class AddCategoryDialog extends StatefulWidget {
  final CategoryType categoryType;

  const AddCategoryDialog({
    Key? key,
    required this.categoryType,
  }) : super(key: key);

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          'Add New ${widget.categoryType == CategoryType.income ? "Income" : "Expense"} Category'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Category Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a category name';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitCategory,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _submitCategory() {
    if (_formKey.currentState!.validate()) {
      try {
        context.read<CategoryBloc>().add(
              AddCategoryEvent(
                name: _nameController.text.trim(),
                iconName: widget.categoryType == CategoryType.income
                    ? 'income'
                    : 'expense',
                type: widget.categoryType,
              ),
            );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding category: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
