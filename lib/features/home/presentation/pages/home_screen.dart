import 'package:flutter/material.dart';
import 'package:money_mate/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:money_mate/features/transactions/presentation/pages/transactions_page.dart';
import 'package:money_mate/features/budgets/presentation/pages/budgets_page.dart';
import 'package:money_mate/features/profile/presentation/pages/profile_page.dart';
import 'package:money_mate/features/home/presentation/widgets/app_bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    TransactionsPage(),
    BudgetsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      return;
    }
    int adjustedIndex = index > 1 ? index - 1 : index;
    setState(() {
      _selectedIndex = adjustedIndex;
    });
  }

  void _onAddPressed() {
    print('Add button tapped!');
    // TODO: Hiển thị modal hay điều hướng đến trang tạo mới
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onItemTapped,
        onAddPressed: _onAddPressed,
      ),
    );
  }
} 