import 'package:flutter/material.dart';
import 'package:money_mate/core/widgets/buttons/app_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Profile Page (Placeholder)'),
          AppButton(
            isDisabled: false,
            onPressed: () {
              // Xử lý khi nhấn nút
              print('Add Expense button pressed!');
            },
            text: 'Logout',
            isFullscreen: true,
          ),
          const SizedBox(height: 20),
          AppButton(
            isDisabled: true,
            onPressed: () {
              // Xử lý khi nhấn nút
              print('Add Expense button pressed!');
            },
            text: 'Logout',
            isFullscreen: true,
          ),
        ],
      ),
    );
  }
}
