import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/i18n/strings.dart';
import '../../core/services/bookmark_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text.dart';
import '../../data/database/quran_repository.dart';
import '../../data/models/bookmark.dart';
import '../reader/reader_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  List<Bookmark> _bookmarks = [];
  List<Map<String, dynamic>> _favorites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final b = await BookmarkService.getAll();
    final f = await StorageService.getFavorites();
    if (mounted) {
      setState(() {
        _bookmarks = b;
        _favorites = f.reversed.toList();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final repo = context.read<QuranRepository>();
    final s = context.watch<S>();

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
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
                  s.t('library'),
                  style: AppText.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color:
                        isDark ? AppColors.textLight : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.nightCard : AppColors.creamCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tab,
              indicator: BoxDecoration(
                color: AppColors.emerald,
                borderRadius: BorderRadius.circular(14),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(4),
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor:
                  isDark ? AppColors.textMuted : AppColors.textSecondary,
              labelStyle:
                  AppText.poppins(fontSize: 13, fontWeight: FontWeight.w600),
              unselectedLabelStyle: AppText.poppins(fontSize: 12),
              tabs: [
                Tab(text: '${s.t('bookmarks')} (${_bookmarks.length})'),
                Tab(text: '${s.t('favorites')} (${_favorites.length})'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _loading
                ? const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.emerald))
                : TabBarView(
                    controller: _tab,
                    children: [
                      _buildBookmarks(isDark, repo, s),
                      _buildFavorites(isDark, repo, s),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarks(bool isDark, QuranRepository repo, S s) {
    if (_bookmarks.isEmpty) {
      return _empty(
        isDark,
        Icons.bookmark_border_rounded,
        s.t('no_bookmarks'),
        s.t('no_bookmarks_hint'),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.emerald,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        itemCount: _bookmarks.length,
        itemBuilder: (_, i) => _bmCard(_bookmarks[i], isDark, repo, s),
      ),
    );
  }

  Widget _bmCard(Bookmark bm, bool isDark, QuranRepository repo, S s) {
    final color =
        Color(kBookmarkColors[bm.colorIndex % kBookmarkColors.length]);
    final surah = repo.byId(bm.surahId);
    final surahName = s.isAr
        ? bm.surahName
        : (surah?.transliteration ?? bm.surahName);

    return Dismissible(
      key: ValueKey(bm.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_rounded, color: Colors.red),
      ),
      onDismissed: (_) async {
        await BookmarkService.remove(bm.surahId, bm.ayahId);
        _load();
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: surah == null
              ? null
              : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReaderScreen(surah: surah),
                    ),
                  ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.nightCard : AppColors.creamCard,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
              boxShadow: isDark ? null : AppShadows.cardLight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration:
                          BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$surahName • ${s.t('ayah')} ${bm.ayahId}',
                      style: AppText.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  bm.ayahText,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppText.amiri(
                    fontSize: 18,
                    height: 1.8,
                    color:
                        isDark ? AppColors.textLight : AppColors.textPrimary,
                  ),
                ),
                if (bm.note.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      bm.note,
                      style: AppText.poppins(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textLight
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavorites(bool isDark, QuranRepository repo, S s) {
    if (_favorites.isEmpty) {
      return _empty(
        isDark,
        Icons.favorite_border_rounded,
        s.t('no_favorites'),
        s.t('no_favorites_hint'),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.emerald,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        itemCount: _favorites.length,
        itemBuilder: (_, i) => _favCard(_favorites[i], isDark, repo, s),
      ),
    );
  }

  Widget _favCard(
      Map<String, dynamic> f, bool isDark, QuranRepository repo, S s) {
    final sid = f['surah'] as int;
    final aid = f['ayah'] as int;
    final surah = repo.byId(sid);
    final surahName = s.isAr
        ? (f['surahName']?.toString() ?? '')
        : (surah?.transliteration ?? f['surahName']?.toString() ?? '');

    return Dismissible(
      key: ValueKey('fav-$sid:$aid'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_rounded, color: Colors.red),
      ),
      onDismissed: (_) async {
        await StorageService.removeFavorite(sid, aid);
        _load();
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: surah == null
              ? null
              : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReaderScreen(surah: surah),
                    ),
                  ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.nightCard : AppColors.creamCard,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.gold.withValues(alpha: 0.15)),
              boxShadow: isDark ? null : AppShadows.cardLight,
            ),
            child: Column(
              children: [
                Text(
                  f['text']?.toString() ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.amiri(
                    fontSize: 20,
                    height: 1.8,
                    color:
                        isDark ? AppColors.textLight : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$surahName • ${s.t('ayah')} $aid',
                  style:
                      AppText.poppins(fontSize: 11, color: AppColors.gold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _empty(bool isDark, IconData icon, String title, String sub) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.gold.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppText.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textLight : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              sub,
              textAlign: TextAlign.center,
              style: AppText.poppins(
                fontSize: 13,
                color:
                    isDark ? AppColors.textMuted : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
