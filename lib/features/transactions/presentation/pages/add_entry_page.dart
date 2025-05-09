import 'package:flutter/material.dart';
import 'package:money_mate/core/widgets/custom_app_bar.dart';
import 'package:money_mate/features/dashboard/data/mock/dashboard_mock_data.dart'; // Tạm dùng mock data
// import 'package:money_mate/features/dashboard/presentation/widgets/dashboard_latest_entries_section.dart'; // Import cũ
import 'package:money_mate/core/widgets/latest_entries_section.dart';
import 'package:money_mate/features/transactions/presentation/widgets/add_options_section.dart';
import 'package:money_mate/core/constants/route_constants.dart'; // Thêm import này
// import 'package:money_mate/core/widgets/custom_bottom_nav_bar.dart'; // Giả sử có widget này

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  // Mock data cho Latest Entries
  final List<Map<String, dynamic>> _latestEntriesData =
      DashboardMockData.latestEntriesData;

  void _onAddIncomeTapped() {
    Navigator.pushNamed(context, RouteConstants.addIncome);
  }

  void _onAddExpenseTapped() {
    Navigator.pushNamed(context, RouteConstants.addExpense);
  }

  void _onPlusIconTapped() {}

  void _onLatestEntryTapped(Map<String, dynamic> entryData) {}

  void _onMoreEntriesTapped() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Theo Figma, phần "Latest Entries" có nền riêng và bo góc trên.
    // Nền chung của trang là màu screenBackgroundFigma (ví dụ: #F5F6F7 cho light)

    return Scaffold(
      backgroundColor: colorScheme.background, // Nền chính của trang
      appBar: const CustomAppBar(
        titleText: 'Add Entry',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: AddOptionsSection(
              onAddIncomeTap: _onAddIncomeTapped,
              onAddExpenseTap: _onAddExpenseTapped,
              onPlusIconTap: _onPlusIconTapped,
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                boxShadow: colorScheme.brightness == Brightness.light
                    ? [
                        BoxShadow(
                          color: const Color(0xFF1D3A58)
                              .withOpacity(0.12), // Figma shadow for light
                          spreadRadius: 0, // Mặc định Figma là 0
                          blurRadius: 64, // Figma blur
                          offset: const Offset(0, 8), // Figma offset
                        ),
                      ]
                    : [
                        const BoxShadow(
                          color: Color(
                              0xFF1B2025), // Figma shadow for dark (opacity 1)
                          blurRadius: 64,
                          offset: Offset(0, 8),
                        ),
                      ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 32.0),
                  child: LatestEntriesSection(
                    latestEntriesData: _latestEntriesData,
                    onLatestEntryTapped: _onLatestEntryTapped,
                    onMoreEntriesTapped: _onMoreEntriesTapped,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
