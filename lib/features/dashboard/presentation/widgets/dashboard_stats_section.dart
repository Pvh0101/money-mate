import 'package:flutter/material.dart';
// import 'package:money_mate/features/dashboard/presentation/widgets/stat_card_item.dart'; // Import cũ
import 'package:money_mate/core/widgets/stat_card_item.dart'; // Import mới

class DashboardStatsSection extends StatelessWidget {
  final List<Map<String, dynamic>> statCardData;
  final Function(Map<String, dynamic> statData) onStatCardTapped;

  const DashboardStatsSection({
    super.key,
    required this.statCardData,
    required this.onStatCardTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: SizedBox(
        height: 140, // hoặc điều chỉnh theo chiều cao của StatCardItem
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          itemCount: statCardData.length,
          itemBuilder: (context, index) {
            final data = statCardData[index];
            return StatCardItem(
              title: data["title"]! as String,
              value: data["value"]! as String,
              iconPath: data["icon"]! as String,
              isPrimaryStyle: data["isPrimary"]! as bool,
              onTap: () => onStatCardTapped(data),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 16.0),
        ),
      ),
    );
  }
}
