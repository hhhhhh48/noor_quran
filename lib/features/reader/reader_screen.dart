import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/share_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text.dart';
import '../../data/database/tafsir_repository.dart';
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
    StorageService.setLastRead(surah.id, 1, surah.name);

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
              icon: Icon(Icons.arrow_back_rounded,
                color: isDark ? AppColors.goldSoft : AppColors.emerald),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.translate_rounded,
                  color: isDark ? AppColors.goldSoft : AppColors.emerald),
                onPressed: () => _showLangPicker(context, transRepo),
              ),
              IconButton(
                icon: Icon(Icons.share_rounded,
                  color: isDark ? AppColors.goldSoft : AppColors.emerald),
                onPressed: () => ShareService.shareApp(),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 16),
              centerTitle: true,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(surah.name,
                    style: AppText.amiri(fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textLight : AppColors.textPrimary)),
                  Text('${surah.totalVerses} آيات',
                    style: AppText.poppins(fontSize: 11,
                      color: isDark ? AppColors.textMuted : AppColors.textSecondary)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            sliver: SliverToBoxAdapter(child: _bismillah(isDark)),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            sliver: SliverList.builder(
              itemCount: surah.ayahs.length,
              itemBuilder: (context, i) {
                final a = surah.ayahs[i];
                final t = transRepo.verse(surah.id, a.number);
                return _AyahCard(
                  ayahText: a.text,
                  ayahNumber: a.number,
                  translation: t,
                  isRtl: isRtl,
                  isDark: isDark,
                  surahId: surah.id,
                  surahName: surah.name,
                  langName: langInfo.englishName,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _bismillah(bool isDark) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    decoration: BoxDecoration(
      gradient: isDark
          ? const LinearGradient(colors: [Color(0xFF1A2E25), Color(0xFF12201A)])
          : AppGradients.heroEmerald,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Center(
      child: Text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        textAlign: TextAlign.center,
        style: AppText.amiri(fontSize: 24,
          color: isDark ? AppColors.goldSoft : Colors.white, height: 1.8)),
    ),
  );

  void _showLangPicker(BuildContext context, TranslationRepository repo) {
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
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('اختر لغة الترجمة',
                  style: AppText.poppins(fontSize: 20, fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textLight : AppColors.textPrimary)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: kSupportedLanguages.length,
                  itemBuilder: (_, i) {
                    final l = kSupportedLanguages[i];
                    final cur = l.code == repo.currentLanguage;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      title: Text(l.nativeName,
                        style: AppText.poppins(fontSize: 16,
                          fontWeight: cur ? FontWeight.bold : FontWeight.normal,
                          color: isDark ? AppColors.textLight : AppColors.textPrimary)),
                      subtitle: Text(l.englishName,
                        style: AppText.poppins(fontSize: 12,
                          color: isDark ? AppColors.textMuted : AppColors.textSecondary)),
                      trailing: cur
                          ? const Icon(Icons.check_circle, color: AppColors.emerald)
                          : null,
                      onTap: () async {
                        final ok = await repo.loadLanguage(l.code);
                        if (context.mounted) {
                          Navigator.pop(context);
                          if (!ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('الترجمة ${l.nativeName} غير متوفرة',
                                style: AppText.poppins())));
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

class _AyahCard extends StatefulWidget {
  final String ayahText;
  final int ayahNumber;
  final String? translation;
  final bool isRtl;
  final bool isDark;
  final int surahId;
  final String surahName;
  final String langName;

  const _AyahCard({
    required this.ayahText,
    required this.ayahNumber,
    required this.translation,
    required this.isRtl,
    required this.isDark,
    required this.surahId,
    required this.surahName,
    required this.langName,
  });

  @override
  State<_AyahCard> createState() => _AyahCardState();
}

class _AyahCardState extends State<_AyahCard> {
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final f = await StorageService.isFavorite(widget.surahId, widget.ayahNumber);
    if (mounted) setState(() => _isFav = f);
  }

  Future<void> _toggle() async {
    if (_isFav) {
      await StorageService.removeFavorite(widget.surahId, widget.ayahNumber);
    } else {
      await StorageService.addFavorite(
        widget.surahId, widget.ayahNumber, widget.surahName, widget.ayahText);
    }
    if (mounted) setState(() => _isFav = !_isFav);
  }

  void _showTafsir(BuildContext context) {
    final repo = context.read<TafsirRepository>();
    final tafsir = repo.getTafsir(widget.surahId, widget.ayahNumber);
    final isDark = widget.isDark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: isDark ? AppColors.nightCard : AppColors.creamCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
              child: Column(
                children: [
                  Text('التفسير الميسر',
                    style: AppText.poppins(fontSize: 18, fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textLight : AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  Text('${widget.surahName} • الآية ${widget.ayahNumber}',
                    style: AppText.poppins(fontSize: 12, color: AppColors.gold)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: AppColors.gold.withValues(alpha: 0.15), height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.nightElevated : AppColors.cream,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
                      ),
                      child: Text(widget.ayahText,
                        textAlign: TextAlign.center,
                        style: AppText.amiri(fontSize: 22, height: 1.9,
                          color: isDark ? AppColors.goldSoft : AppColors.emerald)),
                    ),
                    const SizedBox(height: 20),
                    if (tafsir == null || tafsir.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Text('التفسير غير متوفر لهذه الآية',
                            style: AppText.poppins(fontSize: 14,
                              color: isDark ? AppColors.textMuted : AppColors.textSecondary)),
                        ),
                      )
                    else
                      Text(tafsir,
                        style: AppText.poppins(fontSize: 15, height: 1.9,
                          color: isDark ? AppColors.textLight : AppColors.textPrimary)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.nightCard : AppColors.creamCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.ayahText,
            textAlign: TextAlign.center,
            style: AppText.amiri(fontSize: 26, height: 2.0,
              color: isDark ? AppColors.textLight : AppColors.textPrimary)),
          const SizedBox(height: 14),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppGradients.goldShine,
                borderRadius: BorderRadius.circular(14)),
              child: Text('${widget.ayahNumber}',
                style: AppText.poppins(fontSize: 12,
                  fontWeight: FontWeight.bold, color: AppColors.emerald)),
            ),
          ),
          if (widget.translation != null && widget.translation!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(height: 1, color: AppColors.gold.withValues(alpha: 0.15)),
            const SizedBox(height: 16),
            Directionality(
              textDirection: widget.isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: Text(widget.translation!,
                textAlign: TextAlign.start,
                style: AppText.poppins(fontSize: 15, height: 1.7,
                  color: isDark ? AppColors.textMuted : AppColors.textSecondary)),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _btn(Icons.book_rounded, Icons.book_rounded, false,
                () => _showTafsir(context)),
              const SizedBox(width: 8),
              _btn(Icons.bookmark_border_rounded, Icons.bookmark_rounded,
                _isFav, _toggle),
              const SizedBox(width: 8),
              _btn(Icons.share_rounded, Icons.share_rounded, false, () {
                ShareService.shareAyah(
                  context: context,
                  surahName: widget.surahName,
                  ayahNumber: widget.ayahNumber,
                  ayahText: widget.ayahText,
                  translation: widget.translation,
                  languageName: widget.langName,
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, IconData activeIcon, bool active, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: active
                ? AppColors.gold.withValues(alpha: 0.2)
                : AppColors.emerald.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12)),
          child: Icon(active ? activeIcon : icon, size: 18,
            color: active
                ? AppColors.gold
                : (widget.isDark ? AppColors.goldSoft : AppColors.emerald)),
        ),
      ),
    );
  }
}
