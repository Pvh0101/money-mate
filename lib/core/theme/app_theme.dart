import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import google_fonts
import 'app_colors.dart';

// Helper function to create TextTheme to ensure consistency
TextTheme _buildTextTheme(TextTheme base, ColorScheme colorScheme) {
  // Base styles from Material 3 for Inter, then override specific ones
  TextTheme interBase = GoogleFonts.interTextTheme(base);

  return interBase
      .copyWith(
        displayLarge: interBase.displayLarge?.copyWith(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface),
        displayMedium: interBase.displayMedium?.copyWith(
            fontSize: 45,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface),
        displaySmall: interBase.displaySmall?.copyWith(
            // Figma: Heading 36 (Medium)
            fontSize: 36,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface),

        headlineLarge: interBase.headlineLarge?.copyWith(
            // Consider Figma: "Heading 32" if specified
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface),
        headlineMedium: interBase.headlineMedium?.copyWith(
            // Figma: Heading 24 (Medium)
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface),
        headlineSmall: interBase.headlineSmall?.copyWith(
            // Figma: Subheading 20 (Medium)
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface),

        // Updated based on Figma analysis for common UI elements
        titleLarge: interBase.titleLarge?.copyWith(
            // AppBar Title, Main Page Titles
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.02 * 18,
            height: 20 / 18,
            color: colorScheme.onSurface), // Use onSurface for AppBar
        titleMedium: interBase.titleMedium?.copyWith(
            // Section Titles, Major List Item Text (Category, Amount)
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 20 / 16,
            color: colorScheme.onSurface),
        titleSmall: interBase.titleSmall?.copyWith(
            // Smaller Titles/Captions
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface),

        bodyLarge: interBase.bodyLarge?.copyWith(
            // Main body content
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface),
        bodyMedium: interBase.bodyMedium?.copyWith(
            // Default body, List item subtitles (Date, Payment Method)
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.02 * 14,
            height: 20 / 14,
            color: colorScheme.onSurfaceVariant), // Use onSurfaceVariant
        bodySmall: interBase.bodySmall?.copyWith(
            // Fine print
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurfaceVariant),

        labelLarge: interBase.labelLarge?.copyWith(
            // Main button text
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onPrimary),
        labelMedium: interBase.labelMedium?.copyWith(
            // OptionCardItem title, other small labels
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.02 * 12,
            height: 16 / 12,
            color: colorScheme.onSurface), // Use onSurface for card titles

        // labelSmall uses Rubik, so we define it separately if not already correctly handled by 'base'
        // Forcing Inter here if 'base' for labelSmall wasn't Rubik initially.
        // If GoogleFonts.interTextTheme(base) correctly sets Rubik for labelSmall, this might not be needed or adjusted.
        // However, the original code had GoogleFonts.rubik() specifically for labelSmall.
        // To maintain that, we'll handle it carefully. It seems 'base.labelSmall' would be Inter if not for the special handling.
        // The original _buildTextTheme directly assigned GoogleFonts.rubik to labelSmall.
        // Let's re-introduce that specificity if `interBase.labelSmall` is not Rubik.
        // For now, assume interBase.labelSmall is Inter and style it:
        // labelSmall: interBase.labelSmall?.copyWith(
        //     fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: colorScheme.onSurfaceVariant),
      )
      .copyWith(
          // Explicitly set Rubik for labelSmall as per original design intent
          labelSmall: GoogleFonts.rubik(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: colorScheme.onSurfaceVariant,
              textBaseline:
                  TextBaseline.ideographic) // Figma: Small 10 (Rubik Medium)
          )
      .apply(
        // These ensure that even if a color isn't specified in a copyWith, it has a default
        // However, we've added color to most copyWith calls above for clarity.
        displayColor: colorScheme.onSurface,
        bodyColor: colorScheme
            .onSurface, // Default color for body styles if not overridden
      );
}

// --- Light Theme (Simplified with fromSeed) ---
final ThemeData lightTheme = ThemeData.light(
  useMaterial3: true,
).copyWith(
  scaffoldBackgroundColor: neutralSoftGrey3,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryBrandBlue,
    brightness: Brightness.light,
  ).copyWith(
    primary: primaryBlueLight,
    primaryFixed: primaryBrandBlue,
    secondary: primaryBlueDark,
    onSecondary: neutralWhite,
    error: systemRed,
    onError: neutralWhite,
    background: neutralSoftGrey3, // Explicitly set
    onSurface: neutralDark1, // Explicitly set
    surface: neutralWhite,
    surfaceVariant: neutralSoftGrey2, // For cards or alternative surfaces
    onSurfaceVariant: neutralGrey1, // For secondary text
    outline: neutralSoftGrey1,
    secondaryContainer: neutralSoftGrey2, // Example, adjust as needed
    onSecondaryContainer: neutralGrey1, // Example, adjust as needed
  ),
  textTheme: _buildTextTheme(
      ThemeData.light().textTheme, // Base theme for font metrics
      ColorScheme.fromSeed(
              // ColorScheme to be used by _buildTextTheme
              seedColor: primaryBrandBlue,
              brightness: Brightness.light)
          .copyWith(
              primary: primaryBlueLight,
              onPrimary: neutralWhite, // Text on primary elements (buttons)
              background: neutralSoftGrey3,
              onSurface:
                  neutralDark1, // Text on general background (like AppBar title)
              surface: neutralWhite,
              onSurfaceVariant:
                  neutralGrey1, // Secondary text on cards/surfaces
              secondaryContainer: neutralSoftGrey2,
              onSecondaryContainer: neutralGrey1,
              outline: neutralSoftGrey1,
              error: systemRed,
              onError: neutralWhite)),
);

// --- Dark Theme (Simplified with fromSeed) ---
final ThemeData darkTheme = ThemeData.dark(
  useMaterial3: true,
).copyWith(
  scaffoldBackgroundColor: neutralDark2, // Figma: #242D35
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryBrandBlue,
    brightness: Brightness.dark,
  ).copyWith(
    primary: primaryBlueDark,
    secondary: primaryBlueDark,
    error: const Color(0xFFCF6679),
    onError: neutralDark1,
    background: neutralDark2,
    onSurface: neutralSoftGrey3,
    surface: neutralDark3,
    surfaceVariant: neutralDark1,
    onSurfaceVariant: neutralGrey3,
    outline: neutralGrey2,
    secondaryContainer: darkIconSurface,
    onSecondaryContainer: neutralSoftGrey3,
  ),
  textTheme: _buildTextTheme(
      ThemeData.dark().textTheme, // Base theme for font metrics
      ColorScheme.fromSeed(
              // ColorScheme to be used by _buildTextTheme
              seedColor: primaryBrandBlue,
              brightness: Brightness.dark)
          .copyWith(
        primary: primaryBlueDark,
        onPrimary: neutralWhite,
        background: neutralDark2,
        onSurface: neutralSoftGrey3,
        surface: neutralDark3,
        surfaceVariant: neutralDark1,
        onSurfaceVariant: neutralGrey3,
        secondaryContainer: darkIconSurface,
        onSecondaryContainer: neutralSoftGrey3,
        outline: neutralGrey2,
        error: const Color(0xFFCF6679),
        onError: neutralDark1,
      )),
);
