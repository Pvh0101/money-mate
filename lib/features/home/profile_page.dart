import 'package:flutter/material.dart';
import 'package:money_mate/core/widgets/buttons/app_fill_button.dart';
import 'package:money_mate/core/widgets/buttons/app_icon_button.dart';
import 'package:money_mate/core/widgets/buttons/app_text_button.dart';
import 'package:money_mate/core/widgets/dark_mode_switch.dart';
import 'package:money_mate/core/widgets/fields/app_dropdown_form_field.dart';
import 'package:money_mate/core/widgets/fields/app_text_form_field.dart';
import 'package:money_mate/core/widgets/fields/app_date_picker_form_field.dart';
import 'package:money_mate/core/widgets/fields/password_text_form_field.dart';
import 'package:money_mate/core/widgets/buttons/app_outline_button.dart';
import 'package:money_mate/core/widgets/custom_app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'Profile',
        showBackButton: true,
        trailing: DarkModeSwitch(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Profile Page (Placeholder)'),
              const SizedBox(height: 24),

              // Thêm nút thử nghiệm cho trang chọn ngày mới
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                width: double.infinity,
                child: AppFillButton(
                  isExpanded: true,
                  onPressed: () {},
                  text: 'Thử nghiệm Calendar Picker Mới',
                ),
              ),

              AppTextFormField(
                labelText: 'Name',
                readOnly: false,
                controller: TextEditingController(),
                hintText: 'Enter your name',
                prefixIconData: Icons.person_outline,
              ),
              const SizedBox(height: 24),
              PasswordTextFormField(
                controller: TextEditingController(),
                hintText: 'Enter your password',
              ),
              const SizedBox(height: 24),
              AppDatePickerFormField(
                controller: TextEditingController(),
                hintText: 'Enter your date of birth',
                suffixIconData: Icons.calendar_month_outlined,
              ),
              const SizedBox(height: 24),
              AppDropdownFormField(
                labelText: 'Gender',
                items: [
                  'Female',
                  'Other',
                  'Male',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hintText: 'Select your gender',
                prefixIconData: Icons.person_outline,
                onChanged: (value) {
                  print(value);
                },
              ),
              const SizedBox(height: 24),
              AppFillButton(
                isExpanded: false,
                onPressed: () {},
                text: 'Date Picker',
              ),
              const SizedBox(height: 24),
              AppOutlineButton(
                isExpanded: false,
                onPressed: () {},
                text: 'LOGIN',
              ),
              const SizedBox(height: 24),
              AppTextButton(
                onPressed: () {},
                text: 'LOGIN',
              ),
              const SizedBox(height: 24),
              AppIconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              const SizedBox(height: 24),
              AppIconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_back_ios_new),
                isFilled: true,
              ),
              const SizedBox(height: 24),
              AppIconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
                isCircle: false,
                size: 20,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
