import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_text.dart';

class AudioBar extends StatelessWidget {
  final String surahName;
  const AudioBar({super.key, required this.surahName});

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioService>();
    if (audio.currentSurah == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: AppGradients.heroEmerald,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.emerald.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGradients.goldShine,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 22,
              icon: Icon(
                audio.isLoading
                    ? Icons.hourglass_top_rounded
                    : (audio.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded),
                color: AppColors.emerald,
              ),
              onPressed: () {
                if (audio.isPlaying) {
                  audio.pause();
                } else {
                  audio.resume();
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$surahName • آية ${audio.currentAyah}',
                  style: AppText.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  audio.reciter.arabicName,
                  style: AppText.poppins(
                    fontSize: 11,
                    color: AppColors.goldSoft,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next_rounded, color: Colors.white),
            onPressed: audio.playNext,
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
            onPressed: audio.stop,
          ),
        ],
      ),
    );
  }
}
