import '../models/ufc_model.dart';

/// Full UFC Training Data — Dagestani (5 courses) + Irish (8 courses)
/// Each course has 6 training days + 1 rest day
class UFCData {
  static List<UFCCourse> getDagestaniCourses() => [
    wrestlingFundamentals, grapplingMastery, pressureTraining,
    cardioBeastMode, defensiveFighting,
  ];

  static List<UFCCourse> getIrishCourses() => [
    kickboxingFundamentals, strikingPrecision, powerExplosiveness,
    fightIQMovement, defensiveStriking, cardioFightConditioning,
    boneStrengthPower, dodgeSpeedReflex,
  ];

  // ═══════════════════════════════════════
  // DAGESTANI COURSES
  // ═══════════════════════════════════════

  static final wrestlingFundamentals = UFCCourse(
    name: 'Wrestling Fundamentals', description: 'Takedown + Clinch + Ground Control',
    style: UFCStyle.dagestani, level: 'Beginner → Intermediate', duration: '2 Weeks',
    days: [
      _day(1, 'Takedown Power', [
        _ex('Sprawl Exercise', 4, '12 reps'), _ex('Bear Crawl', 4, '25 sec'),
        _ex('Duck Walk', 4, '20 steps'), _ex('Forward Lunge', 3, '15 each'),
        _ex('Squats', 4, '15 reps'), _ex('Jump Squats', 3, '12 reps'),
        _ex('High Knees', 3, '30 sec'),
      ]),
      _day(2, 'Clinch Strength', [
        _ex('Wall Sit', 4, '45 sec'), _ex('Weighted Plank', 4, '35 sec'),
        _ex('Dumbbell Row', 4, '12 reps'), _ex('Shoulder Press', 3, '12 reps'),
        _ex('Tricep Dips', 3, '15 reps'), _ex('Shrugs', 3, '15 reps'),
        _ex('Farmer Hold', 3, '40 sec'),
      ]),
      _day(3, 'Ground Control', [
        _ex('Shrimping Exercise', 4, '20 reps'), _ex('Bird Dog', 3, '15 reps'),
        _ex('Glute Bridge', 4, '15 reps'), _ex('Back Extension', 3, '15 reps'),
        _ex('Plank', 4, '40 sec'), _ex('Side Plank', 3, '30 sec each'),
        _ex('Dead Bug', 3, '15 reps'),
      ]),
      _day(4, 'Wrestling Conditioning', [
        _ex('Mountain Climber', 4, '40 sec'), _ex('Battle Rope', 4, '30 sec'),
        _ex('Jumping Jacks', 3, '50 sec'), _ex('Burpees', 4, '12 reps'),
        _ex('Stair Climber', 1, '6 min'), _ex('Skipping', 3, '60 sec'),
      ]),
      _day(5, 'Pressure Training', [
        _ex('Duck Walk', 4, '25 steps'), _ex('Wall Sit', 4, '50 sec'),
        _ex('Squat Hold', 3, '40 sec'), _ex('Weighted Plank', 4, '40 sec'),
        _ex('Glute Bridge Hold', 3, '30 sec'), _ex('Backward Running', 3, '30 sec'),
      ]),
      _day(6, 'Fight Simulation', [
        _ex('Sprawl + Bear Crawl', 5, '40 sec'), _ex('Push-Up Shoulder Tap', 4, '15 reps'),
        _ex('Squat Pulses', 4, '20 reps'), _ex('Plank Up & Down', 3, '15 reps'),
        _ex('High Knee Sprint', 5, '25 sec'),
      ]),
    ],
  );

