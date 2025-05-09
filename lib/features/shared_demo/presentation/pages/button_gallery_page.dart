import 'package:flutter/material.dart';
import 'package:money_mate/core/widgets/buttons/app_fill_button.dart';
import 'package:money_mate/core/widgets/buttons/app_icon_button.dart';
import 'package:money_mate/core/widgets/buttons/app_outline_button.dart';
import 'package:money_mate/core/widgets/buttons/app_text_button.dart';
import 'package:money_mate/core/widgets/buttons/button_enums.dart';

class ButtonGalleryPage extends StatefulWidget {
  const ButtonGalleryPage({super.key});

  static const String routeName = '/button-gallery'; // Example route name

  @override
  State<ButtonGalleryPage> createState() => _ButtonGalleryPageState();
}

class _ButtonGalleryPageState extends State<ButtonGalleryPage> {
  bool _isLoading = false;

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Gallery'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: _toggleLoading,
              child: Text(_isLoading ? 'LOADING ON' : 'LOADING OFF'),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionTitle('AppFillButton', context),
            _buildFillButtonGallery(context),
            const SizedBox(height: 24),
            _buildSectionTitle('AppOutlineButton', context),
            _buildOutlineButtonGallery(context),
            const SizedBox(height: 24),
            _buildSectionTitle('AppTextButton', context),
            _buildTextButtonGallery(context),
            const SizedBox(height: 24),
            _buildSectionTitle('AppIconButton', context),
            _buildIconButtonGallery(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    );
  }

  Widget _buildSubtitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 6.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  // Gallery for AppFillButton
  Widget _buildFillButtonGallery(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        // Standard
        AppFillButton(
            text: 'Standard Large', onPressed: () {}, isLoading: _isLoading),
        AppFillButton(
            text: 'Standard Medium',
            size: ButtonSize.medium,
            onPressed: () {},
            isLoading: _isLoading),
        AppFillButton(
            text: 'Standard Small',
            size: ButtonSize.small,
            onPressed: () {},
            isLoading: _isLoading),
        AppFillButton(
            text: 'Disabled',
            onPressed: () {},
            isDisabled: true,
            isLoading: _isLoading),
        AppFillButton(
            text: 'Icon',
            leadingIcon: const Icon(Icons.add, size: 18),
            onPressed: () {},
            isLoading: _isLoading),

        // Dangerous
        AppFillButton(
            text: 'Dangerous Large',
            classType: ButtonClassType.dangerous,
            onPressed: () {},
            isLoading: _isLoading),
        AppFillButton(
            text: 'Dangerous Med',
            classType: ButtonClassType.dangerous,
            size: ButtonSize.medium,
            onPressed: () {},
            isLoading: _isLoading),
        AppFillButton(
            text: 'Dangerous Small',
            classType: ButtonClassType.dangerous,
            size: ButtonSize.small,
            onPressed: () {},
            isLoading: _isLoading),
        AppFillButton(
            text: 'Dangerous Dis',
            classType: ButtonClassType.dangerous,
            onPressed: () {},
            isDisabled: true,
            isLoading: _isLoading),
      ],
    );
  }

  // Gallery for AppOutlineButton
  Widget _buildOutlineButtonGallery(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        AppOutlineButton(
            text: 'Standard Large', onPressed: () {}, isLoading: _isLoading),
        AppOutlineButton(
            text: 'Standard Medium',
            size: ButtonSize.medium,
            onPressed: () {},
            isLoading: _isLoading),
        AppOutlineButton(
            text: 'Standard Small',
            size: ButtonSize.small,
            onPressed: () {},
            isLoading: _isLoading),
        AppOutlineButton(
            text: 'Disabled',
            onPressed: () {},
            isDisabled: true,
            isLoading: _isLoading),
        AppOutlineButton(
            text: 'Icon',
            leadingIcon: const Icon(Icons.add, size: 18),
            onPressed: () {},
            isLoading: _isLoading),
        AppOutlineButton(
            text: 'Dangerous Large',
            classType: ButtonClassType.dangerous,
            onPressed: () {},
            isLoading: _isLoading),
        AppOutlineButton(
            text: 'Dangerous Med',
            classType: ButtonClassType.dangerous,
            size: ButtonSize.medium,
            onPressed: () {},
            isLoading: _isLoading),
        AppOutlineButton(
            text: 'Dangerous Small',
            classType: ButtonClassType.dangerous,
            size: ButtonSize.small,
            onPressed: () {},
            isLoading: _isLoading),
      ],
    );
  }

  // Gallery for AppTextButton
  Widget _buildTextButtonGallery(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        AppTextButton(
            text: 'Standard Large', onPressed: () {}, isLoading: _isLoading),
        AppTextButton(
            text: 'Standard Medium',
            size: ButtonSize.medium,
            onPressed: () {},
            isLoading: _isLoading),
        AppTextButton(
            text: 'Standard Small',
            size: ButtonSize.small,
            onPressed: () {},
            isLoading: _isLoading),
        AppTextButton(
            text: 'Disabled',
            onPressed: () {},
            isDisabled: true,
            isLoading: _isLoading),
        AppTextButton(
            text: 'Icon',
            leadingIcon: const Icon(Icons.info_outline, size: 18),
            onPressed: () {},
            isLoading: _isLoading),
        AppTextButton(
            text: 'Dangerous Large',
            classType: ButtonClassType.dangerous,
            onPressed: () {},
            isLoading: _isLoading),
        AppTextButton(
            text: 'Dangerous Med',
            classType: ButtonClassType.dangerous,
            size: ButtonSize.medium,
            onPressed: () {},
            isLoading: _isLoading),
        AppTextButton(
            text: 'Dangerous Small',
            classType: ButtonClassType.dangerous,
            size: ButtonSize.small,
            onPressed: () {},
            isLoading: _isLoading),
      ],
    );
  }

  // Gallery for AppIconButton
  Widget _buildIconButtonGallery(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubtitle('Filled - Circle', context),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            AppIconButton(
                icon: Icons.home, onPressed: () {}, isLoading: _isLoading),
            AppIconButton(
                icon: Icons.settings,
                size: ButtonSize.medium,
                onPressed: () {},
                isLoading: _isLoading),
            AppIconButton(
                icon: Icons.search,
                size: ButtonSize.small,
                onPressed: () {},
                isLoading: _isLoading),
            AppIconButton(
                icon: Icons.delete,
                classType: ButtonClassType.dangerous,
                onPressed: () {},
                isLoading: _isLoading),
            AppIconButton(
                icon: Icons.favorite,
                isDisabled: true,
                onPressed: () {},
                isLoading: _isLoading),
          ],
        ),
        _buildSubtitle('Filled - Square', context),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            AppIconButton(
                icon: Icons.home,
                shape: IconButtonShape.square,
                onPressed: () {},
                isLoading: _isLoading),
            AppIconButton(
                icon: Icons.settings,
                shape: IconButtonShape.square,
                size: ButtonSize.medium,
                onPressed: () {},
                isLoading: _isLoading),
            AppIconButton(
                icon: Icons.search,
                shape: IconButtonShape.square,
                size: ButtonSize.small,
                onPressed: () {},
                isLoading: _isLoading),
            AppIconButton(
                icon: Icons.delete,
                shape: IconButtonShape.square,
                classType: ButtonClassType.dangerous,
                onPressed: () {},
                isLoading: _isLoading),
          ],
        ),
        _buildSubtitle('Outline - Circle', context),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            AppIconButton(
                icon: Icons.home,
                iconButtonType: IconButtonType.outline,
                onPressed: () {},
                isLoading: _isLoading),
            AppIconButton(
                icon: Icons.settings,
                iconButtonType: IconButtonType.outline,
                size: ButtonSize.medium,
                onPressed: () {},
                isLoading: _isLoading),
            AppIconButton(
                icon: Icons.search,
                iconButtonType: IconButtonType.outline,
                size: ButtonSize.small,
                onPressed: () {},
                isLoading: _isLoading),
            AppIconButton(
                icon: Icons.delete,
                iconButtonType: IconButtonType.outline,
                classType: ButtonClassType.dangerous,
                onPressed: () {},
                isLoading: _isLoading),
          ],
        ),
        _buildSubtitle('Outline - Square', context),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            AppIconButton(
                icon: Icons.home,
                iconButtonType: IconButtonType.outline,
                shape: IconButtonShape.square,
                onPressed: () {},
                isLoading: _isLoading),
            AppIconButton(
                icon: Icons.settings,
                iconButtonType: IconButtonType.outline,
                shape: IconButtonShape.square,
                size: ButtonSize.medium,
                onPressed: () {},
                isLoading: _isLoading),
            AppIconButton(
                icon: Icons.search,
                iconButtonType: IconButtonType.outline,
                shape: IconButtonShape.square,
                size: ButtonSize.small,
                onPressed: () {},
                isLoading: _isLoading),
            AppIconButton(
                icon: Icons.delete,
                iconButtonType: IconButtonType.outline,
                shape: IconButtonShape.square,
                classType: ButtonClassType.dangerous,
                onPressed: () {},
                isLoading: _isLoading),
          ],
        ),
      ],
    );
  }
}
