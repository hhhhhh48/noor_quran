import 'package:flutter/material.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text.dart';
import '../home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  final _pages = [
    (Icons.menu_book_rounded, 'اقرأ القرآن', 'READ THE QURAN',
     'اقرأ القرآن الكريم بالعربية مع ترجمة بـ 10 لغات عالمية',
     'Read the Holy Quran in Arabic with translations in 10 world languages'),
    (Icons.translate_rounded, 'اختر لغتك', 'CHOOSE YOUR LANGUAGE',
     'إنجليزي، فرنسي، إسباني، روسي، تركي، أردي، بنغالي، إندونيسي، صيني، سويدي',
     'English, French, Spanish, Russian, Turkish, Urdu, Bengali, Indonesian, Chinese, Swedish'),
    (Icons.share_rounded, 'شارك الآيات', 'SHARE THE VERSES',
     'شارك الآيات الجميلة مع أصدقائك على واتساب، تلغرام، تويتر',
     'Share beautiful verses with friends on WhatsApp, Telegram, Twitter'),
  ];

  Future<void> _finish() async {
    await StorageService.setOnboarded();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  void _next() {
    if (_page < _pages.length - 1) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.night : AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(
                  'تخطي / Skip',
                  style: AppText.poppins(color: AppColors.emerald),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: const BoxDecoration(
                            gradient: AppGradients.heroEmerald,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(p.$1, size: 64, color: AppColors.goldSoft),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          p.$2,
                          style: AppText.amiri(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.goldSoft
                                : AppColors.emerald,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.$3,
                          style: AppText.poppins(
                            fontSize: 12,
                            letterSpacing: 3,
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          p.$4,
                          textAlign: TextAlign.center,
                          style: AppText.poppins(
                            fontSize: 15,
                            height: 1.7,
                            color: isDark
                                ? AppColors.textLight
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          p.$5,
                          textAlign: TextAlign.center,
                          style: AppText.poppins(
                            fontSize: 13,
                            height: 1.6,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _page == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _page == i
                        ? AppColors.emerald
                        : AppColors.emerald.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _next,
                  child: Text(
                    _page == _pages.length - 1
                        ? 'ابدأ / START'
                        : 'التالي / NEXT',
                    style: AppText.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
