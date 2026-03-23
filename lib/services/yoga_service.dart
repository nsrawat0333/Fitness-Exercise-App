// Yoga service for generating programs, sessions, and custom plans.

import '../data/yoga_poses_data.dart';
import '../models/yoga_models.dart';

class YogaService {
  /// Generate the full 30-day progressive yoga program.
  static List<YogaDay> generate30DayProgram() {
    final warmup = YogaPosesData.getPosesByCategory('warmup');
    final strength = YogaPosesData.getPosesByCategory('strength');
    final flexibility = YogaPosesData.getPosesByCategory('flexibility');
    final relaxation = YogaPosesData.getPosesByCategory('relaxation');

    final days = <YogaDay>[];

    for (int d = 1; d <= 30; d++) {
      // Rest days on day 7, 14, 21
      if (d == 7 || d == 14 || d == 21) {
        days.add(YogaDay(
          dayNumber: d,
          title: 'Rest & Recovery',
          duration: '0 min',
          focus: 'Rest',
          phase: _getPhase(d),
          isRestDay: true,
        ));
        continue;
      }

      List<YogaPose> poses;
      String title;
      String focus;
      int totalMin;

      if (d <= 7) {
        // Phase 1: Beginner — warmup + relaxation
        final dayPoses = <YogaPose>[];
        dayPoses.addAll(_pickPoses(warmup, 3, d));
        dayPoses.addAll(_pickPoses(relaxation, 2, d));
        poses = dayPoses;
        title = _beginnerTitles[(d - 1) % _beginnerTitles.length];
        focus = 'Relax + Flexibility';
        totalMin = 15;
      } else if (d <= 14) {
        // Phase 2: Foundation — warmup + strength + relaxation
        final dayPoses = <YogaPose>[];
        dayPoses.addAll(_pickPoses(warmup, 2, d));
        dayPoses.addAll(_pickPoses(strength, 2, d));
        dayPoses.addAll(_pickPoses(relaxation, 1, d));
        poses = dayPoses;
        title = _foundationTitles[(d - 8) % _foundationTitles.length];
        focus = 'Balance + Strength';
        totalMin = 20;
      } else if (d <= 21) {
        // Phase 3: Intermediate — strength + flexibility + warmup
        final dayPoses = <YogaPose>[];
        dayPoses.addAll(_pickPoses(warmup, 1, d));
        dayPoses.addAll(_pickPoses(strength, 3, d));
        dayPoses.addAll(_pickPoses(flexibility, 2, d));
        poses = dayPoses;
        title = _intermediateTitles[(d - 15) % _intermediateTitles.length];
        focus = 'Core + Flexibility';
        totalMin = 25;
      } else {
        // Phase 4: Advanced — all categories, longer holds
        final dayPoses = <YogaPose>[];
        dayPoses.addAll(_pickPoses(warmup, 1, d));
        dayPoses.addAll(_pickPoses(strength, 3, d));
        dayPoses.addAll(_pickPoses(flexibility, 2, d));
        dayPoses.addAll(_pickPoses(relaxation, 2, d));
        poses = dayPoses;
        title = _advancedTitles[(d - 22) % _advancedTitles.length];
        focus = 'Full Body Control';
        totalMin = 30;
      }

      days.add(YogaDay(
        dayNumber: d,
        title: title,
        duration: '$totalMin min',
        focus: focus,
        phase: _getPhase(d),
        poses: poses,
      ));
    }

    return days;
  }

  /// Get sessions for a specific focus area.
  static List<YogaSession> getSessionsForFocus(String focus) {
    final poses = YogaPosesData.getPosesForFocus(focus);
    if (poses.isEmpty) return [];

    final focusKey = focus.toLowerCase().replaceAll(' ', '_');
    final sessions = <YogaSession>[];

    // Create 3 sessions of different difficulty
    final levels = [
      ('Easy Flow', 'Beginner', 3),
      ('Power Session', 'Intermediate', 4),
      ('Intense Practice', 'Advanced', 5),
    ];

    for (int i = 0; i < levels.length; i++) {
      final (title, difficulty, count) = levels[i];
      final sessionPoses = <YogaPose>[];
      for (int j = 0; j < count && j < poses.length; j++) {
        sessionPoses.add(poses[(i + j) % poses.length]);
      }

      final totalMin = sessionPoses.fold(0, (sum, p) => sum + p.durationSeconds) ~/ 60;

      sessions.add(YogaSession(
        title: '$title — ${_focusLabel(focusKey)}',
        duration: '$totalMin min',
        focusArea: focusKey,
        difficulty: difficulty,
        poses: sessionPoses,
      ));
    }

    return sessions;
  }

