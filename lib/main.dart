import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mate/presentation/pages/test_pages/button_test_page.dart';
import 'core/constants/route_constants.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      // initialRoute: RouteConstants.onboarding,
      // onGenerateRoute: Routes.generateRoute,
      home: const ButtonTestPage(),
    );
  }
}
