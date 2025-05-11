import 'package:flutter/material.dart';

class AddCategoryItem extends StatelessWidget {
  final VoidCallback onAddCategory;

  const AddCategoryItem({Key? key, required this.onAddCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onAddCategory,
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
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
