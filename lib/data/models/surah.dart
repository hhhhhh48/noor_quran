class Ayah {
  final int number;
  final String text;
  Ayah({required this.number, required this.text});

  factory Ayah.fromJson(Map<String, dynamic> j) =>
      Ayah(number: j['n'], text: j['text']);
}

class Surah {
  final int id;
  final String name;
  final String englishName;
  final List<Ayah> ayahs;

  Surah({
    required this.id,
    required this.name,
    required this.englishName,
    required this.ayahs,
  });

  factory Surah.fromJson(Map<String, dynamic> j) => Surah(
        id: j['id'],
        name: j['name'],
        englishName: j['englishName'],
        ayahs: (j['ayahs'] as List)
            .map((e) => Ayah.fromJson(e))
            .toList(),
      );
}
