import 'package:flutter/material.dart';
import '../widgets/dashboard_app_bar.dart'; // Import DashboardAppBar
import '../widgets/stat_card_item.dart'; // Import  StatCardItem
import '../widgets/action_card_item.dart'; // Import ActionCardItem
import '../widgets/latest_entry_item.dart'; 
// Dòng import cho dashboard_bottom_nav_bar.dart đã được xóa hẳn

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentCarouselIndex = 0; // State cho carousel indicator

  // TODO: Replace with data from Bloc/Repository
  final List<Map<String, dynamic>> _statCardData = [
    {"title": "Total Salary", "value": "\$1,289", "isPrimary": false},
    {"title": "Total Expense", "value": "\$298", "isPrimary": true},
    {"title": "Monthly Expense", "value": "\$3,389", "isPrimary": false},
    // Thêm thẻ khác ở đây nếu cần
  ];

  // TODO: Replace with data from Bloc/Repository
  final List<Map<String, dynamic>> _actionCardData = [
    {"title": "Savings", "icon": Icons.savings_outlined, "isHighlighted": true},
    {"title": "Remind", "icon": Icons.notifications_outlined, "isHighlighted": false},
    {"title": "Budget", "icon": Icons.wallet_outlined, "isHighlighted": false},
  ];

  // TODO: Replace with data from Bloc/Repository
  final List<Map<String, dynamic>> _latestEntriesData = [
    {
      "icon": Icons.fastfood, 
      "category": "Food",
      "date": "20 Feb 2024",
      "amount": "+ \$20 + Vat 0.5%",
      "paymentMethod": "Google Pay",
    },
    {
      "icon": Icons.directions_car, 
      "category": "Uber",
      "date": "13 Mar 2024",
      "amount": "- \$18 + Vat 0.8%",
      "paymentMethod": "Cash",
    },
    {
      "icon": Icons.shopping_bag, 
      "category": "Shopping",
      "date": "11 Mar 2024",
      "amount": "- \$400 + Vat 0.12%",
      "paymentMethod": "Paytm",
    },
  ];

  // Giả sử có một cách để thay đổi _currentCarouselIndex, ví dụ qua PageView sau này
  // void _onCarouselPageChanged(int index) {
  //   setState(() {
  //     _currentCarouselIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Sử dụng màu từ theme
      appBar: const DashboardAppBar(), 
      body: ListView(
        children: [
          _buildStatsSection(),
          Container(
            margin: const EdgeInsets.only(top: 24.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface, // Sử dụng màu từ theme
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCarouselSection(context), // Truyền context để lấy theme
                  const SizedBox(height: 24.0),
                  _buildLatestEntriesTitle(context), // Truyền context để lấy theme
                  const SizedBox(height: 32.0),
                  _buildLatestEntriesList(context), // Truyền context để lấy theme
                ],
              ),
            ),
          )
        ],
      ),
      // Các dòng floatingActionButton, floatingActionButtonLocation, bottomNavigationBar đã được xóa hẳn
    );
  }

  Widget _buildStatsSection() {
    List<Widget> statCards = _statCardData.map((data) {
      return StatCardItem(
        title: data["title"]! as String,
        value: data["value"]! as String,
        isPrimaryStyle: data["isPrimary"]! as bool,
      );
    }).toList();

    List<Widget> spacedStatCards = [];
    for (int i = 0; i < statCards.length; i++) {
      spacedStatCards.add(statCards[i]);
      if (i < statCards.length - 1) {
        spacedStatCards.add(const SizedBox(width: 16.0));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24.0), 
        child: Row(
          children: spacedStatCards, // Sử dụng list đã tạo
        ),
      ),
    );
  }

  // Hàm mới để build phần Action Cards và Carousel Indicators
  Widget _buildCarouselSection(BuildContext context) { // Thêm context
    final theme = Theme.of(context);
    List<Widget> actionCards = [];
    for (int i = 0; i < _actionCardData.length; i++) {
      final data = _actionCardData[i];
      final bool isHighlighted = data["isHighlighted"] as bool;
      final Color iconColor = isHighlighted ? Colors.white : theme.colorScheme.onSurface; // Màu icon dựa trên theme

      actionCards.add(
        Expanded(
          child: ActionCardItem(
            icon: Icon(data["icon"] as IconData, size: 20, color: iconColor),
            title: data["title"] as String,
            isHighlighted: isHighlighted,
          ),
        )
      );
      if (i < _actionCardData.length - 1) {
        actionCards.add(const SizedBox(width: 12.0));
      }
    }

    List<Widget> indicators = List.generate(_actionCardData.length, (index) {
      return _buildCarouselIndicator(context, isActive: index == _currentCarouselIndex); // Truyền context
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

  Widget _buildCarouselIndicator(BuildContext context, {required bool isActive}) { // Thêm context
    final theme = Theme.of(context);
    return Container(
      width: 24,
      height: 8,
      decoration: BoxDecoration(
        // Màu active có thể giữ nguyên hoặc lấy từ theme.primary nếu muốn
        color: isActive ? const Color(0xFF0E33F3) : theme.colorScheme.surfaceVariant, // Màu inactive từ theme
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildLatestEntriesTitle(BuildContext context) { // Thêm context
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Latest Entries",
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600), // Sử dụng style từ theme
        ),
        Container(
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: theme.dividerColor, // Sử dụng màu từ theme
              width: 0.5,
            ),
          ),
          child: Icon(Icons.more_horiz, color: theme.iconTheme.color, size: 20), // Sử dụng màu từ theme
        ),
      ],
    );
  }

  Widget _buildLatestEntriesList(BuildContext context) { 
    final theme = Theme.of(context);
    if (_latestEntriesData.isEmpty) {
      return const Center(child: Text("No recent entries."));
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _latestEntriesData.length,
      itemBuilder: (BuildContext context, int index) {
        final data = _latestEntriesData[index];
        return LatestEntryItem(
          // Tạo Icon với màu từ theme ở đây
          iconWidget: Icon(
            data["icon"] as IconData, 
            size: 24, 
            color: theme.colorScheme.onSurfaceVariant // Màu icon từ theme
          ), 
          category: data["category"] as String,
          date: data["date"] as String,
          amount: data["amount"] as String,
          paymentMethod: data["paymentMethod"] as String,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 32.0);
      },
    );
  }
} 