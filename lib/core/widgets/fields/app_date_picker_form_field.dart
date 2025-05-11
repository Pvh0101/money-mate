import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Required for date formatting
import 'app_text_form_field.dart';
import 'field_label_text.dart';

/// Trường chọn ngày tháng, sử dụng lại AppTextFormField và style chung.
/// [controller]: controller cho text field.
/// [onDateSelected]: callback khi chọn ngày.
/// [suffixIconData]: icon lịch ở cuối field.
/// [displayFormat]: định dạng hiển thị ngày tháng.
class AppDatePickerFormField extends StatefulWidget {
  const AppDatePickerFormField({
    super.key,
    required this.controller,
    this.prefixIconData,
    this.labelText,
    this.hintText,
    this.validator,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.suffixIconData = Icons.calendar_today_outlined,
    this.displayFormat = 'dd/MM/yyyy', // Default display format
  });

  final TextEditingController controller;
  final String? labelText; // Similar to InputDecoration's labelText
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?>? onDateSelected;
  final IconData suffixIconData;
  final String displayFormat;
  final IconData? prefixIconData;

  @override
  State<AppDatePickerFormField> createState() => _AppDatePickerFormFieldState();
}

class _AppDatePickerFormFieldState extends State<AppDatePickerFormField> {
  late DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _dateFormat = DateFormat(widget.displayFormat);
    // Optionally set initial date to controller if provided and controller is empty
    if (widget.initialDate != null && widget.controller.text.isEmpty) {
      widget.controller.text = _dateFormat.format(widget.initialDate!);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2101),
    );
    if (picked != null) {
      widget.controller.text = _dateFormat.format(picked);
      widget.onDateSelected?.call(picked);
    } else {
      // Optionally handle if no date is picked, e.g., clear or do nothing
      // widget.controller.clear();
      // widget.onDateSelected?.call(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final field = AppTextFormField(
      controller: widget.controller,
      readOnly: true, // Make the text field read-only
      hintText: widget.hintText ??
          widget.labelText, // Use labelText as fallback for hint
      validator: widget.validator,
      suffixIconData: widget.suffixIconData,
      prefixIconData: widget.prefixIconData,
      onTap: () => _selectDate(context), // Open date picker on tap
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
