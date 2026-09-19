import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ExerciseAssets {
  static const String _basePath = 'assets/all_exercises/';

  // Full list of 255 available assets with EXACT filesystem casing
  static const List<String> _assets = [
    "Abdominal_crunches.lottie",
    "Agility_Ladder_Drill.lottie",
    "Barbell_Calf_Raise.lottie",
    "Barbell_Hip_Thrust.lottie",
    "Bench_Leg_Raise.lottie",
    "Bulgarian_Split_Squat_Jump_(Right).lottie",
    "Clasped_Hands_Behind_the_Back_Stretch.jpg",
    "Cobras.lottie",
    "Decline_Side_Plank.lottie",
    "Deep_Squat_Hold.jpg",
    "Dumbbell_Preacher_Curl.lottie",
    "Dumbbell_Rear_Delt_Fly.lottie",
    "Dumbbell_Romanian_Deadlift.lottie",
    "Dumbbell_Squat.lottie",
    "Elbow_To_Knee_Crunch_(Right).lottie",
    "Flutter_Kicks.lottie",
    "Hanging_Knee_Raise.lottie",
    "High_Stepping.lottie",
    "Jumping_squats.lottie",
    "Kneeling_Back_Extension.jpg",
    "Lunges.lottie",
    "Military_Push_Ups.lottie",
    "Military_Push___Ups.lottie",
    "Plank_Low_To_High.lottie",
    "Plank_hip_dips.lottie",
    "Punches.lottie",
    "Quadruped_Thoracic_Rotation.lottie",
    "Resistance_Band_Reverse_Crunch.lottie",
    "Scissors.lottie",
    "Seated_Dumbbell_Curl.lottie",
    "Shoulder_Stretch.lottie",
    "Shrimping_exercise.lottie",
    "Side-Lying_Dumbbell_Lateral_Raise.lottie",
    "Single-Leg_Box_Squat.lottie",
    "Single_Arm_Front_Raise.lottie",
    "Single_Leg_Hip_Rotation.lottie",
    "Squat_Reach.lottie",
    "Standing_Cross_Leg_Hamstring_Stretch.lottie",
    "Standing_Dumbbell_Curl.lottie",
    "Step_Up_On_Chair.lottie",
    "T_Plank.lottie",
    "Toe_Touch_Stretch.lottie",
    "Triceps_Dips.lottie",
    "V-Sit_Hold.lottie",
    "Wall_Angels.lottie",
    "Wall__Sit.jpg",
    "Weighted_Plank.lottie",
    "Wide_Grip_Pull-Up.lottie",
    "adductor_stretch_in_standing.lottie",
    "adductorur_streach.lottie",
    "alternative_Dumbbell_Curl.lottie",
    "arm_circle__clockwise.lottie",
    "arm_circles.lottie",
    "arm_circles_counterclockwise.lottie",
    "arm_raise.lottie",
    "arm_scissors.lottie",
    "arnold_dumbbell__press.lottie",
    "back_arches.lottie",
    "back_extention.lottie",
    "back_extention_with_dumbell.lottie",
    "backward running.lottie",
    "backward_lunge.lottie",
    "backward_lunge_with_front_kick_left.lottie",
    "backward_lunge_with_front_kick_right.lottie",
    "band_assisted_sprinter_run.lottie",
    "banded_run.lottie",
    "barbell_back_squats.lottie",
    "barbell_overhead_press.lottie",
    "battle_rope.lottie",
    "bear_crawl.jpg",
    "bench_push_up.lottie",
    "bent_over_barbell_row.lottie",
    "bent_over_dumbbell_rows_left.lottie",
    "bent_over_row.lottie",
    "bicycle_crunches.lottie",
    "bird_dog.lottie",
    "bird_dog_left.lottie",
    "box_push-ups.lottie",
    "burpees.lottie",
    "butt_bridge.lottie",
    "butt_kicks.lottie",
    "butterfly_cable_press.lottie",
    "butterfly_streach.lottie",
    "cable_press.lottie",
    "calf_raise_wih_splayed_foot.lottie",
    "calf_raise_with_pigeon-toed.lottie",
    "calf_strech_left.lottie",
    "calf_strech_right.lottie",
    "cat_cow_pose.lottie",
    "chest_dip.lottie",
    "chest_stretch.jpg",
    "chest_support_dumbell_row.lottie",
    "child_pose.lottie",
    "clapping_push_up.jpg",
    "cobra_strech.lottie",
    "cross_and_upercut.lottie",
    "cross_crunches.lottie",
    "cross_grip_dumbell_press.lottie",
    "crossover_crunches.lottie",
    "crunches.lottie",
    "crunches_with_legs_raised.jpg",
    "curtsy_lungs.lottie",
    "dead_bug.lottie",
    "decline_push_up.lottie",
    "diagonal_plank.lottie",
    "diamond_push_up.jpg",
    "diamond_push_up.lottie",
    "donkey_kicks_left.lottie",
    "donkey_kicks_right.lottie",
    "doorway__curls_right.lottie",
    "doorway_curls_left.lottie",
    "double_knees_to_chest.jpg",
    "downward_facing_dog_on_the_wall.jpg",
    "duck_walk.lottie",
    "dumbbell_front_raise.lottie",
    "dumbbell_side_lateral_raises.lottie",
    "dumbbell_side_leteral_raise.lottie",
    "dumbbell_triceps_extension.lottie",
    "dumbell_concentration-curl_left.lottie",
    "dumbell_concentration-curl_right.lottie",
    "dumbell_front_raise.lottie",
    "dumbell_kickbacks.lottie",
    "dumbell_lying_triceps_extension.lottie",
    "dumbell_punches.jpg",
    "dumbell_rear_delt_row.lottie",
    "dumbell_shrug.lottie",
    "dumbell_single_arm_upright_row.lottie",
    "dumbell_standing_calf_raise.jpg",
    "dumbell_upright_row.lottie",
    "dumbell_w_press.lottie",
    "elbow_plank_rotation_left.jpg",
    "elbow_plank_rotation_right.lottie",
    "fast_spider_lunges.lottie",
    "fire_hydrant_left.lottie",
    "fire_hydrant_right.lottie",
    "flexer_inclined_dumbell_curls.lottie",
    "floor_slides.jpg",
    "floor_tricep_dips.lottie",
    "floor_y_raises.jpg",
    "flutter_kicks_squats.lottie",
    "formward_running.lottie",
    "forward_lunge.lottie",
    "frog_crunches.lottie",
    "frog_pump.lottie",
    "glute_kick_back___left.lottie",
    "glute_kick_back_pulse_left.lottie",
    "glute_kick_back_pulse_right.lottie",
    "glute_kick_back_right.lottie",
    "half_cross_crunches.lottie",
    "heel_touch.lottie",
    "heels_to_the_heevens.lottie",
    "high_knee.lottie",
    "hindu_push_up.lottie",
    "hip_bridge_&_leg_lift_left.lottie",
    "hip_hinge.lottie",
    "hover_push-up.lottie",
    "hyperextension.lottie",
    "inchworms.lottie",
    "incline_push-up.lottie",
    "jumping___jacks.lottie",
    "jumping_jacks.lottie",
    "jumping_push_up.lottie",
    "knee_plank._personaje_de_entrenamiento",
    "knee_push_ups.lottie",
    "knee_to_chest_stretch__right.lottie",
    "knee_to_elbow_crunches.lottie",
    "kneeling_jump_squats.lottie",
    "kneeling_lunge_strech_left.lottie",
    "kneeling_lunge_strech_right.lottie",
    "knees_to_chest_stretch_left.lottie",
    "landmine_row.lottie",
    "lateral_flash.png",
    "left_leg_lateral_raise.lottie",
    "left_quad_stretch_with_wall.jpg",
    "leg_barbell_curl_left.lottie",
    "leg_barbell_curl_right.lottie",
    "leg_in_out.lottie",
    "leg_raises.lottie",
    "long_Abs_crunches.lottie",
    "lunges_twist.lottie",
    "lying_butterfly_stretch.lottie",
    "military_press.lottie",
    "modified_push_up_low_hold.jpg",
    "mountain_climber.lottie",
    "ninty_by_ninty_Crunche.lottie",
    "oblique_crossover_crunch_left.lottie",
    "oblique_crossover_crunch_right.lottie",
    "offset_push-ups.lottie",
    "one_arm_dumbbell_row.lottie",
    "pigeon__pose.jpg",
    "pike_push_ups.lottie",
    "piriformis_streatch.lottie",
    "pistol_box_squat_left.lottie",
    "pistol_box_squat_right.lottie",
    "plank_leg_up.jpg",
    "plank_up_&_down.lottie",
    "plie_squats.lottie",
    "prone_flutter_kicks.lottie",
    "prone_triceps_push_ups.jpg",
    "pull_up.lottie",
    "push_up_&_rotation.jpg",
    "push_up_&_shoulder_tap.jpg",
    "push_up_hold.jpg",
    "reclined_oblique_twist.lottie",
    "reclined_rhomboid_squeezes.jpg",
    "resistance_band_shoulder_exercises.lottie",
    "reverse_crunches.lottie",
    "reverse_flutter_kick.lottie",
    "reverse_grip_pull_up.lottie",
    "rhomboid_pulls.jpg",
    "right_leg_lateral_raise.lottie",
    "rolar_quads.lottie",
    "russian_twist.lottie",
    "shadow_boxing.lottie",
    "shoulder_gators.lottie",
    "side lunges.lottie",
    "side_hop.lottie",
    "side_leg_lifts.lottie",
    "side_lunges_streach.lottie",
    "side_lying_leg_lift_left.lottie",
    "side_lying_leg_lift_right.lottie",
    "side_plank.lottie",
    "side_plank_left.jpg",
    "side_plank_right.jpg",
    "side_shuttle.lottie",
    "side_skater_jump.lottie",
    "side_split_streatch.jpg",
    "single_arm_dumbell_overhead_press.lottie",
    "single_leg_box_jump.lottie",
    "sit_ups.lottie",
    "skater_jump.lottie",
    "skiping_without_roop.lottie",
    "spiderman_push_ups.lottie",
    "split_squat_left.lottie",
    "split_squat_right.lottie",
    "sprawl_exercise.lottie",
    "squa ts.lottie",
    "squat_mobility_complex.lottie",
    "squats.lottie",
    "squats_pulses.lottie",
    "staggered_push_up.lottie",
    "stair_climber.lottie",
    "starfish_crunch.lottie",
    "straight_and_side_punch.lottie",
    "straight_arm_plank.jpg",
    "straight_punch.lottie",
    "sumo_squats_and_leg_raises.lottie",
    "superman.lottie",
    "suspine_spinal_twist.jpg",
    "through_a_punch.jpg",
    "tricep_dips.lottie",
    "wall_push_up.lottie",
  ];

  static List<String> get allAssets => _assets;

  static bool _isAnimatedAsset(String asset) {
    final lower = asset.toLowerCase();
    return lower.endsWith('.lottie') || lower.endsWith('.json');
  }

  static bool _isSupportedMediaAsset(String asset) {
    final lower = asset.toLowerCase();
    return lower.endsWith('.lottie') ||
        lower.endsWith('.json') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp');
  }

  /// Normalize a string for fuzzy matching:
  /// lowercase, remove hyphens/underscores, strip trailing 's' from words
  static String _normalize(String s) {
    return s
        .toLowerCase()
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .map((w) {
          // Strip trailing 's' for plural matching (e.g. "ups" → "up")
          if (w.length > 2 && w.endsWith('s') && !w.endsWith('ss')) {
            return w.substring(0, w.length - 1);
          }
          return w;
        })
        .join(' ')
        .trim();
  }

  // Remove runtime qualifiers so variants like "(Fast)" map to base exercises.
  static String _stripQualifiers(String s) {
    return s
        .toLowerCase()
        .replaceAll(RegExp(r'\([^)]*\)'), ' ')
        .replaceAll(RegExp(r'[+→/&|]'), ' ')
        .replaceAll(
          RegExp(r'\b(fast|slow|long|hold|explosive|final|control|burn)\b'),
          ' ',
        )
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String? getAssetForExercise(String exerciseName) {
    if (exerciseName.trim().isEmpty) return null;

    String search = exerciseName
        .toLowerCase()
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .trim();
    final simplifiedSearch = _stripQualifiers(search);
    final normalizedSearch = _normalize(search);
    final normalizedSimplifiedSearch = _normalize(
      simplifiedSearch.isEmpty ? search : simplifiedSearch,
    );

    const aliasByNormalizedName = <String, String>{
      'chin up': 'reverse_grip_pull_up.lottie',
      'clapping push up': 'Military_Push_Ups.lottie',
      'crossbody climber': 'mountain_climber.lottie',
      'crossbody climber fast': 'mountain_climber.lottie',
      'block counter': 'shadow_boxing.lottie',
      'block move strike': 'shadow_boxing.lottie',
      'crab walk': 'duck_walk.lottie',
      'cross counter': 'cross_and_upercut.lottie',
      'cross hook': 'cross_and_upercut.lottie',
      'cross hook fast': 'cross_and_upercut.lottie',
      'cross hook straight': 'straight_and_side_punch.lottie',
      'cross hook combo': 'cross_and_upercut.lottie',
      'deep breathing': 'child_pose.lottie',
      'deep squat hold': 'squats.lottie',
      'double knee to chest': 'knees_to_chest_stretch_left.lottie',
      'dodge move punch': 'shadow_boxing.lottie',
      'farmer hold': 'Weighted_Plank.lottie',
      'farmer walk': 'High_Stepping.lottie',
      'floor slide': 'floor_tricep_dips.lottie',
      'floor y raise': 'arm_raise.lottie',
      'froggy glute lift': 'frog_pump.lottie',
      'forward running': 'formward_running.lottie',
      'glute bridge': 'butt_bridge.lottie',
      'glute bridge hold': 'butt_bridge.lottie',
      'good morning': 'hip_hinge.lottie',
      'knee plank': 'Plank_Low_To_High.lottie',
      'jab cross': 'straight_punch.lottie',
      'back extension': 'back_arches.lottie',
      'kneeling back extension': 'back_arches.lottie',
      'marching': 'High_Stepping.lottie',
      'plank shoulder tap': 'Military_Push_Ups.lottie',
      'prone i t y raise': 'arm_raise.lottie',
      'prone y raise': 'arm_raise.lottie',
      'push up shoulder tap': 'Military_Push_Ups.lottie',
      'push up hold': 'bench_push_up.lottie',
      'push up rotation': 'bench_push_up.lottie',
      'rhomboid pull': 'pull_up.lottie',
      'shrimping sprawl combo': 'sprawl_exercise.lottie',
      'side movement drill': 'side_shuttle.lottie',
      'slip counter combo': 'shadow_boxing.lottie',
      'slip punch combo': 'shadow_boxing.lottie',
      'punch combo': 'straight_and_side_punch.lottie',
      'reverse snow angel': 'arm_raise.lottie',
      'side shuffle': 'side_shuttle.lottie',
      'side shuffle fast': 'side_shuttle.lottie',
      'side split stretch': 'Shoulder_Stretch.lottie',
      'single leg glute bridge': 'hip_bridge_&_leg_lift_left.lottie',
      'shoulder tap': 'Military_Push_Ups.lottie',
      'squat hold': 'squats.lottie',
      'straight cross explosive': 'straight_punch.lottie',
      'straight arm plank': 'Plank_Low_To_High.lottie',
      'straight arm plank long': 'Plank_Low_To_High.lottie',
      'skipping': 'skiping_without_roop.lottie',
      'v up': 'V-Sit_Hold.lottie',
      'supine spinal twist': 'lunges_twist.lottie',
      'clasped hands behind the back stretch': 'Shoulder_Stretch.lottie',
      'downward facing dog on the wall': 'child_pose.lottie',
      'dumbell standing calf raise': 'calf_raise_wih_splayed_foot.lottie',
      'elbow plank rotation left': 'elbow_plank_rotation_right.lottie',
      'lateral flash': 'side_shuttle.lottie',
      'left quad stretch with wall': 'kneeling_lunge_strech_left.lottie',
      'modified push up low hold': 'hover_push-up.lottie',
      'pigeon pose': 'piriformis_streatch.lottie',
      'plank leg up': 'Weighted_Plank.lottie',
      'prone triceps push up': 'Military_Push_Ups.lottie',
      'reclined rhomboid squeeze': 'chest_support_dumbell_row.lottie',
      'shrimping sprawl bear crawl': 'sprawl_exercise.lottie',
      'side split streatch': 'butterfly_streach.lottie',
      'sprawl bear crawl': 'sprawl_exercise.lottie',
      'suspine spinal twist': 'reclined_oblique_twist.lottie',
      'through a punch': 'straight_punch.lottie',
      'toe touche': 'Toe_Touch_Stretch.lottie',
      'wall sit': 'Wall_Angels.lottie',
      'wall sit long': 'Wall_Angels.lottie',
      'bear crawl': 'high_knee.lottie',
      'bear crawl fast': 'high_knee.lottie',
    };

    final aliasedAsset =
        aliasByNormalizedName[normalizedSearch] ??
        aliasByNormalizedName[normalizedSimplifiedSearch];
    String? resolvedAlias = aliasedAsset;

    // Backstop: if alias keys were entered in non-normalized form,
    // normalize keys at runtime and try again.
    if (resolvedAlias == null) {
      for (final entry in aliasByNormalizedName.entries) {
        final normalizedKey = _normalize(entry.key);
        if (normalizedKey == normalizedSearch ||
            normalizedKey == normalizedSimplifiedSearch) {
          resolvedAlias = entry.value;
          break;
        }
      }
    }

    if (resolvedAlias != null && _assets.contains(resolvedAlias)) {
      return '$_basePath$resolvedAlias';
    }

    // ── Pass 1: exact substring match (case-insensitive) ──
    String? firstImageCandidate;
    for (var asset in _assets) {
      if (!_isSupportedMediaAsset(asset)) continue;

      String assetName = asset
          .split('.')
          .first
          .toLowerCase()
          .replaceAll('-', ' ')
          .replaceAll('_', ' ')
          .trim();
      // Match both directions on raw and simplified search text.
      if (assetName.contains(search) ||
          search.contains(assetName) ||
          assetName.contains(simplifiedSearch) ||
          simplifiedSearch.contains(assetName)) {
        if (_isAnimatedAsset(asset)) {
          return '$_basePath$asset';
        }
        firstImageCandidate ??= asset;
      }
    }

    if (firstImageCandidate != null) {
      return '$_basePath$firstImageCandidate';
    }

    // ── Pass 2: normalized token matching (handles plurals, hyphens, etc.) ──
    final searchTokens = normalizedSimplifiedSearch.split(RegExp(r'\s+'));

    int bestScoreAny = 0;
    String? bestMatchAny;
    int bestScoreAnimated = 0;
    String? bestMatchAnimated;

    for (var asset in _assets) {
      if (!_isSupportedMediaAsset(asset)) continue;

      final normalizedAsset = _normalize(asset.split('.').first);
      int matchCount = 0;

      for (var token in searchTokens) {
        if (token.length < 2) continue;
        // Check if this token appears in the normalized asset name
        if (normalizedAsset.contains(token)) {
          matchCount++;
        }
      }

      // Require at least 60% of search tokens to match
      if (matchCount > bestScoreAny) {
        bestScoreAny = matchCount;
        bestMatchAny = asset;
      }
      if (_isAnimatedAsset(asset) && matchCount > bestScoreAnimated) {
        bestScoreAnimated = matchCount;
        bestMatchAnimated = asset;
      }
    }

    // Need a meaningful match (at least 60% of tokens or at least 2 tokens)
    final threshold = (searchTokens.length * 0.6).ceil().clamp(
      1,
      searchTokens.length,
    );
    if (bestMatchAnimated != null && bestScoreAnimated >= threshold) {
      return '$_basePath$bestMatchAnimated';
    }
    if (bestMatchAny != null && bestScoreAny >= threshold) {
      return '$_basePath$bestMatchAny';
    }

    // ── Pass 3: keyword fallbacks ──
    if (search.contains('wall') && search.contains('push')) {
      return '${_basePath}wall_push_up.lottie';
    }
    if (search.contains('march')) {
      return '${_basePath}High_Stepping.lottie';
    }
    if (search.contains('skip')) {
      return '${_basePath}skiping_without_roop.lottie';
    }
    if (search.contains('bridge')) {
      return '${_basePath}butt_bridge.lottie';
    }
    if (search.contains('climber')) {
      return '${_basePath}mountain_climber.lottie';
    }
    if (search.contains('incline') && search.contains('push')) {
      return '${_basePath}incline_push-up.lottie';
    }
    if (search.contains('knee') && search.contains('push')) {
      return '${_basePath}knee_push_ups.lottie';
    }
    if (search.contains('bench') && search.contains('push')) {
      return '${_basePath}bench_push_up.lottie';
    }
    if (search.contains('push') && search.contains('up')) {
      return '${_basePath}Military_Push_Ups.lottie';
    }
    if (search.contains('squat')) {
      return '${_basePath}squats.lottie';
    }
    if (search.contains('plank')) {
      return '${_basePath}Plank_Low_To_High.lottie';
    }
    if (search.contains('lunge')) {
      return '${_basePath}Lunges.lottie';
    }
    if (search.contains('crunch')) {
      return '${_basePath}crunches.lottie';
    }
    if (search.contains('curl')) {
      return '${_basePath}Standing_Dumbbell_Curl.lottie';
    }
    if (search.contains('press')) {
      return '${_basePath}military_press.lottie';
    }
    if (search.contains('row')) {
      return '${_basePath}bent_over_row.lottie';
    }
    if (search.contains('stretch')) {
      return '${_basePath}Shoulder_Stretch.lottie';
    }
    if (search.contains('kick')) {
      return '${_basePath}butt_kicks.lottie';
    }
    if (search.contains('jump')) {
      return '${_basePath}jumping_jacks.lottie';
    }
    if (search.contains('pull')) {
      return '${_basePath}pull_up.lottie';
    }
    if (search.contains('dip')) {
      return '${_basePath}tricep_dips.lottie';
    }

    return null;
  }

  static bool isKnownExerciseAssetPath(String path) {
    final normalizedPath = path.trim();
    if (normalizedPath.isEmpty) return false;

    final lowerPath = normalizedPath.toLowerCase();
    final lowerBasePath = _basePath.toLowerCase();
    if (!lowerPath.startsWith(lowerBasePath)) return false;

    final fileName = normalizedPath.split('/').last.toLowerCase();
    for (final asset in _assets) {
      if (asset.toLowerCase() == fileName) {
        return true;
      }
    }

    return false;
  }
}

// ════════════════════════════════════════════════════════
// Reusable Widget for Displaying Asset (Lottie, JPEG)
// ════════════════════════════════════════════════════════
class ExerciseMediaWidget extends StatelessWidget {
  static const Color _defaultLottieTint = Color(0xFF149D96);

  final String? assetPath;
  final BoxFit fit;

  /// When true, shows static first frame only.
  /// Use this in list views where many thumbnails are visible at once.
  final bool isThumbnail;
  final Color? lottieTint;
  final double lottieTintStrength;

  const ExerciseMediaWidget({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.contain,
    this.isThumbnail = false,
    this.lottieTint = _defaultLottieTint,
    this.lottieTintStrength = 0.14,
  });

  @override
  Widget build(BuildContext context) {
    if (assetPath == null || assetPath!.isEmpty) {
      return _buildFallbackIcon();
    }

    final resolvedPath = _resolveLegacyAssetPath(assetPath!);
    final lowerPath = resolvedPath.toLowerCase();
    final lottieDelegates = _buildLottieDelegates();

    // ── dotLottie animations (.lottie) ──
    // Some bundles include manifest.json first and some use image dirs like `/i/`.
    // Use a custom decoder to pick animation JSON and normalize embedded image paths.
    if (lowerPath.endsWith('.lottie')) {
      return Lottie.asset(
        resolvedPath,
        fit: fit,
        animate: !isThumbnail,
        repeat: !isThumbnail,
        decoder: _dotLottieDecoder,
        delegates: lottieDelegates,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Lottie load error for $resolvedPath: $error');
          return _buildFallbackIcon();
        },
      );
    }

    // ── Lottie JSON animations (.json) ──
    if (lowerPath.endsWith('.json')) {
      return Lottie.asset(
        resolvedPath,
        fit: fit,
        animate: !isThumbnail,
        repeat: !isThumbnail,
        delegates: lottieDelegates,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Lottie load error for $resolvedPath: $error');
          return _buildFallbackIcon();
        },
      );
    }

    // ── Static images (.jpg, .png, .webp) ──
    return Image.asset(
      resolvedPath,
      fit: fit,
      errorBuilder: (_, _, _) => _buildFallbackIcon(),
    );
  }

  LottieDelegates? _buildLottieDelegates() {
    final tint = lottieTint;
    if (tint == null || lottieTintStrength <= 0) return null;

    final alpha = lottieTintStrength.clamp(0.0, 1.0).toDouble();
    return LottieDelegates(
      values: [
        ValueDelegate.colorFilter(
          ['**'],
          value: ColorFilter.mode(
            tint.withValues(alpha: alpha),
            BlendMode.srcATop,
          ),
        ),
      ],
    );
  }

  String _resolveLegacyAssetPath(String path) {
    final normalizedPath = path.trim();
    if (normalizedPath.isEmpty) return normalizedPath;

    if (ExerciseAssets.isKnownExerciseAssetPath(normalizedPath)) {
      return normalizedPath;
    }

    final fileName = normalizedPath.split('/').last;
    final dotIndex = fileName.lastIndexOf('.');
    final baseName = dotIndex > 0 ? fileName.substring(0, dotIndex) : fileName;
    final lookupKey = baseName.replaceAll(RegExp(r'[_-]+'), ' ').trim();

    final resolved = ExerciseAssets.getAssetForExercise(lookupKey);
    if (resolved != null) return resolved;

    final resolvedFromFullValue = ExerciseAssets.getAssetForExercise(
      normalizedPath,
    );
    return resolvedFromFullValue ?? normalizedPath;
  }

  Future<LottieComposition?> _dotLottieDecoder(List<int> bytes) async {
    if (bytes.length < 2 || bytes[0] != 0x50 || bytes[1] != 0x4B) {
      return null;
    }

    final archive = ZipDecoder().decodeBytes(bytes);
    final imageProvidersByPath = <String, MemoryImage>{};
    for (final file in archive.files) {
      if (!file.isFile) continue;
      final lowerName = file.name.toLowerCase();
      final isImageFile =
          lowerName.endsWith('.png') ||
          lowerName.endsWith('.jpg') ||
          lowerName.endsWith('.jpeg') ||
          lowerName.endsWith('.webp') ||
          lowerName.endsWith('.gif');
      if (!isImageFile) continue;

      imageProvidersByPath[_normalizeArchivePath(file.name)] = MemoryImage(
        file.content,
      );
    }

    return LottieComposition.decodeZip(
      bytes,
      filePicker: _pickDotLottieJsonFile,
      imageProviderFactory: (image) {
        for (final candidate in _archiveImagePathCandidates(
          image.dirName,
          image.fileName,
        )) {
          final provider = imageProvidersByPath[candidate];
          if (provider != null) return provider;
        }
        return null;
      },
    );
  }

  ArchiveFile? _pickDotLottieJsonFile(List<ArchiveFile> files) {
    ArchiveFile? firstNonManifestJson;

    for (final file in files) {
      final lower = file.name.toLowerCase();
      final isJson = file.isFile && lower.endsWith('.json');
      if (!isJson) continue;
      if (lower.endsWith('manifest.json')) continue;

      firstNonManifestJson ??= file;

      if (lower.startsWith('a/') || lower.contains('/a/')) {
        return file;
      }
    }

    return firstNonManifestJson;
  }

  Iterable<String> _archiveImagePathCandidates(
    String dirName,
    String fileName,
  ) {
    final normalizedDir = dirName.trim().replaceAll('\\', '/');
    final normalizedFileName = fileName.trim().replaceAll('\\', '/');
    final joinedPath = normalizedDir.isEmpty
        ? normalizedFileName
        : '$normalizedDir/$normalizedFileName';

    final candidates = <String>{
      joinedPath,
      joinedPath.replaceAll(RegExp(r'^/+'), ''),
      '/${joinedPath.replaceAll(RegExp(r'^/+'), '')}',
      normalizedFileName,
      normalizedFileName.replaceAll(RegExp(r'^/+'), ''),
    };

    final trimmedJoined = joinedPath.replaceAll(RegExp(r'^/+'), '');
    if (trimmedJoined.contains('/')) {
      candidates.add(trimmedJoined.substring(trimmedJoined.indexOf('/') + 1));
    }

    return candidates
        .map(_normalizeArchivePath)
        .where((candidate) => candidate.isNotEmpty);
  }

  String _normalizeArchivePath(String path) {
    var normalized = path.trim().replaceAll('\\', '/');
    normalized = normalized.replaceAll(RegExp(r'/+'), '/');
    while (normalized.startsWith('./')) {
      normalized = normalized.substring(2);
    }
    while (normalized.startsWith('/')) {
      normalized = normalized.substring(1);
    }
    return normalized.toLowerCase();
  }

  Widget _buildFallbackIcon() {
    return Container(
      color: const Color(0x0A4CAF50),
      child: Center(
        child: Icon(
          Icons.fitness_center,
          color: Colors.green.withValues(alpha: 0.4),
          size: isThumbnail ? 24 : 48,
        ),
      ),
    );
  }
}
