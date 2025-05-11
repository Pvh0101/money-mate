import 'package:flutter/material.dart';

InputDecoration appFormFieldDecoration({
  required BuildContext context,
  String? hintText,
  String? labelText,
  IconData? prefixIconData,
  IconData? suffixIconData,
  VoidCallback? onSuffixIconPressed,
  bool isFocused = false,
}) {
  final theme = Theme.of(context);
  final hintColor = theme.colorScheme.outline;
  return InputDecoration(
    contentPadding:
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 17.0),
    hintText: hintText,
    labelText: labelText,
    hintStyle: theme.textTheme.bodyLarge?.copyWith(color: hintColor),
    prefixIcon: prefixIconData != null ? Icon(prefixIconData) : null,
    suffixIcon: suffixIconData != null
        ? IconButton(
            icon: Icon(suffixIconData, color: hintColor),
            onPressed: onSuffixIconPressed,
          )
        : null,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: BorderSide(color: hintColor, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: BorderSide(color: theme.colorScheme.error, width: 1.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
    ),
  );
}
