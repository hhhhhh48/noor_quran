import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TranslationRepository extends ChangeNotifier {
  final Map<String, Map<String, String>> _cache = {};
  String _currentLang = 'en';

  String get currentLanguage => _currentLang;

  Map<String, String> get currentVerses => _cache[_currentLang] ?? {};

  bool hasLanguage(String code) => _cache.containsKey(code);

  Future<bool> loadLanguage(String code) async {
    if (_cache.containsKey(code)) {
      _currentLang = code;
      notifyListeners();
      return true;
    }
    try {
      final raw =
          await rootBundle.loadString('assets/translations/$code.json');
      final Map<String, dynamic> data = json.decode(raw);
      final Map<String, String> verses = {};
      data.forEach((k, v) {
        verses[k] = v.toString();
      });
      _cache[code] = verses;
      _currentLang = code;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void setLanguage(String code) {
    if (_cache.containsKey(code)) {
      _currentLang = code;
      notifyListeners();
    }
  }

  String? verse(int surahId, int ayahId) {
    final verses = _cache[_currentLang];
    if (verses == null) return null;
    return verses['$surahId:$ayahId'];
  }
}