  static final grapplingMastery = UFCCourse(
    name: 'Grappling Mastery', description: 'Shrimping + Sprawl + Ground Transitions',
    style: UFCStyle.dagestani, level: 'Intermediate', duration: '2-3 Weeks',
    days: [
      _day(1, 'Shrimping Mastery', [
        _ex('Shrimping Exercise', 5, '20 reps'), _ex('Reverse Crunches', 3, '15 reps'),
        _ex('Glute Bridge', 4, '15 reps'), _ex('Bird Dog', 3, '15 reps'),
        _ex('Dead Bug', 3, '15 reps'), _ex('Plank', 4, '40 sec'),
      ]),
      _day(2, 'Sprawl Defense', [
        _ex('Sprawl Exercise', 5, '12 reps'), _ex('Push-Up Hold', 3, '30 sec'),
        _ex('Mountain Climber', 4, '40 sec'), _ex('High Knees', 4, '30 sec'),
        _ex('Burpees', 4, '12 reps'), _ex('Squat Thrust', 3, '15 reps'),
      ]),
      _day(3, 'Bear Crawl Control', [
        _ex('Bear Crawl', 5, '30 sec'), _ex('Duck Walk', 4, '25 steps'),
        _ex('Crab Walk', 3, '20 sec'), _ex('Forward Lunge', 3, '15 each'),
        _ex('Squat Hold', 3, '40 sec'), _ex('Wall Sit', 3, '45 sec'),
      ]),
      _day(4, 'Ground Transitions', [
        _ex('Shrimping + Bridge Combo', 4, '20 reps'), _ex('Glute Bridge Hold', 3, '30 sec'),
        _ex('Side Plank', 3, '30 sec each'), _ex('Plank Hip Dips', 3, '15 reps'),
        _ex('Back Extension', 3, '15 reps'), _ex('Superman', 3, '15 reps'),
      ]),
      _day(5, 'Grappling Conditioning', [
        _ex('Mountain Climber', 5, '40 sec'), _ex('Battle Rope', 4, '30 sec'),
        _ex('Jumping Jacks', 3, '50 sec'), _ex('Burpees', 4, '15 reps'),
        _ex('Stair Climber', 1, '6-8 min'), _ex('Skipping', 3, '60 sec'),
      ]),
      _day(6, 'Fight Simulation', [
        _ex('Shrimping→Sprawl→Bear Crawl', 5, '1 min'), _ex('Push-Up Shoulder Tap', 4, '15 reps'),
        _ex('Plank Up & Down', 4, '15 reps'), _ex('Squat Pulses', 4, '25 reps'),
        _ex('High Knee Sprint', 5, '30 sec'),
      ]),
    ],
  );

  static final pressureTraining = UFCCourse(
    name: 'Pressure Training', description: 'Static strength + Isometric holds + Smothering',
    style: UFCStyle.dagestani, level: 'Intermediate → Advanced', duration: '2-3 Weeks',
    days: [
      _day(1, 'Lower Body Pressure', [
        _ex('Wall Sit', 5, '45 sec'), _ex('Duck Walk', 4, '25 steps'),
        _ex('Squat Hold', 4, '40 sec'), _ex('Squats', 4, '15 reps'),
        _ex('Calf Raises', 3, '20 reps'), _ex('Backward Running', 3, '30 sec'),
      ]),
      _day(2, 'Core Pressure', [
        _ex('Weighted Plank', 5, '40 sec'), _ex('Plank', 4, '40 sec'),
        _ex('Side Plank', 3, '35 sec each'), _ex('Plank Hip Dips', 3, '15 reps'),
        _ex('Russian Twist', 3, '20 reps'), _ex('Hanging Knee Raise', 3, '12 reps'),
      ]),
      _day(3, 'Upper Body Pressure', [
        _ex('Push-Ups', 4, '15 reps'), _ex('Push-Up Hold', 3, '30 sec'),
        _ex('Tricep Dips', 3, '15 reps'), _ex('Dumbbell Row', 4, '12 reps'),
        _ex('Shoulder Press', 3, '12 reps'), _ex('Shrugs', 3, '15 reps'),
      ]),
      _day(4, 'Pressure Conditioning', [
        _ex('Mountain Climber', 4, '40 sec'), _ex('Battle Rope', 4, '30 sec'),
        _ex('Jumping Jacks', 3, '50 sec'), _ex('Burpees', 4, '15 reps'),
        _ex('Stair Climber', 1, '6-8 min'), _ex('High Knees', 4, '30 sec'),
      ]),
      _day(5, 'Static Hold Mastery', [
        _ex('Wall Sit', 5, '60 sec'), _ex('Weighted Plank', 5, '45 sec'),
        _ex('Squat Hold', 4, '45 sec'), _ex('Glute Bridge Hold', 3, '40 sec'),
        _ex('Push-Up Hold', 3, '35 sec'),
      ]),
      _day(6, 'Pressure Simulation', [
        _ex('Duck Walk + Wall Sit Combo', 5, '1 round'), _ex('Plank Up & Down', 4, '15 reps'),
        _ex('Push-Up Shoulder Tap', 4, '15 reps'), _ex('Squat Pulses', 4, '25 reps'),
        _ex('High Knee Sprint', 5, '30 sec'),
      ]),
    ],
  );

