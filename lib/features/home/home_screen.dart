import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text.dart';
import '../../data/database/quran_repository.dart';
import '../surahs/surahs_screen.dart';
import '../reader/reader_screen.dart';
import '../settings/settings_screen.dart';
import '../search/search_screen.dart';
import '../favorites/favorites_screen.dart';

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

    final pages = [
      _HomeTab(isDark: isDark),
      SurahsScreen(repo: repo),
      const SearchScreen(),
      const FavoritesScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.night : AppColors.cream,
      extendBody: true,
      body: IndexedStack(index: _tab, children: pages),
      bottomNavigationBar: _nav(isDark),
    );
  }

  Widget _nav(bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.nightCard.withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppShadows.navShadow,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: 66,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          indicatorColor: AppColors.emerald.withValues(alpha: 0.15),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, size: 22),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.emerald, size: 22),
              label: 'الرئيسية'),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined, size: 22),
              selectedIcon: Icon(Icons.menu_book_rounded, color: AppColors.emerald, size: 22),
              label: 'السور'),
            NavigationDestination(
              icon: Icon(Icons.search_outlined, size: 22),
              selectedIcon: Icon(Icons.search_rounded, color: AppColors.emerald, size: 22),
              label: 'البحث'),
            NavigationDestination(
              icon: Icon(Icons.bookmark_border_rounded, size: 22),
              selectedIcon: Icon(Icons.bookmark_rounded, color: AppColors.emerald, size: 22),
              label: 'المفضلة'),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, size: 22),
              selectedIcon: Icon(Icons.settings_rounded, color: AppColors.emerald, size: 22),
              label: 'الإعدادات'),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final bool isDark;
  const _HomeTab({required this.isDark});

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
          _sectionTitle('متابعة القراءة'),
          const SizedBox(height: 12),
          _continueCard(context),
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
            Text('السلام عليكم',
              style: AppText.poppins(fontSize: 14,
                color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                letterSpacing: 0.5)),
            const SizedBox(height: 4),
            Text('القرآن الكريم',
              style: AppText.amiri(fontSize: 32, fontWeight: FontWeight.bold,
                color: isDark ? AppColors.goldSoft : AppColors.emerald)),
          ],
        ),
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: isDark ? AppColors.nightCard : AppColors.creamCard,
            shape: BoxShape.circle,
            boxShadow: AppShadows.cardLight),
          child: Icon(Icons.notifications_none_rounded,
            color: isDark ? AppColors.goldSoft : AppColors.emerald),
        ),
      ],
    );
  }

  Widget _verseOfDay(BuildContext context) => Container(
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      gradient: AppGradients.heroEmerald,
      borderRadius: BorderRadius.circular(32),
      boxShadow: AppShadows.softEmerald),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.auto_awesome,
                color: AppColors.goldBright, size: 18),
            ),
            const SizedBox(width: 10),
            Text('آية اليوم',
              style: AppText.poppins(fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.goldSoft, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 24),
        Text('﴿ وَقُل رَّبِّ زِدْنِي عِلْمًا ﴾',
          style: AppText.amiri(fontSize: 30, color: Colors.white, height: 1.8)),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(width: 24, height: 1,
              color: AppColors.gold.withValues(alpha: 0.6)),
            const SizedBox(width: 10),
            Text('سورة طه • الآية ١١٤',
              style: AppText.poppins(fontSize: 12,
                color: AppColors.goldBright.withValues(alpha: 0.9),
                letterSpacing: 0.5)),
          ],
        ),
      ],
    ),
  );

  Widget _sectionTitle(String title) => Row(
    children: [
      Container(width: 4, height: 20,
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 10),
      Text(title,
        style: AppText.poppins(fontSize: 18, fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textLight : AppColors.textPrimary)),
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
            : () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => ReaderScreen(surah: fatiha))),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.nightCard : AppColors.creamCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.2)),
            boxShadow: isDark ? null : AppShadows.cardLight),
          child: Row(
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  gradient: AppGradients.goldShine,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: AppShadows.goldGlow),
                child: const Icon(Icons.bookmark_rounded,
                  color: AppColors.emerald, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fatiha?.name ?? 'سورة الفاتحة',
                      style: AppText.amiri(fontSize: 20, fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textLight : AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text('اضغط للمتابعة',
                      style: AppText.poppins(fontSize: 12,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.textSecondary)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14,
                color: isDark ? AppColors.textMuted : AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
