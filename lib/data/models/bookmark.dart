class Bookmark {
  final String id;
  final int surahId;
  final int ayahId;
  final String surahName;
  final String ayahText;
  final String note;
  final int colorIndex;
  final int createdAt;

  Bookmark({
    required this.id,
    required this.surahId,
    required this.ayahId,
    required this.surahName,
    required this.ayahText,
    required this.note,
    required this.colorIndex,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'surahId': surahId,
        'ayahId': ayahId,
        'surahName': surahName,
        'ayahText': ayahText,
        'note': note,
        'colorIndex': colorIndex,
        'createdAt': createdAt,
      };

  factory Bookmark.fromJson(Map<String, dynamic> j) => Bookmark(
        id: j['id']?.toString() ?? '',
        surahId: j['surahId'] ?? 0,
        ayahId: j['ayahId'] ?? 0,
        surahName: j['surahName']?.toString() ?? '',
        ayahText: j['ayahText']?.toString() ?? '',
        note: j['note']?.toString() ?? '',
        colorIndex: j['colorIndex'] ?? 0,
        createdAt: j['createdAt'] ?? 0,
      );
}

const kBookmarkColors = [
  0xFF2E9E77,
  0xFFD4AF37,
  0xFF3B82F6,
  0xFFEF4444,
  0xFF8B5CF6,
];

const kBookmarkColorNames = [
  'أخضر',
  'ذهبي',
  'أزرق',
  'أحمر',
  'بنفسجي',
];