  static final cardioBeastMode = UFCCourse(
    name: 'Cardio Beast Mode', description: 'Endurance + Explosiveness + Speed',
    style: UFCStyle.dagestani, level: 'Beginner → Advanced', duration: '2-3 Weeks',
    days: [
      _day(1, 'Cardio Foundation', [
        _ex('High Knees', 5, '30 sec'), _ex('Jumping Jacks', 4, '45 sec'),
        _ex('Skipping', 4, '60 sec'), _ex('Mountain Climber', 4, '30 sec'),
        _ex('Stair Climber', 1, '5 min'),
      ]),
      _day(2, 'Explosive Cardio', [
        _ex('Jump Squats', 4, '15 reps'), _ex('Burpees', 4, '12 reps'),
        _ex('High Knee Sprint', 5, '30 sec'), _ex('Squat Pulses', 3, '25 reps'),
        _ex('Skipping', 3, '60 sec'),
      ]),
      _day(3, 'Endurance Builder', [
        _ex('Stair Climber', 1, '10 min'), _ex('Forward Running', 5, '1 min'),
        _ex('Backward Running', 4, '30 sec'), _ex('High Knees', 4, '40 sec'),
        _ex('Jumping Jacks', 3, '60 sec'),
      ]),
      _day(4, 'HIIT Killer', [
        _ex('Mountain Climber', 5, '40 sec'), _ex('Burpees', 5, '15 reps'),
        _ex('Jumping Jacks', 4, '50 sec'), _ex('High Knees', 5, '30 sec'),
        _ex('Skipping', 4, '60 sec'),
      ]),
      _day(5, 'Speed + Agility', [
        _ex('Agility Ladder Drill', 4, '30 sec'), _ex('Skater Jump', 4, '20 reps'),
        _ex('High Knee Sprint', 5, '30 sec'), _ex('Side Shuttle', 4, '30 sec'),
        _ex('Skipping', 3, '60 sec'),
      ]),
      _day(6, 'Fight Simulation Cardio', [
        _ex('High Knee + Burpees Combo', 5, '1 min'), _ex('Mountain Climber', 4, '40 sec'),
        _ex('Jump Squats', 4, '15 reps'), _ex('Skipping', 3, '60 sec'),
        _ex('Stair Climber', 1, '8 min'),
      ]),
    ],
  );

  static final defensiveFighting = UFCCourse(
    name: 'Defensive Fighting', description: 'Guard + Escape + Counter Control',
    style: UFCStyle.dagestani, level: 'Beginner → Intermediate', duration: '2-3 Weeks',
    days: [
      _day(1, 'Guard Position Basics', [
        _ex('Plank', 4, '40 sec'), _ex('Side Plank', 3, '35 sec each'),
        _ex('Glute Bridge', 3, '15 reps'), _ex('Bird Dog', 3, '15 reps'),
        _ex('Push-Up Hold', 3, '30 sec'), _ex('Wall Sit', 3, '40 sec'),
      ]),
      _day(2, 'Escape Drills', [
        _ex('Shrimping Exercise', 5, '20 reps'), _ex('Reverse Crunches', 3, '15 reps'),
        _ex('Dead Bug', 3, '15 reps'), _ex('Glute Bridge Hold', 3, '30 sec'),
        _ex('Back Extension', 3, '15 reps'), _ex('Superman', 3, '15 reps'),
      ]),
      _day(3, 'Core Stability', [
        _ex('Weighted Plank', 5, '40 sec'), _ex('Plank Hip Dips', 3, '15 reps'),
        _ex('Russian Twist', 3, '20 reps'), _ex('Hanging Knee Raise', 3, '12 reps'),
        _ex('V-Sit Hold', 3, '30 sec'), _ex('Cross Crunches', 3, '20 reps'),
      ]),
      _day(4, 'Reaction + Movement', [
        _ex('Sprawl Exercise', 4, '12 reps'), _ex('Mountain Climber', 4, '40 sec'),
        _ex('High Knees', 4, '30 sec'), _ex('Side Shuttle', 4, '30 sec'),
        _ex('Agility Ladder Drill', 4, '30 sec'),
      ]),
      _day(5, 'Defensive Strength', [
        _ex('Push-Ups', 4, '15 reps'), _ex('Tricep Dips', 3, '15 reps'),
        _ex('Dumbbell Row', 4, '12 reps'), _ex('Shoulder Press', 3, '12 reps'),
        _ex('Wall Sit', 4, '45 sec'), _ex('Plank', 4, '40 sec'),
      ]),
      _day(6, 'Defense Simulation', [
        _ex('Shrimping→Sprawl Combo', 5, '1 min'), _ex('Push-Up Shoulder Tap', 4, '15 reps'),
        _ex('Plank Up & Down', 4, '15 reps'), _ex('Squat Hold', 3, '40 sec'),
        _ex('High Knee Sprint', 5, '30 sec'),
      ]),
    ],
  );

