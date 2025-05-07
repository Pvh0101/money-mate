import 'package:flutter/material.dart';

// Figma Color Palette (Node 1:30912)

// Primary Colors
const Color primaryBlueLight = Color(0xFFA0CCF8);
const Color primaryBlueDark = Color(0xFF57A4F2);
const Color primaryBrandBlue = Color(0xFF0E33F3); // From rectangle fill, named "Primary/Orange" in Figma layer but is blue
const Color primaryBrandOrange = Color(0xFFF95D3B); // From text layer, associated with "Primary/Orange"

// Secondary Colors
const Color secondaryGreenDark = Color(0xFF46987F);
const Color secondaryGreenLight = Color(0xFF9BF9D3);
const Color secondaryBlueLight = Color(0xFFD1F4FF); // Corrected typo from "Bue"
const Color secondaryYellowLight = Color(0xFFFCE588);
const Color secondaryRedLight = Color(0xFFFFD7D7); // Rectangle fill, text was AB091E
const Color secondarySoftOrange = Color(0xFFFDE1CE);
const Color secondaryDarkBrandOrange = Color(0xFF395EEC); // Rectangle fill, text was E85737, named "Secondary/Dark Brand"
const Color secondaryRedDark = Color(0xFFC62B30);     // Rectangle fill, text was AB091E
const Color secondaryBrown = Color(0xFFB16F05);

// Neutrals (Grays)
const Color neutralDark1 = Color(0xFF1F2933);
const Color neutralDark2 = Color(0xFF242D35);     // Rectangle fill (fill_J3AUVG), text was 323F4B
const Color neutralGrey1 = Color(0xFF6B7580);
const Color neutralGrey2 = Color(0xFF9BA1A8);
const Color neutralGrey3 = Color(0xFFB0B8BF);
const Color neutralSoftGrey1 = Color(0xFFDCDFE3);
const Color neutralSoftGrey2 = Color(0xFFEBEEF0);
const Color neutralSoftGrey3 = Color(0xFFFAFAFB);
const Color neutralWhite = Color(0xFFFFFFFF);

// System Colors
const Color systemRed = Color(0xFFEF4E4E);
const Color systemYellow = Color(0xFFFBBE4A);
const Color systemGreen = Color(0xFF3EBD93);
const Color systemBlue = Color(0xFF37ABFF);

// Common Base Colors (from the very first interpretation, might overlap or be useful)
const Color appPrimaryIndigo = Color(0xFF4F46E5); // This was the initial primary for M3 seed
const Color appPrimaryBlue = Color(0xFF2563EB);   // This was the initial secondary for M3 seed

// Standard Material Colors (often useful)
const Color white = Colors.white;
const Color black = Colors.black;
const Color transparent = Colors.transparent; 