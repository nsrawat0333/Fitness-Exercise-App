import '../models/gym_course_model.dart';

/// ──────────────────────────────────────────────────────────────
/// GYM COURSES DATA — Body-Type (FAT/FIT/LEAN) + Focus Area
/// All exercise names mapped to existing 256-asset database
/// ──────────────────────────────────────────────────────────────
class GymCoursesData {

  /// Get courses by body type result from AI analyser
  static List<GymCourseInfo> getCoursesForBodyType(String bodyType) {
    switch (bodyType.toLowerCase()) {
      case 'fat': return fatCourses;
      case 'fit': return fitCourses;
      case 'lean': return leanCourses;
      default: return fitCourses;
    }
  }

  /// Get all focus-area courses (common + gender-specific)
  static List<GymCourseInfo> getFocusCourses({String? gender}) {
    final common = commonFocusCourses;
    if (gender == 'male') return [...common, ...maleFocusCourses];
    if (gender == 'female') return [...common, ...femaleFocusCourses];
    return common;
  }

  // ═══════════════════════════════════════
  //  FAT BODY-TYPE COURSES (5)
  // ═══════════════════════════════════════
  static final fatCourses = <GymCourseInfo>[
    _course('Fat Burn Beast Mode', '🔥', 'Maximum calorie burn + sweating', 'fat', [
      _level(CourseLevel.beginner, 'Easy fat loss start', _names([
        'Jumping Jacks','High Knees','Butt Kicks','Mountain Climbers','Skater Jumps',
        'Bear Crawl','Burpees','Step-Ups','Squats','Lunges','Arm Circles','Plank',
        'Cat-Cow Stretch','Child\'s Pose','Toe Touches',
      ])),
      _level(CourseLevel.intermediate, 'Fast fat burn', _names([
        'Burpees','Jumping Jacks','High Knees','Butt Kicks','Mountain Climbers',
        'Crossbody Mountain Climber','Skater Jumps','Jump Squats','Squat Pulses',
        'Forward Running','Backward Running','Band Sprint','Agility Ladder Drill',
        'Stair Climber','Battle Rope','Bear Crawl','Sprawl Exercise','Shadow Boxing',
        'Push-Ups','Plank',
      ])),
      _level(CourseLevel.advanced, 'Extreme fat burn', _names([
        'Burpees','Jumping Jacks','High Knees','Butt Kicks','Mountain Climbers',
        'Crossbody Mountain Climber','Skater Jumps','Jump Squats','Squat Pulses',
        'Forward Running','Backward Running','Band Sprint','Agility Ladder Drill',
        'Stair Climber','Battle Rope','Bear Crawl','Sprawl Exercise','Shrimping Exercise',
        'Shadow Boxing','Side Shuffle','Duck Walk',
      ])),
    ]),
    _course('Belly Fat Destroyer', '🧨', 'Belly fat remove + flat stomach', 'fat', [
      _level(CourseLevel.beginner, 'Core activation', _names([
        'Crunches','Bicycle Crunches','Heel Touches','Flutter Kicks','Plank',
        'Dead Bug','Bird Dog','Leg Raises','Cat-Cow Stretch','Child\'s Pose',
        'Toe Touches','Cross Crunches','Starfish Crunch','Knee Plank','Scissors',
      ])),
      _level(CourseLevel.intermediate, 'Visible abs', _names([
        'Crunches','Bicycle Crunches','Cross Crunches','Reverse Crunches',
        'Hanging Knee Raise','V-Sit Hold','Leg Raises','Flutter Kicks','Scissors',
        'Russian Twists','Heel Touches','Starfish Crunch','Plank','Weighted Plank',
        'Plank Hip Dips','Elbow Plank Rotation','Knee to Elbow Crunch','Dead Bug',
        'Bird Dog','Double Knees to Chest',
      ])),
      _level(CourseLevel.advanced, 'Six pack abs', _names([
        'Crunches','Bicycle Crunches','Cross Crunches','Reverse Crunches',
        'Resistance Band Reverse Crunch','Hanging Knee Raise','V-Sit Hold','Leg Raises',
        'Flutter Kicks','Scissors','Russian Twists','Heel Touches','Starfish Crunch',
        'Plank','Weighted Plank','Plank Hip Dips','Elbow Plank Rotation',
        'Knee to Elbow Crunch','Dead Bug','Double Knees to Chest',
      ])),
    ]),
    _course('Cardio Blast', '⚡', 'Stamina + endurance + fat loss', 'fat', [
      _level(CourseLevel.beginner, 'Base stamina', _names([
        'Jumping Jacks','High Knees','Butt Kicks','Skipping','Stair Climber',
        'Walking Lunges','Arm Circles','Marching','Squats','Step-Ups',
        'Cat-Cow Stretch','Child\'s Pose','Shoulder Stretch','Toe Touches','Plank',
      ])),
      _level(CourseLevel.intermediate, 'Fight endurance', _names([
        'Forward Running','Backward Running','High Knees','Butt Kicks','Skipping',
        'Band Sprint','Banded Run','Stair Climber','Agility Ladder Drill',
        'Side Shuffle','Side Shuttle','Duck Walk','Side Hop','Skater Jumps',
        'Bear Crawl','Battle Rope','Shadow Boxing','Punch Combos',
      ])),
      _level(CourseLevel.advanced, 'Extreme stamina', _names([
        'Forward Running','Backward Running','High Knees','Butt Kicks','Skipping',
        'Band Sprint','Banded Run','Stair Climber','Agility Ladder Drill',
        'Side Shuffle','Side Shuttle','Duck Walk','Side Hop','Skater Jumps',
        'Bear Crawl','Battle Rope','Shadow Boxing','Punch Combos',
      ])),
    ]),
    _course('Full Body Fat Melt', '🧱', 'Fat loss + muscle toning', 'fat', [
      _level(CourseLevel.beginner, 'Body activation', _names([
        'Push-Ups','Squats','Lunges','Step-Ups','Hip Bridge','Plank',
        'Bird Dog','Dead Bug','Superman','Arm Circles','Cat-Cow Stretch',
        'Child\'s Pose','Toe Touches','Shoulder Stretch','Jumping Jacks',
      ])),
      _level(CourseLevel.intermediate, 'Toning + strength', _names([
        'Push-Ups','Incline Push-Ups','Knee Push-Ups','Diamond Push-Ups',
        'Squats','Dumbbell Squat','Lunges','Split Squat','Bulgarian Split Squat',
        'Step-Ups','Hip Bridge','Hip Thrusts','Romanian Deadlift','Calf Raises',
        'Single Leg Box Squat','Bear Crawl','Bird Dog','Dead Bug','Superman',
        'Push-Up Shoulder Tap',
      ])),
      _level(CourseLevel.advanced, 'Full body power', _names([
        'Push-Ups','Incline Push-Ups','Diamond Push-Ups','Push-Up Shoulder Tap',
        'Squats','Dumbbell Squat','Lunges','Split Squat','Bulgarian Split Squat',
        'Step-Ups','Hip Thrusts','Romanian Deadlift','Calf Raises',
        'Single Leg Box Squat','Bear Crawl','Bird Dog','Dead Bug','Superman',
        'Burpees','Mountain Climbers',
      ])),
    ]),
    _course('Beginner Fat Loss', '🧠', 'Beginners easy start', 'fat', [
      _level(CourseLevel.beginner, 'Easy fat loss', _names([
        'Jumping Jacks','High Knees','Wall Sit','Squats','Lunges','Step-Ups',
        'Toe Touches','Butterfly Stretch','Arm Circles','Shoulder Stretch',
        'Cat-Cow Stretch','Child\'s Pose','Plank','Knee Push-Ups','Heel Touches',
      ])),
    ]),
  ];

