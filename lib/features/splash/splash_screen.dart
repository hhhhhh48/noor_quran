import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text.dart';
import '../home/home_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../../core/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _verseCtrl;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoGlow;
  late final Animation<double> _textFade;
  late final Animation<double> _verseFade;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _verseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutBack),
    );
    _logoGlow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut),
    );
    _verseFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _verseCtrl, curve: Curves.easeIn),
    );

    _run();
  }

  Future<void> _run() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 700));
    _verseCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => FutureBuilder<bool>(future: StorageService.isOnboarded(), builder: (c, snap) { if (snap.data == false) return const OnboardingScreen(); return const HomeScreen(); }),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _verseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.splash),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              AnimatedBuilder(
                animation: _logoCtrl,
                builder: (_, __) {
                  return Transform.scale(
                    scale: _logoScale.value,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.gold
                              .withValues(alpha: 0.6 + _logoGlow.value * 0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold
                                .withValues(alpha: 0.15 * _logoGlow.value),
                            blurRadius: 60,
                            spreadRadius: 10 * _logoGlow.value,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: AppColors.gold,
                        size: 70,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              FadeTransition(
                opacity: _textFade,
                child: Column(
                  children: [
                    Text(
                      'القرآن الكريم',
                      style: AppText.amiri(
                        fontSize: 46,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldSoft,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'THE HOLY QURAN',
                      style: AppText.poppins(
                        fontSize: 13,
                        letterSpacing: 8,
                        color: AppColors.gold.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              FadeTransition(
                opacity: _verseFade,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 1,
                        color: AppColors.gold.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '﴿ إِنَّا نَحْنُ نَزَّلْنَا الذِّكْرَ وَإِنَّا لَهُ لَحَافِظُونَ ﴾',
                        textAlign: TextAlign.center,
                        style: AppText.amiri(
                          fontSize: 20,
                          height: 2,
                          color: AppColors.goldSoft.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'الحجر • ٩',
                        style: AppText.poppins(
                          fontSize: 12,
                          color: AppColors.gold.withValues(alpha: 0.7),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
