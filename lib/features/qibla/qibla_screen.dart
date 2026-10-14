import 'package:flutter/material.dart';
import '../../core/services/location_service.dart';
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
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _detect();
  }

  Future<void> _detect() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    final ok = await LocationService.detect();
    if (mounted) {
      setState(() {
        _loading = false;
        _failed = !ok;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lat = LocationService.lat ?? 21.4225;
    final lng = LocationService.lng ?? 39.8262;
    final qibla = PrayerService.qiblaDirection(lat, lng);

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
          'Qibla Direction',
          style: AppText.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textLight : AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded,
                color: isDark ? AppColors.goldSoft : AppColors.emerald),
            onPressed: _detect,
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.emerald))
          : SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _locationBar(isDark),
                      const SizedBox(height: 40),
                      _qiblaCard(isDark, qibla),
                      if (_failed) ...[
                        const SizedBox(height: 24),
                        _errorBox(isDark),
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _locationBar(bool isDark) {
    final city = LocationService.city ?? 'Makkah';
    final country = LocationService.country ?? 'Saudi Arabia';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.emerald.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.emerald.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on_rounded,
              color: AppColors.emerald, size: 20),
          const SizedBox(width: 10),
          Text(
            '$city, $country',
            style: AppText.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textLight : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorBox(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.red, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Could not detect location. Turn on internet and tap refresh.',
              style: AppText.poppins(
                fontSize: 12,
                height: 1.5,
                color: isDark ? AppColors.textLight : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qiblaCard(bool isDark, double angle) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: AppGradients.heroEmerald,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.emerald.withValues(alpha: 0.35),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'QIBLA DIRECTION',
            style: AppText.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.goldSoft,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 260,
            height: 260,
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
                  top: 8,
                  child: Text('N',
                      style: AppText.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldBright)),
                ),
                Positioned(
                  bottom: 8,
                  child: Text('S',
                      style: AppText.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldBright)),
                ),
                Positioned(
                  right: 8,
                  child: Text('E',
                      style: AppText.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldBright)),
                ),
                Positioned(
                  left: 8,
                  child: Text('W',
                      style: AppText.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldBright)),
                ),
                Transform.rotate(
                  angle: angle * 3.14159265 / 180,
                  child: const Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Icon(Icons.navigation_rounded,
                          color: AppColors.goldBright, size: 50),
                    ),
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.goldShine,
                  ),
                  child: const Icon(Icons.mosque_rounded,
                      size: 26, color: AppColors.emerald),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            '${angle.toStringAsFixed(1)}°',
            style: AppText.poppins(
              fontSize: 44,
              fontWeight: FontWeight.bold,
              color: AppColors.goldBright,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'from North',
            style: AppText.poppins(fontSize: 14, color: AppColors.goldSoft),
          ),
        ],
      ),
    );
  }
}