  // ═══════════════════════════════════════
  // IRISH COURSES
  // ═══════════════════════════════════════

  static final kickboxingFundamentals = UFCCourse(
    name: 'Kickboxing Fundamentals', description: 'Stance + Punches + Kicks + Combos',
    style: UFCStyle.irish, level: 'Beginner', duration: '2 Weeks',
    days: [
      _day(1, 'Stance + Basic Punches', [
        _ex('Shadow Boxing', 5, '1 min'), _ex('Straight Punch', 4, '20 reps'),
        _ex('Cross and Uppercut', 3, '15 reps'), _ex('Arm Raises', 3, '20 reps'),
        _ex('Plank', 3, '30 sec'),
      ]),
      _day(2, 'Basic Kicks', [
        _ex('Forward Lunge', 3, '15 each'), _ex('Squats', 4, '15 reps'),
        _ex('Jump Squats', 3, '12 reps'), _ex('High Knees', 4, '30 sec'),
        _ex('Side Lunges', 3, '12 reps'),
      ]),
      _day(3, 'Punch + Kick Combo', [
        _ex('Shadow Boxing', 5, '1 min'), _ex('Straight + Kick Combo', 4, '15 reps'),
        _ex('Cross + Hook Combo', 3, '15 reps'), _ex('Mountain Climber', 3, '30 sec'),
        _ex('Plank', 3, '30 sec'),
      ]),
      _day(4, 'Balance + Movement', [
        _ex('Agility Ladder Drill', 4, '30 sec'), _ex('Side Shuttle', 4, '30 sec'),
        _ex('Skater Jump', 4, '20 reps'), _ex('High Knee Sprint', 4, '30 sec'),
        _ex('Shadow Boxing (Movement)', 4, '1 min'),
      ]),
      _day(5, 'Combo Training', [
        _ex('Shadow Boxing', 5, '1 min'), _ex('Jab + Cross', 4, '20 reps'),
        _ex('Cross + Hook + Kick', 4, '15 reps'), _ex('Push-Ups', 3, '15 reps'),
        _ex('Plank Hip Dips', 3, '15 reps'),
      ]),
      _day(6, 'Light Fight Simulation', [
        _ex('Shadow Boxing', 5, '1 min'), _ex('High Knee Sprint', 4, '30 sec'),
        _ex('Burpees', 3, '12 reps'), _ex('Jump Squats', 3, '15 reps'),
        _ex('Mountain Climber', 3, '30 sec'),
      ]),
    ],
  );