  // ═══════════════════════════════════════
  //  FIT BODY-TYPE COURSES (6)
  // ═══════════════════════════════════════
  static final fitCourses = <GymCourseInfo>[
    _course('Athletic Body Builder', '🦸', 'Strong + athletic body', 'fit', [
      _level(CourseLevel.beginner, 'Foundation', _names([
        'Push-Ups','Squats','Lunges','Step-Ups','Plank','Bird Dog','Dead Bug',
        'Superman','Arm Circles','Cat-Cow Stretch','Child\'s Pose','Jumping Jacks',
        'Shoulder Stretch','Toe Touches','Hip Bridge',
      ])),
      _level(CourseLevel.intermediate, 'Athletic growth', _names([
        'Push-Ups','Incline Push-Ups','Diamond Push-Ups','Staggered Push-Ups',
        'Push-Up Shoulder Tap','Squats','Squat Pulses','Lunges','Split Squat',
        'Bulgarian Split Squat','Step-Ups','Dumbbell Squat','Hip Bridge','Hip Thrusts',
        'Romanian Deadlift','Calf Raises','Bear Crawl','Bird Dog','Dead Bug',
        'Superman','Single Leg Box Squat','Side Lunges','Curtsy Lunges','Duck Walk',
      ])),
      _level(CourseLevel.advanced, 'Full athlete', _names([
        'Push-Ups','Incline Push-Ups','Diamond Push-Ups','Staggered Push-Ups',
        'Push-Up Shoulder Tap','Squats','Squat Pulses','Lunges','Split Squat',
        'Bulgarian Split Squat','Step-Ups','Dumbbell Squat','Hip Bridge','Hip Thrusts',
        'Romanian Deadlift','Calf Raises','Bear Crawl','Bird Dog','Dead Bug',
        'Superman','Single Leg Box Squat','Side Lunges','Curtsy Lunges','Duck Walk',
      ])),
    ]),
    _course('Speed & Agility', '⚡', 'Speed + coordination + quick movement', 'fit', [
      _level(CourseLevel.intermediate, 'Agility build', _names([
        'Agility Ladder Drill','High Knees','Butt Kicks','Side Shuffle',
        'Side Shuttle','Side Hop','Skater Jumps','Band Sprint','Banded Run',
        'Forward Running','Backward Running','Duck Walk','Shadow Boxing',
        'Punch Combos','Fast Spider Lunges','Jump Squats','Mountain Climbers',
        'Crossbody Mountain Climber','Stair Climber',
      ])),
    ]),
    _course('Core of Steel', '🧠', 'Strong core + balance', 'fit', [
      _level(CourseLevel.intermediate, 'Core strength', _names([
        'Crunches','Bicycle Crunches','Cross Crunches','Reverse Crunches',
        'Hanging Knee Raise','V-Sit Hold','Leg Raises','Flutter Kicks',
        'Scissors','Russian Twists','Heel Touches','Starfish Crunch',
        'Plank','Weighted Plank','Side Plank','T-Plank','Plank Hip Dips',
        'Elbow Plank Rotation','Dead Bug','Bird Dog','Diagonal Plank',
      ])),
    ]),
    _course('Hero Physique', '🦸‍♂️', 'Good looking V-shape body', 'fit', [
      _level(CourseLevel.intermediate, 'V-shape build', _names([
        'Push-Ups','Decline Push-Ups','Diamond Push-Ups','Chest Dips',
        'Dumbbell Press','Cable Press','Butterfly Cable Press','Dumbbell Row',
        'One Arm Dumbbell Row','Bent Over Row','Pull-Ups','Wide Grip Pull-Ups',
        'Reverse Grip Pull-Ups','Dumbbell Curl','Standing Dumbbell Curl',
        'Preacher Curl','Overhead Press','Arnold Press','Lateral Raise',
        'Rear Delt Fly',
      ])),
    ]),
    _course('Mobility Pro', '🧘', 'Flexible + injury-free body', 'fit', [
      _level(CourseLevel.beginner, 'Flexibility start', _names([
        'Butterfly Stretch','Side Split Stretch','Toe Touches','Hamstring Stretch',
        'Cobra Stretch','Child\'s Pose','Cat-Cow Stretch','Pigeon Stretch',
        'Thoracic Rotation','Wall Angels','Deep Squat Hold','Piriformis Stretch',
        'Kneeling Lunge Stretch','Calf Stretch','Shoulder Stretch','Floor Slides',
        'Floor Y Raises',
      ])),
    ]),
    _course('Strength+Endurance Hybrid', '🧱', 'Strength + stamina combo', 'fit', [
      _level(CourseLevel.intermediate, 'Hybrid power', _names([
        'Push-Ups','Squats','Lunges','Jump Squats','Burpees','Mountain Climbers',
        'Battle Rope','Bear Crawl','Stair Climber','Running','High Knees',
        'Skater Jumps','Side Shuffle','Romanian Deadlift','Hip Thrusts',
        'Dumbbell Row','Plank','Side Plank','V-Sit Hold',
      ])),
    ]),
  ];

