import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/i18n/strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text.dart';
import '../../data/database/adhkar_repository.dart';
import '../../data/models/adhkar.dart';

class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final repo = context.watch<AdhkarRepository>();
    final s = context.watch<S>();

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
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
                  s.t('adhkar_duas'),
                  style: AppText.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        isDark ? AppColors.textLight : AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showLangPicker(context, repo),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.emerald.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.translate_rounded,
                            size: 16, color: AppColors.emerald),
                        const SizedBox(width: 6),
                        Text(
                          AdhkarRepository
                                  .languageNames[repo.currentLanguage] ??
                              'EN',
                          style: AppText.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.emerald,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: !repo.isLoaded
                ? const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.emerald))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                    itemCount: repo.categories.length,
                    itemBuilder: (_, i) {
                      return _CategoryCard(
                        category: repo.categories[i],
                        isDark: isDark,
                        lang: repo.currentLanguage,
                        s: s,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showLangPicker(BuildContext context, AdhkarRepository repo) {
    final s = context.read<S>();
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color:
                      isDark ? AppColors.textMuted : AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  s.t('translation_lang'),
                  style: AppText.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        isDark ? AppColors.textLight : AppColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: AdhkarRepository.languageNames.length,
                  itemBuilder: (_, i) {
                    final code =
                        AdhkarRepository.languageNames.keys.elementAt(i);
                    final name = AdhkarRepository.languageNames[code]!;
                    final cur = code == repo.currentLanguage;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 4),
                      title: Text(
                        name,
                        style: AppText.poppins(
                          fontSize: 16,
                          fontWeight:
                              cur ? FontWeight.bold : FontWeight.normal,
                          color: isDark
                              ? AppColors.textLight
                              : AppColors.textPrimary,
                        ),
                      ),
                      trailing: cur
                          ? const Icon(Icons.check_circle,
                              color: AppColors.emerald)
                          : null,
                      onTap: () async {
                        final ok = await repo.loadLanguage(code);
                        if (context.mounted) Navigator.pop(context);
                        if (!ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(s.t('not_available'),
                                  style: AppText.poppins()),
                            ),
                          );
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

class _CategoryCard extends StatelessWidget {
  final AdhkarCategory category;
  final bool isDark;
  final String lang;
  final S s;
  const _CategoryCard({
    required this.category,
    required this.isDark,
    required this.lang,
    required this.s,
  });

  IconData _iconFor(String name) {
    switch (name) {
      case 'wb_sunny':
        return Icons.wb_sunny_rounded;
      case 'nights_stay':
        return Icons.nights_stay_rounded;
      case 'bedtime':
        return Icons.bedtime_rounded;
      case 'wb_twilight':
        return Icons.wb_twilight_rounded;
      case 'mosque':
        return Icons.mosque_rounded;
      case 'volunteer_activism':
        return Icons.volunteer_activism_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      case 'healing':
        return Icons.healing_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdhkarCategoryScreen(
              category: category,
              lang: lang,
              s: s,
            ),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
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
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppGradients.goldShine
                      : AppGradients.heroEmerald,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _iconFor(category.icon),
                  color: isDark ? AppColors.emerald : AppColors.goldSoft,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.isAr ? category.title : category.titleEn,
                      style: AppText.amiri(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textLight
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${category.titleEn} • ${category.items.length}',
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
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color:
                    isDark ? AppColors.textMuted : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdhkarCategoryScreen extends StatelessWidget {
  final AdhkarCategory category;
  final String lang;
  final S s;
  const AdhkarCategoryScreen({
    super.key,
    required this.category,
    required this.lang,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.night : AppColors.cream,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.night : AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? AppColors.goldSoft : AppColors.emerald,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          s.isAr ? category.title : category.titleEn,
          style: AppText.amiri(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textLight : AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        itemCount: category.items.length,
        itemBuilder: (_, i) => _AdhkarCard(
          item: category.items[i],
          isDark: isDark,
          index: i + 1,
          showLocalized: lang != 'en',
          s: s,
        ),
      ),
    );
  }
}

class _AdhkarCard extends StatefulWidget {
  final AdhkarItem item;
  final bool isDark;
  final int index;
  final bool showLocalized;
  final S s;
  const _AdhkarCard({
    required this.item,
    required this.isDark,
    required this.index,
    required this.showLocalized,
    required this.s,
  });

  @override
  State<_AdhkarCard> createState() => _AdhkarCardState();
}

class _AdhkarCardState extends State<_AdhkarCard> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final item = widget.item;
    final s = widget.s;
    final done = _counter >= item.count;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.nightCard : AppColors.creamCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:
              done ? AppColors.emerald : AppColors.gold.withValues(alpha: 0.15),
          width: done ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${widget.index}',
                  style: AppText.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.emerald,
                  ),
                ),
              ),
              const Spacer(),
              if (item.count > 1)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: AppGradients.goldShine,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${item.count}x',
                    style: AppText.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.emerald,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            item.arabic,
            textAlign: TextAlign.right,
            style: AppText.amiri(
              fontSize: 22,
              height: 2.0,
              color: isDark ? AppColors.goldSoft : AppColors.emerald,
            ),
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: AppColors.gold.withValues(alpha: 0.15)),
          const SizedBox(height: 14),
          Text(
            item.transliteration,
            style: AppText.poppins(
              fontSize: 13,
              height: 1.6,
              fontStyle: FontStyle.italic,
              color: isDark ? AppColors.textMuted : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          if (widget.showLocalized) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.emerald.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item.localized,
                style: AppText.poppins(
                  fontSize: 14,
                  height: 1.7,
                  color:
                      isDark ? AppColors.textLight : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.english,
              style: AppText.poppins(
                fontSize: 12,
                height: 1.6,
                color:
                    isDark ? AppColors.textMuted : AppColors.textSecondary,
              ),
            ),
          ] else
            Text(
              item.english,
              style: AppText.poppins(
                fontSize: 14,
                height: 1.7,
                color: isDark ? AppColors.textLight : AppColors.textPrimary,
              ),
            ),
          if (item.count > 1) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                if (!done) setState(() => _counter++);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: done ? AppGradients.goldShine : null,
                  color: done ? null : AppColors.emerald,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      done ? Icons.check_circle : Icons.touch_app_rounded,
                      color: done ? AppColors.emerald : Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      done
                          ? s.t('done')
                          : '${s.t('tap_to_count')} ($_counter / ${item.count})',
                      style: AppText.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: done ? AppColors.emerald : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
