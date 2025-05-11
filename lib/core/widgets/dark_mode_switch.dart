import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: ValueListenableBuilder<AdaptiveThemeMode>(
        valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
        builder: (_, mode, __) {
          if (mode.isDark) {
            return const Icon(Icons.light_mode_outlined);
          } else if (mode.isLight) {
            return const Icon(Icons.dark_mode_outlined);
          } else {
            // System mode, check brightness
            final bool isPlatformDark =
                MediaQuery.platformBrightnessOf(context) == Brightness.dark;
            return Icon(isPlatformDark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined);
          }
        },
      ),
      tooltip: 'Toggle Dark Mode',
      onPressed: () {
        // AdaptiveTheme.of(context).toggleThemeMode(); // This toggles between light, dark, system
        // For a simple light/dark toggle, we can do this:
        if (AdaptiveTheme.of(context).mode.isLight) {
          AdaptiveTheme.of(context).setDark();
        } else {
          AdaptiveTheme.of(context).setLight();
        }
      },
    );
  }
}
