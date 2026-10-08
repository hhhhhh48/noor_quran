import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareAyah({
    required BuildContext context,
    required String surahName,
    required int ayahNumber,
    required String ayahText,
    String? translation,
    String? languageName,
  }) async {
    final buffer = StringBuffer();
    buffer.writeln('﴿ $ayahText ﴾');
    buffer.writeln();
    buffer.writeln('— $surahName • الآية $ayahNumber');
    if (translation != null && translation.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('[$languageName]');
      buffer.writeln(translation);
    }
    buffer.writeln();
    buffer.write('— القرآن الكريم • The Holy Quran');

    await Share.share(
      buffer.toString(),
      subject: '$surahName - الآية $ayahNumber',
    );
  }

  static Future<void> shareApp() async {
    await Share.share(
      'تطبيق القرآن الكريم - 10 لغات، بدون إنترنت\n'
      'The Holy Quran App - 10 languages, offline\n'
      'https://github.com/hhhhhh48/noor_quran',
    );
  }
}
