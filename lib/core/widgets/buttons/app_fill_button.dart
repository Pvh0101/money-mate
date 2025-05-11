import 'package:flutter/material.dart';

class AppFillButton extends StatefulWidget {
  const AppFillButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isExpanded = false,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isExpanded;

  @override
  State<AppFillButton> createState() => _AppFillButtonState();
}

class _AppFillButtonState extends State<AppFillButton> {
  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        elevation: 6,
        shadowColor: Theme.of(context).colorScheme.primaryFixed,
        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        widget.text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white,
            ),
      ),
    );

    if (widget.isExpanded) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }
    return button;
  }
}
