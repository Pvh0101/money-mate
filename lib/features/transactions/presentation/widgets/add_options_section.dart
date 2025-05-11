import 'package:flutter/material.dart';
import 'option_card_item.dart';

class AddOptionsSection extends StatelessWidget {
  final VoidCallback onAddIncomeTap;
  final VoidCallback onAddExpenseTap;
  final VoidCallback onPlusIconTap; // Cho thẻ icon plus viền đứt nét

  const AddOptionsSection({
    super.key,
    required this.onAddIncomeTap,
    required this.onAddExpenseTap,
    required this.onPlusIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 32.0), // Khoảng cách trên dưới section
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Để các card align top
        children: [
          Expanded(
            child: OptionCardItem(
              iconPath: 'assets/icons/plus.svg',
              onTap: onPlusIconTap,
            ),
          ),
          const SizedBox(width: 16), // Khoảng cách giữa các card theo Figma
          Expanded(
            child: OptionCardItem(
              title: 'Add Income',
              iconPath: 'assets/icons/wallet.svg',
              onTap: onAddIncomeTap,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OptionCardItem(
              isHighlighted: true,
              title: 'Add Expense',
              iconPath: 'assets/icons/wallet.svg',
              onTap: onAddExpenseTap,
            ),
          ),
        ],
      ),
    );
  }
}
