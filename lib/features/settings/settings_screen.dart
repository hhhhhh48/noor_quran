import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/theme_provider.dart';
import '../../data/database/translation_repository.dart';
import '../../data/models/translation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tp = context.watch<ThemeProvider>();
    final transRepo = context.watch<TranslationRepository>();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
        children: [
          _header(isDark),
          const SizedBox(height: 24),
          _sectionTitle('المظهر', isDark),
          const SizedBox(height: 10),
          _themeSelector(tp, isDark),
          const SizedBox(height: 24),
          _sectionTitle('حجم الخط', isDark),
          const SizedBox(height: 10),
          _fontSizeSlider(tp, isDark),
          const SizedBox(height: 24),
          _sectionTitle('لغة الترجمة الافتراضية', isDark),
          const SizedBox(height: 10),
          _defaultLangSelector(tp, transRepo, isDark),
          const SizedBox(height: 24),
          _sectionTitle('حول التطبيق', isDark),
          const SizedBox(height: 10),
          _aboutCard(isDark),
        ],
      ),
    );
  }

  Widget _header(bool isDark) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'الإعدادات',
          style: AppText.poppins(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textLight : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text, bool isDark) {
    return Text(
      text,
      style: AppText.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textMuted : AppColors.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _card({required bool isDark, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.nightCard : AppColors.creamCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
        ),
        boxShadow: isDark ? null : AppShadows.cardLight,
      ),
      child: child,
    );
  }

  Widget _themeSelector(ThemeProvider tp, bool isDark) {
    final options = [
      (ThemeMode.light, Icons.light_mode_rounded, 'فاتح'),
      (ThemeMode.system, Icons.brightness_auto_rounded, 'تلقائي'),
      (ThemeMode.dark, Icons.dark_mode_rounded, 'ليلي'),
    ];

    return _card(
      isDark: isDark,
      child: Row(
        children: options.map((o) {
          final selected = tp.themeMode == o.$1;
          return Expanded(
            child: GestureDetector(
              onTap: () => tp.setThemeMode(o.$1),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: selected ? AppColors.emerald : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Icon(
                      o.$2,
                      size: 22,
                      color: selected
                          ? Colors.white
                          : (isDark
                              ? AppColors.textMuted
                              : AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      o.$3,
                      style: AppText.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : (isDark
                                ? AppColors.textLight
                                : AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _fontSizeSlider(ThemeProvider tp, bool isDark) {
    return _card(
      isDark: isDark,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'أ',
                style: AppText.poppins(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.textSecondary,
                ),
              ),
              Expanded(
                child: Slider(
                  value: tp.fontSize,
                  min: 0.8,
                  max: 1.5,
                  divisions: 7,
                  activeColor: AppColors.emerald,
                  inactiveColor: AppColors.emerald.withValues(alpha: 0.2),
                  onChanged: (v) => tp.setFontSize(v),
                ),
              ),
              Text(
                'أ',
                style: AppText.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textLight
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.nightElevated : AppColors.cream,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              textAlign: TextAlign.center,
              style: AppText.amiri(
                fontSize: 22,
                height: 1.8,
                color: isDark ? AppColors.goldSoft : AppColors.emerald,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultLangSelector(
      ThemeProvider tp, TranslationRepository transRepo, bool isDark) {
    return _card(
      isDark: isDark,
      child: Column(
        children: kSupportedLanguages.map((lang) {
          final isSelected = lang.code == transRepo.currentLanguage;
          return InkWell(
            onTap: () async {
              await transRepo.loadLanguage(lang.code);
              await tp.setDefaultLang(lang.code);
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.emerald
                            : (isDark
                                ? AppColors.textMuted
                                : AppColors.textSecondary),
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: AppColors.emerald,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.nativeName,
                          style: AppText.poppins(
                            fontSize: 15,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isDark
                                ? AppColors.textLight
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          lang.englishName,
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
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _aboutCard(bool isDark) {
    return _card(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppGradients.goldShine,
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: AppColors.emerald,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'القرآن الكريم',
                    style: AppText.amiri(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textLight
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'الإصدار ١.٠.٠',
                    style: AppText.poppins(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: AppColors.gold.withValues(alpha: 0.15)),
          const SizedBox(height: 16),
          Text(
            'تطبيق مجاني لقراءة القرآن الكريم بـ 10 لغات عالمية.\n'
            'يعمل بدون إنترنت تماماً.',
            style: AppText.poppins(
              fontSize: 13,
              height: 1.7,
              color: isDark ? AppColors.textMuted : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: AppColors.gold.withValues(alpha: 0.15)),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.person_rounded,
                size: 18,
                color: isDark ? AppColors.goldSoft : AppColors.emerald,
              ),
              const SizedBox(width: 8),
              Text(
                'تطوير',
                style: AppText.poppins(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'محمد واشمي',
            style: AppText.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textLight : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.email_rounded,
                size: 16,
                color: isDark ? AppColors.goldSoft : AppColors.emerald,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'mohamedouachmi3@gmail.com',
                  style: AppText.poppins(
                    fontSize: 13,
                    color: AppColors.gold,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: AppColors.gold.withValues(alpha: 0.15)),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '﴿ إِنَّا نَحْنُ نَزَّلْنَا الذِّكْرَ وَإِنَّا لَهُ لَحَافِظُونَ ﴾',
              textAlign: TextAlign.center,
              style: AppText.amiri(
                fontSize: 16,
                height: 1.9,
                color: isDark ? AppColors.goldSoft : AppColors.emerald,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
