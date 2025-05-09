import 'package:flutter/material.dart';
import 'package:money_mate/core/widgets/custom_app_bar.dart';
import 'package:money_mate/features/dashboard/data/mock/dashboard_mock_data.dart';
import 'package:money_mate/core/widgets/latest_entries_section.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Entries',
      ),
      body: SingleChildScrollView(
        child: LatestEntriesSection(
          latestEntriesData: DashboardMockData.latestEntriesData,
          onLatestEntryTapped: (entryData) {
            // TODO: Xử lý khi một entry được tap, ví dụ điều hướng đến chi tiết
            // print('Entry tapped: ${entryData['category']}');
          },
          onMoreEntriesTapped: () {
            // TODO: Xử lý khi nút "More" được tap, ví dụ điều hướng đến một trang đầy đủ hơn nếu cần
            // print('More entries tapped');
            // Trong ngữ cảnh của EntriesPage, nút này có thể không cần thiết
            // hoặc có thể ẩn đi nếu LatestEntriesSection cho phép.
            // Hiện tại, LatestEntriesSection luôn hiển thị nút này.
          },
        ),
      ),
    );
  }
}
