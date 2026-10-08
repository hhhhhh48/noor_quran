import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.emerald,
      brightness: Brightness.light,
      primary: AppColors.emerald,
      secondary: AppColors.gold,
      surface: AppColors.surfaceLight,
    ),
    textTheme: TextTheme().apply(
      bodyColor: AppColors.textDark,
      displayColor: AppColors.textDark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: AppColors.emerald),
      titleTextStyle: AppText.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.emerald,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    dividerColor: AppColors.divider,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.midnight,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.emerald,
      brightness: Brightness.dark,
      primary: AppColors.goldSoft,
      secondary: AppColors.gold,
      surface: AppColors.surfaceDark,
    ),
    textTheme: TextTheme().apply(
      bodyColor: AppColors.textLight,
      displayColor: AppColors.textLight,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: AppColors.goldSoft),
      titleTextStyle: AppText.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.goldSoft,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    dividerColor: Colors.white12,
  );
}
