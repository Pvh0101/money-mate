import 'package:flutter/material.dart';
import 'package:money_mate/core/widgets/action_card_item.dart';

class DashboardActionsSection extends StatelessWidget {
  final List<Map<String, dynamic>> actionCardData;
  final int currentCarouselIndex; // Để xác định indicator nào active
  final Function(Map<String, dynamic> actionData) onActionCardTapped;
  // Nếu cần callback cho việc thay đổi carousel index từ bên trong (ví dụ: nếu dùng PageView ở đây)
  // final Function(int index)? onCarouselPageChanged;

  const DashboardActionsSection({
    super.key,
    required this.actionCardData,
    required this.currentCarouselIndex,
    required this.onActionCardTapped,
    // this.onCarouselPageChanged,
  });

  Widget _buildCarouselIndicator(BuildContext context,
      {required bool isActive}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? colorScheme.primary : colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context); // Không cần trực tiếp nếu ActionCardItem đã xử lý

    List<Widget> actionCards = [];
    for (int i = 0; i < actionCardData.length; i++) {
      final data = actionCardData[i];
      actionCards.add(Expanded(
        child: ActionCardItem(
          iconPath: data["icon"]! as String,
          title: data["title"]! as String,
          isHighlighted: data["isHighlighted"]! as bool,
          onTap: () => onActionCardTapped(data),
        ),
      ));
      if (i < actionCardData.length - 1) {
        actionCards.add(const SizedBox(width: 12.0));
      }
    }

    List<Widget> indicators = List.generate(actionCardData.length, (index) {
      return _buildCarouselIndicator(context,
          isActive: index == currentCarouselIndex);
    });

    List<Widget> spacedIndicators = [];
    for (int i = 0; i < indicators.length; i++) {
      spacedIndicators.add(indicators[i]);
      if (i < indicators.length - 1) {
        spacedIndicators.add(const SizedBox(width: 8.0));
      }
    }

    return Column(
      children: [
        Row(
          children: actionCards,
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: spacedIndicators,
        ),
      ],
    );
  }
}
