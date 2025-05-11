import 'package:flutter/material.dart';
import 'app_text_form_field.dart'; // Assuming AppTextFormField is in the same directory
import 'field_label_text.dart';

/// Trường nhập mật khẩu với icon ẩn/hiện và style đồng bộ.
/// [controller]: controller cho text field.
/// [hintText]: gợi ý nhập liệu.
/// [validator]: hàm kiểm tra dữ liệu nhập.
/// [prefixIconData]: icon ổ khoá ở đầu field.
class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    super.key,
    required this.controller,
    this.hintText = 'Password',
    this.labelText,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.prefixIconData = Icons.lock_outline,
    this.fillColor,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final IconData? prefixIconData; // Allow customizing prefix icon if needed
  final Color? fillColor;

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  // No need to manage _obscureText here, AppTextFormField will do it if obscureText is true
  // and no specific suffixIconData/onSuffixIconPressed is given to it.

  @override
  Widget build(BuildContext context) {
    final field = AppTextFormField(
      controller: widget.controller,
      hintText: widget.hintText,
      validator: widget.validator,
      obscureText: true, // This is the key part for a password field
      prefixIconData: widget.prefixIconData,
      // AppTextFormField will automatically handle visibility toggle icon
      // because obscureText is true and we are not providing suffixIconData
      // or onSuffixIconPressed here directly to AppTextFormField.
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      fillColor: widget.fillColor,
    );
    if (widget.labelText != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldLabelText(widget.labelText!),
          field,
        ],
      );
    }
    return field;
  }
}
