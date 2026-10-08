import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _keyMode = 'theme_mode';
  static const _keyFontSize = 'font_size';
  static const _keyDefaultLang = 'default_lang';

  ThemeMode _mode = ThemeMode.system;
  double _fontSize = 1.0;
  String _defaultLang = 'en';

  ThemeMode get themeMode => _mode;
  double get fontSize => _fontSize;
  String get defaultLang => _defaultLang;

  ThemeProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getString(_keyMode);
    if (v == 'light') _mode = ThemeMode.light;
    if (v == 'dark') _mode = ThemeMode.dark;
    if (v == 'system') _mode = ThemeMode.system;

    _fontSize = prefs.getDouble(_keyFontSize) ?? 1.0;
    _defaultLang = prefs.getString(_keyDefaultLang) ?? 'en';
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _mode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _keyMode,
        mode == ThemeMode.light
            ? 'light'
            : mode == ThemeMode.dark
                ? 'dark'
                : 'system');
    notifyListeners();
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size.clamp(0.8, 1.5);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyFontSize, _fontSize);
    notifyListeners();
  }

  Future<void> setDefaultLang(String code) async {
    _defaultLang = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultLang, code);
    notifyListeners();
  }
}
