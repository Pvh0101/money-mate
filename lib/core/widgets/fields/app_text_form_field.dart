import 'package:flutter/material.dart';
import 'app_form_field_decoration.dart';
import 'field_label_text.dart';

/// Trường nhập liệu text đồng bộ giao diện, hỗ trợ icon, trạng thái focus, ẩn/hiện mật khẩu.
/// [controller]: controller cho text field.
/// [hintText]: gợi ý nhập liệu.
/// [labelText]: nhãn phía trên input.
/// [prefixIconData]: icon ở đầu field.
/// [suffixIconData]: icon ở cuối field.
/// [obscureText]: có phải trường mật khẩu không.
/// [validator]: hàm kiểm tra dữ liệu nhập.
/// [onSuffixIconPressed]: callback khi nhấn icon cuối.
/// [readOnly]: chỉ đọc.
/// [onTap]: callback khi nhấn vào field.
class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.prefixIconData,
    this.suffixIconData,
    this.obscureText = false,
    this.validator,
    this.onSuffixIconPressed,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.readOnly = false,
    this.onTap,
    this.fillColor,
  });
  final bool readOnly;
  final Color? fillColor;
  final VoidCallback? onTap;
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIconData;
  final IconData? suffixIconData;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onSuffixIconPressed;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

/// State cho AppTextFormField, quản lý focus và trạng thái ẩn/hiện mật khẩu.
class _AppTextFormFieldState extends State<AppTextFormField> {
  late FocusNode _focusNode;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _obscureText = widget.obscureText;
    _focusNode.addListener(() {
      setState(() {}); // Rebuild on focus change to update border color
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isFocused = _focusNode.hasFocus;

    IconData? currentSuffixIcon;
    if (widget.obscureText) {
      currentSuffixIcon = _obscureText
          ? Icons.visibility_off_outlined
          : Icons.visibility_outlined;
    }
    if (widget.suffixIconData != null) {
      currentSuffixIcon = widget.suffixIconData;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          FieldLabelText(widget.labelText!),
        ],
        TextFormField(
          readOnly: widget.readOnly,
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: _obscureText,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          onTap: widget.onTap,
          style: theme.textTheme.bodyLarge,
          decoration: appFormFieldDecoration(
            context: context,
            hintText: widget.hintText,
            labelText: null,
            prefixIconData: widget.prefixIconData,
            suffixIconData: currentSuffixIcon,
            onSuffixIconPressed: widget.onSuffixIconPressed ??
                (widget.obscureText
                    ? () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      }
                    : null),
            isFocused: isFocused,
            fillColor: widget.fillColor,
          ),
        ),
      ],
    );
  }
}
