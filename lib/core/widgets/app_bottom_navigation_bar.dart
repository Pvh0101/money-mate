import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_mate/core/theme/app_colors.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onAddPressed;
  final bool hasNotification;

  const AppBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onAddPressed,
    this.hasNotification = false,
  });

  static const _fabSize = 64.0;
  static const _fabTopOffset = -10.0;
  static const _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        _buildNavigationBar(context),
        Positioned(
          top: _fabTopOffset,
          child: GestureDetector(
            onTap: onAddPressed,
            child: Container(
              width: _fabSize,
              height: _fabSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF2F51FF), primaryBrandBlue],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(18, 98, 251, 0.32),
                    blurRadius: 24,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child:
                  const Icon(Icons.add, color: neutralWhite, size: _iconSize),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor:
          Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: selectedIndex >= 2 ? selectedIndex + 1 : selectedIndex,
      onTap: onTabSelected,
      items: [
        _buildItem('assets/icons/home.svg', 0),
        _buildItem('assets/icons/task.svg', 1),
        const BottomNavigationBarItem(
          icon: SizedBox(width: _fabSize),
          label: '',
        ),
        _buildItem('assets/icons/notification.svg', 2,
            showBadge: hasNotification),
        _buildItem('assets/icons/setting.svg', 3),
      ],
    );
  }

  BottomNavigationBarItem _buildItem(String iconPath, int index,
      {bool showBadge = false}) {
    final isSelected = selectedIndex == index;
    final icon = SvgPicture.asset(
      iconPath,
      width: _iconSize,
      height: _iconSize,
      colorFilter: isSelected
          ? const ColorFilter.mode(primaryBrandBlue, BlendMode.srcIn)
          : null,
    );

    return BottomNavigationBarItem(
      icon: showBadge
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                icon,
                const Positioned(
                  top: -1,
                  right: -1,
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: systemRed,
                  ),
                ),
              ],
            )
          : icon,
      label: '',
    );
  }
}