  // ═══════════════════════════════════════
  //  LEAN BODY-TYPE COURSES (6)
  // ═══════════════════════════════════════
  static final leanCourses = <GymCourseInfo>[
    _course('Muscle Builder Pro', '💪', 'Full body muscle gain', 'lean', [
      _level(CourseLevel.intermediate, 'Muscle growth', _names([
        'Barbell Squat','Dumbbell Squat','Romanian Deadlift','Hip Thrusts',
        'Dumbbell Row','One Arm Dumbbell Row','Bent Over Row','Landmine Row',
        'Pull-Ups','Wide Grip Pull-Ups','Reverse Grip Pull-Ups','Dumbbell Curl',
        'Standing Dumbbell Curl','Preacher Curl','Concentration Curl',
        'Dumbbell Tricep Extension','Tricep Kickbacks','Tricep Dips','Chest Press',
        'Cable Press','Butterfly Cable Press','Push-Ups','Decline Push-Ups',
      ])),
    ]),
    _course('Ritik Roshan Aesthetic', '🦸‍♂️', 'V-shape + aesthetic body', 'lean', [
      _level(CourseLevel.intermediate, 'Aesthetic build', _names([
        'Overhead Press','Arnold Press','Dumbbell Front Raise','Lateral Raise',
        'Side Lateral Raise','Rear Delt Fly','Dumbbell Rear Delt Row',
        'Upright Row','Dumbbell Upright Row','Shoulder Gators',
        'Resistance Band Shoulder','Push-Ups','Chest Dips','Cable Press',
        'Butterfly Cable Press','Dumbbell Row','Pull-Ups','Dumbbell Curl',
        'Preacher Curl',
      ])),
    ]),
    _course('Chest+Arms Bulker', '🧱', 'Chest + biceps + triceps growth', 'lean', [
      _level(CourseLevel.intermediate, 'Upper body mass', _names([
        'Push-Ups','Incline Push-Ups','Decline Push-Ups','Diamond Push-Ups',
        'Staggered Push-Ups','Hindu Push-Ups','Chest Dips','Cable Press',
        'Cross Grip Dumbbell Press','Dumbbell Curl','Standing Dumbbell Curl',
        'Preacher Curl','Concentration Curl','Hammer Curls','Dumbbell Tricep Extension',
        'Tricep Kickbacks','Tricep Dips','Floor Tricep Dips',
      ])),
    ]),
    _course('Leg Power Builder', '🦵', 'Thick legs + power', 'lean', [
      _level(CourseLevel.intermediate, 'Leg mass', _names([
        'Barbell Squat','Dumbbell Squat','Romanian Deadlift','Hip Thrusts',
        'Lunges','Split Squat','Bulgarian Split Squat','Step-Ups','Jump Squats',
        'Squat Pulses','Calf Raises','Barbell Calf Raise','Single Leg Box Squat',
        'Curtsy Lunges','Duck Walk','Side Lunges',
      ])),
    ]),
    _course('Core+Strength Bulk', '🧠', 'Strong abs + core thickness', 'lean', [
      _level(CourseLevel.intermediate, 'Core power', _names([
        'Crunches','Bicycle Crunches','Reverse Crunches','Hanging Knee Raise',
        'V-Sit Hold','Leg Raises','Flutter Kicks','Russian Twists','Heel Touches',
        'Starfish Crunch','Plank','Weighted Plank','Side Plank','T-Plank',
        'Plank Hip Dips','Dead Bug','Bird Dog',
      ])),
    ]),
    _course('Upper Body Strength', '🏋️', 'Strong upper body', 'lean', [
      _level(CourseLevel.intermediate, 'Pull + push master', _names([
        'Pull-Ups','Wide Grip Pull-Ups','Reverse Grip Pull-Ups','Dumbbell Row',
        'One Arm Dumbbell Row','Bent Over Row','Landmine Row','Push-Ups',
        'Decline Push-Ups','Diamond Push-Ups','Chest Dips','Shoulder Press',
        'Arnold Press','Lateral Raise','Rear Delt Fly','Dumbbell Curl',
        'Preacher Curl','Tricep Dips',
      ])),
    ]),
  ];

