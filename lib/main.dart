import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/core.dart' as core; // Import barrel file core với prefix
import 'core/storage/hive_service.dart';
import 'core/storage/hive_config.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart'; // Giữ lại vì là feature khác
import 'features/authentication/presentation/widgets/auth_gate.dart'; // Giữ lại vì là feature khác
import 'features/categories/presentation/bloc/category_bloc.dart';
import 'features/transactions/presentation/bloc/transaction_bloc.dart';
import 'features/summary/presentation/bloc/summary_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Khởi tạo Hive
  await HiveService.init();

  // Khởi tạo các dependency
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
        BlocProvider<CategoryBloc>(
          create: (context) => core.sl<CategoryBloc>(),
        ),
        BlocProvider<TransactionBloc>(
          create: (context) => core.sl<TransactionBloc>(),
        ),
        BlocProvider<SummaryBloc>(
          create: (context) => core.sl<SummaryBloc>(),
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
