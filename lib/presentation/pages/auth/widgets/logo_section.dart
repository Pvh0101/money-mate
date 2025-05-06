import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 136,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Image.asset(
              'assets/logo/logo.png',
              width: 88,
              height: 88,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 94.5,
            child: Text(
              'monex',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF242D35),
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