  static final strikingPrecision = UFCCourse(
    name: 'Striking Precision', description: 'Accuracy + Timing + Clean Hits',
    style: UFCStyle.irish, level: 'Beginner → Intermediate', duration: '2-3 Weeks',
    days: [
      _day(1, 'Accuracy Basics', [
        _ex('Shadow Boxing (Slow)', 5, '1 min'), _ex('Straight Punch', 5, '20 reps'),
        _ex('Cross and Uppercut', 4, '15 reps'), _ex('Arm Circles', 3, '20 reps'),
        _ex('Plank', 3, '30 sec'),
      ]),
      _day(2, 'Timing Control', [
        _ex('Shadow Boxing (Pause Strike)', 5, '1 min'), _ex('Straight Punch (Hold→Hit)', 4, '20 reps'),
        _ex('Push-Up Hold', 3, '30 sec'), _ex('Mountain Climber', 3, '30 sec'),
        _ex('High Knees', 3, '30 sec'),
      ]),
      _day(3, 'Clean Hit Training', [
        _ex('Shadow Boxing', 5, '1 min'), _ex('Cross + Hook', 4, '15 reps'),
        _ex('Lateral Flash', 3, '15 reps'), _ex('Push-Ups', 3, '15 reps'),
        _ex('Plank Hip Dips', 3, '15 reps'),
      ]),
      _day(4, 'Precision + Movement', [
        _ex('Agility Ladder Drill', 4, '30 sec'), _ex('Side Shuttle', 4, '30 sec'),
        _ex('Skater Jump', 4, '20 reps'), _ex('Shadow Boxing (Movement)', 5, '1 min'),
        _ex('High Knee Sprint', 4, '30 sec'),
      ]),
      _day(5, 'Combo Precision', [
        _ex('Shadow Boxing', 5, '1 min'), _ex('Jab + Cross', 4, '20 reps'),
        _ex('Cross + Hook + Straight', 4, '15 reps'), _ex('Push-Up & Rotation', 3, '12 reps'),
        _ex('Plank', 3, '30 sec'),
      ]),
      _day(6, 'Precision Simulation', [
        _ex('Shadow Boxing', 5, '1 min'), _ex('Straight Punch', 4, '20 reps'),
        _ex('Cross and Uppercut', 4, '15 reps'), _ex('Mountain Climber', 3, '30 sec'),
        _ex('Burpees', 3, '12 reps'),
      ]),
    ],
  );

  static final powerExplosiveness = UFCCourse(
    name: 'Power & Explosiveness', description: 'KO Power + Plyometrics + Fast-twitch',
    style: UFCStyle.irish, level: 'Intermediate → Advanced', duration: '2-3 Weeks',
    days: [
      _day(1, 'Explosive Upper Body', [
        _ex('Clapping Push-Ups', 4, '10 reps'), _ex('Push-Ups', 4, '15 reps'),
        _ex('Shoulder Press', 4, '12 reps'), _ex('Dumbbell Punches', 3, '30 sec'),
        _ex('Plank', 3, '30 sec'),
      ]),
      _day(2, 'Explosive Legs', [
        _ex('Jump Squats', 5, '15 reps'), _ex('Squat Pulses', 4, '25 reps'),
        _ex('Forward Lunge', 4, '15 each'), _ex('High Knee Sprint', 5, '30 sec'),
        _ex('Calf Raises', 3, '20 reps'),
      ]),
      _day(3, 'Plyometric Training', [
        _ex('Burpees', 5, '15 reps'), _ex('Skater Jump', 4, '20 reps'),
        _ex('Side Shuttle', 4, '30 sec'), _ex('Agility Ladder Drill', 4, '30 sec'),
        _ex('Mountain Climber', 4, '40 sec'),
      ]),
      _day(4, 'Power + Core', [
        _ex('Russian Twist', 4, '20 reps'), _ex('Plank Hip Dips', 3, '15 reps'),
        _ex('V-Sit Hold', 3, '30 sec'), _ex('Hanging Knee Raise', 3, '12 reps'),
        _ex('Push-Up & Rotation', 3, '12 reps'),
      ]),
      _day(5, 'Combination Power', [
        _ex('Shadow Boxing (Power)', 5, '1 min'), _ex('Straight + Cross (Explosive)', 4, '20 reps'),
        _ex('Cross + Hook + Kick', 4, '15 reps'), _ex('Battle Rope', 4, '30 sec'),
        _ex('Burpees', 4, '15 reps'),
      ]),
      _day(6, 'Explosive Simulation', [
        _ex('Shadow Boxing', 5, '1 min'), _ex('High Knee Sprint', 5, '30 sec'),
        _ex('Jump Squats', 4, '15 reps'), _ex('Mountain Climber', 4, '40 sec'),
        _ex('Burpees', 4, '15 reps'),
      ]),
    ],
  );

