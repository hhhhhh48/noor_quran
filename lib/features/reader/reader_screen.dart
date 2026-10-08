import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../data/database/translation_repository.dart';
import '../../data/models/translation.dart';

class ReaderScreen extends StatelessWidget {
  final dynamic surah;
  const ReaderScreen({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final transRepo = context.watch<TranslationRepository>();
    final langInfo = kSupportedLanguages.firstWhere(
      (l) => l.code == transRepo.currentLanguage,
      orElse: () => kSupportedLanguages[1],
    );
    final isRtl = langInfo.direction == 'rtl';

    return Scaffold(
      appBar: AppBar(
        title: Text(surah.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.translate),
            tooltip: langInfo.englishName,
            onPressed: () => _showLanguagePicker(context, transRepo),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: surah.ayahs.length,
          itemBuilder: (context, i) {
            final a = surah.ayahs[i];
            final translation = transRepo.verse(surah.id, a.number);
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    a.text,
                    textAlign: TextAlign.center,
                    style: AppText.amiri(
                      fontSize: 26,
                      height: 2.0,
                      color:
                          isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${a.number}',
                        style: AppText.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                  ),
                  if (translation != null && translation.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Divider(
                      color: AppColors.gold.withValues(alpha: 0.2),
                      height: 1,
                    ),
                    const SizedBox(height: 16),
                    Directionality(
                      textDirection:
                          isRtl ? TextDirection.rtl : TextDirection.ltr,
                      child: Text(
                        translation,
                        textAlign: TextAlign.start,
                        style: AppText.poppins(
                          fontSize: 15,
                          height: 1.6,
                          color: isDark
                              ? Colors.white70
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context, TranslationRepository repo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اختر لغة الترجمة',
              style: AppText.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: kSupportedLanguages.length,
                itemBuilder: (_, i) {
                  final lang = kSupportedLanguages[i];
                  return ListTile(
                    title: Text(lang.nativeName,
                        style: AppText.poppins(fontSize: 16)),
                    subtitle: Text(lang.englishName,
                        style: AppText.poppins(fontSize: 12)),
                    trailing: lang.code == repo.currentLanguage
                        ? const Icon(Icons.check, color: AppColors.emerald)
                        : null,
                    onTap: () async {
                      final ok = await repo.loadLanguage(lang.code);
                      if (context.mounted) {
                        Navigator.pop(context);
                        if (!ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'الترجمة ${lang.nativeName} غير متوفرة بعد',
                                style: AppText.poppins(),
                              ),
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