  // ═══════════════════════════════════════
  //  COMMON FOCUS-AREA COURSES (9)
  // ═══════════════════════════════════════
  static final commonFocusCourses = <GymCourseInfo>[
    _focusCourse('Chest Builder', '💪', 'chest', null, [
      _level(CourseLevel.beginner, 'Chest activation', _names([
        'Wall Push-Ups','Incline Push-Ups','Knee Push-Ups','Bench Push-Ups',
        'Push-Ups','Push-Up Hold','Plank Up & Down','Knee Plank',
        'Push-Up Shoulder Tap','Arm Raises','Arm Circles','Arm Scissors',
        'Chest Stretch','Shoulder Stretch','Floor Slides','Shoulder Gators',
        'Cobra Stretch','Cat-Cow Stretch',
      ])),
      _level(CourseLevel.intermediate, 'Chest growth', _names([
        'Push-Ups','Incline Push-Ups','Decline Push-Ups','Diamond Push-Ups',
        'Staggered Push-Ups','Spiderman Push-Ups','Hindu Push-Ups','Push-Up & Rotation',
        'Push-Up Shoulder Tap','Military Push-Ups','Pike Push-Ups','Offset Push-Ups',
        'Cross Grip Dumbbell Press','Dumbbell Press','Cable Press','Butterfly Cable Press',
        'Chest Dips','Push-Up Hold','Plank Up & Down','T-Plank',
        'Dumbbell Punches','Resistance Band Chest Press','Incline Push-Up Hold',
        'Close Grip Push-Ups','Partial Push-Ups',
      ])),
      _level(CourseLevel.advanced, 'Full chest power', _names([
        'Decline Push-Ups','Diamond Push-Ups','Staggered Push-Ups','Spiderman Push-Ups',
        'Hindu Push-Ups','Military Push-Ups','Pike Push-Ups','Offset Push-Ups',
        'Clapping Push-Ups','Jumping Push-Ups','Chest Dips','Weighted Dips',
        'Cable Press','Butterfly Cable Press','Cross Grip Dumbbell Press',
        'Dumbbell Press','Resistance Band Chest Press','Push-Up Shoulder Tap',
        'Plank Up & Down','T-Plank','Weighted Plank','Side Plank','Plank Hip Dips',
        'Push-Up Hold','Decline Push-Up Hold','Slow Tempo Push-Ups',
        'Chest Stretch','Cobra Stretch','Shoulder Stretch','Cat-Cow Stretch',
      ])),
    ]),
    _focusCourse('Shoulder Builder', '🦸‍♂️', 'shoulders', null, [
      _level(CourseLevel.beginner, 'Shoulder mobility', _names([
        'Arm Circles','Arm Raises','Arm Scissors','Wall Angels','Shoulder Stretch',
        'Shoulder Gators','Resistance Band Shoulder','Floor Slides','Floor Y Raises',
        'Dumbbell Front Raise','Single Arm Front Raise','Dumbbell Punches',
        'Plank Shoulder Tap','Knee Plank','Chest Stretch','Cat-Cow Stretch',
        'Neck Stretch','Cobra Stretch',
      ])),
      _level(CourseLevel.intermediate, 'Shoulder shape', _names([
        'Overhead Press','Arnold Press','Military Press','Dumbbell Front Raise',
        'Single Arm Front Raise','Lateral Raise','Side Lateral Raise','Rear Delt Fly',
        'Dumbbell Rear Delt Row','Upright Row','W Press','Resistance Band Shoulder',
        'Dumbbell Punches','Pike Push-Ups','Push-Up Shoulder Tap','Plank Up & Down',
        'T-Plank','Shoulder Gators','Wall Angels','Floor Y Raises',
      ])),
      _level(CourseLevel.advanced, 'Full shoulder power', _names([
        'Overhead Press','Military Press','Arnold Press','Single Arm Press',
        'Dumbbell Front Raise','Lateral Raise','Side Lateral Raise',
        'Rear Delt Fly','Dumbbell Rear Delt Row','Rhomboid Pulls',
        'Dumbbell Punches','Battle Rope','Shadow Boxing','Pike Push-Ups',
        'Push-Up Shoulder Tap','Plank Up & Down','T-Plank','Side Plank',
        'Wall Angels','Shoulder Gators','Floor Slides','Floor Y Raises',
        'Thoracic Rotation','Shoulder Stretch',
      ])),
    ]),
    _focusCourse('Back Builder', '🧱', 'back', null, [
      _level(CourseLevel.beginner, 'Posture fix', _names([
        'Superman','Bird Dog','Dead Bug','Wall Angels','Floor Slides','Floor Y Raises',
        'Cat-Cow Stretch','Cobra Stretch','Child\'s Pose','Shoulder Stretch',
        'Thoracic Rotation','Back Extension','Hyperextension','Hip Hinge',
        'Chest Stretch','Kneeling Back Extension',
      ])),
      _level(CourseLevel.intermediate, 'Back width', _names([
        'Dumbbell Row','One Arm Row','Bent Over Row','Chest Supported Row',
        'Landmine Row','Pull-Ups','Wide Grip Pull-Ups','Reverse Grip Pull-Ups',
        'Dumbbell Rear Delt Row','Rhomboid Pulls','Superman','Bird Dog','Dead Bug',
        'Back Extension','Hyperextension','Shoulder Gators','Wall Angels',
        'Floor Y Raises','Plank','Side Plank',
      ])),
      _level(CourseLevel.advanced, 'V-shape back', _names([
        'Pull-Ups','Wide Grip Pull-Ups','Reverse Grip Pull-Ups','Dumbbell Row',
        'One Arm Row','Bent Over Row','Landmine Row','Chest Supported Row',
        'Dumbbell Rear Delt Row','Rear Delt Fly','Rhomboid Pulls',
        'Bear Crawl','Shrimping Exercise','Sprawl Exercise','Battle Rope',
        'Bird Dog','Dead Bug','Superman','Plank','Side Plank','T-Plank',
        'Wall Angels','Thoracic Rotation','Cat-Cow Stretch','Cobra Stretch',
        'Child\'s Pose','Back Extension','Hyperextension',
      ])),
    ]),
    _focusCourse('Arms Builder', '💪', 'arms', null, [
      _level(CourseLevel.beginner, 'Arms activation', _names([
        'Bicep Curls','Standing Dumbbell Curl','Alternating Dumbbell Curl',
        'Resistance Band Curl','Bench Dips','Assisted Tricep Dips','Tricep Kickbacks',
        'Arm Circles','Arm Raises','Arm Scissors','Wrist Curls','Forearm Stretch',
        'Shoulder Gators','Wall Angels','Plank','Cat-Cow Stretch','Child\'s Pose',
      ])),
      _level(CourseLevel.intermediate, 'Arms size', _names([
        'Standing Dumbbell Curl','Alternating Dumbbell Curl','Preacher Curl',
        'Concentration Curl','Incline Dumbbell Curl','Hammer Curls','Cross Body Curl',
        'Bench Dips','Tricep Dips','Dumbbell Tricep Extension',
        'Overhead Tricep Extension','Tricep Kickbacks','Close Grip Push-Ups',
        'Diamond Push-Ups','Push-Up Hold','Dumbbell Punches','Arm Circles',
        'Wrist Curls','Farmer Hold','Plank','Side Plank',
      ])),
      _level(CourseLevel.advanced, 'Big arms power', _names([
        'Standing Dumbbell Curl','Alternating Dumbbell Curl','Heavy Dumbbell Curl',
        'Incline Dumbbell Curl','Preacher Curl','Concentration Curl','Hammer Curls',
        'Cross Body Curl','Reverse Grip Curl','Tricep Dips','Weighted Dips',
        'Bench Dips','Close Grip Push-Ups','Diamond Push-Ups','Dumbbell Tricep Extension',
        'Overhead Tricep Extension','Tricep Kickbacks','Pull-Ups','Chin-Ups',
        'Battle Rope','Shadow Boxing','Dumbbell Punches','Wrist Curls',
        'Farmer Walk','Plank','Side Plank','Shoulder Stretch','Cat-Cow Stretch',
      ])),
    ]),
    _focusCourse('Core / Abs', '🧠', 'abs', null, [
      _level(CourseLevel.beginner, 'Core activation', _names([
        'Crunches','Bicycle Crunches','Heel Touches','Knee Plank','Plank',
        'Dead Bug','Bird Dog','Flutter Kicks','Scissors','Leg In-Out',
        'Cross Crunches','Starfish Crunch','Toe Touches','Cat-Cow Stretch','Child\'s Pose',
      ])),
      _level(CourseLevel.intermediate, 'Visible abs', _names([
        'Crunches','Bicycle Crunches','Reverse Crunches','Hanging Knee Raise',
        'V-Sit Hold','Leg Raises','Flutter Kicks','Scissors','Russian Twists',
        'Heel Touches','Starfish Crunch','Plank','Side Plank','T-Plank',
        'Plank Hip Dips','Elbow Plank Rotation','Knee to Elbow Crunch',
        'Dead Bug','Bird Dog','Diagonal Plank','Sit-Ups','In & Out',
      ])),
      _level(CourseLevel.advanced, '6-pack power', _names([
        'Hanging Knee Raise','V-Sit Hold','Leg Raises','Reverse Crunches',
        'Sit-Ups','Russian Twists','Side Plank','T-Plank','Oblique Crunch',
        'Heel Touches','Cross Crunches','Plank','Weighted Plank','Plank Hip Dips',
        'Elbow Plank Rotation','Diagonal Plank','Dead Bug','Bird Dog',
        'Flutter Kicks','Scissors','In & Out','Mountain Climbers',
        'Crossbody Mountain Climber','Cobra Stretch','Cat-Cow Stretch','Child\'s Pose',
      ])),
    ]),
    _focusCourse('Leg Power', '🦵', 'legs', null, [
      _level(CourseLevel.beginner, 'Leg foundation', _names([
        'Squats','Squat Pulses','Lunges','Step-Ups','Hip Bridge','Glute Bridge',
        'Donkey Kicks','Fire Hydrants','Side Leg Lifts','Calf Raises',
        'Wall Sit','Toe Touches','Butterfly Stretch','Cat-Cow Stretch','Duck Walk',
      ])),
      _level(CourseLevel.intermediate, 'Leg strength', _names([
        'Squats','Dumbbell Squat','Lunges','Split Squat','Bulgarian Split Squat',
        'Step-Ups','Hip Thrusts','Romanian Deadlift','Curtsy Lunges','Side Lunges',
        'Jump Squats','Squat Pulses','Calf Raises','Single Leg Box Squat',
        'Duck Walk','Skater Jumps','Stair Climber','High Knees','Butt Kicks',
        'Glute Kickback','Frog Pump',
      ])),
      _level(CourseLevel.advanced, 'Explosive legs', _names([
        'Barbell Squat','Dumbbell Squat','Romanian Deadlift','Hip Thrusts',
        'Split Squat','Bulgarian Split Squat','Step-Ups','Single Leg Box Squat',
        'Pistol Squats','Jump Squats','Bulgarian Split Squat Jump',
        'Kneeling Jump Squats','Skater Jumps','Side Hop','Forward Running',
        'Backward Running','Band Sprint','Stair Climber','High Knees',
        'Butt Kicks','Duck Walk','Side Shuffle','Bear Crawl','Hip Thrusts',
        'Glute Bridge','Frog Pump','Donkey Kicks','Fire Hydrants','Curtsy Lunges',
        'Wall Sit','Butterfly Stretch','Hamstring Stretch','Pigeon Stretch',
        'Calf Stretch',
      ])),
    ]),
    _focusCourse('Full Body', '🔥', 'full_body', null, [
      _level(CourseLevel.beginner, 'Full body start', _names([
        'Jumping Jacks','High Knees','Squats','Lunges','Step-Ups','Push-Ups',
        'Incline Push-Ups','Plank','Bird Dog','Dead Bug','Superman','Arm Circles',
        'Shoulder Stretch','Toe Touches','Cat-Cow Stretch','Child\'s Pose',
      ])),
      _level(CourseLevel.intermediate, 'Balanced fitness', _names([
        'Push-Ups','Incline Push-Ups','Decline Push-Ups','Squats','Dumbbell Squat',
        'Lunges','Split Squat','Step-Ups','Hip Bridge','Romanian Deadlift',
        'Burpees','Mountain Climbers','High Knees','Butt Kicks','Skater Jumps',
        'Bear Crawl','Plank','Side Plank','V-Sit Hold','Russian Twists',
        'Dead Bug','Bird Dog','Superman','Jump Squats',
      ])),
      _level(CourseLevel.advanced, 'Athlete mode', _names([
        'Push-Ups','Decline Push-Ups','Diamond Push-Ups','Squats','Dumbbell Squat',
        'Romanian Deadlift','Hip Thrusts','Lunges','Split Squat','Bulgarian Split Squat',
        'Burpees','Jump Squats','Clapping Push-Ups','Skater Jumps',
        'Mountain Climbers','Crossbody Mountain Climber','High Knees','Butt Kicks',
        'Forward Running','Backward Running','Agility Ladder Drill','Stair Climber',
        'Battle Rope','Bear Crawl','Sprawl Exercise','Duck Walk','Side Shuffle',
        'Plank','Weighted Plank','Side Plank','T-Plank','V-Sit Hold',
        'Hanging Knee Raise','Russian Twists','Leg Raises',
        'Toe Touches','Butterfly Stretch','Cobra Stretch','Cat-Cow Stretch',
      ])),
    ]),
    _focusCourse('Fat Burn', '🔥', 'fat_burn', null, [
      _level(CourseLevel.beginner, 'Low impact fat loss', _names([
        'Jumping Jacks','High Knees','Squats','Lunges','Step-Ups','Arm Circles',
        'Cat-Cow Stretch','Child\'s Pose','Plank','Knee Plank','Heel Touches',
        'Mountain Climbers','Duck Walk','Wall Sit','Toe Touches',
      ])),
      _level(CourseLevel.intermediate, 'HIIT fat loss', _names([
        'Burpees','Jumping Jacks','High Knees','Butt Kicks','Mountain Climbers',
        'Crossbody Mountain Climber','Skater Jumps','Jump Squats','Squat Pulses',
        'Lunges','Bear Crawl','Stair Climber','Forward Running','Backward Running',
        'Agility Ladder Drill','Battle Rope','Shadow Boxing','Push-Ups','Plank',
        'Side Plank','V-Sit Hold','Russian Twists','Dead Bug','Superman',
      ])),
      _level(CourseLevel.advanced, 'Extreme shred', _names([
        'Burpees','High Knees','Butt Kicks','Mountain Climbers','Crossbody Mountain Climber',
        'Jumping Jacks','Forward Running','Backward Running','Band Sprint','Stair Climber',
        'Jump Squats','Bulgarian Split Squat Jump','Skater Jumps','Side Hop',
        'Kneeling Jump Squats','Agility Ladder Drill','Bear Crawl','Sprawl Exercise',
        'Duck Walk','Side Shuffle','Battle Rope','Push-Ups','Decline Push-Ups',
        'Squats','Lunges','Step-Ups','Romanian Deadlift','Hip Thrusts',
        'Plank','Weighted Plank','Side Plank','V-Sit Hold','Hanging Knee Raise',
        'Russian Twists','Leg Raises','Toe Touches','Butterfly Stretch',
        'Cobra Stretch','Cat-Cow Stretch','Child\'s Pose',
      ])),
    ]),
    _focusCourse('Mobility & Flexibility', '🧘', 'mobility', null, [
      _level(CourseLevel.beginner, 'Flexibility start', _names([
        'Toe Touches','Butterfly Stretch','Hamstring Stretch','Cobra Stretch',
        'Child\'s Pose','Cat-Cow Stretch','Shoulder Stretch','Chest Stretch',
        'Arm Circles','Arm Raises','Neck Stretch','Calf Stretch',
        'Knee to Chest Stretch','Lying Butterfly Stretch','Adductor Stretch',
        'Piriformis Stretch','Deep Breathing',
      ])),
      _level(CourseLevel.intermediate, 'Mobility control', _names([
        'Deep Squat Hold','Side Split Stretch','Pigeon Stretch','Kneeling Lunge Stretch',
        'Thoracic Rotation','Wall Angels','Floor Slides','Floor Y Raises',
        'Shoulder Gators','Cobra Stretch','Cat-Cow Stretch','Child\'s Pose',
        'Hip Hinge','Back Extension','Kneeling Back Extension','Supine Spinal Twist',
        'Adductor Stretch','Hamstring Stretch','Calf Stretch','Arm Circles',
      ])),
      _level(CourseLevel.advanced, 'Athlete mobility', _names([
        'Deep Squat Hold','Side Split Stretch','Pigeon Stretch','Kneeling Lunge Stretch',
        'Hamstring Stretch','Toe Touches','Adductor Stretch','Piriformis Stretch',
        'Calf Stretch','Cat-Cow Stretch','Cobra Stretch','Child\'s Pose',
        'Thoracic Rotation','Supine Spinal Twist','Back Extension',
        'Kneeling Back Extension','Wall Angels','Shoulder Gators','Floor Slides',
        'Floor Y Raises','Arm Circles','Bird Dog','Dead Bug','Plank',
        'Side Plank','Squat Mobility Complex',
      ])),
    ]),
  ];

