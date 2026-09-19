import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

enum XpDomain { gym, challenge }

class XpProgress {
  final int xp;
  final int level;
  final String rank;
  final int currentLevelMinXp;
  final int nextLevelXp;

  const XpProgress({
    required this.xp,
    required this.level,
    required this.rank,
    required this.currentLevelMinXp,
    required this.nextLevelXp,
  });

  bool get isMaxLevel => level >= 10;

  int get xpIntoLevel => max(0, xp - currentLevelMinXp);

  int get xpToNextLevel => isMaxLevel ? 0 : max(0, nextLevelXp - xp);

  double get levelProgress {
    if (isMaxLevel) return 1.0;
    final span = max(1, nextLevelXp - currentLevelMinXp);
    return ((xp - currentLevelMinXp) / span).clamp(0.0, 1.0);
  }
}

class XpAwardResult {
  final XpDomain domain;
  final int awardedXp;
  final int beforeXp;
  final int afterXp;
  final int beforeLevel;
  final int afterLevel;
  final String beforeRank;
  final String afterRank;

  const XpAwardResult({
    required this.domain,
    required this.awardedXp,
    required this.beforeXp,
    required this.afterXp,
    required this.beforeLevel,
    required this.afterLevel,
    required this.beforeRank,
    required this.afterRank,
  });

  bool get leveledUp => afterLevel > beforeLevel;
}

/// Persistent XP + level system with separate tracks for Gym and Challenge.
///
/// Rules:
/// - 10 levels max
/// - Level 1 unlocks at 100 XP
/// - Level 10 unlocks at 100000 XP
class XpService {
  static final XpService _instance = XpService._internal();
  factory XpService() => _instance;
  XpService._internal();

  static const List<int> _levelThresholds = [
    100,
    600,
    1500,
    3500,
    8000,
    16000,
    30000,
    50000,
    75000,
    100000,
  ];

  static const List<String> _rankByLevel = [
    'UNRANKED',
    'F RANK',
    'E RANK',
    'D RANK',
    'C RANK',
    'B RANK',
    'A RANK',
    'S RANK',
    'SS RANK',
    'SSS RANK',
    'X RANK',
  ];

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<XpProgress> getProgress(XpDomain domain) async {
    await init();
    return _buildProgress(_getXpSync(domain));
  }

  int getXpSync(XpDomain domain) => _getXpSync(domain);

  XpProgress getProgressSync(XpDomain domain) {
    return _buildProgress(_getXpSync(domain));
  }

  Future<XpAwardResult> awardGymSession({
    required int targetValue,
    required int completedValue,
    required bool isTimeBased,
    required int caloriesBurned,
  }) async {
    final base = isTimeBased ? 70 : 55;
    final effort = isTimeBased ? (targetValue ~/ 6) : (targetValue * 3);
    final completionBonus = completedValue >= targetValue ? 40 : 20;
    final calorieBonus = max(0, caloriesBurned ~/ 25);
    final points = (base + effort + completionBonus + calorieBonus).clamp(45, 900);

    return _award(XpDomain.gym, points);
  }

  Future<XpAwardResult> awardGymWorkout({
    required int exerciseCount,
    required int totalDurationSeconds,
    required int caloriesBurned,
  }) async {
    final minutes = max(1, (totalDurationSeconds / 60).ceil());
    final points = (40 + exerciseCount * 11 + minutes * 9 + (caloriesBurned ~/ 20)).clamp(60, 3500);
    return _award(XpDomain.gym, points);
  }

  Future<XpAwardResult> awardChallengeExercise({
    required int targetValue,
    required bool isTimeBased,
  }) async {
    final base = isTimeBased ? 95 : 80;
    final effort = isTimeBased ? (targetValue ~/ 4) : (targetValue * 4);
    final points = (base + effort).clamp(90, 1200);

    return _award(XpDomain.challenge, points);
  }

  Future<XpAwardResult> awardChallengeMilestone({
    required int challengeSize,
  }) async {
    final points = (350 + challengeSize * 42).clamp(600, 6000);
    return _award(XpDomain.challenge, points);
  }

  Future<XpAwardResult> _award(XpDomain domain, int points) async {
    await init();

    final beforeXp = _getXpSync(domain);
    final beforeLevel = _levelForXp(beforeXp);
    final beforeRank = _rankForLevel(beforeLevel);

    final afterXp = beforeXp + points;
    await _setXp(domain, afterXp);

    final afterLevel = _levelForXp(afterXp);
    final afterRank = _rankForLevel(afterLevel);

    return XpAwardResult(
      domain: domain,
      awardedXp: points,
      beforeXp: beforeXp,
      afterXp: afterXp,
      beforeLevel: beforeLevel,
      afterLevel: afterLevel,
      beforeRank: beforeRank,
      afterRank: afterRank,
    );
  }

  int _getXpSync(XpDomain domain) {
    final key = _xpKey(domain);
    return _prefs?.getInt(key) ?? 0;
  }

  Future<void> _setXp(XpDomain domain, int value) async {
    final key = _xpKey(domain);
    await _prefs!.setInt(key, value);
  }

  String _xpKey(XpDomain domain) {
    switch (domain) {
      case XpDomain.gym:
        return 'xp_gym_total';
      case XpDomain.challenge:
        return 'xp_challenge_total';
    }
  }

  XpProgress _buildProgress(int xp) {
    final level = _levelForXp(xp);
    final minXp = level <= 0 ? 0 : _levelThresholds[level - 1];
    final nextXp = level >= 10 ? _levelThresholds.last : _levelThresholds[level];

    return XpProgress(
      xp: xp,
      level: level,
      rank: _rankForLevel(level),
      currentLevelMinXp: minXp,
      nextLevelXp: nextXp,
    );
  }

  int _levelForXp(int xp) {
    var level = 0;
    for (var i = 0; i < _levelThresholds.length; i++) {
      if (xp >= _levelThresholds[i]) {
        level = i + 1;
      } else {
        break;
      }
    }
    return level.clamp(0, 10);
  }

  String _rankForLevel(int level) {
    final safe = level.clamp(0, 10);
    return _rankByLevel[safe];
  }
}