  /// Generate a custom plan based on user preferences.
  static YogaSession generateCustomPlan({
    required String level,
    required String goal,
    required int durationMinutes,
  }) {
    // Map goal to focus areas
    List<String> focusKeys;
    switch (goal) {
      case 'Weight Loss':
        focusKeys = ['weight_loss', 'abs_core'];
        break;
      case 'Relax':
        focusKeys = ['stress_relief'];
        break;
      case 'Flexibility':
        focusKeys = ['flexibility'];
        break;
      default:
        focusKeys = ['full_body'];
    }

    // Collect matching poses
    final pool = <YogaPose>[];
    for (final key in focusKeys) {
      pool.addAll(YogaPosesData.getPosesForFocus(key));
    }
    // Remove duplicates by name
    final seen = <String>{};
    pool.removeWhere((p) => !seen.add(p.name));

    if (pool.isEmpty) {
      pool.addAll(YogaPosesData.allPoses);
    }

    // Select poses based on level and duration
    int poseCount;
    switch (level) {
      case 'Advanced':
        poseCount = (durationMinutes / 3).ceil(); // ~3 min each
        break;
      case 'Intermediate':
        poseCount = (durationMinutes / 3.5).ceil();
        break;
      default: // Beginner
        poseCount = (durationMinutes / 4).ceil(); // ~4 min each (longer holds, fewer poses)
    }
    poseCount = poseCount.clamp(3, pool.length);

    // Priority: warm-up first, then goal-specific, then relaxation at end
    final selected = <YogaPose>[];

    // Always start with a warm-up
    final warmups = pool.where((p) => p.category == 'warmup').toList();
    if (warmups.isNotEmpty) {
      selected.add(warmups.first);
      pool.remove(warmups.first);
    }

    // Fill with goal-specific poses
    for (int i = 0; i < poseCount - 2 && i < pool.length; i++) {
      selected.add(pool[i]);
    }

    // End with a relaxation pose
    final relaxPoses = YogaPosesData.getPosesByCategory('relaxation');
    if (relaxPoses.isNotEmpty) {
      selected.add(relaxPoses.first);
    }

    return YogaSession(
      title: '$goal Yoga — $level',
      duration: '$durationMinutes min',
      focusArea: goal.toLowerCase().replaceAll(' ', '_'),
      difficulty: level,
      poses: selected,
    );
  }

  // ── Helpers ──

  static String _getPhase(int day) {
    if (day <= 7) return 'Beginner';
    if (day <= 14) return 'Foundation';
    if (day <= 21) return 'Intermediate';
    return 'Advanced';
  }

  static List<YogaPose> _pickPoses(List<YogaPose> pool, int count, int seed) {
    if (pool.isEmpty) return [];
    final result = <YogaPose>[];
    for (int i = 0; i < count; i++) {
      result.add(pool[(seed + i) % pool.length]);
    }
    return result;
  }

  static String _focusLabel(String key) {
    switch (key) {
      case 'weight_loss': return 'Weight Loss';
      case 'flexibility': return 'Flexibility';
      case 'stress_relief': return 'Stress Relief';
      case 'back_pain': return 'Back Pain';
      case 'abs_core': return 'Abs & Core';
      case 'full_body': return 'Full Body';
      default: return key;
    }
  }

  static const _beginnerTitles = [
    'Beginner Relax Flow',
    'Gentle Morning Stretch',
    'Calm & Center',
    'Easy Breathing Session',
    'Basic Body Awareness',
    'Soft Opening Flow',
  ];

  static const _foundationTitles = [
    'Foundation Balance',
    'Strength Basics',
    'Core Activation',
    'Standing Strong',
    'Energy Builder',
    'Grounding Practice',
  ];

  static const _intermediateTitles = [
    'Core & Flexibility',
    'Deep Stretch Power',
    'Balance Challenge',
    'Flow & Strength',
    'Twist & Tone',
    'Dynamic Practice',
  ];

  static const _advancedTitles = [
    'Advanced Power Flow',
    'Full Body Control',
    'Peak Performance',
    'Warrior Mastery',
    'Total Integration',
    'Ultimate Flow',
    'Final Challenge',
    'Champion Practice',
    'Mind-Body Fusion',
  ];
}
