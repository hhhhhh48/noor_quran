class AdhkarItem {
  final String arabic;
  final String transliteration;
  final String english;
  final String localized;
  final int count;
  AdhkarItem({
    required this.arabic,
    required this.transliteration,
    required this.english,
    required this.localized,
    required this.count,
  });

  factory AdhkarItem.fromJson(Map<String, dynamic> j) => AdhkarItem(
        arabic: j['ar']?.toString() ?? '',
        transliteration: j['tr']?.toString() ?? '',
        english: j['en']?.toString() ?? '',
        localized: j['localized']?.toString() ?? j['en']?.toString() ?? '',
        count: j['count'] ?? 1,
      );
}

class AdhkarCategory {
  final String id;
  final String title;
  final String titleEn;
  final String icon;
  final List<AdhkarItem> items;

  AdhkarCategory({
    required this.id,
    required this.title,
    required this.titleEn,
    required this.icon,
    required this.items,
  });

  factory AdhkarCategory.fromJson(Map<String, dynamic> j) => AdhkarCategory(
        id: j['id']?.toString() ?? '',
        title: j['title']?.toString() ?? '',
        titleEn: j['titleEn']?.toString() ?? '',
        icon: j['icon']?.toString() ?? 'star',
        items: (j['items'] as List)
            .map((e) => AdhkarItem.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
}
