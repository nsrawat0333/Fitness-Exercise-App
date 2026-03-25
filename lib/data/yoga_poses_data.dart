// 20 yoga poses organized by category for the Yoga module.
// All poses provided by the user, grouped into 4 progressive categories.

import '../models/yoga_models.dart';

class YogaPosesData {
  /// Returns all 20 poses.
  static List<YogaPose> get allPoses => [
    ..._warmupPoses,
    ..._strengthPoses,
    ..._flexibilityPoses,
    ..._relaxationPoses,
  ];

  /// Returns poses by category key.
  static List<YogaPose> getPosesByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'warmup':
      case 'warm-up':
        return _warmupPoses;
      case 'strength':
        return _strengthPoses;
      case 'flexibility':
        return _flexibilityPoses;
      case 'relaxation':
        return _relaxationPoses;
      default:
        return allPoses;
    }
  }

  /// Returns poses matching a focus area key.
  static List<YogaPose> getPosesForFocus(String focus) {
    final key = focus.toLowerCase().replaceAll(' ', '_');
    return allPoses.where((p) => p.focusAreas.contains(key)).toList();
  }

  // ═══════════════════════════════════════════
  // 1–5: WARM-UP & BASIC START
  // ═══════════════════════════════════════════
  static const _warmupPoses = [
    YogaPose(
      name: 'Mountain Pose',
      sanskritName: 'Tadasana',
      description: 'Foundation standing pose that improves posture and body awareness.',
      steps: [
        'Stand with feet together, arms at sides',
        'Distribute weight evenly across both feet',
        'Engage thighs, lift kneecaps',
        'Lengthen spine, roll shoulders back',
        'Reach crown of head towards ceiling',
      ],
      durationSeconds: 60,
      category: 'warmup',
      focusAreas: ['full_body', 'flexibility', 'stress_relief'],
      image: 'assets/images/yoga/mountain_pose.png',
      animation: 'assets/images/yogajsonanimation/mountain_pose.json',
    ),
    YogaPose(
      name: "Child's Pose",
      sanskritName: 'Balasana',
      description: 'Gentle resting pose that calms the mind and relieves back tension.',
      steps: [
        'Kneel on floor, big toes touching',
        'Sit on heels, separate knees hip-width',
        'Fold forward, extend arms in front',
        'Rest forehead on the mat',
        'Breathe deeply and relax',
      ],
      durationSeconds: 60,
      category: 'warmup',
      focusAreas: ['stress_relief', 'back_pain', 'flexibility'],
      image: 'assets/images/yoga/child_pose.png',
      animation: 'assets/images/yogajsonanimation/child_pose.json',
    ),
    YogaPose(
      name: 'Cat-Cow Pose',
      sanskritName: 'Marjariasana',
      description: 'Dynamic spinal movement that warms up the back and core.',
      steps: [
        'Start on all fours, hands under shoulders',
        'Inhale: Drop belly, lift head (Cow)',
        'Exhale: Round spine, tuck chin (Cat)',
        'Move with breath rhythmically',
        'Repeat 10-15 cycles',
      ],
      durationSeconds: 60,
      category: 'warmup',
      focusAreas: ['back_pain', 'flexibility', 'stress_relief'],
      image: 'assets/images/yoga/cat_cow.png',
      animation: 'assets/images/jsonanimation/cat_cow_pose.json',
    ),
    YogaPose(
      name: 'Downward Dog',
      sanskritName: 'Adho Mukha Svanasana',
      description: 'Full-body stretch that strengthens arms and lengthens the spine.',
      steps: [
        'Start on all fours',
        'Tuck toes, lift hips up and back',
        'Straighten legs, press heels down',
        'Spread fingers wide, push floor away',
        'Hold, pedal feet to loosen calves',
      ],
      durationSeconds: 60,
      category: 'warmup',
      focusAreas: ['full_body', 'flexibility', 'weight_loss'],
      image: 'assets/images/yoga/downward_dog.png',
      animation: 'assets/images/jsonanimation/downward dog.json',
    ),
    YogaPose(
      name: 'Cobra Pose',
      sanskritName: 'Bhujangasana',
      description: 'Backbend that opens the chest and strengthens the spine.',
      steps: [
        'Lie face down, palms under shoulders',
        'Press into palms, lift chest off floor',
        'Keep elbows slightly bent',
        'Roll shoulders back, open chest',
        'Hold and breathe deeply',
      ],
      durationSeconds: 60,
      category: 'warmup',
      focusAreas: ['back_pain', 'flexibility', 'abs_core'],
      image: 'assets/images/yoga/cobra_pose.png',
      animation: 'assets/images/jsonanimation/Cobra Stretch.json',
    ),
  ];

  // ═══════════════════════════════════════════
  // 6–10: STRENGTH & FAT BURN
  // ═══════════════════════════════════════════
  static const _strengthPoses = [
    YogaPose(
      name: 'Warrior Pose',
      sanskritName: 'Virabhadrasana',
      description: 'Powerful standing pose that builds leg and core strength.',
      steps: [
        'Step one foot forward into a lunge',
        'Back foot angled at 45 degrees',
        'Bend front knee over ankle',
        'Raise arms overhead, gaze forward',
        'Hold and feel the burn in thighs',
      ],
      durationSeconds: 60,
      category: 'strength',
      focusAreas: ['weight_loss', 'full_body', 'abs_core'],
      image: 'assets/images/yoga/warrior_pose.png',
      animation: 'assets/images/yogajsonanimation/warrior_pose.json',
    ),
    YogaPose(
      name: 'Chair Pose',
      sanskritName: 'Utkatasana',
      description: 'Intense standing squat that fires up the legs and core.',
      steps: [
        'Stand with feet together',
        'Bend knees as if sitting in a chair',
        'Keep weight in heels',
        'Raise arms overhead',
        'Hold, keeping core engaged',
      ],
      durationSeconds: 60,
      category: 'strength',
      focusAreas: ['weight_loss', 'abs_core', 'full_body'],
      image: 'assets/images/yoga/chair_pose.png',
      animation: 'assets/images/yogajsonanimation/chair_pose.json',
    ),
    YogaPose(
      name: 'Plank Pose',
      sanskritName: 'Phalakasana',
      description: 'Core-building isometric hold that strengthens the entire body.',
      steps: [
        'Start in push-up position',
        'Hands directly under shoulders',
        'Body forms a straight line',
        'Engage core, squeeze glutes',
        'Hold without letting hips sag',
      ],
      durationSeconds: 60,
      category: 'strength',
      focusAreas: ['abs_core', 'weight_loss', 'full_body'],
      image: 'assets/images/yoga/plank_pose.png',
      animation: 'assets/images/jsonanimation/plank.json',
    ),
    YogaPose(
      name: 'Boat Pose',
      sanskritName: 'Navasana',
      description: 'Deep core workout that challenges balance and abdominal strength.',
      steps: [
        'Sit with knees bent, feet on floor',
        'Lean back slightly, lift feet off floor',
        'Straighten legs to form V-shape',
        'Extend arms parallel to floor',
        'Hold, keeping core tight',
      ],
      durationSeconds: 60,
      category: 'strength',
      focusAreas: ['abs_core', 'weight_loss'],
      image: 'assets/images/yoga/boat_pose.png',
      animation: 'assets/images/yogajsonanimation/boat_pose.json',
    ),
    YogaPose(
      name: 'Bridge Pose',
      sanskritName: 'Setu Bandhasana',
      description: 'Backbend that strengthens glutes, hips, and lower back.',
      steps: [
        'Lie on back, knees bent, feet flat',
        'Arms at sides, palms down',
        'Press feet into floor, lift hips',
        'Squeeze glutes at the top',
        'Hold, then lower slowly',
      ],
      durationSeconds: 60,
      category: 'strength',
      focusAreas: ['back_pain', 'abs_core', 'weight_loss'],
      image: 'assets/images/yoga/bridge_pose.png',
      animation: 'assets/images/yogajsonanimation/bridge_pose.json',
    ),
  ];

  // ═══════════════════════════════════════════
  // 11–15: FLEXIBILITY & STRETCH
  // ═══════════════════════════════════════════
  static const _flexibilityPoses = [
    YogaPose(
      name: 'Forward Bend',
      sanskritName: 'Paschimottanasana',
      description: 'Deep hamstring and lower back stretch that calms the nervous system.',
      steps: [
        'Sit with legs extended forward',
        'Inhale, lengthen spine',
        'Exhale, fold forward from hips',
        'Reach for toes or shins',
        'Hold, breathing into the stretch',
      ],
      durationSeconds: 60,
      category: 'flexibility',
      focusAreas: ['flexibility', 'stress_relief', 'back_pain'],
      image: 'assets/images/yoga/forward_bend.png',
      animation: 'assets/images/yogajsonanimation/forward_bend.json',
    ),
    YogaPose(
      name: 'Butterfly Pose',
      sanskritName: 'Baddha Konasana',
      description: 'Hip opener that releases tension in the groin and inner thighs.',
      steps: [
        'Sit with soles of feet together',
        'Hold feet with both hands',
        'Let knees fall open to sides',
        'Gently press knees down',
        'Sit tall and breathe',
      ],
      durationSeconds: 60,
      category: 'flexibility',
      focusAreas: ['flexibility', 'stress_relief'],
      image: 'assets/images/yoga/butterfly_pose.png',
      animation: 'assets/images/yogajsonanimation/butterfly_pose.json',
    ),
    YogaPose(
      name: 'Triangle Pose',
      sanskritName: 'Trikonasana',
      description: 'Standing stretch that opens the hips, chest, and shoulders.',
      steps: [
        'Stand with feet wide apart',
        'Turn right foot out, left foot in',
        'Extend arms to sides',
        'Reach right hand to right ankle',
        'Left arm extends upward',
      ],
      durationSeconds: 60,
      category: 'flexibility',
      focusAreas: ['flexibility', 'full_body', 'weight_loss'],
      image: 'assets/images/yoga/triangle_pose.png',
      animation: 'assets/images/yogajsonanimation/triangle_pose.json',
    ),
    YogaPose(
      name: 'Sphinx Pose',
      sanskritName: 'Sphinx Pose',
      description: 'Gentle backbend that strengthens the spine and opens the chest.',
      steps: [
        'Lie face down, forearms on floor',
        'Elbows directly under shoulders',
        'Press forearms into floor',
        'Lift chest, lengthen spine',
        'Hold, breathe into chest',
      ],
      durationSeconds: 60,
      category: 'flexibility',
      focusAreas: ['back_pain', 'flexibility'],
      image: 'assets/images/yoga/sphinx_pose.png',
      animation: 'assets/images/yogajsonanimation/sphinx_pose.json',
    ),
    YogaPose(
      name: 'Puppy Pose',
      sanskritName: 'Uttana Shishosana',
      description: 'Heart-opening stretch for shoulders, spine, and upper back.',
      steps: [
        'Start on all fours',
        'Walk hands forward, lower chest',
        'Keep hips over knees',
        'Forehead or chin to floor',
        'Melt heart toward the ground',
      ],
      durationSeconds: 60,
      category: 'flexibility',
      focusAreas: ['flexibility', 'back_pain', 'stress_relief'],
      image: 'assets/images/yoga/puppy_pose.png',
      animation: 'assets/images/yogajsonanimation/puppy_pose.json',
    ),
  ];

  // ═══════════════════════════════════════════
  // 16–20: RELAXATION & RECOVERY
  // ═══════════════════════════════════════════
  static const _relaxationPoses = [
    YogaPose(
      name: 'Legs Up the Wall',
      sanskritName: 'Viparita Karani',
      description: 'Restorative inversion that calms the mind and improves circulation.',
      steps: [
        'Sit sideways next to a wall',
        'Swing legs up the wall as you lie back',
        'Scoot hips close to wall',
        'Arms out to sides, palms up',
        'Close eyes and breathe deeply',
      ],
      durationSeconds: 60,
      category: 'relaxation',
      focusAreas: ['stress_relief', 'flexibility'],
      image: 'assets/images/yoga/legs_up_wall.png',
      animation: 'assets/images/yogajsonanimation/legs_up_wall.json',
    ),
    YogaPose(
      name: 'Corpse Pose',
      sanskritName: 'Savasana',
      description: 'Final resting pose for total body and mind relaxation.',
      steps: [
        'Lie flat on your back',
        'Legs slightly apart, toes falling open',
        'Arms at sides, palms facing up',
        'Close eyes, relax every muscle',
        'Focus on natural breath for 5 minutes',
      ],
      durationSeconds: 60,
      category: 'relaxation',
      focusAreas: ['stress_relief', 'full_body'],
      image: 'assets/images/yoga/corpse_pose.png',
    ),
    YogaPose(
      name: 'Happy Baby Pose',
      sanskritName: 'Ananda Balasana',
      description: 'Playful hip opener that releases tension in the lower back.',
      steps: [
        'Lie on your back',
        'Draw knees towards chest',
        'Grab outer edges of feet',
        'Open knees wider than torso',
        'Gently rock side to side',
      ],
      durationSeconds: 60,
      category: 'relaxation',
      focusAreas: ['stress_relief', 'back_pain', 'flexibility'],
      image: 'assets/images/yoga/happy_baby.png',
      animation: 'assets/images/yogajsonanimation/happy_joy.json',
    ),
    YogaPose(
      name: 'Spinal Twist',
      sanskritName: 'Ardha Matsyendrasana',
      description: 'Seated twist that detoxifies organs and relieves spinal tension.',
      steps: [
        'Sit with legs extended',
        'Bend right knee, cross over left leg',
        'Place right hand behind for support',
        'Left elbow outside right knee',
        'Twist gently, look over right shoulder',
      ],
      durationSeconds: 60,
      category: 'relaxation',
      focusAreas: ['back_pain', 'stress_relief', 'flexibility'],
      image: 'assets/images/yoga/spinal_twist.png',
      animation: 'assets/images/yogajsonanimation/spinal_twist.json',
    ),
    YogaPose(
      name: 'Easy Pose / Meditation',
      sanskritName: 'Sukhasana',
      description: 'Comfortable seated position for meditation and deep breathing.',
      steps: [
        'Sit cross-legged on the floor',
        'Rest hands on knees, palms up',
        'Lengthen spine, relax shoulders',
        'Close eyes, focus on breath',
        'Sit in stillness for 3-5 minutes',
      ],
      durationSeconds: 60,
      category: 'relaxation',
      focusAreas: ['stress_relief', 'full_body'],
      image: 'assets/images/yoga/easy_pose.png',
      animation: 'assets/images/yogajsonanimation/easy_pose.json',
    ),
  ];

  // ═══════════════════════════════════════════
  // DIET PLANS
  // ═══════════════════════════════════════════
  static const dietPlans = [
    YogaDietPlan(
      goal: 'Weight Loss',
      morning: 'Warm water + lemon + honey',
      breakfast: 'Oats with fruits + green tea',
      lunch: 'Dal + roti + sabzi + salad',
      evening: 'Green tea + roasted chana',
      dinner: 'Light khichdi + curd',
    ),
    YogaDietPlan(
      goal: 'Muscle Gain',
      morning: 'Warm water + soaked almonds',
      breakfast: 'Paneer paratha + lassi',
      lunch: 'Rajma/chole + rice + salad',
      evening: 'Banana shake + peanuts',
      dinner: 'Egg curry / paneer + roti + dal',
    ),
    YogaDietPlan(
      goal: 'Flexibility',
      morning: 'Warm water + turmeric',
      breakfast: 'Idli/dosa + coconut chutney',
      lunch: 'Brown rice + dal + mixed veggies',
      evening: 'Herbal tea + dry fruits',
      dinner: 'Soup + multigrain roti + sabzi',
    ),
    YogaDietPlan(
      goal: 'Detox',
      morning: 'Warm water + apple cider vinegar',
      breakfast: 'Smoothie bowl (banana + berries + seeds)',
      lunch: 'Quinoa / daliya + vegetables + salad',
      evening: 'Coconut water + cucumber slices',
      dinner: 'Vegetable soup + steamed veggies',
    ),
  ];
}
