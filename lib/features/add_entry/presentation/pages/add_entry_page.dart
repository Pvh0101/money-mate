import 'package:flutter/material.dart';
import 'package:money_mate/features/dashboard/data/mock/dashboard_mock_data.dart'; // Tạm dùng mock data
// import 'package:money_mate/features/dashboard/presentation/widgets/dashboard_latest_entries_section.dart'; // Import cũ
import 'package:money_mate/core/widgets/latest_entries_section.dart'; // Import mới
import '../widgets/add_entry_app_bar.dart';
import '../widgets/add_options_section.dart';
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
    print("Add Income Tapped");
    // TODO: Navigate to Add Income screen
  }

  void _onAddExpenseTapped() {
    print("Add Expense Tapped");
    // TODO: Navigate to Add Expense screen
  }

  void _onPlusIconTapped() {
    print("Plus Icon Card Tapped");
    // TODO: Có thể là một action khác hoặc không làm gì
  }

  void _onLatestEntryTapped(Map<String, dynamic> entryData) {
    print("Latest entry tapped from AddEntryPage: \${entryData['category']}");
    // TODO: Navigate to Transaction Detail screen
  }

  void _onMoreEntriesTapped() {
    print("More entries tapped from AddEntryPage");
    // TODO: Navigate to All Transactions screen
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Theo Figma, phần "Latest Entries" có nền riêng và bo góc trên.
    // Nền chung của trang là màu screenBackgroundFigma (ví dụ: #F5F6F7 cho light)

    return Scaffold(
      backgroundColor: colorScheme.background, // Nền chính của trang
      appBar: AddEntryAppBar(
        onBackTap: () {
          // Xử lý khi nhấn nút back, ví dụ Navigator.pop(context)
          // Hoặc nếu nó là một phần của tab, thì chuyển tab
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
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
                        BoxShadow(
                          color: const Color(
                              0xFF1B2025), // Figma shadow for dark (opacity 1)
                          blurRadius: 64,
                          offset: const Offset(0, 8),
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
      // bottomNavigationBar: CustomBottomNavigationBar( // Nếu có
      //   currentIndex: 2, // Giả sử FAB là index 2
      //   onTap: (index) {
      //     // Xử lý chuyển tab
      //     print('Tapped tab $index');
      //   },
      // ),
      // floatingActionButton: FloatingActionButton( // Theo Figma, FAB là một phần của BottomNavBar
      //   onPressed: () { /* Hành động của FAB, có thể là _onPlusIconTapped hoặc _onAddExpenseTapped */ },
      //   backgroundColor: colorScheme.primary, // Hoặc gradient
      //   child: Icon(Icons.add, color: colorScheme.onPrimary),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Nếu BottomNavBar có notch
    );
  }
}
