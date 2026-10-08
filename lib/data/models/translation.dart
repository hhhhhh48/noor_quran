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
  LanguageInfo(code: 'de', nativeName: 'Deutsch', englishName: 'German'),
  LanguageInfo(code: 'it', nativeName: 'Italiano', englishName: 'Italian'),
  LanguageInfo(code: 'pt', nativeName: 'Português', englishName: 'Portuguese'),
  LanguageInfo(code: 'ru', nativeName: 'Русский', englishName: 'Russian'),
  LanguageInfo(code: 'tr', nativeName: 'Türkçe', englishName: 'Turkish'),
  LanguageInfo(code: 'ur', nativeName: 'اردو', englishName: 'Urdu', direction: 'rtl'),
  LanguageInfo(code: 'fa', nativeName: 'فارسی', englishName: 'Persian', direction: 'rtl'),
  LanguageInfo(code: 'hi', nativeName: 'हिन्दी', englishName: 'Hindi'),
  LanguageInfo(code: 'bn', nativeName: 'বাংলা', englishName: 'Bengali'),
  LanguageInfo(code: 'id', nativeName: 'Bahasa Indonesia', englishName: 'Indonesian'),
  LanguageInfo(code: 'ms', nativeName: 'Bahasa Melayu', englishName: 'Malay'),
  LanguageInfo(code: 'zh', nativeName: '中文', englishName: 'Chinese'),
  LanguageInfo(code: 'ja', nativeName: '日本語', englishName: 'Japanese'),
  LanguageInfo(code: 'ko', nativeName: '한국어', englishName: 'Korean'),
  LanguageInfo(code: 'he', nativeName: 'עברית', englishName: 'Hebrew', direction: 'rtl'),
  LanguageInfo(code: 'sw', nativeName: 'Kiswahili', englishName: 'Swahili'),
  LanguageInfo(code: 'ku', nativeName: 'Kurdî', englishName: 'Kurdish'),
  LanguageInfo(code: 'uk', nativeName: 'Українська', englishName: 'Ukrainian'),
  LanguageInfo(code: 'pl', nativeName: 'Polski', englishName: 'Polish'),
  LanguageInfo(code: 'ro', nativeName: 'Română', englishName: 'Romanian'),
  LanguageInfo(code: 'nl', nativeName: 'Nederlands', englishName: 'Dutch'),
  LanguageInfo(code: 'sv', nativeName: 'Svenska', englishName: 'Swedish'),
  LanguageInfo(code: 'no', nativeName: 'Norsk', englishName: 'Norwegian'),
  LanguageInfo(code: 'da', nativeName: 'Dansk', englishName: 'Danish'),
  LanguageInfo(code: 'fi', nativeName: 'Suomi', englishName: 'Finnish'),
  LanguageInfo(code: 'bs', nativeName: 'Bosanski', englishName: 'Bosnian'),
];
