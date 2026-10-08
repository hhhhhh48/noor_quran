import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/bookmark_service.dart';
import '../../core/services/share_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/widgets/audio_bar.dart';
import '../../data/database/tafsir_repository.dart';
import '../../data/database/translation_repository.dart';
import '../../data/models/bookmark.dart';
import '../../data/models/reciter.dart';
import '../../data/models/translation.dart';
import 'mushaf_view.dart';

class ReaderScreen extends StatelessWidget {
  final dynamic surah;
  final int? initialAyah;
  const ReaderScreen({super.key, required this.surah, this.initialAyah});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final transRepo = context.watch<TranslationRepository>();
    final tp = context.watch<ThemeProvider>();
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
                icon: Icon(
                  tp.mushafMode
                      ? Icons.view_agenda_rounded
                      : Icons.auto_stories_rounded,
                  color: isDark ? AppColors.goldSoft : AppColors.emerald,
                ),
                tooltip: tp.mushafMode ? 'وضع البطاقات' : 'وضع المصحف',
                onPressed: () => tp.setMushafMode(!tp.mushafMode),
              ),
              IconButton(
                icon: Icon(Icons.record_voice_over_rounded,
                    color: isDark ? AppColors.goldSoft : AppColors.emerald),
                tooltip: 'اختر القارئ',
                onPressed: () => _showReciterPicker(context),
              ),
              IconButton(
                icon: Icon(Icons.translate_rounded,
                    color: isDark ? AppColors.goldSoft : AppColors.emerald),
                onPressed: () => _showLangPicker(context, transRepo),
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
                      color:
                          isDark ? AppColors.textLight : AppColors.textPrimary,
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
            sliver: SliverToBoxAdapter(child: _bismillah(isDark)),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            sliver: SliverToBoxAdapter(
              child: tp.mushafMode
                  ? MushafView(surah: surah, isDark: isDark)
                  : _AyahList(
                      surah: surah,
                      isRtl: isRtl,
                      isDark: isDark,
                      langName: langInfo.englishName,
                      initialAyah: initialAyah,
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AudioBar(surahName: surah.name),
    );
  }

  Widget _bismillah(bool isDark) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [Color(0xFF1A2E25), Color(0xFF12201A)])
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

  void _showReciterPicker(BuildContext context) {
    final audio = context.read<AudioService>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: isDark ? AppColors.nightCard : AppColors.creamCard,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              _handle(isDark),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'اختر القارئ',
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
                  itemCount: kReciters.length,
                  itemBuilder: (_, i) {
                    final r = kReciters[i];
                    final cur = r.folder == audio.reciter.folder;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 4),
                      title: Text(
                        r.arabicName,
                        style: AppText.poppins(
                          fontSize: 16,
                          fontWeight:
                              cur ? FontWeight.bold : FontWeight.normal,
                          color: isDark
                              ? AppColors.textLight
                              : AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        r.englishName,
                        style: AppText.poppins(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.textSecondary,
                        ),
                      ),
                      trailing: cur
                          ? const Icon(Icons.check_circle,
                              color: AppColors.emerald)
                          : null,
                      onTap: () {
                        audio.setReciter(r);
                        Navigator.pop(context);
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
              _handle(isDark),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'اختر لغة الترجمة',
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
                  itemCount: kSupportedLanguages.length,
                  itemBuilder: (_, i) {
                    final l = kSupportedLanguages[i];
                    final cur = l.code == repo.currentLanguage;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 4),
                      title: Text(
                        l.nativeName,
                        style: AppText.poppins(
                          fontSize: 16,
                          fontWeight:
                              cur ? FontWeight.bold : FontWeight.normal,
                          color: isDark
                              ? AppColors.textLight
                              : AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        l.englishName,
                        style: AppText.poppins(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.textSecondary,
                        ),
                      ),
                      trailing: cur
                          ? const Icon(Icons.check_circle,
                              color: AppColors.emerald)
                          : null,
                      onTap: () async {
                        final ok = await repo.loadLanguage(l.code);
                        if (context.mounted) {
                          Navigator.pop(context);
                          if (!ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'الترجمة ${l.nativeName} غير متوفرة',
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

  Widget _handle(bool isDark) => Container(
        margin: const EdgeInsets.only(top: 12, bottom: 8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: isDark ? AppColors.textMuted : AppColors.textSecondary,
          borderRadius: BorderRadius.circular(2),
        ),
      );
}

class _AyahList extends StatelessWidget {
  final dynamic surah;
  final bool isRtl;
  final bool isDark;
  final String langName;
  final int? initialAyah;

  const _AyahList({
    required this.surah,
    required this.isRtl,
    required this.isDark,
    required this.langName,
    this.initialAyah,
  });

  @override
  Widget build(BuildContext context) {
    final transRepo = context.watch<TranslationRepository>();
    return Column(
      children: List.generate(surah.ayahs.length, (i) {
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
          langName: langName,
        );
      }),
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
  bool _isBookmarked = false;
  Bookmark? _bookmark;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final f = await StorageService.isFavorite(widget.surahId, widget.ayahNumber);
    final bm = await BookmarkService.getOne(widget.surahId, widget.ayahNumber);
    if (mounted) {
      setState(() {
        _isFav = f;
        _isBookmarked = bm != null;
        _bookmark = bm;
      });
    }
  }

  Future<void> _toggleFav() async {
    if (_isFav) {
      await StorageService.removeFavorite(widget.surahId, widget.ayahNumber);
    } else {
      await StorageService.addFavorite(
          widget.surahId, widget.ayahNumber, widget.surahName, widget.ayahText);
    }
    if (mounted) setState(() => _isFav = !_isFav);
  }

  void _openBookmarkSheet() {
    final isDark = widget.isDark;
    final noteCtrl = TextEditingController(text: _bookmark?.note ?? '');
    int selectedColor = _bookmark?.colorIndex ?? 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.nightCard : AppColors.creamCard,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.textSecondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  _isBookmarked ? 'تعديل الإشارة' : 'إضافة إشارة مرجعية',
                  style: AppText.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        isDark ? AppColors.textLight : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'اللون',
                  style: AppText.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(kBookmarkColors.length, (i) {
                    final c = Color(kBookmarkColors[i]);
                    final sel = i == selectedColor;
                    return GestureDetector(
                      onTap: () => setSt(() => selectedColor = i),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: sel ? Colors.white : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: sel
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 20)
                            : null,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Text(
                  'ملاحظة (اختياري)',
                  style: AppText.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: noteCtrl,
                  maxLines: 3,
                  style: AppText.poppins(
                    color:
                        isDark ? AppColors.textLight : AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'اكتب ملاحظتك هنا...',
                    hintStyle: AppText.poppins(
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.textSecondary,
                    ),
                    filled: true,
                    fillColor:
                        isDark ? AppColors.nightElevated : AppColors.cream,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (_isBookmarked)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await BookmarkService.remove(
                                widget.surahId, widget.ayahNumber);
                            if (ctx.mounted) Navigator.pop(ctx);
                            if (mounted) {
                              setState(() {
                                _isBookmarked = false;
                                _bookmark = null;
                              });
                            }
                          },
                          icon: const Icon(Icons.delete_rounded,
                              color: Colors.red),
                          label: Text(
                            'حذف',
                            style: AppText.poppins(color: Colors.red),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    if (_isBookmarked) const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final bm = Bookmark(
                            id: '${widget.surahId}:${widget.ayahNumber}',
                            surahId: widget.surahId,
                            ayahId: widget.ayahNumber,
                            surahName: widget.surahName,
                            ayahText: widget.ayahText,
                            note: noteCtrl.text.trim(),
                            colorIndex: selectedColor,
                            createdAt: DateTime.now().millisecondsSinceEpoch,
                          );
                          await BookmarkService.add(bm);
                          if (ctx.mounted) Navigator.pop(ctx);
                          if (mounted) {
                            setState(() {
                              _isBookmarked = true;
                              _bookmark = bm;
                            });
                          }
                        },
                        icon: const Icon(Icons.bookmark_rounded,
                            color: Colors.white),
                        label: Text(
                          _isBookmarked ? 'حفظ التعديل' : 'حفظ الإشارة',
                          style: AppText.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emerald,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTafsir(BuildContext context) {
    final repo = context.read<TafsirRepository>();
    final isDark = widget.isDark;
    final available = repo.loadedLanguages;
    String selectedLang = repo.currentLanguage;
    if (!available.contains(selectedLang) && available.isNotEmpty) {
      selectedLang = available.first;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) {
          final tafsir = repo.getTafsir(widget.surahId, widget.ayahNumber,
              lang: selectedLang);
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: isDark ? AppColors.nightCard : AppColors.creamCard,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
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
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.menu_book_rounded,
                              size: 20,
                              color: isDark
                                  ? AppColors.goldSoft
                                  : AppColors.emerald),
                          const SizedBox(width: 8),
                          Text(
                            'التفسير',
                            style: AppText.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.textLight
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${widget.surahName} • الآية ${widget.ayahNumber}',
                        style: AppText.poppins(
                            fontSize: 12, color: AppColors.gold),
                      ),
                    ],
                  ),
                ),
                if (available.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: available.map((code) {
                        final label =
                            TafsirRepository.availableLangs[code] ?? code;
                        final sel = code == selectedLang;
                        return GestureDetector(
                          onTap: () {
                            repo.setLanguage(code);
                            setSt(() => selectedLang = code);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColors.emerald
                                  : (isDark
                                      ? AppColors.nightElevated
                                      : AppColors.cream),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel
                                    ? AppColors.emerald
                                    : AppColors.gold.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              label,
                              style: AppText.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: sel
                                    ? Colors.white
                                    : (isDark
                                        ? AppColors.textLight
                                        : AppColors.textPrimary),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Container(
                    height: 1,
                    color: AppColors.gold.withValues(alpha: 0.15)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.nightElevated
                                : AppColors.cream,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color:
                                    AppColors.gold.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            widget.ayahText,
                            textAlign: TextAlign.center,
                            style: AppText.amiri(
                              fontSize: 22,
                              height: 1.9,
                              color: isDark
                                  ? AppColors.goldSoft
                                  : AppColors.emerald,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (tafsir == null || tafsir.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Text(
                                'التفسير غير متوفر بهذه اللغة',
                                style: AppText.poppins(
                                  fontSize: 14,
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          )
                        else
                          Directionality(
                            textDirection: (selectedLang == 'ar' ||
                                    selectedLang == 'ur')
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: Text(
                              tafsir,
                              style: AppText.poppins(
                                fontSize: 15,
                                height: 1.9,
                                color: isDark
                                    ? AppColors.textLight
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final audio = context.watch<AudioService>();
    final isCurrent = audio.currentSurah == widget.surahId &&
        audio.currentAyah == widget.ayahNumber;
    final isPlayingThis = isCurrent && audio.isPlaying;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.nightCard : AppColors.creamCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCurrent
              ? AppColors.gold
              : AppColors.gold.withValues(alpha: 0.15),
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.ayahText,
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppGradients.goldShine,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '${widget.ayahNumber}',
                style: AppText.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.emerald,
                ),
              ),
            ),
          ),
          if (widget.translation != null && widget.translation!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(height: 1, color: AppColors.gold.withValues(alpha: 0.15)),
            const SizedBox(height: 16),
            Directionality(
              textDirection:
                  widget.isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: Text(
                widget.translation!,
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
              _btn(
                isPlayingThis ? Icons.pause_rounded : Icons.play_arrow_rounded,
                Icons.play_arrow_rounded,
                isCurrent,
                () {
                  if (isPlayingThis) {
                    audio.pause();
                  } else if (isCurrent) {
                    audio.resume();
                  } else {
                    audio.playAyah(widget.surahId, widget.ayahNumber);
                  }
                },
              ),
              const SizedBox(width: 8),
              _btn(Icons.book_rounded, Icons.book_rounded, false,
                  () => _showTafsir(context)),
              const SizedBox(width: 8),
              _btn(Icons.favorite_border_rounded, Icons.favorite_rounded,
                  _isFav, _toggleFav),
              const SizedBox(width: 8),
              _btn(
                _isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                Icons.bookmark_rounded,
                _isBookmarked,
                _openBookmarkSheet,
              ),
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

  Widget _btn(
      IconData icon, IconData activeIcon, bool active, VoidCallback onTap) {
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
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            active ? activeIcon : icon,
            size: 18,
            color: active
                ? AppColors.gold
                : (widget.isDark ? AppColors.goldSoft : AppColors.emerald),
          ),
        ),
      ),
    );
  }
}
