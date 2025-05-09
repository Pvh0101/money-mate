import 'package:flutter/material.dart';
import 'package:money_mate/features/dashboard/data/mock/dashboard_mock_data.dart'; // Import dữ liệu mock
import '../widgets/dashboard_app_bar.dart';
import '../widgets/dashboard_stats_section.dart';
import '../widgets/dashboard_actions_section.dart';
import 'package:money_mate/core/widgets/latest_entries_section.dart'; // Import mới

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentCarouselIndex = 0;

  final List<Map<String, dynamic>> _statCardData =
      DashboardMockData.statCardData;
  final List<Map<String, dynamic>> _actionCardData =
      DashboardMockData.actionCardData;
  final List<Map<String, dynamic>> _latestEntriesData =
      DashboardMockData.latestEntriesData;

  void _onStatCardTapped(Map<String, dynamic> statData) {
    print("Stat card tapped: ${statData['title']}");
    // TODO: Navigate to a relevant screen
  }

  void _onActionCardTapped(Map<String, dynamic> actionData) {
    print("Action card tapped: ${actionData['title']}");
    // TODO: Navigate or perform action
  }

  void _onLatestEntryTapped(Map<String, dynamic> entryData) {
    print("Latest entry tapped: ${entryData['category']}");
    // TODO: Navigate to Transaction Detail screen
  }

  void _onMoreEntriesTapped() {
    print("More entries tapped");
    // TODO: Navigate to All Transactions screen
  }

  void _onUserProfileTapped() {
    print("User profile tapped");
    // TODO: Navigate to Profile screen
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: DashboardAppBar(
        onUserProfileTap: _onUserProfileTapped,
      ),
      body: ListView(
        children: [
          DashboardStatsSection(
            statCardData: _statCardData,
            onStatCardTapped: _onStatCardTapped,
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
              boxShadow: colorScheme.brightness == Brightness.light
                  ? [
                      BoxShadow(
                        color: const Color(0xFF1D3A58).withOpacity(0.12),
                        spreadRadius: 0,
                        blurRadius: 64,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: const Color(0xFF1B2025),
                        blurRadius: 64,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardActionsSection(
                    actionCardData: _actionCardData,
                    currentCarouselIndex:
                        _currentCarouselIndex, // Truyền state này
                    onActionCardTapped: _onActionCardTapped,
                  ),
                  const SizedBox(height: 32.0),
                  LatestEntriesSection(
                    latestEntriesData: _latestEntriesData,
                    onLatestEntryTapped: _onLatestEntryTapped,
                    onMoreEntriesTapped: _onMoreEntriesTapped,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
