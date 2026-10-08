import 'dart:convert';
import 'package:flutter/services.dart';

class TafsirRepository {
  final Map<String, Map<String, String>> _cache = {};
  String _currentLang = 'en';

  static const availableLangs = <String, String>{
    'ar': 'العربية (الميسر)',
    'en': 'English (Ibn Kathir)',
    'ur': 'اردو (Bayan ul Quran)',
  };

  String get currentLanguage => _currentLang;
  bool get hasArabic => _cache.containsKey('ar');

  bool hasLanguage(String code) => _cache.containsKey(code);

  List<String> get loadedLanguages => _cache.keys.toList();

  Future<void> load() async {
    // العربية (الميسر)
    await _loadFile('ar', 'assets/tafsirs/ar_muyassar.json');
    // الإنجليزية
    await _loadFile('en', 'assets/tafsirs/en.json');
    // الأردية
    await _loadFile('ur', 'assets/tafsirs/ur.json');

    // اختر لغة افتراضية
    if (_cache.containsKey('en')) {
      _currentLang = 'en';
    } else if (_cache.containsKey('ar')) {
      _currentLang = 'ar';
    } else if (_cache.isNotEmpty) {
      _currentLang = _cache.keys.first;
    }
  }

  Future<void> _loadFile(String code, String path) async {
    try {
      final raw = await rootBundle.loadString(path);
      final Map<String, dynamic> data = json.decode(raw);
      final Map<String, String> verses = {};
      data.forEach((k, v) {
        verses[k] = v.toString();
      });
      _cache[code] = verses;
    } catch (_) {}
  }

  void setLanguage(String code) {
    if (_cache.containsKey(code)) {
      _currentLang = code;
    }
  }

  String? getTafsir(int surahId, int ayahId, {String? lang}) {
    final code = lang ?? _currentLang;
    final map = _cache[code];
    if (map == null) return null;
    return map['$surahId:$ayahId'];
  }
}
