import 'package:flutter/material.dart';

class FieldLabelText extends StatelessWidget {
  final String text;
  const FieldLabelText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSecondaryFixed,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
