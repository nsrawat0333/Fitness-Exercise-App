import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Background music service for workouts.
/// Plays looping background music during exercises and relaxation phases.
class MusicService {
  static final MusicService _instance = MusicService._internal();
  factory MusicService() => _instance;
  MusicService._internal();

  final AudioPlayer _player = AudioPlayer();
  final ValueNotifier<bool> isPlayingNotifier = ValueNotifier(false);
  final ValueNotifier<bool> enabledNotifier = ValueNotifier(true);

  static const String _workoutTrack = 'images/music/workout_bgm.mp3';

  bool _initialized = false;
  double _currentVolume = 0.25; // Track the active phase volume

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      _player.onPlayerStateChanged.listen((state) {
        isPlayingNotifier.value = state == PlayerState.playing;
      });

      // Loop the music
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(_currentVolume);
    } catch (e) {
      debugPrint('MusicService Init Error: $e');
    }
  }

  /// Start playing workout music.
  Future<void> play() async {
    if (!enabledNotifier.value) return;
    if (!_initialized) await init();

    try {
      if (_player.state == PlayerState.playing) {
        await _player.setVolume(_currentVolume);
        return;
      }

      await _player.setVolume(_currentVolume);
      await _player.play(AssetSource(_workoutTrack));
    } catch (e) {
      debugPrint('MusicService Play Error: $e');
      isPlayingNotifier.value = false;
    }
  }

  /// Pause music (e.g. during voice coaching or recovery).
  Future<void> pause() async {
    await _player.pause();
  }

  /// Resume paused music.
  Future<void> resume() async {
    if (!enabledNotifier.value) return;
    await _player.resume();
  }

  /// Stop music completely.
  Future<void> stop() async {
    await _player.stop();
  }

  /// Set volume (0.0 to 1.0). Also saves as the "active" level.
  Future<void> setVolume(double volume) async {
    _currentVolume = volume.clamp(0.0, 1.0);
    await _player.setVolume(_currentVolume);
  }

  /// Duck volume during voice coaching (very low so voice is clear).
  Future<void> duckForVoice() async {
    await _player.setVolume(0.08);
  }

  /// Restore to the last phase-set volume after voice finishes.
  Future<void> restoreVolume() async {
    await _player.setVolume(_currentVolume);
  }

  /// Toggle music on/off.
  void setEnabled(bool enabled) {
    enabledNotifier.value = enabled;
    if (!enabled) {
      stop();
    }
  }

  void dispose() {
    _player.dispose();
  }
}
