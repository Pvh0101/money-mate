import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/core.dart' as core; // Import barrel file core với prefix
import 'features/authentication/presentation/bloc/auth_bloc.dart'; // Giữ lại vì là feature khác
import 'features/authentication/presentation/widgets/auth_gate.dart'; // Giữ lại vì là feature khác

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await core.init();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              core.sl<AuthBloc>()..add(const GetCurrentUserRequested()),
        ),
      ],
      child: AdaptiveTheme(
        light: core.lightTheme,
        dark: core.darkTheme,
        initial: savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Money Mate',
          theme: theme,
          darkTheme: darkTheme,
          home: const AuthGate(),
          onGenerateRoute: core.Routes.generateRoute,
        ),
      ),
    );
  }
}