  // ═══════════════════════════════════════
  //  MALE-SPECIFIC FOCUS COURSES (7)
  // ═══════════════════════════════════════
  static final maleFocusCourses = <GymCourseInfo>[
    _focusCourse('V-Shape Physique', '🦸‍♂️', 'v_shape', 'male', [
      _level(CourseLevel.intermediate, 'V-shape build', _names([
        'Pull-Ups','Wide Grip Pull-Ups','Reverse Grip Pull-Ups','Dumbbell Row',
        'One Arm Row','Bent Over Row','Landmine Row','Overhead Press','Arnold Press',
        'Lateral Raise','Side Lateral Raise','Rear Delt Fly','Dumbbell Rear Delt Row',
        'Plank','Side Plank','Bird Dog','Superman','Shoulder Gators','Wall Angels',
      ])),
    ]),
    _focusCourse('Wide Back', '🧱', 'wide_back', 'male', [
      _level(CourseLevel.intermediate, 'Lat width', _names([
        'Pull-Ups','Wide Grip Pull-Ups','Reverse Grip Pull-Ups','Dumbbell Row',
        'One Arm Row','Bent Over Row','Landmine Row','Chest Supported Row',
        'Face Pull','Dumbbell Rear Delt Row','Superman','Bird Dog','Dead Bug',
        'Back Extension','Hyperextension','Shoulder Gators','Wall Angels',
        'Floor Y Raises','Plank','Side Plank',
      ])),
    ]),
    _focusCourse('Big Arms', '💪', 'big_arms', 'male', [
      _level(CourseLevel.intermediate, 'Arms mass', _names([
        'Standing Dumbbell Curl','Alternating Curl','Preacher Curl',
        'Concentration Curl','Hammer Curls','Bench Dips','Tricep Dips',
        'Dumbbell Tricep Extension','Overhead Tricep Extension','Tricep Kickbacks',
        'Close Grip Push-Ups','Diamond Push-Ups','Wrist Curls','Farmer Hold',
        'Dumbbell Punches','Pull-Ups','Chin-Ups','Plank','Side Plank',
      ])),
    ]),
    _focusCourse('Chest Thickness', '💪', 'chest_thick', 'male', [
      _level(CourseLevel.intermediate, 'Thick chest', _names([
        'Push-Ups','Decline Push-Ups','Diamond Push-Ups','Staggered Push-Ups',
        'Hindu Push-Ups','Chest Dips','Dumbbell Press','Cross Grip Press',
        'Cable Press','Butterfly Cable Press','Push-Up Hold','Incline Push-Up Hold',
        'T-Plank','Plank Up & Down','Close Grip Push-Ups','Partial Push-Ups',
      ])),
    ]),
    _focusCourse('Upper Body Strength', '💥', 'upper_strength', 'male', [
      _level(CourseLevel.intermediate, 'Push + pull power', _names([
        'Push-Ups','Decline Push-Ups','Diamond Push-Ups','Pull-Ups',
        'Wide Grip Pull-Ups','Dumbbell Row','One Arm Row','Bent Over Row',
        'Overhead Press','Arnold Press','Lateral Raise','Rear Delt Fly',
        'Chest Dips','Tricep Dips','Close Grip Push-Ups','Dumbbell Curl',
        'Hammer Curls','Plank','Side Plank','Farmer Hold',
      ])),
    ]),
    _focusCourse('Muscle Mass Gain', '🏋️', 'mass_gain', 'male', [
      _level(CourseLevel.intermediate, 'Full bulk', _names([
        'Push-Ups','Decline Push-Ups','Diamond Push-Ups','Dumbbell Press',
        'Cable Press','Squats','Dumbbell Squat','Lunges','Split Squat',
        'Bulgarian Split Squat','Hip Thrusts','Romanian Deadlift','Pull-Ups',
        'Dumbbell Row','One Arm Row','Bent Over Row','Overhead Press','Arnold Press',
        'Lateral Raise','Rear Delt Fly','Dumbbell Curl','Hammer Curls',
        'Preacher Curl','Tricep Dips','Dumbbell Tricep Extension','Plank',
        'Side Plank','Dead Bug','Superman',
      ])),
    ]),
    _focusCourse('Athletic Fighter Body', '🥊', 'fighter_body', 'male', [
      _level(CourseLevel.intermediate, 'Fighter conditioning', _names([
        'Burpees','Jump Squats','Mountain Climbers','Crossbody Mountain Climber',
        'Skater Jumps','Shadow Boxing','Punch Combos','Battle Rope','Bear Crawl',
        'Sprawl Exercise','Shrimping Exercise','Push-Ups','Decline Push-Ups',
        'Pull-Ups','Dumbbell Row','Overhead Press','Squats','Lunges',
        'Romanian Deadlift','Plank','Side Plank','V-Sit Hold','Russian Twists',
        'High Knees','Butt Kicks','Stair Climber','Duck Walk',
      ])),
    ]),
  ];

