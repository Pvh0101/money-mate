import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import google_fonts
import 'app_colors.dart';

// Helper function to create TextTheme to ensure consistency
TextTheme _buildTextTheme(TextTheme base, ColorScheme colorScheme) {
  return base
      .copyWith(
        displayLarge: GoogleFonts.inter(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
            color: colorScheme.onSurface),
        displayMedium: GoogleFonts.inter(
            fontSize: 45,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.0,
            color: colorScheme.onSurface),
        displaySmall: GoogleFonts.inter(
            fontSize: 36,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.0,
            color: colorScheme.onSurface), // Figma: Heading 36 (Medium)

        headlineLarge: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.0,
            color: colorScheme.onSurface),
        headlineMedium: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.0,
            color: colorScheme.onSurface), // Figma: Heading 24 (Medium)
        headlineSmall: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.0,
            color: colorScheme.onSurface), // Figma: Subheading 20 (Medium)

        titleLarge: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
            color: colorScheme.onSurface), // Figma: Subheading 20 (Medium)
        titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
            color: colorScheme.onSurface), // Figma: Subheading 16 (SemiBold)
        titleSmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: colorScheme.onSurface), // Figma: Subheading 12 (SemiBold)

        bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
            color: colorScheme.onSurface), // Figma: Body 16 (Regular)
        bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
            color: colorScheme.onSurface), // Figma: Body 14 (Regular)
        bodySmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
            color: colorScheme.onSurface), // Figma: Body 12 (Regular)

        labelLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: colorScheme
                .onPrimary), // For Elevated Buttons primary text, Figma: Subheading 16 (SemiBold)
        labelMedium: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: colorScheme.onSurfaceVariant), // Default for TextButtons
        labelSmall: GoogleFonts.rubik(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: colorScheme.onSurfaceVariant,
            textBaseline:
                TextBaseline.ideographic), // Figma: Small 10 (Rubik Medium)
      )
      .apply(
        displayColor: colorScheme.onSurface,
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
    surface: neutralWhite,
    onSurface: neutralDark1,
    outline: neutralSoftGrey1,
    // errorContainer: destructiveRedLightBg,
    // onErrorContainer: systemRed,
    // surfaceVariant: neutralSoftGrey2,
    // onSurfaceVariant: neutralGrey1,
    // tertiary: primaryBrandOrange,
    // onTertiary: neutralWhite,
  ),
  textTheme: _buildTextTheme(
      GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      ColorScheme.fromSeed(
              seedColor: primaryBrandBlue, brightness: Brightness.light)
          .copyWith(
              onSurface: neutralDark1,
              onPrimary: neutralWhite,
              onSurfaceVariant: neutralGrey1)),
);

// --- Dark Theme (Simplified with fromSeed) ---
final ThemeData darkTheme = ThemeData.dark(
  useMaterial3: true,
).copyWith(
  scaffoldBackgroundColor: neutralDark1,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryBrandBlue,
    brightness: Brightness.dark,
  ).copyWith(
    primary: primaryBlueDark,
    primaryFixed: primaryBrandBlue,
    secondary: primaryBlueDark,
    onSecondary: neutralWhite,
    error: const Color(0xFFDC2626), // destructiveRedDarker - Hardcoded
    onError: neutralWhite,
    surface: neutralDark2,
    onSurface: neutralSoftGrey2,
    outline: neutralGrey1,
    // errorContainer: secondaryRedDark,
    // onErrorContainer: const Color(0xFFF87171), // destructiveRedLighter - Hardcoded
    // surfaceVariant: neutralGrey1,
    // onSurfaceVariant: neutralSoftGrey1,
    // tertiary: primaryBrandOrange,
    // onTertiary: neutralWhite,
  ),
);