  static final fightIQMovement = UFCCourse(
    name: 'Fight IQ & Movement', description: 'Flash Speed + Direction Change + Reaction',
    style: UFCStyle.irish, level: 'Advanced', duration: '2-3 Weeks',
    days: [
      _day(1, 'Speed Foundation', [
        _ex('High Knee Sprint', 6, '30 sec'), _ex('Agility Ladder Drill', 6, '30 sec'),
        _ex('Side Shuttle', 6, '30 sec'), _ex('Forward Running', 5, '40 sec'),
        _ex('Backward Running', 5, '30 sec'), _ex('Skipping', 4, '60 sec'),
        _ex('Jumping Jacks', 4, '50 sec'),
      ]),
      _day(2, 'Explosive Speed', [
        _ex('Skater Jump', 6, '25 reps'), _ex('Jump Squats', 6, '15 reps'),
        _ex('Burpees', 5, '15 reps'), _ex('Mountain Climber', 5, '45 sec'),
        _ex('High Knees', 5, '35 sec'), _ex('Squat Pulses', 4, '25 reps'),
        _ex('Stair Climber', 1, '6-8 min'),
      ]),
      _day(3, 'Direction Change', [
        _ex('Side Shuttle', 6, '35 sec'), _ex('Agility Ladder Drill', 6, '30 sec'),
        _ex('Skater Jump', 5, '30 reps'), _ex('Crossbody Mountain Climber', 5, '40 sec'),
        _ex('Shadow Boxing (Movement)', 6, '1 min'), _ex('Side Lunges', 4, '15 reps'),
        _ex('Duck Walk', 4, '30 steps'),
      ]),
      _day(4, 'Reaction Speed', [
        _ex('High Knee Sprint', 7, '30 sec'), _ex('Agility Ladder Drill', 6, '30 sec'),
        _ex('Mountain Climber', 6, '45 sec'), _ex('Shadow Boxing (Reaction)', 6, '1 min'),
        _ex('Burpees', 5, '15 reps'), _ex('Jumping Jacks', 4, '60 sec'),
        _ex('Side Shuttle', 5, '35 sec'),
      ]),
      _day(5, 'Speed + Striking', [
        _ex('Shadow Boxing (Fast)', 7, '1 min'), _ex('Straight Punch (Fast)', 6, '25 reps'),
        _ex('Cross + Hook (Fast)', 5, '20 reps'), _ex('High Knee Sprint', 6, '30 sec'),
        _ex('Side Shuttle', 6, '30 sec'), _ex('Push-Up Shoulder Tap', 4, '15 reps'),
        _ex('Plank', 4, '40 sec'),
      ]),
      _day(6, 'Flash Simulation', [
        _ex('Shadow Boxing', 7, '1 min'), _ex('Dodge + Move + Punch', 6, '20 reps'),
        _ex('High Knee Sprint', 7, '30 sec'), _ex('Skater Jump', 6, '30 reps'),
        _ex('Mountain Climber', 6, '45 sec'), _ex('Burpees', 5, '15 reps'),
        _ex('Jumping Jacks', 4, '60 sec'),
      ]),
    ],
  );

  static final defensiveStriking = UFCCourse(
    name: 'Defensive Striking', description: 'Slipping + Blocking + Counter Defense',
    style: UFCStyle.irish, level: 'Beginner → Intermediate', duration: '2-3 Weeks',
    days: [
      _day(1, 'Guard & Defense', [
        _ex('Shadow Boxing (Defensive)', 5, '1 min'), _ex('Push-Up Hold', 3, '30 sec'),
        _ex('Plank', 3, '30 sec'), _ex('Wall Sit', 3, '40 sec'),
        _ex('Arm Circles', 3, '20 reps'),
      ]),
      _day(2, 'Slipping Technique', [
        _ex('Shadow Boxing (Slip)', 5, '1 min'), _ex('Side Shuttle', 4, '30 sec'),
        _ex('Skater Jump', 4, '20 reps'), _ex('Mountain Climber', 3, '30 sec'),
        _ex('High Knees', 3, '30 sec'),
      ]),
      _day(3, 'Blocking Strength', [
        _ex('Push-Ups', 4, '15 reps'), _ex('Tricep Dips', 3, '15 reps'),
        _ex('Dumbbell Row', 3, '12 reps'), _ex('Shoulder Press', 3, '12 reps'),
        _ex('Plank', 3, '40 sec'),
      ]),
      _day(4, 'Counter Defense', [
        _ex('Shadow Boxing (Block→Punch)', 5, '1 min'), _ex('Straight Punch', 4, '20 reps'),
        _ex('Cross + Counter', 4, '15 reps'), _ex('Push-Up & Rotation', 3, '12 reps'),
        _ex('Plank Hip Dips', 3, '15 reps'),
      ]),
      _day(5, 'Reaction & Reflex', [
        _ex('Agility Ladder Drill', 4, '30 sec'), _ex('High Knee Sprint', 5, '30 sec'),
        _ex('Mountain Climber', 4, '40 sec'), _ex('Shadow Boxing (Reaction)', 5, '1 min'),
        _ex('Burpees', 3, '12 reps'),
      ]),
      _day(6, 'Defense Simulation', [
        _ex('Shadow Boxing', 5, '1 min'), _ex('Slip→Counter Combo', 4, '15 reps'),
        _ex('Block→Move→Strike', 4, '15 reps'), _ex('Side Movement Drill', 4, '30 sec'),
        _ex('High Knee Sprint', 4, '30 sec'),
      ]),
    ],
  );

