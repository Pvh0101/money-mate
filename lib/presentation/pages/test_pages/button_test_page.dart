import 'package:flutter/material.dart';
import 'package:money_mate/presentation/widgets/buttons/button_enums.dart';
import 'package:money_mate/presentation/widgets/buttons/app_outline_button.dart';
import 'package:money_mate/presentation/widgets/buttons/app_text_button.dart';
import 'package:money_mate/presentation/widgets/buttons/app_fill_button.dart';
import 'package:money_mate/presentation/widgets/buttons/app_icon_button.dart';
import '../../widgets/fields/app_text_field.dart';

class ButtonTestPage extends StatelessWidget {
  const ButtonTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Buttons Test Page'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 16.0, 
          runSpacing: 16.0, 
          children: <Widget>[
            // AppFillButton Section
            const Text('--- AppFillButtons ---', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            const SizedBox(height: 10, width: double.infinity),
            const Text('Button Sizes (Fill):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppFillButton(
              text: 'Small Fill',
              onPressed: () {},
              size: ButtonSize.small,
            ),
            AppFillButton(
              text: 'Medium Fill',
              onPressed: () {},
              size: ButtonSize.medium,
            ),
            AppFillButton(
              text: 'Large Fill (Default)',
              onPressed: () {},
              size: ButtonSize.large,
            ),
            const SizedBox(height: 20, width: double.infinity),
            const Text('Button Class Types (Fill):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppFillButton(
              text: 'Standard Fill',
              onPressed: () {},
              classType: ButtonClassType.standard,
            ),
            AppFillButton(
              text: 'Dangerous Fill',
              onPressed: () {},
              classType: ButtonClassType.dangerous,
            ),
            const SizedBox(height: 20, width: double.infinity),
            const Text('Button States (Fill):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppFillButton(text: 'Disabled Standard Fill', onPressed: () {}, classType: ButtonClassType.standard, isDisabled: true),
            AppFillButton(text: 'Loading Standard Fill', onPressed: () {}, classType: ButtonClassType.standard, isLoading: true),
            AppFillButton(text: 'Disabled Dangerous Fill', onPressed: () {}, classType: ButtonClassType.dangerous, isDisabled: true),
            AppFillButton(text: 'Loading Dangerous Fill', onPressed: () {}, classType: ButtonClassType.dangerous, isLoading: true),
            const SizedBox(height: 20, width: double.infinity),
            const Text('Buttons with Icons (Fill):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppFillButton(text: 'Leading Icon Fill', onPressed: () {}, classType: ButtonClassType.standard, leadingIcon: Icon(Icons.add)),
            AppFillButton(text: 'Trailing Icon Fill', onPressed: () {}, classType: ButtonClassType.standard, trailingIcon: Icon(Icons.arrow_forward)),
            AppFillButton(text: 'Icons Fill (Dangerous)', onPressed: () {}, classType: ButtonClassType.dangerous, leadingIcon: Icon(Icons.favorite), trailingIcon: Icon(Icons.share), size: ButtonSize.medium),
            AppFillButton(text: 'Loading Icon Fill', onPressed: () {}, classType: ButtonClassType.standard, leadingIcon: Icon(Icons.save), isLoading: true),
            const SizedBox(height: 20, width: double.infinity),
            const Text('Full Width Buttons (Fill):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppFillButton(text: 'Full Width Standard Fill', onPressed: () {}, classType: ButtonClassType.standard, isFullWidth: true),
            AppFillButton(text: 'Full Width Dangerous Fill', onPressed: () {}, classType: ButtonClassType.dangerous, isFullWidth: true),
            
            // AppOutlineButton Section
            const SizedBox(height: 30, width: double.infinity),
            const Text('--- AppOutlineButtons ---', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 10, width: double.infinity),
            const Text('Button Sizes (Outline):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppOutlineButton(text: 'Small Outline', onPressed: () {}, size: ButtonSize.small),
            AppOutlineButton(text: 'Medium Outline', onPressed: () {}, size: ButtonSize.medium),
            AppOutlineButton(text: 'Large Outline (Default)', onPressed: () {}, size: ButtonSize.large),
            const SizedBox(height: 20, width: double.infinity),
            const Text('Button Class Types (Outline):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppOutlineButton(text: 'Standard Outline', onPressed: () {}, classType: ButtonClassType.standard),
            AppOutlineButton(text: 'Dangerous Outline', onPressed: () {}, classType: ButtonClassType.dangerous),
            const SizedBox(height: 20, width: double.infinity),
            const Text('Button States (Outline):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppOutlineButton(text: 'Disabled Std Outline', onPressed: () {}, classType: ButtonClassType.standard, isDisabled: true),
            AppOutlineButton(text: 'Loading Std Outline', onPressed: () {}, classType: ButtonClassType.standard, isLoading: true),
            AppOutlineButton(text: 'Disabled Dng Outline', onPressed: () {}, classType: ButtonClassType.dangerous, isDisabled: true),
            AppOutlineButton(text: 'Loading Dng Outline', onPressed: () {}, classType: ButtonClassType.dangerous, isLoading: true),
            const SizedBox(height: 20, width: double.infinity),
            const Text('Buttons with Icons (Outline):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppOutlineButton(text: 'Leading Icon Outline', onPressed: () {}, classType: ButtonClassType.standard, leadingIcon: Icon(Icons.add)),
            AppOutlineButton(text: 'Trailing Icon Outline', onPressed: () {}, classType: ButtonClassType.standard, trailingIcon: Icon(Icons.arrow_forward)),
            AppOutlineButton(text: 'Icons Outline (Dng)', onPressed: () {}, classType: ButtonClassType.dangerous, leadingIcon: Icon(Icons.favorite), trailingIcon: Icon(Icons.share), size: ButtonSize.medium),
            AppOutlineButton(text: 'Loading Icon Outline', onPressed: () {}, classType: ButtonClassType.standard, leadingIcon: Icon(Icons.save), isLoading: true),
            const SizedBox(height: 20, width: double.infinity),
            const Text('Full Width Buttons (Outline):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppOutlineButton(text: 'Full Width Std Outline', onPressed: () {}, classType: ButtonClassType.standard, isFullWidth: true),
            AppOutlineButton(text: 'Full Width Dng Outline', onPressed: () {}, classType: ButtonClassType.dangerous, isFullWidth: true),

            // AppTextButton Section
            const SizedBox(height: 30, width: double.infinity),
            const Text('--- AppTextButtons ---', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple)),
            const SizedBox(height: 10, width: double.infinity),
            const Text('Button Sizes (Text):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppTextButton(text: 'Small Text', onPressed: () {}, size: ButtonSize.small),
            AppTextButton(text: 'Medium Text', onPressed: () {}, size: ButtonSize.medium),
            AppTextButton(text: 'Large Text (Default)', onPressed: () {}, size: ButtonSize.large),
            const SizedBox(height: 20, width: double.infinity),
            const Text('Button Class Types (Text):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppTextButton(text: 'Standard Text', onPressed: () {}, classType: ButtonClassType.standard),
            AppTextButton(text: 'Dangerous Text', onPressed: () {}, classType: ButtonClassType.dangerous),
            const SizedBox(height: 20, width: double.infinity),
            const Text('Button States (Text):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppTextButton(text: 'Disabled Std Text', onPressed: () {}, classType: ButtonClassType.standard, isDisabled: true),
            AppTextButton(text: 'Loading Std Text', onPressed: () {}, classType: ButtonClassType.standard, isLoading: true),
            AppTextButton(text: 'Disabled Dng Text', onPressed: () {}, classType: ButtonClassType.dangerous, isDisabled: true),
            AppTextButton(text: 'Loading Dng Text', onPressed: () {}, classType: ButtonClassType.dangerous, isLoading: true),
            const SizedBox(height: 20, width: double.infinity),
            const Text('Buttons with Icons (Text):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppTextButton(text: 'Leading Icon Text', onPressed: () {}, classType: ButtonClassType.standard, leadingIcon: Icon(Icons.add)),
            AppTextButton(text: 'Trailing Icon Text', onPressed: () {}, classType: ButtonClassType.standard, trailingIcon: Icon(Icons.arrow_forward)),
            AppTextButton(text: 'Icons Text (Dng)', onPressed: () {}, classType: ButtonClassType.dangerous, leadingIcon: Icon(Icons.favorite), trailingIcon: Icon(Icons.share), size: ButtonSize.medium),
            AppTextButton(text: 'Loading Icon Text', onPressed: () {}, classType: ButtonClassType.standard, leadingIcon: Icon(Icons.save), isLoading: true),
            const SizedBox(height: 20, width: double.infinity),
            const Text('Full Width Buttons (Text):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppTextButton(text: 'Full Width Std Text', onPressed: () {}, classType: ButtonClassType.standard, isFullWidth: true),
            AppTextButton(text: 'Full Width Dng Text', onPressed: () {}, classType: ButtonClassType.dangerous, isFullWidth: true),

            // AppIconButton Section
            const SizedBox(height: 30, width: double.infinity),
            const Text('--- AppIconButtons ---', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
            const SizedBox(height: 10, width: double.infinity),
            const Text('Button Sizes (Icon):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppIconButton(
              icon: Icons.add,
              onPressed: () {},
              size: ButtonSize.small,
            ),
            AppIconButton(
              icon: Icons.add,
              onPressed: () {},
              size: ButtonSize.medium,
            ),
            AppIconButton(
              icon: Icons.add,
              onPressed: () {},
              size: ButtonSize.large,
            ),
            const SizedBox(height: 20, width: double.infinity),
            const Text('Button Class Types (Icon):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppIconButton(
              icon: Icons.favorite,
              onPressed: () {},
              classType: ButtonClassType.standard,
            ),
            AppIconButton(
              icon: Icons.delete,
              onPressed: () {},
              classType: ButtonClassType.dangerous,
            ),
            const SizedBox(height: 20, width: double.infinity),
            const Text('Button States (Icon):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppIconButton(
              icon: Icons.edit,
              onPressed: () {},
              classType: ButtonClassType.standard,
              isDisabled: true,
            ),
            AppIconButton(
              icon: Icons.save,
              onPressed: () {},
              classType: ButtonClassType.standard,
              isLoading: true,
            ),
            AppIconButton(
              icon: Icons.delete,
              onPressed: () {},
              classType: ButtonClassType.dangerous,
              isDisabled: true,
            ),
            AppIconButton(
              icon: Icons.delete,
              onPressed: () {},
              classType: ButtonClassType.dangerous,
              isLoading: true,
            ),
            const SizedBox(height: 20, width: double.infinity),
            const Text('Custom IconButtons (Mixed):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppIconButton(
              icon: Icons.settings,
              onPressed: () {},
              iconButtonType: IconButtonType.filled,
              shape: IconButtonShape.square,
              classType: ButtonClassType.standard,
            ),
            AppIconButton(
              icon: Icons.star,
              onPressed: () {},
              iconButtonType: IconButtonType.outline,
              shape: IconButtonShape.circle,
              classType: ButtonClassType.standard,
              size: ButtonSize.large,
            ),

            // AppIconButton - Filled, Circle - Default
            const SizedBox(height: 30, width: double.infinity),
            const Text('--- AppIconButtons (Filled, Circle - Default) ---', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
            const SizedBox(height: 10, width: double.infinity),
            const Text('Sizes (Filled, Circle):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppIconButton(icon: Icons.add_circle, onPressed: () {}, size: ButtonSize.small),
            AppIconButton(icon: Icons.add_circle_outline, onPressed: () {}, size: ButtonSize.medium),
            AppIconButton(icon: Icons.add_circle_sharp, onPressed: () {}, size: ButtonSize.large),
            const SizedBox(height: 10, width: double.infinity),
            const Text('Class Types (Filled, Circle):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppIconButton(icon: Icons.favorite, onPressed: () {}, classType: ButtonClassType.standard),
            AppIconButton(icon: Icons.delete, onPressed: () {}, classType: ButtonClassType.dangerous),
            const SizedBox(height: 10, width: double.infinity),
            const Text('States (Filled, Circle):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppIconButton(icon: Icons.edit, onPressed: () {}, classType: ButtonClassType.standard, isDisabled: true),
            AppIconButton(icon: Icons.save, onPressed: () {}, classType: ButtonClassType.standard, isLoading: true),
            
            // AppIconButton - Filled, Square
            const SizedBox(height: 20, width: double.infinity),
            const Text('--- AppIconButtons (Filled, Square) ---', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
            const SizedBox(height: 10, width: double.infinity),
            AppIconButton(icon: Icons.square, onPressed: () {}, shape: IconButtonShape.square, size: ButtonSize.small),
            AppIconButton(icon: Icons.check_box_outline_blank, onPressed: () {}, shape: IconButtonShape.square, classType: ButtonClassType.standard),
            AppIconButton(icon: Icons.dangerous, onPressed: () {}, shape: IconButtonShape.square, classType: ButtonClassType.dangerous, size: ButtonSize.large),
            AppIconButton(icon: Icons.square_foot, onPressed: () {}, shape: IconButtonShape.square, isDisabled: true),
            AppIconButton(icon: Icons.apps, onPressed: () {}, shape: IconButtonShape.square, isLoading: true),

            // AppIconButton - Outline, Circle
            const SizedBox(height: 20, width: double.infinity),
            const Text('--- AppIconButtons (Outline, Circle) ---', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.cyan)),
            const SizedBox(height: 10, width: double.infinity),
            AppIconButton(icon: Icons.circle_notifications, onPressed: () {}, iconButtonType: IconButtonType.outline, shape: IconButtonShape.circle, size: ButtonSize.small),
            AppIconButton(icon: Icons.album, onPressed: () {}, iconButtonType: IconButtonType.outline, shape: IconButtonShape.circle, classType: ButtonClassType.standard),
            AppIconButton(icon: Icons.error, onPressed: () {}, iconButtonType: IconButtonType.outline, shape: IconButtonShape.circle, classType: ButtonClassType.dangerous, size: ButtonSize.large),
            AppIconButton(icon: Icons.circle, onPressed: () {}, iconButtonType: IconButtonType.outline, shape: IconButtonShape.circle, isDisabled: true),
            AppIconButton(icon: Icons.data_usage, onPressed: () {}, iconButtonType: IconButtonType.outline, shape: IconButtonShape.circle, isLoading: true),

            // AppIconButton - Outline, Square
            const SizedBox(height: 20, width: double.infinity),
            const Text('--- AppIconButtons (Outline, Square) ---', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
            const SizedBox(height: 10, width: double.infinity),
            AppIconButton(icon: Icons.crop_square, onPressed: () {}, iconButtonType: IconButtonType.outline, shape: IconButtonShape.square, size: ButtonSize.small),
            AppIconButton(icon: Icons.check_box_outline_blank, onPressed: () {}, iconButtonType: IconButtonType.outline, shape: IconButtonShape.square, classType: ButtonClassType.standard),
            AppIconButton(icon: Icons.warning_amber_rounded, onPressed: () {}, iconButtonType: IconButtonType.outline, shape: IconButtonShape.square, classType: ButtonClassType.dangerous, size: ButtonSize.large),
            AppIconButton(icon: Icons.select_all, onPressed: () {}, iconButtonType: IconButtonType.outline, shape: IconButtonShape.square, isDisabled: true),
            AppIconButton(icon: Icons.stop_screen_share_outlined, onPressed: () {}, iconButtonType: IconButtonType.outline, shape: IconButtonShape.square, isLoading: true),

            const SizedBox(height: 20, width: double.infinity),
            const Text('Custom IconButtons (Mixed):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            AppIconButton(
              icon: Icons.settings,
              onPressed: () {},
              iconButtonType: IconButtonType.filled,
              shape: IconButtonShape.square,
              classType: ButtonClassType.standard,
            ),
            AppIconButton(
              icon: Icons.star,
              onPressed: () {},
              iconButtonType: IconButtonType.outline,
              shape: IconButtonShape.circle,
              classType: ButtonClassType.standard,
              size: ButtonSize.large,
            ),

            // AppTextField Section
            const SizedBox(height: 30, width: double.infinity),
            const Text('--- AppTextFields ---', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo)),
            const SizedBox(height: 10, width: double.infinity),

            const Text('Default (Outlined, Medium):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const AppTextField(
              hintText: 'Enter text here',
            ),
            const SizedBox(height: 10, width: double.infinity),

            const Text('Sizes (Outlined):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const AppTextField(
              hintText: 'Small Outlined',
              size: AppTextFieldSize.small,
            ),
            const AppTextField(
              hintText: 'Medium Outlined',
              size: AppTextFieldSize.medium,
            ),
            const AppTextField(
              hintText: 'Large Outlined',
              size: AppTextFieldSize.large,
            ),
            const SizedBox(height: 10, width: double.infinity),

            const Text('Filled Style:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const AppTextField(
              hintText: 'Small Filled',
              size: AppTextFieldSize.small,
              filled: true,
            ),
            const AppTextField(
              hintText: 'Medium Filled',
              size: AppTextFieldSize.medium,
              filled: true,
            ),
            const AppTextField(
              hintText: 'Large Filled',
              size: AppTextFieldSize.large,
              filled: true,
            ),
            const SizedBox(height: 10, width: double.infinity),
            
            const Text('With LabelText:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const AppTextField(
              labelText: 'Your Name',
              hintText: 'Enter your full name',
              size: AppTextFieldSize.medium,
            ),
            const AppTextField(
              labelText: 'Email Address (Filled)',
              hintText: 'example@mail.com',
              size: AppTextFieldSize.medium,
              filled: true,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10, width: double.infinity),

            const Text('With Icons:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const AppTextField(
              hintText: 'Username',
              prefixIcon: Icon(Icons.person_outline),
              size: AppTextFieldSize.medium,
            ),
            const AppTextField(
              hintText: 'Password',
              filled: true,
              obscureText: true,
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: Icon(Icons.visibility_off_outlined),
              size: AppTextFieldSize.medium,
            ),
             AppTextField(
              labelText: 'Search',
              hintText: 'Search items...',
              size: AppTextFieldSize.large,
              suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            ),
            const SizedBox(height: 10, width: double.infinity),

            const Text('States:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const AppTextField(
              hintText: 'Error State',
              errorText: 'This field is required.',
              size: AppTextFieldSize.medium,
            ),
            const AppTextField(
              hintText: 'Disabled Outlined',
              enabled: false,
              size: AppTextFieldSize.medium,
            ),
            const AppTextField(
              hintText: 'Disabled Filled',
              labelText: 'Read Only Data',
              initialValue: "Some pre-filled data",
              enabled: false,
              filled: true,
              readOnly: true,
              size: AppTextFieldSize.medium,
            ),
            const SizedBox(height: 10, width: double.infinity),
             const Text('Full Width TextField:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(
                width: double.infinity,
                child: AppTextField(
                labelText: 'Full Width Field',
                hintText: 'This field tries to be full width',
                size: AppTextFieldSize.medium,
                prefixIcon: Icon(Icons.text_fields_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 