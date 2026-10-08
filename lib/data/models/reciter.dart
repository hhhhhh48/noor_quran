class Reciter {
  final String folder;
  final String arabicName;
  final String englishName;
  const Reciter({
    required this.folder,
    required this.arabicName,
    required this.englishName,
  });
}

const kReciters = <Reciter>[
  Reciter(folder: 'Alafasy_128kbps', arabicName: 'مشاري العفاسي', englishName: 'Mishary Alafasy'),
  Reciter(folder: 'Abdul_Basit_Murattal_192kbps', arabicName: 'عبد الباسط عبد الصمد', englishName: 'Abdul Basit'),
  Reciter(folder: 'Husary_128kbps', arabicName: 'محمود خليل الحصري', englishName: 'Al-Husary'),
  Reciter(folder: 'Minshawy_Murattal_128kbps', arabicName: 'محمد صديق المنشاوي', englishName: 'Al-Minshawi'),
  Reciter(folder: 'Abdurrahmaan_As-Sudais_192kbps', arabicName: 'عبد الرحمن السديس', englishName: 'As-Sudais'),
  Reciter(folder: 'Ghamadi_40kbps', arabicName: 'سعد الغامدي', englishName: 'Saad Al-Ghamdi'),
  Reciter(folder: 'Yasser_Ad-Dussary_128kbps', arabicName: 'ياسر الدوسري', englishName: 'Yasser Al-Dossari'),
  Reciter(folder: 'Ahmed_ibn_Ali_al-Ajamy_128kbps', arabicName: 'أحمد العجمي', englishName: 'Ahmed Al-Ajamy'),
];
