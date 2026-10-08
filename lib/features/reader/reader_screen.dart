import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/share_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
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
      backgroundColor: isDark ? AppColors.night : AppColors.cream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: isDark ? AppColors.night : AppColors.cream,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            expandedHeight: 140,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: isDark ? AppColors.goldSoft : AppColors.emerald,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.translate_rounded,
                  color: isDark ? AppColors.goldSoft : AppColors.emerald,
                ),
                tooltip: langInfo.englishName,
                onPressed: () => _showLanguagePicker(context, transRepo),
              ),
              IconButton(
                icon: Icon(
                  Icons.share_rounded,
                  color: isDark ? AppColors.goldSoft : AppColors.emerald,
                ),
                onPressed: () => ShareService.shareApp(),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 16),
              centerTitle: true,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    surah.name,
                    style: AppText.amiri(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textLight
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${surah.totalVerses} آيات',
                    style: AppText.poppins(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            sliver: SliverToBoxAdapter(
              child: _buildBismillah(isDark),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            sliver: SliverList.builder(
              itemCount: surah.ayahs.length,
              itemBuilder: (context, i) {
                final a = surah.ayahs[i];
                final translation = transRepo.verse(surah.id, a.number);
                return _AyahCard(
                  ayahText: a.text,
                  ayahNumber: a.number,
                  translation: translation,
                  isRtl: isRtl,
                  isDark: isDark,
                  surahName: surah.name,
                  languageName: langInfo.englishName,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBismillah(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF1A2E25), Color(0xFF12201A)],
              )
            : AppGradients.heroEmerald,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          textAlign: TextAlign.center,
          style: AppText.amiri(
            fontSize: 24,
            color: isDark ? AppColors.goldSoft : Colors.white,
            height: 1.8,
          ),
        ),
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context, TranslationRepository repo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: isDark ? AppColors.nightCard : AppColors.creamCard,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'اختر لغة الترجمة',
                  style: AppText.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textLight
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: kSupportedLanguages.length,
                  itemBuilder: (_, i) {
                    final lang = kSupportedLanguages[i];
                    final isCurrent = lang.code == repo.currentLanguage;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 4,
                      ),
                      title: Text(
                        lang.nativeName,
                        style: AppText.poppins(
                          fontSize: 16,
                          fontWeight: isCurrent
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isDark
                              ? AppColors.textLight
                              : AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        lang.englishName,
                        style: AppText.poppins(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.textSecondary,
                        ),
                      ),
                      trailing: isCurrent
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.emerald,
                            )
                          : null,
                      onTap: () async {
                        final ok = await repo.loadLanguage(lang.code);
                        if (context.mounted) {
                          Navigator.pop(context);
                          if (!ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'الترجمة ${lang.nativeName} غير متوفرة',
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
        );
      },
    );
  }
}

class _AyahCard extends StatelessWidget {
  final String ayahText;
  final int ayahNumber;
  final String? translation;
  final bool isRtl;
  final bool isDark;
  final String surahName;
  final String languageName;

  const _AyahCard({
    required this.ayahText,
    required this.ayahNumber,
    required this.translation,
    required this.isRtl,
    required this.isDark,
    required this.surahName,
    required this.languageName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.nightCard : AppColors.creamCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            ayahText,
            textAlign: TextAlign.center,
            style: AppText.amiri(
              fontSize: 26,
              height: 2.0,
              color: isDark ? AppColors.textLight : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                gradient: AppGradients.goldShine,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '$ayahNumber',
                style: AppText.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emerald,
                ),
              ),
            ),
          ),
          if (translation != null && translation!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              height: 1,
              color: AppColors.gold.withValues(alpha: 0.15),
            ),
            const SizedBox(height: 16),
            Directionality(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: Text(
                translation!,
                textAlign: TextAlign.start,
                style: AppText.poppins(
                  fontSize: 15,
                  height: 1.7,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _iconButton(
                icon: Icons.share_rounded,
                isDark: isDark,
                onTap: () => ShareService.shareAyah(
                  context: context,
                  surahName: surahName,
                  ayahNumber: ayahNumber,
                  ayahText: ayahText,
                  translation: translation,
                  languageName: languageName,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.emerald.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isDark ? AppColors.goldSoft : AppColors.emerald,
          ),
        ),
      ),
    );
  }
}
