import 'package:provider/provider.dart';
import '../../data/database/quran_repository.dart';
import '../surahs/surahs_screen.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_colors.dart';

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
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: [
          _buildHome(context, isDark),
          SurahsScreen(repo: context.read<QuranRepository>()),
          const Center(child: Text('البحث')),
          const Center(child: Text('الإعدادات')),
        ],
      ),
      bottomNavigationBar: _buildNav(isDark),
    );
  }

  Widget _buildNav(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : AppColors.emerald)
                .withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: AppColors.emerald.withValues(alpha: 0.15),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.emerald),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon:
                  Icon(Icons.menu_book_rounded, color: AppColors.emerald),
              label: 'السور',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search_rounded, color: AppColors.emerald),
              label: 'البحث',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon:
                  Icon(Icons.settings_rounded, color: AppColors.emerald),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHome(BuildContext context, bool isDark) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'السلام عليكم',
                      style: AppText.poppins(
                        fontSize: 14,
                        color: isDark
                            ? Colors.white60
                            : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'نور القرآن',
                      style: AppText.amiri(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.goldSoft
                            : AppColors.emerald,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceDark
                        : AppColors.surfaceLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: isDark ? AppColors.goldSoft : AppColors.emerald,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            _buildVerseOfDay(isDark),
            const SizedBox(height: 24),
            Text(
              'متابعة القراءة',
              style: AppText.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            _buildContinueCard(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildVerseOfDay(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.emerald, AppColors.emeraldSoft],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.emerald.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.gold, size: 20),
              const SizedBox(width: 8),
              Text(
                'آية اليوم',
                style: AppText.poppins(
                  fontSize: 14,
                  color: AppColors.goldSoft,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '﴿ وَقُل رَّبِّ زِدْنِي عِلْمًا ﴾',
            style: AppText.amiri(
              fontSize: 26,
              color: Colors.white,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'سورة طه - الآية 114',
            style: AppText.poppins(
              fontSize: 12,
              color: AppColors.gold.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.emerald.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.bookmark_rounded,
              color: AppColors.emerald,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سورة الفاتحة',
                  style: AppText.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'الآية 1 من 7',
                  style: AppText.poppins(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        ],
      ),
    );
  }
}
