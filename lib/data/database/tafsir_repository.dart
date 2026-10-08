import 'dart:convert';
import 'package:flutter/services.dart';

class TafsirRepository {
  final Map<String, String> _tafsir = {};
  bool _loaded = false;

  bool get isLoaded => _loaded;

  Future<void> load() async {
    if (_loaded) return;
    try {
      final raw = await rootBundle
          .loadString('assets/tafsirs/ar_muyassar.json');
      final Map<String, dynamic> data = json.decode(raw);
      data.forEach((k, v) {
        _tafsir[k] = v.toString();
      });
      _loaded = true;
    } catch (_) {
      _loaded = false;
    }
  }

  String? getTafsir(int surahId, int ayahId) {
    return _tafsir['$surahId:$ayahId'];
  }
}
