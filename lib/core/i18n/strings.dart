import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class S extends ChangeNotifier {
  static const _key = 'ui_lang';
  String _lang = 'ar';
  static late S instance;

  String get lang => _lang;
  bool get isAr => _lang == 'ar';

  S._();
  static Future<S> create() async {
    instance = S._();
    final p = await SharedPreferences.getInstance();
    instance._lang = p.getString(_key) ?? 'ar';
    return instance;
  }

  Future<void> setLang(String code) async {
    _lang = code;
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, code);
    notifyListeners();
  }

  String t(String key) {
    return _all[key]?[_lang] ?? _all[key]?['en'] ?? key;
  }
}

const _all = <String, Map<String, String>>{
  // Navigation
  'home': {'ar': 'الرئيسية', 'en': 'Home'},
  'surahs': {'ar': 'السور', 'en': 'Surahs'},
  'adhkar': {'ar': 'الأذكار', 'en': 'Adhkar'},
  'search': {'ar': 'البحث', 'en': 'Search'},
  'library': {'ar': 'مكتبتي', 'en': 'Library'},
  'settings': {'ar': 'الإعدادات', 'en': 'Settings'},

  // Home
  'salam': {'ar': 'السلام عليكم', 'en': 'Assalamu Alaikum'},
  'quran_kareem': {'ar': 'القرآن الكريم', 'en': 'The Holy Quran'},
  'ayah_of_day': {'ar': 'آية اليوم', 'en': 'Verse of the Day'},
  'continue_reading': {'ar': 'متابعة القراءة', 'en': 'Continue Reading'},
  'tools': {'ar': 'أدوات', 'en': 'Tools'},
  'qibla': {'ar': 'القبلة', 'en': 'Qibla'},
  'reciters': {'ar': 'القراء', 'en': 'Reciters'},
  'tap_to_continue': {'ar': 'اضغط للمتابعة', 'en': 'Tap to continue'},
  'surah_fatiha': {'ar': 'سورة الفاتحة', 'en': 'Al-Fatiha'},

  // Surahs
  'surah': {'ar': 'سورة', 'en': 'Surah'},
  'ayahs': {'ar': 'آيات', 'en': 'verses'},
  'surah_count': {'ar': 'سورة', 'en': 'Surahs'},

  // Reader
  'translation_lang': {'ar': 'اختر لغة الترجمة', 'en': 'Choose Translation Language'},
  'choose_reciter': {'ar': 'اختر القارئ', 'en': 'Choose Reciter'},
  'tafsir': {'ar': 'التفسير', 'en': 'Tafsir'},
  'tafsir_muyassar': {'ar': 'التفسير الميسر', 'en': 'Tafsir'},
  'not_available': {'ar': 'غير متوفر', 'en': 'Not available'},
  'not_available_lang': {'ar': 'التفسير غير متوفر بهذه اللغة', 'en': 'Tafsir not available in this language'},
  'share': {'ar': 'مشاركة', 'en': 'Share'},
  'ayah': {'ar': 'آية', 'en': 'Verse'},

  // Search
  'search_hint': {'ar': 'ابحث في القرآن والترجمة...', 'en': 'Search Quran and translations...'},
  'search_quran': {'ar': 'ابحث في القرآن', 'en': 'Search the Quran'},
  'search_min': {'ar': 'اكتب كلمتين على الأقل', 'en': 'Type at least 2 letters'},
  'no_results': {'ar': 'لا نتائج', 'en': 'No results'},

  // Library
  'bookmarks': {'ar': 'الإشارات', 'en': 'Bookmarks'},
  'favorites': {'ar': 'المفضلة', 'en': 'Favorites'},
  'no_bookmarks': {'ar': 'لا توجد إشارات', 'en': 'No bookmarks'},
  'no_bookmarks_hint': {'ar': 'اضغط على أيقونة الحفظ في أي آية', 'en': 'Tap the bookmark icon in any verse'},
  'no_favorites': {'ar': 'لا توجد آيات محفوظة', 'en': 'No favorites'},
  'no_favorites_hint': {'ar': 'اضغط على أيقونة القلب في أي آية', 'en': 'Tap the heart icon in any verse'},

  // Adhkar
  'adhkar_duas': {'ar': 'الأذكار والأدعية', 'en': 'Adhkar & Duas'},
  'tap_to_count': {'ar': 'اضغط للعد', 'en': 'Tap to count'},
  'done': {'ar': 'تم', 'en': 'Done'},

  // Settings
  'appearance': {'ar': 'المظهر', 'en': 'Appearance'},
  'light': {'ar': 'فاتح', 'en': 'Light'},
  'auto': {'ar': 'تلقائي', 'en': 'Auto'},
  'dark': {'ar': 'ليلي', 'en': 'Dark'},
  'font_size': {'ar': 'حجم الخط', 'en': 'Font Size'},
  'default_lang': {'ar': 'لغة الترجمة الافتراضية', 'en': 'Default Translation'},
  'app_lang': {'ar': 'لغة التطبيق', 'en': 'App Language'},
  'about': {'ar': 'حول التطبيق', 'en': 'About'},
  'developed_by': {'ar': 'تطوير', 'en': 'Developed by'},
  'version': {'ar': 'الإصدار', 'en': 'Version'},
  'description': {
    'ar': 'تطبيق مجاني لقراءة القرآن الكريم بـ 10 لغات عالمية.\nيعمل بدون إنترنت تماماً.',
    'en': 'A free app to read the Holy Quran in 10 languages.\nWorks completely offline.'
  },

  // Onboarding
  'skip': {'ar': 'تخطي', 'en': 'Skip'},
  'next': {'ar': 'التالي', 'en': 'Next'},
  'start': {'ar': 'ابدأ', 'en': 'Start'},

  // Bookmark sheet
  'add_bookmark': {'ar': 'إضافة إشارة مرجعية', 'en': 'Add Bookmark'},
  'edit_bookmark': {'ar': 'تعديل الإشارة', 'en': 'Edit Bookmark'},
  'color': {'ar': 'اللون', 'en': 'Color'},
  'note_optional': {'ar': 'ملاحظة (اختياري)', 'en': 'Note (optional)'},
  'write_note': {'ar': 'اكتب ملاحظتك هنا...', 'en': 'Write your note here...'},
  'save_bookmark': {'ar': 'حفظ الإشارة', 'en': 'Save'},
  'save_edit': {'ar': 'حفظ التعديل', 'en': 'Save Changes'},
  'delete': {'ar': 'حذف', 'en': 'Delete'},

  // Mushaf
  'mushaf_mode': {'ar': 'وضع المصحف', 'en': 'Mushaf Mode'},
  'cards_mode': {'ar': 'وضع البطاقات', 'en': 'Cards Mode'},

  // Extra
  'bismillah': {'ar': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', 'en': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'},
  'meccan': {'ar': 'مكية', 'en': 'Meccan'},
  'medinan': {'ar': 'مدنية', 'en': 'Medinan'},
};