  static final cardioFightConditioning = UFCCourse(
    name: 'Cardio & Fight Conditioning', description: 'Fight Stamina + Round Training',
    style: UFCStyle.irish, level: 'Beginner → Advanced', duration: '2-3 Weeks',
    days: [
      _day(1, 'Cardio Base', [
        _ex('High Knees', 5, '30 sec'), _ex('Jumping Jacks', 4, '45 sec'),
        _ex('Skipping', 4, '60 sec'), _ex('Mountain Climber', 4, '30 sec'),
        _ex('Stair Climber', 1, '6 min'),
      ]),
      _day(2, 'Speed Endurance', [
        _ex('High Knee Sprint', 5, '30 sec'), _ex('Forward Running', 4, '1 min'),
        _ex('Backward Running', 4, '30 sec'), _ex('Skater Jump', 4, '20 reps'),
        _ex('Side Shuttle', 4, '30 sec'),
      ]),
      _day(3, 'Round Conditioning', [
        _ex('Shadow Boxing', 5, '1 min'), _ex('Mountain Climber', 4, '40 sec'),
        _ex('Burpees', 4, '15 reps'), _ex('Jump Squats', 4, '15 reps'),
        _ex('Plank', 3, '40 sec'),
      ]),
      _day(4, 'HIIT Fight Mode', [
        _ex('Mountain Climber', 5, '40 sec'), _ex('Burpees', 5, '15 reps'),
        _ex('Jumping Jacks', 4, '50 sec'), _ex('High Knees', 5, '30 sec'),
        _ex('Skipping', 4, '60 sec'),
      ]),
      _day(5, 'Agility + Conditioning', [
        _ex('Agility Ladder Drill', 4, '30 sec'), _ex('Side Shuttle', 5, '30 sec'),
        _ex('Skater Jump', 4, '20 reps'), _ex('High Knee Sprint', 5, '30 sec'),
        _ex('Mountain Climber', 4, '40 sec'),
      ]),
      _day(6, 'Fight Simulation', [
        _ex('Shadow Boxing', 5, '1 min'), _ex('High Knee Sprint', 5, '30 sec'),
        _ex('Burpees', 4, '15 reps'), _ex('Jump Squats', 4, '15 reps'),
        _ex('Mountain Climber', 4, '40 sec'),
      ]),
    ],
  );

