import 'package:flutter/material.dart';
import '../../core/services/prayer_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});
  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  static const double _lat = 21.4225;
  static const double _lng = 39.8262;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final qibla = PrayerService.qiblaDirection(_lat, _lng);
    final times = PrayerService.calculate(lat: _lat, lng: _lng);

    return Scaffold(
      backgroundColor: isDark ? AppColors.night : AppColors.cream,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.night : AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: isDark ? AppColors.goldSoft : AppColors.emerald),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'القبلة وأوقات الصلاة',
          style: AppText.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textLight : AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            _qiblaCard(isDark, qibla),
            const SizedBox(height: 24),
            Text(
              'أوقات الصلاة',
              style: AppText.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textLight : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _tile('الفجر', times.fajr, Icons.nightlight_round, isDark),
            _tile('الشروق', times.sunrise, Icons.wb_sunny_outlined, isDark),
            _tile('الظهر', times.dhuhr, Icons.wb_sunny, isDark),
            _tile('العصر', times.asr, Icons.wb_twilight, isDark),
            _tile('المغرب', times.maghrib, Icons.nights_stay, isDark),
            _tile('العشاء', times.isha, Icons.bedtime, isDark),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.nightCard : AppColors.creamCard,
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 18,
                      color: isDark ? AppColors.goldSoft : AppColors.emerald),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'الموقع الحالي: مكة المكرمة (افتراضي).',
                      style: AppText.poppins(
                        fontSize: 12,
                        height: 1.6,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qiblaCard(bool isDark, double angle) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: AppGradients.heroEmerald,
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
        children: [
          Text(
            'اتجاه القبلة',
            style: AppText.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.goldSoft,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  child: Text('N',
                      style: AppText.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldBright)),
                ),
                Positioned(
                  bottom: 6,
                  child: Text('S',
                      style: AppText.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldBright)),
                ),
                Positioned(
                  right: 6,
                  child: Text('E',
                      style: AppText.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldBright)),
                ),
                Positioned(
                  left: 6,
                  child: Text('W',
                      style: AppText.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldBright)),
                ),
                Transform.rotate(
                  angle: angle * 3.14159265 / 180,
                  child: const Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Icon(Icons.navigation_rounded,
                          color: AppColors.goldBright, size: 36),
                    ),
                  ),
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.goldShine,
                  ),
                  child: const Icon(Icons.mosque_rounded,
                      size: 18, color: AppColors.emerald),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${angle.toStringAsFixed(1)}°',
            style: AppText.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.goldBright,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'من الشمال',
            style: AppText.poppins(fontSize: 12, color: AppColors.goldSoft),
          ),
        ],
      ),
    );
  }

  Widget _tile(
      String name, DateTime time, IconData icon, bool isDark) {
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.nightCard : AppColors.creamCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.emerald.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.emerald, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: AppText.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textLight : AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            '$hh:$mm',
            style: AppText.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.gold,
            ),
          ),
        ],
      ),
    );
  }
}
