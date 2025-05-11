import 'package:flutter/material.dart';
import 'app_form_field_decoration.dart';
import 'field_label_text.dart';

/// Dropdown chọn giá trị, style đồng bộ với các form field khác.
/// [value]: giá trị đang chọn.
/// [items]: danh sách lựa chọn.
/// [onChanged]: callback khi chọn giá trị mới.
/// [hintText]: gợi ý.
/// [labelText]: nhãn phía trên input.
/// [prefixIconData]: icon ở đầu field.
class AppDropdownFormField<T> extends StatelessWidget {
  const AppDropdownFormField({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.hintText,
    this.labelText,
    this.validator,
    this.prefixIconData,
    this.isExpanded = true,
    this.focusNode,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hintText;
  final String? labelText;
  final FormFieldValidator<T>? validator;
  final IconData? prefixIconData;
  final bool isExpanded;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.colorScheme.outline;
    final bool isFocused = focusNode?.hasFocus ?? false;

    final dropdown = DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      isExpanded: isExpanded,
      focusNode: focusNode,
      icon: Icon(Icons.arrow_drop_down,
          color: isFocused ? theme.colorScheme.primary : hintColor),
      decoration: appFormFieldDecoration(
        context: context,
        hintText: hintText,
        labelText: null, // Không dùng labelText của InputDecoration nữa
        prefixIconData: prefixIconData,
        isFocused: isFocused,
      ),
      style: theme.textTheme.bodyLarge,
    );

    if (labelText != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldLabelText(labelText!),
          dropdown,
        ],
      );
    }
    return dropdown;
  }
}
