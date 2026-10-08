class Ayah {
  final int number;
  final String text;
  Ayah({required this.number, required this.text});

  factory Ayah.fromJson(Map<String, dynamic> j) =>
      Ayah(number: j['id'], text: j['text']);
}

class Surah {
  final int id;
  final String name;
  final String transliteration;
  final String type;
  final int totalVerses;
  final List<Ayah> ayahs;

  Surah({
    required this.id,
    required this.name,
    required this.transliteration,
    required this.type,
    required this.totalVerses,
    required this.ayahs,
  });

  factory Surah.fromJson(Map<String, dynamic> j) => Surah(
        id: j['id'],
        name: j['name'],
        transliteration: j['transliteration'] ?? '',
        type: j['type'] ?? '',
        totalVerses: j['total_verses'] ?? 0,
        ayahs:
            (j['verses'] as List).map((e) => Ayah.fromJson(e)).toList(),
      );
}
