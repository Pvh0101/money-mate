import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // Không còn cần thiết trực tiếp ở đây
import 'package:money_mate/core/widgets/latest_entry_item.dart'; // Đường dẫn mới

class LatestEntriesSection extends StatelessWidget {
  // Đổi tên class
  final List<Map<String, dynamic>> latestEntriesData;
  final Function(Map<String, dynamic> entryData) onLatestEntryTapped;
  final VoidCallback onMoreEntriesTapped;

  const LatestEntriesSection({
    // Đổi tên constructor
    super.key,
    required this.latestEntriesData,
    required this.onLatestEntryTapped,
    required this.onMoreEntriesTapped,
  });

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Latest Entries',
          style: textTheme.titleMedium,
        ),
        InkWell(
          onTap: onMoreEntriesTapped,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.5),
                width: 0.5,
              ),
            ),
            child: Icon(
              Icons
                  .more_horiz, // Sử dụng Icon thay vì SvgPicture vì đây là icon chuẩn Material
              color: colorScheme.onSurface,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    if (latestEntriesData.isEmpty) {
      return const Center(child: Text('No entries yet.'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: latestEntriesData.length, // Hiển thị tất cả các mục
      itemBuilder: (context, index) {
        final entry = latestEntriesData[index];
        return LatestEntryItem(
          iconPath: entry['icon']! as String,
          category: entry['category']! as String,
          date: entry['date']! as String,
          amount: entry['amount']! as String,
          paymentMethod: entry['paymentMethod']! as String,
          onTap: () => onLatestEntryTapped(entry),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 24.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context),
        const SizedBox(height: 24.0), // Khoảng cách giữa title và list
        _buildList(context),
      ],
    );
  }
}
