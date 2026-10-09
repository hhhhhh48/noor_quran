import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/i18n/strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../data/database/quran_repository.dart';
import '../../data/database/translation_repository.dart';
import '../reader/reader_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';
  List<Map<String, dynamic>> _results = [];

  void _search(String q, QuranRepository repo, TranslationRepository trans) {
    setState(() => _query = q);
    if (q.trim().length < 2) {
      setState(() => _results = []);
      return;
    }
    final results = <Map<String, dynamic>>[];
    final norm = q.trim();
    final low = norm.toLowerCase();

    for (final s in repo.surahs) {
      if (s.name.contains(norm) ||
          s.transliteration.toLowerCase().contains(low)) {
        results.add({
          'type': 'surah',
          'surah': s,
          'title': s.name,
          'subtitle': s.transliteration,
        });
      }
      for (final a in s.ayahs) {
        if (a.text.contains(norm)) {
          results.add({
            'type': 'ayah',
            'surah': s,
            'title': a.text,
            'subtitle': '${s.name} • ${a.number}',
          });
        }
        final t = trans.verse(s.id, a.number);
        if (t != null && t.toLowerCase().contains(low)) {
          results.add({
            'type': 'trans',
            'surah': s,
            'title': t,
            'subtitle': '${s.name} • ${a.number}',
          });
        }
        if (results.length > 150) break;
      }
      if (results.length > 150) break;
    }
    setState(() => _results = results);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final repo = context.read<QuranRepository>();
    final trans = context.watch<TranslationRepository>();
    final s = context.watch<S>();

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _ctrl,
              onChanged: (v) => _search(v, repo, trans),
              style: AppText.poppins(
                color:
                    isDark ? AppColors.textLight : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: s.t('search_hint'),
                hintStyle: AppText.poppins(
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.textSecondary,
                ),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.emerald),
                filled: true,
                fillColor:
                    isDark ? AppColors.nightCard : AppColors.creamCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _query.length < 2
                ? _empty(isDark, s)
                : _results.isEmpty
                    ? _noResult(isDark, s)
                    : ListView.builder(
                        padding:
                            const EdgeInsets.fromLTRB(16, 0, 16, 120),
                        itemCount: _results.length,
                        itemBuilder: (_, i) =>
                            _card(_results[i], isDark),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _empty(bool isDark, S s) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_rounded,
                size: 64, color: AppColors.gold.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(s.t('search_quran'),
                style: AppText.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textLight
                        : AppColors.textPrimary)),
            const SizedBox(height: 6),
            Text(s.t('search_min'),
                style: AppText.poppins(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.textSecondary)),
          ],
        ),
      );

  Widget _noResult(bool isDark, S s) => Center(
        child: Text(s.t('no_results'),
            style: AppText.poppins(
                fontSize: 16,
                color:
                    isDark ? AppColors.textMuted : AppColors.textSecondary)),
      );

  Widget _card(Map<String, dynamic> r, bool isDark) {
    final isAyah = r['type'] == 'ayah';
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ReaderScreen(surah: r['surah']))),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.nightCard : AppColors.creamCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r['title'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: isAyah
                      ? AppText.amiri(
                          fontSize: 20,
                          height: 1.8,
                          color: isDark
                              ? AppColors.textLight
                              : AppColors.textPrimary)
                      : AppText.poppins(
                          fontSize: 14,
                          height: 1.6,
                          color: isDark
                              ? AppColors.textLight
                              : AppColors.textPrimary)),
              const SizedBox(height: 6),
              Text(r['subtitle'],
                  style:
                      AppText.poppins(fontSize: 11, color: AppColors.gold)),
            ],
          ),
        ),
      ),
    );
  }
}
