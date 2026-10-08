import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _kFav = 'favorites';
  static const _kLast = 'last_read';
  static const _kOnb = 'onboarded';

  static Future<bool> isOnboarded() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kOnb) ?? false;
  }

  static Future<void> setOnboarded() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kOnb, true);
  }

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_kFav);
    if (raw == null) return [];
    final List data = json.decode(raw);
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<void> addFavorite(int s, int a, String name, String text) async {
    final list = await getFavorites();
    if (list.any((e) => e['surah'] == s && e['ayah'] == a)) return;
    list.add({
      'surah': s, 'ayah': a, 'surahName': name, 'text': text,
      'time': DateTime.now().millisecondsSinceEpoch,
    });
    final p = await SharedPreferences.getInstance();
    await p.setString(_kFav, json.encode(list));
  }

  static Future<void> removeFavorite(int s, int a) async {
    final list = await getFavorites();
    list.removeWhere((e) => e['surah'] == s && e['ayah'] == a);
    final p = await SharedPreferences.getInstance();
    await p.setString(_kFav, json.encode(list));
  }

  static Future<bool> isFavorite(int s, int a) async {
    final list = await getFavorites();
    return list.any((e) => e['surah'] == s && e['ayah'] == a);
  }

  static Future<void> setLastRead(int s, int a, String name) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kLast, json.encode({
      'surah': s, 'ayah': a, 'surahName': name,
      'time': DateTime.now().millisecondsSinceEpoch,
    }));
  }

  static Future<Map<String, dynamic>?> getLastRead() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_kLast);
    if (raw == null) return null;
    return Map<String, dynamic>.from(json.decode(raw) as Map);
  }
}