  // ═══════════════════════════════════════
  //  FEMALE-SPECIFIC FOCUS COURSES (6)
  // ═══════════════════════════════════════
  static final femaleFocusCourses = <GymCourseInfo>[
    _focusCourse('Glutes Builder', '🍑', 'glutes', 'female', [
      _level(CourseLevel.intermediate, 'Glute shape', _names([
        'Hip Thrusts','Glute Bridge','Single Leg Glute Bridge','Dumbbell Squat',
        'Squats','Lunges','Split Squat','Bulgarian Split Squat','Step-Ups',
        'Curtsy Lunges','Frog Pump','Donkey Kicks','Fire Hydrants','Glute Kickback',
        'Side Lunges','Romanian Deadlift','Calf Raises','Duck Walk','Stair Climber',
        'Jump Squats','Squat Pulses','Plank','Side Plank','Dead Bug','Bird Dog',
        'Hamstring Stretch','Pigeon Stretch',
      ])),
    ]),
    _focusCourse('Slim & Toned Legs', '🦵', 'slim_legs', 'female', [
      _level(CourseLevel.intermediate, 'Leg toning', _names([
        'Squats','Squat Pulses','Lunges','Split Squat','Step-Ups','Side Lunges',
        'Curtsy Lunges','Skater Jumps','Jump Squats','Stair Climber','Duck Walk',
        'Calf Raises','Romanian Deadlift','Glute Bridge','Hip Thrusts',
        'Fire Hydrants','Donkey Kicks','Plank','Side Plank','Dead Bug','Bird Dog',
        'Hamstring Stretch','Pigeon Stretch','Butterfly Stretch',
      ])),
    ]),
    _focusCourse('Flat Belly', '🔥', 'flat_belly', 'female', [
      _level(CourseLevel.intermediate, 'Core toning', _names([
        'Crunches','Bicycle Crunches','Reverse Crunches','Hanging Knee Raise',
        'V-Sit Hold','Leg Raises','Flutter Kicks','Scissors','Russian Twists',
        'Heel Touches','Starfish Crunch','Plank','Side Plank','T-Plank',
        'Plank Hip Dips','Elbow Plank Rotation','Knee to Elbow Crunch',
        'Dead Bug','Bird Dog','Mountain Climbers','Crossbody Mountain Climber',
        'High Knees','Jumping Jacks','Cat-Cow Stretch','Child\'s Pose',
      ])),
    ]),
    _focusCourse('Toned Arms', '💪', 'toned_arms', 'female', [
      _level(CourseLevel.intermediate, 'Arm toning', _names([
        'Standing Dumbbell Curl','Alternating Curl','Hammer Curls',
        'Bench Dips','Tricep Dips','Dumbbell Tricep Extension',
        'Overhead Tricep Extension','Tricep Kickbacks','Close Grip Push-Ups',
        'Diamond Push-Ups','Push-Up Hold','Dumbbell Punches','Arm Circles',
        'Arm Raises','Wrist Curls','Farmer Hold','Plank','Side Plank',
        'Dead Bug','Bird Dog','Shoulder Gators','Cat-Cow Stretch','Child\'s Pose',
      ])),
    ]),
    _focusCourse('Slim & Fit Body', '🌸', 'slim_fit', 'female', [
      _level(CourseLevel.intermediate, 'Full body tone', _names([
        'Squats','Squat Pulses','Lunges','Split Squat','Step-Ups','Hip Bridge',
        'Glute Bridge','Push-Ups','Incline Push-Ups','Plank','Side Plank',
        'Dead Bug','Bird Dog','Russian Twists','Heel Touches','Jumping Jacks',
        'High Knees','Butt Kicks','Skater Jumps','Stair Climber','Dumbbell Squat',
        'Tricep Dips','Arm Circles','Pigeon Stretch','Hamstring Stretch',
        'Butterfly Stretch',
      ])),
    ]),
    _focusCourse('Lower Body Shape', '💃', 'lower_shape', 'female', [
      _level(CourseLevel.intermediate, 'Thigh + glutes shape', _names([
        'Squats','Squat Pulses','Lunges','Split Squat','Bulgarian Split Squat',
        'Step-Ups','Hip Thrusts','Romanian Deadlift','Curtsy Lunges','Side Lunges',
        'Jump Squats','Skater Jumps','Calf Raises','Single Leg Glute Bridge',
        'Frog Pump','Donkey Kicks','Fire Hydrants','Glute Kickback',
        'Plank','Side Plank','Dead Bug','Bird Dog','Hamstring Stretch',
        'Pigeon Stretch','Butterfly Stretch',
      ])),
    ]),
  ];

