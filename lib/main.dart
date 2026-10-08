import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'data/database/quran_repository.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = QuranRepository();
  await repo.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<QuranRepository>.value(value: repo),
      ],
      child: const NoorQuranApp(),
    ),
  );
}

class NoorQuranApp extends StatelessWidget {
  const NoorQuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tp = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Noor Quran',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: tp.themeMode,
      locale: const Locale('ar'),
      home: const SplashScreen(),
    );
  }
}
