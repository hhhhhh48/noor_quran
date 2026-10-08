import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/surah.dart';

class QuranRepository {
  List<Surah> _surahs = [];
  bool _loaded = false;

  List<Surah> get surahs => _surahs;
  bool get isLoaded => _loaded;

  Future<void> load() async {
    if (_loaded) return;
    final raw = await rootBundle.loadString('assets/data/quran_full.json');
    final List data = json.decode(raw);
    _surahs =
        data.map((e) => Surah.fromJson(e as Map<String, dynamic>)).toList();
    _loaded = true;
  }

  Surah? byId(int id) {
    try {
      return _surahs.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
