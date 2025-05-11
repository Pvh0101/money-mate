import 'package:flutter/material.dart';
import 'package:money_mate/features/transactions/presentation/pages/add_income_page.dart';
import 'package:money_mate/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:money_mate/features/dashboard/presentation/pages/total_expense_page.dart';
import 'package:money_mate/features/budgets/presentation/pages/budgets_page.dart';
import 'package:money_mate/features/transactions/presentation/pages/entries_page.dart';
import 'package:money_mate/features/home/profile_page.dart';
import 'package:money_mate/core/app_bottom_navigation_bar.dart';
import 'package:money_mate/core/routes/app_routes.dart';
import 'package:money_mate/core/constants/route_constants.dart';

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
    TotalExpensePage(),
    AddIncomePage(),
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
    Routes.navigateTo(context, RouteConstants.addEntry);
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
