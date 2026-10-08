class LanguageInfo {
  final String code;
  final String nativeName;
  final String englishName;
  final String direction;
  const LanguageInfo({
    required this.code,
    required this.nativeName,
    required this.englishName,
    this.direction = 'ltr',
  });
}

const kSupportedLanguages = <LanguageInfo>[
  LanguageInfo(code: 'ar', nativeName: 'العربية', englishName: 'Arabic', direction: 'rtl'),
  LanguageInfo(code: 'en', nativeName: 'English', englishName: 'English'),
  LanguageInfo(code: 'fr', nativeName: 'Français', englishName: 'French'),
  LanguageInfo(code: 'es', nativeName: 'Español', englishName: 'Spanish'),
  LanguageInfo(code: 'ru', nativeName: 'Русский', englishName: 'Russian'),
  LanguageInfo(code: 'tr', nativeName: 'Türkçe', englishName: 'Turkish'),
  LanguageInfo(code: 'ur', nativeName: 'اردو', englishName: 'Urdu', direction: 'rtl'),
  LanguageInfo(code: 'bn', nativeName: 'বাংলা', englishName: 'Bengali'),
  LanguageInfo(code: 'id', nativeName: 'Bahasa Indonesia', englishName: 'Indonesian'),
  LanguageInfo(code: 'zh', nativeName: '中文', englishName: 'Chinese'),
  LanguageInfo(code: 'sv', nativeName: 'Svenska', englishName: 'Swedish'),
];
