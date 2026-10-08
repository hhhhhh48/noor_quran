import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text.dart';
import '../../data/database/quran_repository.dart';
import '../reader/reader_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> _favs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final f = await StorageService.getFavorites();
    if (mounted) {
      setState(() {
        _favs = f.reversed.toList();
        _loading = false;
      });
    }
  }

  Future<void> _remove(int s, int a) async {
    await StorageService.removeFavorite(s, a);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final repo = context.read<QuranRepository>();

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 4, height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text('المفضلة',
                  style: AppText.poppins(
                    fontSize: 26, fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textLight : AppColors.textPrimary,
                  )),
                const Spacer(),
                if (!_loading)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.emerald.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('${_favs.length}',
                      style: AppText.poppins(fontSize: 12,
                        fontWeight: FontWeight.w600, color: AppColors.emerald)),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(
                    color: AppColors.emerald))
                : _favs.isEmpty
                    ? _empty(isDark)
                    : RefreshIndicator(
                        onRefresh: _load,
                        color: AppColors.emerald,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                          itemCount: _favs.length,
                          itemBuilder: (_, i) =>
                              _card(_favs[i], isDark, repo),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _empty(bool isDark) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.bookmark_border_rounded, size: 64,
          color: AppColors.gold.withValues(alpha: 0.5)),
        const SizedBox(height: 16),
        Text('لا توجد آيات محفوظة',
          style: AppText.poppins(fontSize: 18, fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textLight : AppColors.textPrimary)),
        const SizedBox(height: 6),
        Text('اضغط على أيقونة الحفظ في أي آية',
          style: AppText.poppins(fontSize: 13,
            color: isDark ? AppColors.textMuted : AppColors.textSecondary)),
      ],
    ),
  );

  Widget _card(Map<String, dynamic> f, bool isDark, QuranRepository repo) {
    final sid = f['surah'] as int;
    final aid = f['ayah'] as int;
    final surah = repo.byId(sid);

    return Dismissible(
      key: ValueKey('$sid:$aid'),
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
      onDismissed: (_) => _remove(sid, aid),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: surah == null
              ? null
              : () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => ReaderScreen(surah: surah))),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.nightCard : AppColors.creamCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.15)),
              boxShadow: isDark ? null : AppShadows.cardLight,
            ),
            child: Column(
              children: [
                Text(f['text'] ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.amiri(fontSize: 20, height: 1.8,
                    color: isDark
                        ? AppColors.textLight
                        : AppColors.textPrimary)),
                const SizedBox(height: 10),
                Text('${f['surahName']} • آية $aid',
                  textAlign: TextAlign.center,
                  style: AppText.poppins(fontSize: 11, color: AppColors.gold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
