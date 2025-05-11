import 'package:flutter/material.dart';

class EmptyStateList extends StatelessWidget {
  final String imageAssetName;
  final String title;
  final String description;

  const EmptyStateList({
    super.key,
    required this.imageAssetName,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageAssetName,
            width: 100,
            height: 100,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(description),
        ],
      ),
    );
  }
}
