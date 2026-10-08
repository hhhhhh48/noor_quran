import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/reciter.dart';

class AudioService extends ChangeNotifier {
  static final AudioService instance = AudioService._();
  AudioService._();

  final AudioPlayer player = AudioPlayer();
  Reciter _reciter = kReciters[0];
  int? _currentSurah;
  int? _currentAyah;
  bool _isLoading = false;

  Reciter get reciter => _reciter;
  int? get currentSurah => _currentSurah;
  int? get currentAyah => _currentAyah;
  bool get isLoading => _isLoading;
  bool get isPlaying => player.playing;
  Stream<Duration> get positionStream => player.positionStream;
  Stream<Duration?> get durationStream => player.durationStream;

  void setReciter(Reciter r) {
    _reciter = r;
    notifyListeners();
  }

  String url(int surah, int ayah) {
    final s = surah.toString().padLeft(3, '0');
    final a = ayah.toString().padLeft(3, '0');
    return 'https://everyayah.com/data/${_reciter.folder}/$s$a.mp3';
  }

  Future<void> playAyah(int surah, int ayah) async {
    _currentSurah = surah;
    _currentAyah = ayah;
    _isLoading = true;
    notifyListeners();
    try {
      await player.setUrl(url(surah, ayah));
      _isLoading = false;
      notifyListeners();
      player.play();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> playNext() async {
    if (_currentAyah == null || _currentSurah == null) return;
    await playAyah(_currentSurah!, _currentAyah! + 1);
  }

  void pause() {
    player.pause();
    notifyListeners();
  }

  void resume() {
    player.play();
    notifyListeners();
  }

  void stop() {
    player.stop();
    _currentSurah = null;
    _currentAyah = null;
    notifyListeners();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
