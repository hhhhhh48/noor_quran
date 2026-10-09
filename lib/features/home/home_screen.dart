import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/i18n/strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text.dart';
import '../../data/database/quran_repository.dart';
import '../adhkar/adhkar_screen.dart';
import '../bookmarks/bookmarks_screen.dart';
import '../qibla/qibla_screen.dart';
import '../reader/reader_screen.dart';
import '../search/search_screen.dart';
import '../settings/settings_screen.dart';
import '../surahs/surahs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final repo = context.read<QuranRepository>();
    final s = context.watch<S>();

    final pages = [
      _HomeTab(isDark: isDark, s: s),
      SurahsScreen(repo: repo),
      const AdhkarScreen(),
      const SearchScreen(),
      const BookmarksScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.night : AppColors.cream,
      extendBody: true,
      body: IndexedStack(index: _tab, children: pages),
      bottomNavigationBar: _nav(isDark, s),
    );
  }

  Widget _nav(bool isDark, S s) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.nightCard.withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppShadows.navShadow,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: 64,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          indicatorColor: AppColors.emerald.withValues(alpha: 0.15),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined, size: 20),
              selectedIcon: const Icon(Icons.home_rounded, color: AppColors.emerald, size: 20),
              label: s.t('home'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.menu_book_outlined, size: 20),
              selectedIcon: const Icon(Icons.menu_book_rounded, color: AppColors.emerald, size: 20),
              label: s.t('surahs'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.auto_awesome_outlined, size: 20),
              selectedIcon: const Icon(Icons.auto_awesome, color: AppColors.emerald, size: 20),
              label: s.t('adhkar'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.search_outlined, size: 20),
              selectedIcon: const Icon(Icons.search_rounded, color: AppColors.emerald, size: 20),
              label: s.t('search'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.bookmark_border_rounded, size: 20),
              selectedIcon: const Icon(Icons.bookmark_rounded, color: AppColors.emerald, size: 20),
              label: s.t('library'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined, size: 20),
              selectedIcon: const Icon(Icons.settings_rounded, color: AppColors.emerald, size: 20),
              label: s.t('settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final bool isDark;
  final S s;
  const _HomeTab({required this.isDark, required this.s});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: [
          _header(context),
          const SizedBox(height: 28),
          _verseOfDay(context),
          const SizedBox(height: 24),
          _sectionTitle(s.t('continue_reading')),
          const SizedBox(height: 12),
          _continueCard(context),
          const SizedBox(height: 24),
          _sectionTitle(s.t('tools')),
          const SizedBox(height: 12),
          _quickActions(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.t('salam'),
              style: AppText.poppins(
                fontSize: 14,
                color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              s.t('quran_kareem'),
              style: AppText.amiri(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.goldSoft : AppColors.emerald,
              ),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDark ? AppColors.nightCard : AppColors.creamCard,
            shape: BoxShape.circle,
            boxShadow: AppShadows.cardLight,
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: isDark ? AppColors.goldSoft : AppColors.emerald,
          ),
        ),
      ],
    );
  }

  Widget _verseOfDay(BuildContext context) => Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: AppGradients.heroEmerald,
          borderRadius: BorderRadius.circular(32),
          boxShadow: AppShadows.softEmerald,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.auto_awesome,
                      color: AppColors.goldBright, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  s.t('ayah_of_day'),
                  style: AppText.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.goldSoft,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '﴿ وَقُل رَّبِّ زِدْنِي عِلْمًا ﴾',
              style: AppText.amiri(
                fontSize: 30,
                color: Colors.white,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 24,
                  height: 1,
                  color: AppColors.gold.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 10),
                Text(
                  'طه • ١١٤',
                  style: AppText.poppins(
                    fontSize: 12,
                    color: AppColors.goldBright.withValues(alpha: 0.9),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _sectionTitle(String title) => Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: AppText.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textLight : AppColors.textPrimary,
            ),
          ),
        ],
      );

  Widget _continueCard(BuildContext context) {
    final repo = context.read<QuranRepository>();
    final fatiha = repo.surahs.isNotEmpty ? repo.surahs.first : null;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: fatiha == null
            ? null
            : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReaderScreen(surah: fatiha),
                  ),
                ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.nightCard : AppColors.creamCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.2),
            ),
            boxShadow: isDark ? null : AppShadows.cardLight,
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppGradients.goldShine,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: AppShadows.goldGlow,
                ),
                child: const Icon(Icons.bookmark_rounded,
                    color: AppColors.emerald, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.isAr
                          ? (fatiha?.name ?? s.t('surah_fatiha'))
                          : (fatiha?.transliteration ?? 'Al-Fatiha'),
                      style: AppText.amiri(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textLight
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.t('tap_to_continue'),
                      style: AppText.poppins(
                        fontSize: 12,
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
                color: isDark ? AppColors.textMuted : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QiblaScreen()),
              ),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.nightCard : AppColors.creamCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.explore_rounded,
                        color: AppColors.emerald, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      s.t('qibla'),
                      style: AppText.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textLight
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.nightCard : AppColors.creamCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.headphones_rounded,
                    color: AppColors.emerald, size: 28),
                const SizedBox(height: 8),
                Text(
                  s.t('reciters'),
                  style: AppText.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textLight
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