  // ── Helper Constructors ──
  static GymCourseInfo _course(String name, String emoji, String goal, String bodyType, List<CourseLevelData> levels) =>
    GymCourseInfo(name: name, emoji: emoji, goal: goal, bodyType: bodyType, levels: levels);

  static GymCourseInfo _focusCourse(String name, String emoji, String focusArea, String? gender, List<CourseLevelData> levels) =>
    GymCourseInfo(name: name, emoji: emoji, goal: '', focusArea: focusArea, genderFilter: gender, levels: levels);

  static CourseLevelData _level(CourseLevel level, String goal, List<CourseExercise> exercises) =>
    CourseLevelData(level: level, goal: goal, exercises: exercises);

  static List<CourseExercise> _names(List<String> names) =>
    names.map((n) => CourseExercise(name: n, durationSeconds: _autoDuration(n))).toList();

  /// Assigns realistic durations based on exercise type
  static int _autoDuration(String name) {
    final lower = name.toLowerCase();
    // Short burst / cardio exercises
    if (lower.contains('jump') || lower.contains('burpee') ||
        lower.contains('high knee') || lower.contains('butt kick') ||
        lower.contains('skater') || lower.contains('shuffle') ||
        lower.contains('hop') || lower.contains('sprint') ||
        lower.contains('agility') || lower.contains('skipping')) {
      return 30;
    }
    // Stretches / holds
    if (lower.contains('stretch') || lower.contains('pose') ||
        lower.contains('hold') || lower.contains('sit') ||
        lower.contains('butterfly') || lower.contains('pigeon') ||
        lower.contains('deep squat hold') || lower.contains('angels') ||
        lower.contains('breathing') || lower.contains('twist')) {
      return 40;
    }
    // Plank variations
    if (lower.contains('plank')) return 45;
    // Running / battle rope
    if (lower.contains('running') || lower.contains('battle rope') ||
        lower.contains('shadow box') || lower.contains('punch')) {
      return 60;
    }
    // Standard strength exercises
    if (lower.contains('push') || lower.contains('pull') ||
        lower.contains('curl') || lower.contains('press') ||
        lower.contains('dip') || lower.contains('row') ||
        lower.contains('raise') || lower.contains('fly')) {
      return 35;
    }
    // Compound lower body
    if (lower.contains('squat') || lower.contains('lunge') ||
        lower.contains('deadlift') || lower.contains('thrust') ||
        lower.contains('bridge') || lower.contains('step')) {
      return 40;
    }
    // Core exercises
    if (lower.contains('crunch') || lower.contains('leg raise') ||
        lower.contains('flutter') || lower.contains('scissor') ||
        lower.contains('dead bug') || lower.contains('bird dog') ||
        lower.contains('superman')) {
      return 30;
    }
    // Default
    return 30;
  }
}
