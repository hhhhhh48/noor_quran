import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/bookmark.dart';

class BookmarkService {
  static const _key = 'bookmarks_v2';

  static Future<List<Bookmark>> getAll() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_key);
    if (raw == null) return [];
    try {
      final List data = json.decode(raw);
      return data
          .map((e) => Bookmark.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveAll(List<Bookmark> list) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(
        _key, json.encode(list.map((b) => b.toJson()).toList()));
  }

  static Future<bool> isBookmarked(int surahId, int ayahId) async {
    final list = await getAll();
    return list.any((b) => b.surahId == surahId && b.ayahId == ayahId);
  }

  static Future<void> add(Bookmark bookmark) async {
    final list = await getAll();
    list.removeWhere(
        (b) => b.surahId == bookmark.surahId && b.ayahId == bookmark.ayahId);
    list.insert(0, bookmark);
    await _saveAll(list);
  }

  static Future<void> remove(int surahId, int ayahId) async {
    final list = await getAll();
    list.removeWhere((b) => b.surahId == surahId && b.ayahId == ayahId);
    await _saveAll(list);
  }

  static Future<void> updateNote(
      int surahId, int ayahId, String note, int colorIndex) async {
    final list = await getAll();
    final idx = list.indexWhere(
        (b) => b.surahId == surahId && b.ayahId == ayahId);
    if (idx >= 0) {
      final old = list[idx];
      list[idx] = Bookmark(
        id: old.id,
        surahId: old.surahId,
        ayahId: old.ayahId,
        surahName: old.surahName,
        ayahText: old.ayahText,
        note: note,
        colorIndex: colorIndex,
        createdAt: old.createdAt,
      );
      await _saveAll(list);
    }
  }

  static Future<Bookmark?> getOne(int surahId, int ayahId) async {
    final list = await getAll();
    try {
      return list.firstWhere(
          (b) => b.surahId == surahId && b.ayahId == ayahId);
    } catch (_) {
      return null;
    }
  }
}
