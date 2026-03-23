// Exercise data organized by focus area for the Home Workout system.
// Each focus area has 6-10 bodyweight exercises.
// Animation field is intentionally left empty for future use.

import '../models/home_workout_models.dart';

class HomeExercisesData {
  /// Returns exercises for the given focus area key.
  static List<HomeExercise> getExercisesForFocus(String focusArea) {
    final key = focusArea.toLowerCase().trim();
    return _exercisesByFocus[key] ?? _exercisesByFocus['full_body']!;
  }

  /// Returns all available focus area keys.
  static List<String> get focusAreaKeys => _exercisesByFocus.keys.toList();

  static const Map<String, List<HomeExercise>> _exercisesByFocus = {
    // ═══════════════════════════════════════════
    // CHEST
    // ═══════════════════════════════════════════
    'chest': [
      HomeExercise(
        name: 'Push-Ups',
        description: 'Classic push-up targeting the chest, shoulders, and triceps.',
        steps: ['Start in plank with hands shoulder-width apart', 'Lower chest towards floor', 'Push back up', 'Keep body straight'],
        duration: '30s', reps: '10-20', rest: '30s',
        image: 'assets/images/jsonimg/push_ups.png', animation: 'assets/images/jsonanimation/push_up.json',
      ),
      HomeExercise(
        name: 'Wide Push-Ups',
        description: 'Wider hand placement emphasizes the outer chest.',
        steps: ['Place hands wider than shoulder-width', 'Lower chest to floor', 'Push back up with control', 'Focus on chest squeeze'],
        duration: '30s', reps: '10-15', rest: '30s',
        image: 'assets/images/jsonimg/wide_push_ups.png', animation: 'assets/images/jsonanimation/push up.json',
      ),
      HomeExercise(
        name: 'Diamond Push-Ups',
        description: 'Hands close together to target inner chest and triceps.',
        steps: ['Form diamond shape with hands', 'Lower chest towards hands', 'Push back up', 'Keep elbows close'],
        duration: '30s', reps: '8-12', rest: '30s',
        image: 'assets/images/jsonimg/diamond_push_ups.png', animation: 'assets/images/jsonanimation/diamond_push_up.json',
      ),
      HomeExercise(
        name: 'Decline Push-Ups',
        description: 'Feet elevated to target the upper chest fibers.',
        steps: ['Place feet on elevated surface', 'Hands on floor shoulder-width', 'Lower chest to floor', 'Push back up'],
        duration: '30s', reps: '10-15', rest: '30s',
        image: 'assets/images/jsonimg/decline_push_ups.png', animation: '',
      ),
      HomeExercise(
        name: 'Incline Push-Ups',
        description: 'Hands elevated for an easier variation targeting the lower chest.',
        steps: ['Place hands on elevated surface', 'Lower chest towards surface', 'Push back up', 'Easier variation'],
        duration: '30s', reps: '12-20', rest: '25s',
        image: 'assets/images/jsonimg/incline_push_ups.png', animation: '',
      ),
      HomeExercise(
        name: 'Chest Dips',
        description: 'Bodyweight dips leaning forward to engage the chest.',
        steps: ['Grip parallel bars and lift up', 'Lean slightly forward', 'Lower by bending elbows', 'Push back up'],
        duration: '30s', reps: '8-12', rest: '35s',
        image: 'assets/images/jsonimg/chest_dips.png', animation: '',
      ),
      HomeExercise(
        name: 'Archer Push-Ups',
        description: 'Unilateral push-up for advanced chest strength.',
        steps: ['Wide push-up position', 'Shift weight to one arm and lower', 'Push back up', 'Alternate sides'],
        duration: '30s', reps: '6-10', rest: '40s',
        image: 'assets/images/jsonimg/push_ups.png', animation: '',
      ),
      HomeExercise(
        name: 'Explosive Push-Ups',
        description: 'Plyometric push-up for power and muscle activation.',
        steps: ['Start in push-up position', 'Lower chest to floor', 'Push up explosively, hands leave ground', 'Land softly and repeat'],
        duration: '30s', reps: '8-12', rest: '40s',
        image: 'assets/images/jsonimg/push_ups.png', animation: '',
      ),
    ],

    // ═══════════════════════════════════════════
    // BACK
    // ═══════════════════════════════════════════
    'back': [
      HomeExercise(
        name: 'Superman',
        description: 'Lying back extension to strengthen the lower back.',
        steps: ['Lie face down with arms extended', 'Lift arms, legs, and chest off floor', 'Hold briefly at the top', 'Lower back down'],
        duration: '30s', reps: '10-15', rest: '30s',
        image: 'assets/images/jsonimg/superman.png', animation: '',
      ),
      HomeExercise(
        name: 'Back Extensions',
        description: 'Target the erector spinae muscles of the lower back.',
        steps: ['Lie face down with hands behind head', 'Lift upper body off floor', 'Hold briefly', 'Lower back down slowly'],
        duration: '30s', reps: '12-15', rest: '30s',
        image: 'assets/images/jsonimg/back_extensions.png', animation: 'assets/images/jsonanimation/back_extension.json',
      ),
      HomeExercise(
        name: 'Inverted Rows',
        description: 'Horizontal pull using a bar or table edge.',
        steps: ['Lie under a sturdy bar or table', 'Grip and pull chest up', 'Lower with control', 'Keep body straight'],
        duration: '30s', reps: '8-12', rest: '35s',
        image: 'assets/images/jsonimg/inverted_rows.png', animation: '',
      ),
      HomeExercise(
        name: 'Pull-Ups',
        description: 'Bodyweight vertical pull targeting lats and upper back.',
        steps: ['Grip bar with palms facing away', 'Pull body up until chin over bar', 'Lower back down with control', 'Keep core engaged'],
        duration: '30s', reps: '5-10', rest: '45s',
        image: 'assets/images/jsonimg/pull_ups.png', animation: 'assets/images/jsonanimation/pull_ups.json',
      ),
      HomeExercise(
        name: 'Good Mornings',
        description: 'Hip hinge movement strengthening the posterior chain.',
        steps: ['Stand with hands behind head', 'Hinge forward at hips', 'Keep back straight', 'Return to standing'],
        duration: '30s', reps: '12-15', rest: '30s',
        image: 'assets/images/jsonimg/good_mornings.png', animation: '',
      ),
      HomeExercise(
        name: 'Reverse Snow Angels',
        description: 'Prone arm sweep to activate the upper back and rear delts.',
        steps: ['Lie face down, arms at sides', 'Lift chest slightly and sweep arms overhead', 'Reverse the motion', 'Keep arms off the ground'],
        duration: '30s', reps: '10-12', rest: '30s',
        image: 'assets/images/jsonimg/superman.png', animation: '',
      ),
      HomeExercise(
        name: 'Prone Y Raises',
        description: 'Targets the lower traps and upper back stabilizers.',
        steps: ['Lie face down with arms in Y position', 'Lift arms off the ground', 'Hold at the top for 2 seconds', 'Lower slowly'],
        duration: '30s', reps: '10-15', rest: '25s',
        image: 'assets/images/jsonimg/superman.png', animation: '',
      ),
    ],

    // ═══════════════════════════════════════════
    // SHOULDERS
    // ═══════════════════════════════════════════
    'shoulders': [
      HomeExercise(
        name: 'Pike Push-Ups',
        description: 'Inverted push-up to target the anterior deltoids.',
        steps: ['Start in downward dog position', 'Bend elbows and lower head towards floor', 'Push back up', 'Great shoulder builder'],
        duration: '30s', reps: '8-12', rest: '35s',
        image: 'assets/images/jsonimg/pike_push_ups.png', animation: '',
      ),
      HomeExercise(
        name: 'Arm Circles',
        description: 'Dynamic shoulder warm-up and endurance exercise.',
        steps: ['Extend arms out to sides', 'Make small circles forward', 'Gradually increase size', 'Reverse direction'],
        duration: '30s', reps: '15-20 each direction', rest: '20s',
        image: 'assets/images/jsonimg/arm_circles.png', animation: 'assets/images/jsonanimation/arm_circle.json',
      ),
      HomeExercise(
        name: 'Lateral Raises',
        description: 'Isolates the medial deltoid for shoulder width.',
        steps: ['Stand with dumbbells at sides', 'Raise arms to sides at shoulder height', 'Lower slowly', 'Keep slight bend in elbows'],
        duration: '30s', reps: '12-15', rest: '30s',
        image: 'assets/images/jsonimg/lateral_raises.png', animation: '',
      ),
      HomeExercise(
        name: 'Front Raises',
        description: 'Targets the anterior deltoid with a front arm raise.',
        steps: ['Stand with weights at thighs', 'Raise arms forward to shoulder height', 'Lower slowly', 'Alternate or both arms'],
        duration: '30s', reps: '10-12', rest: '30s',
        image: 'assets/images/jsonimg/front_raises.png', animation: '',
      ),
      HomeExercise(
        name: 'Shoulder Taps',
        description: 'Plank-based rotational stability for the shoulders.',
        steps: ['Start in high plank position', 'Tap left shoulder with right hand', 'Tap right shoulder with left hand', 'Keep hips stable'],
        duration: '30s', reps: '10-15 each side', rest: '25s',
        image: 'assets/images/jsonimg/plank.png', animation: '',
      ),
      HomeExercise(
        name: 'Wall Push-Ups (Handstand Prep)',
        description: 'Vertical push against a wall to build overhead pressing strength.',
        steps: ['Place hands on wall at shoulder height', 'Lean in and push back', 'Progress by moving feet further back', 'Keep core tight'],
        duration: '30s', reps: '12-15', rest: '25s',
        image: 'assets/images/jsonimg/incline_push_ups.png', animation: '',
      ),
      HomeExercise(
        name: 'Prone I-T-Y Raises',
        description: 'Targets all three deltoid heads and upper back.',
        steps: ['Lie face down', 'Raise arms in I position overhead', 'Then T position to sides', 'Then Y position at 45 degrees'],
        duration: '30s', reps: '8-10 each', rest: '30s',
        image: 'assets/images/jsonimg/superman.png', animation: '',
      ),
    ],

    // ═══════════════════════════════════════════
    // BICEPS
    // ═══════════════════════════════════════════
    'biceps': [
      HomeExercise(
        name: 'Chin-Ups',
        description: 'Underhand grip pull-up heavily recruiting the biceps.',
        steps: ['Grip bar with palms facing you', 'Pull up until chin over bar', 'Lower slowly', 'Focus on bicep contraction'],
        duration: '30s', reps: '5-10', rest: '45s',
        image: 'assets/images/jsonimg/chin_ups.png', animation: '',
      ),
      HomeExercise(
        name: 'Bicep Curls',
        description: 'Classic dumbbell curl for bicep mass and definition.',
        steps: ['Stand with dumbbells at sides', 'Curl up towards shoulders', 'Squeeze at top', 'Lower slowly'],
        duration: '30s', reps: '10-15', rest: '30s',
        image: 'assets/images/jsonimg/bicep_curls.png', animation: 'assets/images/jsonanimation/bicep_curl.json',
      ),
      HomeExercise(
        name: 'Hammer Curls',
        description: 'Neutral grip curl targeting brachialis and brachioradialis.',
        steps: ['Hold dumbbells with palms facing each other', 'Curl up keeping neutral grip', 'Squeeze at top', 'Lower with control'],
        duration: '30s', reps: '10-15', rest: '30s',
        image: 'assets/images/jsonimg/hammer_curls.png', animation: 'assets/images/jsonanimation/hammer_curl.json',
      ),
      HomeExercise(
        name: 'Concentration Curls',
        description: 'Seated isolated curl for peak bicep contraction.',
        steps: ['Sit with elbow against inner thigh', 'Curl dumbbell to shoulder', 'Squeeze at top', 'Lower slowly'],
        duration: '30s', reps: '10-12 each arm', rest: '30s',
        image: 'assets/images/jsonimg/concentration_curls.png', animation: 'assets/images/jsonanimation/concentration_curls.json',
      ),
      HomeExercise(
        name: 'Isometric Towel Curls',
        description: 'Use a towel under your foot for resistance-free bicep work.',
        steps: ['Step on a towel with one foot', 'Hold both ends and curl up', 'Pull against resistance of foot', 'Hold contraction for 5 seconds'],
        duration: '30s', reps: '8-10 each arm', rest: '30s',
        image: 'assets/images/jsonimg/bicep_curls.png', animation: '',
      ),
      HomeExercise(
        name: 'Door Frame Curls',
        description: 'Bodyweight bicep curl using a door frame for resistance.',
        steps: ['Stand at open door frame', 'Grip the frame at waist height', 'Lean back and curl yourself forward', 'Focus on bicep squeeze'],
        duration: '30s', reps: '8-12', rest: '30s',
        image: 'assets/images/jsonimg/chin_ups.png', animation: '',
      ),
    ],

    // ═══════════════════════════════════════════
    // TRICEPS
    // ═══════════════════════════════════════════
    'triceps': [
      HomeExercise(
        name: 'Tricep Dips',
        description: 'Bodyweight dip on a bench or chair for tricep isolation.',
        steps: ['Place hands on bench edge behind you', 'Slide hips off bench', 'Bend elbows to lower body', 'Push back up'],
        duration: '30s', reps: '10-15', rest: '30s',
        image: 'assets/images/jsonimg/tricep_dips.png', animation: '',
      ),
      HomeExercise(
        name: 'Diamond Push-Ups',
        description: 'Close-grip push-up heavily targeting the triceps.',
        steps: ['Form diamond shape with hands', 'Lower chest towards hands', 'Push back up', 'Keep elbows close to body'],
        duration: '30s', reps: '8-12', rest: '30s',
        image: 'assets/images/jsonimg/diamond_push_ups.png', animation: 'assets/images/jsonanimation/diamond_push_up.json',
      ),
      HomeExercise(
        name: 'Close Grip Push-Ups',
        description: 'Hands placed close together under chest for tricep emphasis.',
        steps: ['Place hands close together under chest', 'Lower body keeping elbows close', 'Push back up', 'Targets triceps heavily'],
        duration: '30s', reps: '8-12', rest: '30s',
        image: 'assets/images/jsonimg/close_grip_push_ups.png', animation: 'assets/images/jsonanimation/close_grip_push_ups.json',
      ),
      HomeExercise(
        name: 'Tricep Kickbacks',
        description: 'Bent-over dumbbell extension isolating the triceps.',
        steps: ['Bend forward at waist with dumbbell', 'Extend arm straight behind', 'Squeeze tricep at full extension', 'Return to bent position'],
        duration: '30s', reps: '10-12 each arm', rest: '30s',
        image: 'assets/images/jsonimg/tricep_kickbacks.png', animation: '',
      ),
      HomeExercise(
        name: 'Overhead Tricep Extension',
        description: 'Overhead press-down movement targeting long head of triceps.',
        steps: ['Hold dumbbell overhead with both hands', 'Lower weight behind head', 'Extend arms back up', 'Keep elbows close to head'],
        duration: '30s', reps: '10-12', rest: '30s',
        image: 'assets/images/jsonimg/overhead_tricep_extension.png', animation: 'assets/images/jsonanimation/overhead_tricep_extension.json',
      ),
      HomeExercise(
        name: 'Bench Tricep Push-Ups',
        description: 'Narrow push-up on a bench for easy tricep targeting.',
        steps: ['Hands narrow on bench edge', 'Lower chest to bench', 'Push back up', 'Keep elbows tucked'],
        duration: '30s', reps: '10-15', rest: '25s',
        image: 'assets/images/jsonimg/tricep_dips.png', animation: '',
      ),
    ],

    // ═══════════════════════════════════════════
    // ABS
    // ═══════════════════════════════════════════
    'abs': [
      HomeExercise(
        name: 'Abdominal Crunches',
        description: 'Standard crunch targeting the upper abs.',
        steps: ['Lie on back with knees bent', 'Place hands behind head', 'Curl upper body towards knees', 'Lower with control'],
        duration: '30s', reps: '15-20', rest: '25s',
        image: 'assets/images/jsonimg/abdominal_crunches.png', animation: 'assets/images/jsonanimation/Abdominal crunhes.json',
      ),
      HomeExercise(
        name: 'Bicycle Crunches',
        description: 'Rotational crunch for obliques and rectus abdominis.',
        steps: ['Lie on back with hands behind head', 'Bring right elbow to left knee', 'Switch sides', 'Keep pedaling motion continuous'],
        duration: '30s', reps: '15-20 each side', rest: '25s',
        image: 'assets/images/jsonimg/bicycle_crunches.png', animation: '',
      ),
      HomeExercise(
        name: 'Plank',
        description: 'Isometric core hold for deep stabilizer muscles.',
        steps: ['Start in forearm plank position', 'Keep body in straight line', 'Engage core', 'Hold without sagging'],
        duration: '45s', reps: 'hold', rest: '30s',
        image: 'assets/images/jsonimg/plank.png', animation: 'assets/images/jsonanimation/plank.json',
      ),
      HomeExercise(
        name: 'Leg Raises',
        description: 'Lower ab isolation by raising both legs.',
        steps: ['Lie flat with legs straight', 'Raise legs to 90 degrees', 'Lower slowly without touching floor', 'Keep lower back pressed down'],
        duration: '30s', reps: '12-15', rest: '30s',
        image: 'assets/images/jsonimg/leg_raises.png', animation: 'assets/images/jsonanimation/leg_raises.json',
      ),
      HomeExercise(
        name: 'Russian Twists',
        description: 'Seated rotation to target the obliques.',
        steps: ['Sit with knees bent, feet off floor', 'Lean back slightly', 'Rotate torso side to side', 'Touch hands to floor each side'],
        duration: '30s', reps: '15-20 each side', rest: '25s',
        image: 'assets/images/jsonimg/russian_twists.png', animation: 'assets/images/jsonanimation/russian_twist.json',
      ),
      HomeExercise(
        name: 'Flutter Kicks',
        description: 'Alternating leg kicks to work the lower abs.',
        steps: ['Lie on back with legs extended', 'Lift legs slightly off ground', 'Kick up and down alternately', 'Keep core engaged'],
        duration: '30s', reps: '20-30', rest: '25s',
        image: 'assets/images/jsonimg/flutter_kicks.png', animation: '',
      ),
      HomeExercise(
        name: 'V-Ups',
        description: 'Full body crunch for advanced ab activation.',
        steps: ['Lie flat with arms overhead', 'Simultaneously lift legs and upper body', 'Touch toes at top', 'Lower with control'],
        duration: '30s', reps: '10-15', rest: '35s',
        image: 'assets/images/jsonimg/v_ups.png', animation: 'assets/images/jsonanimation/v_up.json',
      ),
      HomeExercise(
        name: 'Mountain Climbers',
        description: 'Dynamic plank exercise for abs and cardiovascular endurance.',
        steps: ['Start in plank position', 'Drive one knee towards chest', 'Quickly switch legs', 'Keep core tight and hips level'],
        duration: '30s', reps: '20-30', rest: '25s',
        image: 'assets/images/jsonimg/mountain_climbers.png', animation: 'assets/images/jsonanimation/mountain_climbers.json',
      ),
    ],

    // ═══════════════════════════════════════════
    // LEGS
    // ═══════════════════════════════════════════
    'legs': [
      HomeExercise(
        name: 'Squats',
        description: 'Fundamental lower-body compound movement.',
        steps: ['Stand with feet shoulder-width apart', 'Lower hips back and down', 'Keep chest up and knees over toes', 'Push through heels to stand'],
        duration: '30s', reps: '15-20', rest: '30s',
        image: 'assets/images/jsonimg/squats.png', animation: 'assets/images/jsonanimation/sqautss.json',
      ),
      HomeExercise(
        name: 'Jump Squats',
        description: 'Plyometric squat for explosive leg power.',
        steps: ['Perform a regular squat', 'Explode upward into a jump', 'Land softly back into squat', 'Keep movements controlled'],
        duration: '30s', reps: '12-15', rest: '35s',
        image: 'assets/images/jsonimg/jump_squats.png', animation: 'assets/images/jsonanimation/jump_squats.json',
      ),
      HomeExercise(
        name: 'Lunges',
        description: 'Unilateral leg exercise for strength and balance.',
        steps: ['Step forward with one leg', 'Lower back knee towards floor', 'Push through front heel to stand', 'Alternate legs'],
        duration: '30s', reps: '10-12 each leg', rest: '30s',
        image: 'assets/images/jsonimg/lunges.png', animation: 'assets/images/jsonanimation/lunges.json',
      ),
      HomeExercise(
        name: 'Wall Sit',
        description: 'Isometric quad hold against a wall.',
        steps: ['Lean against a wall', 'Slide down until thighs parallel', 'Hold the position', 'Keep back flat against wall'],
        duration: '45s', reps: 'hold', rest: '30s',
        image: 'assets/images/jsonimg/wall_sit.png', animation: 'assets/images/jsonanimation/Lunges.json',
      ),
      HomeExercise(
        name: 'Calf Raises',
        description: 'Standing toe raise to build calf muscles.',
        steps: ['Stand with feet hip-width apart', 'Rise up onto toes', 'Hold briefly at top', 'Lower slowly'],
        duration: '30s', reps: '15-20', rest: '25s',
        image: 'assets/images/jsonimg/calf_raises.png', animation: 'assets/images/jsonanimation/Calf rasies.json',
      ),
      HomeExercise(
        name: 'Sumo Squats',
        description: 'Wide stance squat targeting inner thighs and glutes.',
        steps: ['Stand with feet wide, toes pointed out', 'Lower hips straight down', 'Keep chest up', 'Push through heels to stand'],
        duration: '30s', reps: '15-20', rest: '30s',
        image: 'assets/images/jsonimg/sumo_squats.png', animation: 'assets/images/jsonanimation/sumo_squats.json',
      ),
      HomeExercise(
        name: 'Side Lunges',
        description: 'Lateral lunge for inner and outer thigh development.',
        steps: ['Stand with feet together', 'Step wide to one side', 'Bend stepping leg, push hips back', 'Push back to start'],
        duration: '30s', reps: '10-12 each side', rest: '30s',
        image: 'assets/images/jsonimg/side_lunges.png', animation: 'assets/images/jsonanimation/side_lunges.json',
      ),
      HomeExercise(
        name: 'Step-Ups',
        description: 'Unilateral step exercise using a bench or stair.',
        steps: ['Stand in front of a step', 'Step up with one foot', 'Bring other foot up', 'Step back down and alternate'],
        duration: '30s', reps: '10-12 each leg', rest: '30s',
        image: 'assets/images/jsonimg/step_ups.png', animation: 'assets/images/jsonanimation/jump squats.json',
      ),
    ],

    // ═══════════════════════════════════════════
    // GLUTES
    // ═══════════════════════════════════════════
    'glutes': [
      HomeExercise(
        name: 'Glute Bridges',
        description: 'Hip thrust from the floor targeting the glutes.',
        steps: ['Lie on back with knees bent', 'Push hips up towards ceiling', 'Squeeze glutes at top', 'Lower hips back down'],
        duration: '30s', reps: '15-20', rest: '25s',
        image: 'assets/images/jsonimg/glute_bridges.png', animation: 'assets/images/jsonanimation/side lunges.json',
      ),
      HomeExercise(
        name: 'Single Leg Glute Bridge',
        description: 'Unilateral glute bridge for isolated activation.',
        steps: ['Lie on back with one leg extended', 'Push hips up using one leg', 'Squeeze glute at top', 'Lower and switch'],
        duration: '30s', reps: '10-12 each leg', rest: '30s',
        image: 'assets/images/jsonimg/single_leg_glute_bridge.png', animation: 'assets/images/jsonanimation/sumo squats.json',
      ),
      HomeExercise(
        name: 'Donkey Kicks',
        description: 'All-fours kick-back for glute maximus activation.',
        steps: ['Start on all fours', 'Kick one leg up towards ceiling', 'Keep knee bent at 90°', 'Squeeze and lower'],
        duration: '30s', reps: '15-20 each leg', rest: '25s',
        image: 'assets/images/jsonimg/donkey_kicks.png', animation: '',
      ),
      HomeExercise(
        name: 'Fire Hydrants',
        description: 'Lateral hip rotation for glute medius development.',
        steps: ['Start on all fours', 'Lift one knee out to side', 'Keep knee bent at 90°', 'Lower back down'],
        duration: '30s', reps: '15-20 each leg', rest: '25s',
        image: 'assets/images/jsonimg/fire_hydrants.png', animation: '',
      ),
      HomeExercise(
        name: 'Hip Thrusts',
        description: 'Back-supported hip extension for max glute overload.',
        steps: ['Lean upper back against bench', 'Place feet flat on floor', 'Drive hips up squeezing glutes', 'Lower hips back down'],
        duration: '30s', reps: '12-15', rest: '30s',
        image: 'assets/images/jsonimg/hip_thrusts.png', animation: '',
      ),
      HomeExercise(
        name: 'Froggy Glute Lifts',
        description: 'Prone glute squeeze with soles pressed together.',
        steps: ['Lie face down, knees bent, soles together', 'Squeeze glutes to lift thighs', 'Hold briefly at top', 'Lower with control'],
        duration: '30s', reps: '15-20', rest: '25s',
        image: 'assets/images/jsonimg/froggy_glute_lifts.png', animation: 'assets/images/jsonanimation/froggy_glute_lifts.json',
      ),
      HomeExercise(
        name: 'Curtsy Lunges',
        description: 'Cross-behind lunge targeting the glutes from a unique angle.',
        steps: ['Stand with feet hip-width', 'Step one leg behind and across', 'Lower into lunge', 'Push back up and alternate'],
        duration: '30s', reps: '10-12 each side', rest: '30s',
        image: 'assets/images/jsonimg/curtsy_lunges.png', animation: 'assets/images/jsonanimation/Dubmbbell Lunges.json',
      ),
    ],

    // ═══════════════════════════════════════════
    // FULL BODY
    // ═══════════════════════════════════════════
    'full_body': [
      HomeExercise(
        name: 'Burpees',
        description: 'Full-body conditioning combining push-up, squat, and jump.',
        steps: ['Stand with feet shoulder-width', 'Drop into squat, hands on floor', 'Jump feet back to plank', 'Push-up, jump forward, jump up'],
        duration: '30s', reps: '10-15', rest: '40s',
        image: 'assets/images/jsonimg/burpees.png', animation: '',
      ),
      HomeExercise(
        name: 'Jumping Jacks',
        description: 'Classic cardio warm-up and full-body activator.',
        steps: ['Stand with feet together, arms at sides', 'Jump spreading legs and raising arms', 'Jump back to start', 'Keep steady rhythm'],
        duration: '30s', reps: '20-30', rest: '20s',
        image: 'assets/images/jsonimg/jumping_jacks.png', animation: 'assets/images/jsonanimation/animationjumpingjaks.json',
      ),
      HomeExercise(
        name: 'Mountain Climbers',
        description: 'Plank-based cardio targeting core, shoulders, and legs.',
        steps: ['Start in plank position', 'Drive one knee towards chest', 'Quickly switch legs', 'Keep hips level'],
        duration: '30s', reps: '20-30', rest: '25s',
        image: 'assets/images/jsonimg/mountain_climbers.png', animation: 'assets/images/jsonanimation/mountain_climbers.json',
      ),
      HomeExercise(
        name: 'Push-Ups',
        description: 'Classic upper-body compound pushing exercise.',
        steps: ['Start in plank, hands shoulder-width', 'Lower chest towards floor', 'Push back up', 'Keep body straight'],
        duration: '30s', reps: '10-20', rest: '30s',
        image: 'assets/images/jsonimg/push_ups.png', animation: 'assets/images/jsonanimation/push_up.json',
      ),
      HomeExercise(
        name: 'Squats',
        description: 'Fundamental lower-body compound movement.',
        steps: ['Feet shoulder-width apart', 'Lower hips back and down', 'Chest up, knees over toes', 'Push through heels to stand'],
        duration: '30s', reps: '15-20', rest: '30s',
        image: 'assets/images/jsonimg/squats.png', animation: 'assets/images/jsonanimation/sqautss.json',
      ),
      HomeExercise(
        name: 'Plank',
        description: 'Full-body isometric hold for core stabilization.',
        steps: ['Forearm plank position', 'Body in straight line', 'Engage core throughout', 'Hold without sagging'],
        duration: '45s', reps: 'hold', rest: '30s',
        image: 'assets/images/jsonimg/plank.png', animation: 'assets/images/jsonanimation/plank.json',
      ),
      HomeExercise(
        name: 'Lunges',
        description: 'Unilateral leg strength and balance exercise.',
        steps: ['Step forward with one leg', 'Lower back knee towards floor', 'Push through front heel', 'Alternate legs'],
        duration: '30s', reps: '10-12 each leg', rest: '30s',
        image: 'assets/images/jsonimg/lunges.png', animation: 'assets/images/jsonanimation/lunges.json',
      ),
      HomeExercise(
        name: 'Plank to Push-Up',
        description: 'Transition between forearm and full plank for total body work.',
        steps: ['Start in forearm plank', 'Push up to full plank one arm at a time', 'Lower back to forearms', 'Alternate leading arm'],
        duration: '30s', reps: '10-12', rest: '30s',
        image: 'assets/images/jsonimg/plank_to_push_up.png', animation: 'assets/images/jsonanimation/Lunges.json',
      ),
      HomeExercise(
        name: 'Bear Crawl',
        description: 'Total body crawling exercise for coordination and strength.',
        steps: ['Start on all fours, knees hovering', 'Move using opposite hand and foot', 'Keep hips low and core tight', 'Crawl forward'],
        duration: '30s', reps: '10-15 steps', rest: '30s',
        image: 'assets/images/jsonimg/bear_crawl.png', animation: '',
      ),
      HomeExercise(
        name: 'High Knees',
        description: 'Cardio exercise driving knees upward rapidly.',
        steps: ['Stand tall, feet hip-width', 'Drive one knee up towards chest', 'Quickly switch', 'Pump arms for momentum'],
        duration: '30s', reps: '20-30', rest: '25s',
        image: 'assets/images/jsonimg/high_knees.png', animation: 'assets/images/jsonanimation/high_knees.json',
      ),
    ],
  };
}
