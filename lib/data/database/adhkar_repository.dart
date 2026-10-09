import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/adhkar.dart';

class AdhkarRepository {
  List<AdhkarCategory> _categories = [];
  bool _loaded = false;

  List<AdhkarCategory> get categories => _categories;
  bool get isLoaded => _loaded;

  Future<void> load() async {
    if (_loaded) return;
    try {
      final raw = await rootBundle.loadString('assets/adhkar/adhkar.json');
      final data = json.decode(raw);
      _categories = (data['categories'] as List)
          .map((e) => AdhkarCategory.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      _loaded = true;
    } catch (_) {
      _loaded = false;
    }
  }
}
