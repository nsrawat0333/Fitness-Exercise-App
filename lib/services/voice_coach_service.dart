import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'music_service.dart';

/// Centralized Hindi voice coaching service.
/// Queue-based to prevent overlapping speech. Global mute toggle.
/// Automatically ducks music volume when speaking.
class VoiceCoachService {
  static final VoiceCoachService _instance = VoiceCoachService._internal();
  factory VoiceCoachService() => _instance;
  VoiceCoachService._internal();

  final FlutterTts _tts = FlutterTts();
  final ValueNotifier<bool> enabledNotifier = ValueNotifier(true);
  final Queue<String> _queue = Queue();
  bool _isSpeaking = false;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      await _tts.setLanguage('hi-IN');

      // Attempt to find and set a male Hindi voice
      try {
        final voices = await _tts.getVoices;
        if (voices != null) {
          for (var voice in voices) {
            String name = voice["name"]?.toString().toLowerCase() ?? "";
            String locale = voice["locale"]?.toString().toLowerCase() ?? "";

            if (locale.contains("hi-in") || locale.contains("hi_in")) {
              if (name.contains("male") || name.contains("rishi") || name.contains("-hic") || name.contains("-hid") || name.contains("-hie")) {
                await _tts.setVoice({"name": voice["name"], "locale": voice["locale"]});
                break;
              }
            }
          }
        }
      } catch (e) {
        debugPrint("Error setting male voice: $e");
      }

      await _tts.setSpeechRate(0.45);
      await _tts.setVolume(1.0);
      await _tts.setPitch(0.9);

      await _tts.awaitSpeakCompletion(true);
    } catch (e) {
      debugPrint('VoiceCoachService Init Error: $e');
    }
  }

  /// Speak a single Hindi sentence. Queued to avoid overlap.
  Future<void> speak(String text) async {
    if (!enabledNotifier.value) return;
    if (!_initialized) await init();

    _queue.add(text);
    _processQueue();
  }

  /// Speak a sequence of Hindi sentences one after another.
  Future<void> speakSequence(List<String> texts) async {
    if (!enabledNotifier.value) return;
    if (!_initialized) await init();

    for (final t in texts) {
      _queue.add(t);
    }
    _processQueue();
  }

  /// Speak with dynamic variable substitution.
  Future<void> speakDynamic(String template, Map<String, String> vars) async {
    String text = template;
    vars.forEach((key, value) {
      text = text.replaceAll('\$$key', value);
    });
    await speak(text);
  }

  bool _isProcessingQueue = false;

  Future<void> _processQueue() async {
    if (_isProcessingQueue || !enabledNotifier.value) return;
    _isProcessingQueue = true;

    while (_queue.isNotEmpty && enabledNotifier.value) {
      final text = _queue.removeFirst();
      _isSpeaking = true;
      try {
        await MusicService().duckForVoice();
        await _tts.speak(text);
      } catch (e) {
        debugPrint('TTS speak error: $e');
      }
      _isSpeaking = false;
    }

    if (_queue.isEmpty) {
      await MusicService().restoreVolume();
    }
    _isProcessingQueue = false;
  }

  /// Stop all speech and clear the queue.
  Future<void> stop() async {
    _queue.clear();
    _isSpeaking = false;
    await _tts.stop();
    MusicService().restoreVolume();
  }

  /// Toggle voice coaching on/off.
  void setEnabled(bool enabled) {
    enabledNotifier.value = enabled;
    if (!enabled) {
      stop();
    }
  }

  void dispose() {
    stop();
    _tts.stop();
  }
}
