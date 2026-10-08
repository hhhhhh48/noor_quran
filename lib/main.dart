import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_text.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'data/database/quran_repository.dart';
import 'data/database/translation_repository.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final quranRepo = QuranRepository();
  await quranRepo.load();

  final transRepo = TranslationRepository();
  await transRepo.loadLanguage('en');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<TranslationRepository>.value(value: transRepo),
        Provider<QuranRepository>.value(value: quranRepo),
      ],
      child: const QuranKareemApp(),
    ),
  );
}

class QuranKareemApp extends StatelessWidget {
  const QuranKareemApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tp = Provider.of<ThemeProvider>(context);
    AppText.scale = tp.fontSize;

    return MaterialApp(
      title: 'القرآن الكريم',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: tp.themeMode,
      locale: const Locale('ar'),
      home: const SplashScreen(),
    );
  }
}
