import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../data/database/quran_repository.dart';
import '../reader/reader_screen.dart';

class SurahsScreen extends StatelessWidget {
  final QuranRepository repo;
  const SurahsScreen({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              'السور',
              style: AppText.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.goldSoft : AppColors.emerald,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: repo.surahs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final s = repo.surahs[i];
                return _SurahTile(surah: s, isDark: isDark);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahTile extends StatelessWidget {
  final dynamic surah;
  final bool isDark;
  const _SurahTile({required this.surah, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ReaderScreen(surah: surah),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.emerald.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    '${surah.id}',
                    style: AppText.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.emerald,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.name,
                      style: AppText.amiri(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color:
                            isDark ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${surah.transliteration} • ${surah.totalVerses} آيات',
                      style: AppText.poppins(
                        fontSize: 12,
                        color:
                            isDark ? Colors.white54 : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: isDark ? Colors.white38 : AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
