import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';

class MushafView extends StatelessWidget {
  final dynamic surah;
  final bool isDark;
  const MushafView({super.key, required this.surah, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A1810) : const Color(0xFFFDFBF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            style: AppText.amiri(
              fontSize: 26,
              height: 2.4,
              color: isDark ? AppColors.textLight : AppColors.textPrimary,
            ),
            children: _buildSpans(),
          ),
        ),
      ),
    );
  }

  List<InlineSpan> _buildSpans() {
    final spans = <InlineSpan>[];
    for (int i = 0; i < surah.ayahs.length; i++) {
      final a = surah.ayahs[i];
      spans.add(TextSpan(text: '${a.text} '));
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: _AyahMarker(number: a.number, isDark: isDark),
        ),
      );
      spans.add(const TextSpan(text: ' '));
    }
    return spans;
  }
}

class _AyahMarker extends StatelessWidget {
  final int number;
  final bool isDark;
  const _AyahMarker({required this.number, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.gold.withValues(alpha: 0.25),
              AppColors.gold.withValues(alpha: 0.1),
            ],
          ),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            _toArabicDigits(number),
            style: AppText.poppins(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.goldBright : AppColors.emerald,
            ),
          ),
        ),
      ),
    );
  }

  String _toArabicDigits(int n) {
    const map = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return n.toString().split('').map((d) => map[int.parse(d)]).join();
  }
}