  static final boneStrengthPower = UFCCourse(
    name: 'Bone Strength & Power Striking', description: 'Iron Body + Explosive Strikes',
    style: UFCStyle.irish, level: 'Intermediate → Advanced', duration: '2-3 Weeks',
    days: [
      _day(1, 'Leg Bone Strength', [
        _ex('Squats', 4, '15 reps'), _ex('Jump Squats', 4, '12 reps'),
        _ex('Forward Lunge', 4, '15 each'), _ex('Wall Sit', 4, '45 sec'),
        _ex('Calf Raises', 4, '25 reps'), _ex('Barbell Squat', 3, '10 reps'),
        _ex('Dumbbell Squat', 3, '12 reps'),
      ]),
      _day(2, 'Punch Strength', [
        _ex('Push-Ups', 4, '20 reps'), _ex('Knuckle Push-Ups', 4, '15 reps'),
        _ex('Dumbbell Punches', 4, '40 sec'), _ex('Dumbbell Row', 4, '12 reps'),
        _ex('Shoulder Press', 4, '12 reps'), _ex('Tricep Dips', 3, '15 reps'),
        _ex('Plank', 3, '45 sec'),
      ]),
      _day(3, 'Bone Conditioning', [
        _ex('Plank Hold', 4, '50 sec'), _ex('Squat Hold', 4, '45 sec'),
        _ex('Wall Push-Up Hold', 3, '40 sec'), _ex('Farmer Hold', 4, '45 sec'),
        _ex('Duck Walk', 4, '30 steps'), _ex('Glute Bridge Hold', 3, '40 sec'),
      ]),
      _day(4, 'Kick Power + Balance', [
        _ex('Jump Squats', 4, '15 reps'), _ex('Side Lunges', 4, '15 reps'),
        _ex('High Knees', 5, '30 sec'), _ex('Skater Jump', 4, '25 reps'),
        _ex('Split Squat Left', 3, '12 reps'), _ex('Split Squat Right', 3, '12 reps'),
        _ex('Shadow Kick Drills', 5, '20 reps'),
      ]),
      _day(5, 'Punch Accuracy + Power', [
        _ex('Shadow Boxing (Target)', 6, '1 min'), _ex('Straight Punch', 5, '25 reps'),
        _ex('Cross + Hook', 4, '20 reps'), _ex('Cross and Uppercut', 4, '15 reps'),
        _ex('Push-Up & Rotation', 3, '15 reps'), _ex('Plank Hip Dips', 3, '20 reps'),
      ]),
      _day(6, 'Full Power Simulation', [
        _ex('Shadow Boxing', 6, '1 min'), _ex('Burpees', 5, '15 reps'),
        _ex('Jump Squats', 5, '15 reps'), _ex('High Knee Sprint', 6, '30 sec'),
        _ex('Mountain Climber', 5, '40 sec'), _ex('Battle Rope', 4, '30 sec'),
      ]),
    ],
  );

  static final dodgeSpeedReflex = UFCCourse(
    name: 'Dodge & Speed Reflex', description: 'Head Movement + Reaction + Counter',
    style: UFCStyle.irish, level: 'Intermediate → Advanced', duration: '2-3 Weeks',
    days: [
      _day(1, 'Basic Dodge', [
        _ex('Shadow Boxing (Slip)', 6, '1 min'), _ex('Side Shuttle', 5, '30 sec'),
        _ex('Skater Jump', 5, '20 reps'), _ex('High Knees', 4, '30 sec'),
        _ex('Agility Ladder Drill', 4, '30 sec'),
      ]),
      _day(2, 'Head Movement', [
        _ex('Shadow Boxing (Head Movement)', 6, '1 min'), _ex('Mountain Climber', 5, '40 sec'),
        _ex('Agility Ladder Drill', 5, '30 sec'), _ex('Burpees', 4, '12 reps'),
        _ex('Side Lunges', 3, '15 reps'),
      ]),
      _day(3, 'Reaction Training', [
        _ex('Agility Ladder Drill', 6, '30 sec'), _ex('High Knee Sprint', 6, '30 sec'),
        _ex('Side Shuttle', 5, '30 sec'), _ex('Skater Jump', 5, '25 reps'),
        _ex('Shadow Boxing (Reaction)', 6, '1 min'),
      ]),
      _day(4, 'Dodge + Counter', [
        _ex('Slip→Punch Combo', 5, '20 reps'), _ex('Block→Counter', 5, '15 reps'),
        _ex('Push-Up & Rotation', 3, '15 reps'), _ex('Plank', 4, '40 sec'),
        _ex('Cross + Counter', 4, '20 reps'),
      ]),
      _day(5, 'Speed & Movement', [
        _ex('Skater Jump', 5, '25 reps'), _ex('Side Shuttle', 6, '30 sec'),
        _ex('Agility Ladder Drill', 5, '30 sec'), _ex('High Knee Sprint', 6, '30 sec'),
        _ex('Forward Running', 4, '40 sec'),
      ]),
      _day(6, 'Fight Simulation', [
        _ex('Shadow Boxing', 6, '1 min'), _ex('Dodge + Move + Punch', 5, '20 reps'),
        _ex('Mountain Climber', 5, '40 sec'), _ex('Burpees', 5, '15 reps'),
        _ex('High Knee Sprint', 5, '30 sec'),
      ]),
    ],
  );

  // ── Helper constructors ──
  static UFCDay _day(int num, String focus, List<UFCExercise> exercises) =>
      UFCDay(dayNumber: num, focus: focus, exercises: exercises);

  static UFCExercise _ex(String name, int sets, String repsOrDuration) =>
      UFCExercise(name: name, sets: sets, repsOrDuration: repsOrDuration);
}
