import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/adhkar.dart';

class AdhkarRepository extends ChangeNotifier {
  final Map<String, List<AdhkarCategory>> _cache = {};
  String _currentLang = 'en';

  String get currentLanguage => _currentLang;

  List<AdhkarCategory> get categories => _cache[_currentLang] ?? [];

  bool get isLoaded => _cache.containsKey('en');

  bool hasLanguage(String code) => _cache.containsKey(code);

  List<String> get loadedLanguages => _cache.keys.toList();

  static const Map<String, String> languageNames = {
    'en': 'English',
    'fr': 'Français',
    'es': 'Español',
    'ru': 'Русский',
    'tr': 'Türkçe',
    'ur': 'اردو',
    'bn': 'বাংলা',
    'id': 'Bahasa Indonesia',
    'zh': '中文',
    'sv': 'Svenska',
  };

  Future<void> load() async {
    await loadLanguage('en');
  }

  Future<bool> loadLanguage(String code) async {
    if (_cache.containsKey(code)) {
      _currentLang = code;
      notifyListeners();
      return true;
    }
    try {
      final path = code == 'en'
          ? 'assets/adhkar/adhkar_en.json'
          : 'assets/adhkar/adhkar_$code.json';
      final raw = await rootBundle.loadString(path);
      final data = json.decode(raw);
      final cats = (data['categories'] as List)
          .map((e) =>
              AdhkarCategory.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      _cache[code] = cats;
      _currentLang = code;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }
}
