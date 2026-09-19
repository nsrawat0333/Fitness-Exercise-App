import json

exercises_data = [
    # A exercises
    ("abdominal_crunches", "Abdominal Crunches", "abs", ["abs"], "beginner", "bodyweight", 10),
    ("adductor_stretch_in_standing", "Adductor Stretch In Standing", "stretching", ["legs"], "beginner", "bodyweight", 20),
    ("alternating_hooks", "Alternating Hooks", "arms", ["arms"], "beginner", "bodyweight", 10),
    ("arm_circles", "Arm Circles", "arms", ["arms", "shoulders"], "beginner", "bodyweight", 20),
    ("arm_circles_counterclockwise", "Arm Circles Counterclockwise", "arms", ["arms", "shoulders"], "beginner", "bodyweight", 20),
    ("arm_curls_crunch_left_right", "Arm Curls Crunch Left/Right", "arms", ["arms", "abs"], "beginner", "bodyweight", 10),
    ("arm_raises", "Arm Raises", "shoulders", ["shoulders"], "beginner", "bodyweight", 10),
    ("arm_scissors", "Arm Scissors", "chest", ["chest", "arms"], "beginner", "bodyweight", 20),
    ("arnold_dumbbell_press", "Arnold Dumbbell Press", "shoulders", ["shoulders"], "intermediate", "dumbbell", 10),
    # B exercises
    ("back_arches", "Back Arches", "back", ["back"], "beginner", "bodyweight", 10),
    ("back_bow_pulls", "Back Bow Pulls", "back", ["back"], "intermediate", "bodyweight", 10),
    ("backward_lunge", "Backward Lunge", "legs", ["legs", "glutes"], "beginner", "bodyweight", 10),
    ("backward_lunge_with_front_kick", "Backward Lunge With Front Kick Right/Left", "legs", ["legs", "glutes"], "intermediate", "bodyweight", 10),
    ("bent_knee_side_hip_raises", "Bent Knee Side Hip Raises Left/Right", "abs", ["abs", "glutes"], "beginner", "bodyweight", 10),
    ("bent_leg_twist", "Bent Leg Twist", "abs", ["abs"], "beginner", "bodyweight", 10),
    ("bent_over_dumbbell_rows", "Bent Over Dumbbell Rows Left/Right", "back", ["back"], "intermediate", "dumbbell", 10),
    ("bent_over_row", "Bent Over Row", "back", ["back"], "intermediate", "dumbbell", 10),
    ("bicycle_crunches", "Bicycle Crunches", "abs", ["abs"], "beginner", "bodyweight", 10),
    ("bird_dog_left_right", "Bird Dog Left/Right", "abs", ["abs", "back"], "beginner", "bodyweight", 10),
    ("bottom_leg_lift_right_left", "Bottom Leg Lift Right/Left", "abs", ["abs", "legs"], "beginner", "bodyweight", 10),
    ("box_push_ups", "Box Push-Ups", "chest", ["chest", "arms"], "beginner", "bodyweight", 10),
    ("bulgarian_split_squat", "Bulgarian Split Squat Left/Right", "legs", ["legs", "glutes"], "intermediate", "bodyweight", 10),
    ("burpees", "Burpees", "full_body", ["full_body"], "intermediate", "bodyweight", 10),
    ("butt_bridge", "Butt Bridge", "glutes", ["glutes", "legs"], "beginner", "bodyweight", 10),
    ("butt_kicks", "Butt Kicks", "legs", ["legs"], "beginner", "bodyweight", 20),
    # C exercises
    ("calf_raise_with_splayed_foot", "Calf Raise With Splayed Foot/Pigeon-Toed", "legs", ["legs", "calves"], "beginner", "bodyweight", 10),
    ("calf_stretch_left_right", "Calf Stretch Left/Right", "stretching", ["legs", "calves"], "beginner", "bodyweight", 20),
    ("cat_cow_pose", "Cat Cow Pose", "stretching", ["back", "abs"], "beginner", "bodyweight", 20),
    ("chest_press_pulse", "Chest Press Pulse", "chest", ["chest"], "beginner", "bodyweight", 10),
    ("chest_stretch", "Chest Stretch", "stretching", ["chest"], "beginner", "bodyweight", 20),
    ("child_pose", "Child's Pose", "stretching", ["back"], "beginner", "bodyweight", 20),
    ("clasp_hands_behind_back", "Clasp Hands Behind Back", "stretching", ["shoulders", "chest"], "beginner", "bodyweight", 20),
    ("cobra_stretch", "Cobra Stretch", "stretching", ["abs", "back"], "beginner", "bodyweight", 20),
    ("crossbody_mountain_climber", "Crossbody Mountain Climber", "abs", ["abs", "full_body"], "intermediate", "bodyweight", 10),
    ("crossover_crunch", "Crossover Crunch", "abs", ["abs"], "beginner", "bodyweight", 10),
    ("crunches_with_legs_raised", "Crunches With Legs Raised", "abs", ["abs"], "beginner", "bodyweight", 10),
    ("curtsy_lunges", "Curtsy Lunges", "legs", ["legs", "glutes"], "intermediate", "bodyweight", 10),
    # D exercises
    ("dead_bug", "Dead Bug", "abs", ["abs"], "beginner", "bodyweight", 10),
    ("decline_push_ups", "Decline Push-Ups", "chest", ["chest", "arms"], "intermediate", "bodyweight", 10),
    ("diagonal_plank", "Diagonal Plank", "abs", ["abs", "full_body"], "intermediate", "bodyweight", 20),
    ("diamond_push_ups", "Diamond Push-Ups", "chest", ["chest", "arms", "triceps"], "intermediate", "bodyweight", 10),
    ("donkey_kicks_right_left", "Donkey Kicks Right/Left", "glutes", ["glutes"], "beginner", "bodyweight", 10),
    ("doorway_curls_left_right", "Doorway Curls Left/Right", "arms", ["arms", "biceps"], "beginner", "bodyweight", 10),
    ("double_knees_to_chest", "Double Knees To Chest", "stretching", ["abs", "back"], "beginner", "bodyweight", 20),
    ("downward_facing_dog_on_wall", "Downward Facing Dog On The Wall", "stretching", ["shoulders", "back"], "beginner", "bodyweight", 20),
    ("dumbbell_concentration_curl_left", "Dumbbell Concentration Curl Left", "arms", ["arms", "biceps"], "intermediate", "dumbbell", 10),
    ("dumbbell_concentration_curl_right", "Dumbbell Concentration Curl Right", "arms", ["arms", "biceps"], "intermediate", "dumbbell", 10),
    ("dumbbell_front_raise", "Dumbbell Front Raise", "shoulders", ["shoulders"], "intermediate", "dumbbell", 10),
    ("dumbbell_kickbacks", "Dumbbell Kickbacks", "arms", ["arms", "triceps"], "intermediate", "dumbbell", 10),
    ("dumbbell_lying_triceps_extension", "Dumbbell Lying Triceps Extension", "arms", ["arms", "triceps"], "intermediate", "dumbbell", 10),
    ("dumbbell_punch", "Dumbbell Punch", "arms", ["arms", "shoulders"], "intermediate", "dumbbell", 10),
    ("dumbbell_rear_delt_row", "Dumbbell Rear Delt Row", "back", ["back", "shoulders"], "intermediate", "dumbbell", 10),
    ("dumbbell_shrug", "Dumbbell Shrug", "shoulders", ["shoulders", "back"], "intermediate", "dumbbell", 10),
    ("dumbbell_side_lateral_raise", "Dumbbell Side Lateral Raise", "shoulders", ["shoulders"], "intermediate", "dumbbell", 10),
    ("dumbbell_triceps_extension", "Dumbbell Triceps Extension", "arms", ["arms", "triceps"], "intermediate", "dumbbell", 10),
    ("dumbbell_upright_row", "Dumbbell Upright-Row", "shoulders", ["shoulders", "back"], "intermediate", "dumbbell", 10),
    # E exercises
    ("elbow_plank_rotation_left", "Elbow Plank Rotation Left", "abs", ["abs", "obliques"], "intermediate", "bodyweight", 10),
    ("elbow_plank_rotation_right", "Elbow Plank Rotation Right", "abs", ["abs", "obliques"], "intermediate", "bodyweight", 10),
    ("elbows_back", "Elbows Back", "stretching", ["shoulders", "chest"], "beginner", "bodyweight", 20),
    # F exercises
    ("fast_spider_lunges", "Fast Spider Lunges", "legs", ["legs", "full_body"], "intermediate", "bodyweight", 20),
    ("fire_hydrant_left", "Fire Hydrant Left", "glutes", ["glutes"], "beginner", "bodyweight", 10),
    ("fire_hydrant_right", "Fire Hydrant Right", "glutes", ["glutes"], "beginner", "bodyweight", 10),
    ("floor_slides", "Floor Slides", "back", ["back", "shoulders"], "beginner", "bodyweight", 20),
    ("floor_tricep_dips", "Floor Tricep Dips", "arms", ["arms", "triceps"], "beginner", "bodyweight", 10),
    ("floor_y_raises", "Floor Y Raises", "back", ["back", "shoulders"], "beginner", "bodyweight", 10),
    ("flutter_kick_squats", "Flutter Kick Squats", "legs", ["legs", "full_body"], "intermediate", "bodyweight", 10),
    ("flutter_kicks", "Flutter Kicks", "abs", ["abs"], "beginner", "bodyweight", 20),
    ("frog_pump", "Frog Pump", "glutes", ["glutes"], "beginner", "bodyweight", 10),
    ("froggy_glute_lifts", "Froggy Glute Lifts", "glutes", ["glutes"], "beginner", "bodyweight", 10),
    # G exercises
    ("glute_kick_back_left", "Glute Kick Back Left", "glutes", ["glutes"], "beginner", "bodyweight", 10),
    ("glute_kick_back_right", "Glute Kick Back Right", "glutes", ["glutes"], "beginner", "bodyweight", 10),
    ("glute_kickback_pulse_left", "Glute Kickback Pulse Left", "glutes", ["glutes"], "beginner", "bodyweight", 10),
    ("glute_kickback_pulse_right", "Glute Kickback Pulse Right", "glutes", ["glutes"], "beginner", "bodyweight", 10),
    ("glute_stretch_left", "Glute Stretch Left", "stretching", ["glutes"], "beginner", "bodyweight", 20),
    ("glute_stretch_right", "Glute Stretch Right", "stretching", ["glutes"], "beginner", "bodyweight", 20),
    # H exercises
    ("heel_touch", "Heel Touch", "abs", ["abs", "obliques"], "beginner", "bodyweight", 10),
    ("heels_to_the_heavens", "Heels To The Heavens", "abs", ["abs"], "intermediate", "bodyweight", 10),
    ("high_stepping", "High Stepping", "legs", ["legs", "full_body"], "beginner", "bodyweight", 20),
    ("hindu_push_ups", "Hindu Push-Ups", "chest", ["chest", "shoulders", "arms"], "intermediate", "bodyweight", 10),
    ("hip_bridge_leg_lift_left", "Hip Bridge & Leg Lift Left", "glutes", ["glutes", "legs"], "intermediate", "bodyweight", 10),
    ("hip_bridge_leg_lift_right", "Hip Bridge & Leg Lift Right", "glutes", ["glutes", "legs"], "intermediate", "bodyweight", 10),
    ("hip_hinge", "Hip Hinge", "legs", ["legs", "back"], "beginner", "bodyweight", 10),
    ("hover_push_up", "Hover Push Up", "chest", ["chest", "arms"], "intermediate", "bodyweight", 10),
    ("hyperextension", "Hyperextension", "back", ["back"], "beginner", "bodyweight", 10),
    # I exercises
    ("in_and_outs", "In & Outs", "abs", ["abs"], "beginner", "bodyweight", 20),
    ("incline_push_ups", "Incline Push-Ups", "chest", ["chest", "arms"], "beginner", "bodyweight", 10),
    ("inchworms", "Inchworms", "full_body", ["full_body"], "intermediate", "bodyweight", 10),
    # J exercises
    ("jumping_jacks", "Jumping Jacks", "full_body", ["full_body"], "beginner", "bodyweight", 20),
    ("jumping_push_ups", "Jumping Push-Ups", "chest", ["chest", "arms"], "advanced", "bodyweight", 10),
    ("jumping_squats", "Jumping Squats", "legs", ["legs", "glutes"], "intermediate", "bodyweight", 10),
    # K exercises
    ("knee_plank", "Knee Plank", "abs", ["abs"], "beginner", "bodyweight", 20),
    ("knee_push_ups", "Knee Push-Ups", "chest", ["chest", "arms"], "beginner", "bodyweight", 10),
    ("knee_to_chest_stretch_left", "Knee To Chest Stretch Left", "stretching", ["legs", "back"], "beginner", "bodyweight", 20),
    ("knee_to_chest_stretch_right", "Knee To Chest Stretch Right", "stretching", ["legs", "back"], "beginner", "bodyweight", 20),
    ("knee_to_elbow_crunches", "Knee To Elbow Crunches", "abs", ["abs", "obliques"], "intermediate", "bodyweight", 10),
    ("kneeling_lunge_stretch_left", "Kneeling Lunge Stretch Left", "stretching", ["legs"], "beginner", "bodyweight", 20),
    ("kneeling_lunge_stretch_right", "Kneeling Lunge Stretch Right", "stretching", ["legs"], "beginner", "bodyweight", 20),
    # L exercises
    ("leaning_stretcher_raises", "Leaning Stretcher Raises", "shoulders", ["shoulders"], "beginner", "bodyweight", 10),
    ("left_leg_lateral_raise", "Left Leg Lateral Raise", "legs", ["legs", "glutes"], "beginner", "bodyweight", 10),
    ("left_quad_stretch_with_wall", "Left Quad Stretch With Wall", "stretching", ["legs"], "beginner", "bodyweight", 20),
    ("leg_barbell_curl_left", "Leg Barbell Curl Left", "legs", ["legs"], "intermediate", "dumbbell", 10),
    ("leg_barbell_curl_right", "Leg Barbell Curl Right", "legs", ["legs"], "intermediate", "dumbbell", 10),
    ("leg_in_outs", "Leg In & Outs", "abs", ["abs"], "beginner", "bodyweight", 10),
    ("leg_raises", "Leg Raises", "abs", ["abs"], "beginner", "bodyweight", 10),
    ("long_arm_crunches", "Long Arm Crunches", "abs", ["abs"], "beginner", "bodyweight", 10),
    ("lunge_twist", "Lunge Twist", "legs", ["legs", "abs"], "intermediate", "bodyweight", 10),
    ("lunges", "Lunges", "legs", ["legs", "glutes"], "beginner", "bodyweight", 10),
    ("lying_butterfly_stretch", "Lying Butterfly Stretch", "stretching", ["legs", "glutes"], "beginner", "bodyweight", 20),
    # M exercises
    ("military_press", "Military Press", "shoulders", ["shoulders"], "intermediate", "dumbbell", 10),
    ("military_push_ups", "Military Push Ups", "chest", ["chest", "arms", "triceps"], "intermediate", "bodyweight", 10),
    ("modified_push_up_low_hold", "Modified Push-Up Low Hold", "chest", ["chest", "arms"], "beginner", "bodyweight", 20),
    ("mountain_climber", "Mountain Climber", "full_body", ["full_body", "abs"], "intermediate", "bodyweight", 10),
    # N - 90/90
    ("90_90_crunch", "90/90 Crunch", "abs", ["abs"], "beginner", "bodyweight", 10),
    # O exercises
    ("oblique_crossover_crunch_left", "Oblique Crossover Crunch Left", "abs", ["abs", "obliques"], "beginner", "bodyweight", 10),
    ("oblique_crossover_crunch_right", "Oblique Crossover Crunch Right", "abs", ["abs", "obliques"], "beginner", "bodyweight", 10),
    ("offset_push_ups", "Offset Push-Ups", "chest", ["chest", "arms"], "intermediate", "bodyweight", 10),
    # P exercises
    ("pigeon_pose_left", "Pigeon Pose Left", "stretching", ["glutes", "legs"], "beginner", "bodyweight", 20),
    ("pigeon_pose_right", "Pigeon Pose Right", "stretching", ["glutes", "legs"], "beginner", "bodyweight", 20),
    ("pike_push_ups", "Pike Push Ups", "shoulders", ["shoulders", "arms"], "intermediate", "bodyweight", 10),
    ("pistol_box_squat_left", "Pistol Box Squat Left", "legs", ["legs"], "advanced", "bodyweight", 10),
    ("pistol_box_squat_right", "Pistol Box Squat Right", "legs", ["legs"], "advanced", "bodyweight", 10),
    ("plank", "Plank", "abs", ["abs", "full_body"], "beginner", "bodyweight", 20),
    ("plank_hip_dips", "Plank Hip Dips", "abs", ["abs", "obliques"], "intermediate", "bodyweight", 20),
    ("plank_leg_up", "Plank Leg Up", "abs", ["abs", "glutes"], "intermediate", "bodyweight", 10),
    ("plie_squats", "Plie Squats", "legs", ["legs", "glutes"], "beginner", "bodyweight", 10),
    ("prone_flutter_kicks", "Prone Flutter Kicks", "back", ["back", "glutes"], "beginner", "bodyweight", 20),
    ("prone_triceps_push_ups", "Prone Triceps Push Ups", "arms", ["arms", "triceps"], "intermediate", "bodyweight", 10),
    ("punches", "Punches", "arms", ["arms", "shoulders"], "beginner", "bodyweight", 20),
    ("push_up_and_rotation", "Push-Up & Rotation", "chest", ["chest", "arms", "abs"], "intermediate", "bodyweight", 10),
    ("push_up_hold", "Push Up Hold", "chest", ["chest", "arms"], "beginner", "bodyweight", 20),
    ("push_ups", "Push-Ups", "chest", ["chest", "arms"], "beginner", "bodyweight", 10),
    # R exercises
    ("reclined_oblique_twist", "Reclined Oblique Twist", "abs", ["abs", "obliques"], "beginner", "bodyweight", 10),
    ("reclined_rhomboid_squeezes", "Reclined Rhomboid Squeezes", "back", ["back"], "beginner", "bodyweight", 10),
    ("reverse_crunches", "Reverse Crunches", "abs", ["abs"], "beginner", "bodyweight", 10),
    ("reverse_crunches_with_leg_raised", "Reverse Crunches With Leg Raised", "abs", ["abs"], "intermediate", "bodyweight", 10),
    ("reverse_flutter_kicks", "Reverse Flutter Kicks", "abs", ["abs"], "beginner", "bodyweight", 10),
    ("reverse_flys", "Reverse Flys", "back", ["back", "shoulders"], "intermediate", "bodyweight", 10),
    ("reverse_push_ups", "Reverse Push-Ups", "arms", ["arms", "triceps"], "intermediate", "bodyweight", 10),
    ("reverse_snow_angels", "Reverse Snow Angels", "back", ["back"], "beginner", "bodyweight", 10),
    ("rhomboid_pulls", "Rhomboid Pulls", "back", ["back"], "beginner", "bodyweight", 10),
    ("right_leg_lateral_raise", "Right Leg Lateral Raise", "legs", ["legs", "glutes"], "beginner", "bodyweight", 10),
    ("right_quad_stretch_with_wall", "Right Quad Stretch With Wall", "stretching", ["legs"], "beginner", "bodyweight", 20),
    ("russian_twist", "Russian Twist", "abs", ["abs", "obliques"], "intermediate", "bodyweight", 10),
    # S exercises
    ("scissors", "Scissors", "abs", ["abs"], "beginner", "bodyweight", 20),
    ("seated_butterfly_stretch", "Seated Butterfly Stretch", "stretching", ["legs", "glutes"], "beginner", "bodyweight", 20),
    ("shoulder_stretch", "Shoulder Stretch", "stretching", ["shoulders"], "beginner", "bodyweight", 20),
    ("shoulder_gators", "Shoulder Gators", "shoulders", ["shoulders"], "beginner", "bodyweight", 10),
    ("side_arm_raise", "Side Arm Raise", "shoulders", ["shoulders"], "beginner", "bodyweight", 20),
    ("side_bridges_left", "Side Bridges Left", "abs", ["abs", "obliques"], "intermediate", "bodyweight", 10),
    ("side_bridges_right", "Side Bridges Right", "abs", ["abs", "obliques"], "intermediate", "bodyweight", 10),
    ("side_hop", "Side Hop", "legs", ["legs", "full_body"], "beginner", "bodyweight", 20),
    ("side_leg_circles_left", "Side Leg Circles Left", "legs", ["legs", "glutes"], "beginner", "bodyweight", 10),
    ("side_leg_circles_right", "Side Leg Circles Right", "legs", ["legs", "glutes"], "beginner", "bodyweight", 10),
    ("side_leg_raise_left", "Side Leg Raise Left", "legs", ["legs", "glutes"], "beginner", "bodyweight", 10),
    ("side_leg_raise_right", "Side Leg Raise Right", "legs", ["legs", "glutes"], "beginner", "bodyweight", 10),
    ("side_lunges", "Side Lunges", "legs", ["legs", "glutes"], "beginner", "bodyweight", 10),
    ("side_lying_floor_stretch_left", "Side-Lying Floor Stretch Left", "stretching", ["back", "abs"], "beginner", "bodyweight", 20),
    ("side_lying_floor_stretch_right", "Side-Lying Floor Stretch Right", "stretching", ["back", "abs"], "beginner", "bodyweight", 20),
    ("side_lying_leg_lift_left", "Side-Lying Leg Lift Left", "legs", ["legs", "glutes"], "beginner", "bodyweight", 10),
    ("side_lying_leg_lift_right", "Side-Lying Leg Lift Right", "legs", ["legs", "glutes"], "beginner", "bodyweight", 10),
    ("side_plank_left", "Side Plank Left", "abs", ["abs", "obliques"], "intermediate", "bodyweight", 20),
    ("side_plank_right", "Side Plank Right", "abs", ["abs", "obliques"], "intermediate", "bodyweight", 20),
    ("single_left_leg_calf_raises", "Single Left Leg Calf Raises", "legs", ["legs", "calves"], "beginner", "bodyweight", 10),
    ("single_leg_calf_hop_left", "Single Leg Calf Hop Left", "legs", ["legs", "calves"], "intermediate", "bodyweight", 10),
    ("single_leg_calf_hop_right", "Single Leg Calf Hop Right", "legs", ["legs", "calves"], "intermediate", "bodyweight", 10),
    ("single_leg_deadlift_left", "Single Leg Deadlift Left", "legs", ["legs", "back"], "intermediate", "bodyweight", 10),
    ("single_leg_deadlift_right", "Single Leg Deadlift Right", "legs", ["legs", "back"], "intermediate", "bodyweight", 10),
    ("single_right_leg_calf_raises", "Single Right Leg Calf Raises", "legs", ["legs", "calves"], "beginner", "bodyweight", 10),
    ("sit_up_twist", "Sit-Up Twist", "abs", ["abs", "obliques"], "intermediate", "bodyweight", 10),
    ("sit_ups", "Sit-Ups", "abs", ["abs"], "beginner", "bodyweight", 10),
    ("skater_jump", "Skater Jump", "legs", ["legs", "full_body"], "intermediate", "bodyweight", 20),
    ("skipping_without_rope", "Skipping Without Rope", "full_body", ["full_body"], "beginner", "bodyweight", 20),
    ("slow_mountain_climber", "Slow Mountain Climber", "abs", ["abs", "full_body"], "beginner", "bodyweight", 20),
    ("spiderman_plank", "Spiderman Plank", "abs", ["abs", "obliques"], "intermediate", "bodyweight", 10),
    ("spiderman_push_ups", "Spiderman Push-Ups", "chest", ["chest", "arms", "abs"], "advanced", "bodyweight", 10),
    ("spine_lumbar_twist_stretch_left", "Spine Lumbar Twist Stretch Left", "stretching", ["back"], "beginner", "bodyweight", 20),
    ("spine_lumbar_twist_stretch_right", "Spine Lumbar Twist Stretch Right", "stretching", ["back"], "beginner", "bodyweight", 20),
    ("split_squat_left", "Split Squat Left", "legs", ["legs", "glutes"], "beginner", "bodyweight", 10),
    ("split_squat_right", "Split Squat Right", "legs", ["legs", "glutes"], "beginner", "bodyweight", 10),
    ("squat_kicks", "Squat Kicks", "legs", ["legs", "glutes"], "intermediate", "bodyweight", 10),
    ("squat_pulses", "Squat Pulses", "legs", ["legs", "glutes"], "intermediate", "bodyweight", 20),
    ("squat_reach_ups", "Squat Reach Ups", "legs", ["legs", "full_body"], "beginner", "bodyweight", 20),
    ("squats", "Squats", "legs", ["legs", "glutes"], "beginner", "bodyweight", 10),
    ("staggered_push_ups", "Staggered Push-Ups", "chest", ["chest", "arms"], "intermediate", "bodyweight", 10),
    ("standing_biceps_stretch_left", "Standing Biceps Stretch Left", "stretching", ["arms", "biceps"], "beginner", "bodyweight", 20),
    ("standing_biceps_stretch_right", "Standing Biceps Stretch Right", "stretching", ["arms", "biceps"], "beginner", "bodyweight", 20),
    ("standing_glute_kickbacks_left", "Standing Glute Kickbacks Left", "glutes", ["glutes"], "beginner", "bodyweight", 10),
    ("standing_glute_kickbacks_right", "Standing Glute Kickbacks Right", "glutes", ["glutes"], "beginner", "bodyweight", 10),
    ("standing_oblique_crunches_left", "Standing Oblique Crunches Left", "abs", ["abs", "obliques"], "beginner", "bodyweight", 10),
    ("standing_oblique_crunches_right", "Standing Oblique Crunches Right", "abs", ["abs", "obliques"], "beginner", "bodyweight", 10),
    ("starfish_crunch", "Starfish Crunch", "abs", ["abs"], "intermediate", "bodyweight", 20),
    ("step_up_onto_chair", "Step-Up Onto Chair", "legs", ["legs", "glutes"], "intermediate", "bodyweight", 10),
    ("straight_arm_plank_to_pike", "Straight Arm Plank To Pike", "abs", ["abs", "shoulders"], "intermediate", "bodyweight", 10),
    ("sumo_squat", "Sumo Squat", "legs", ["legs", "glutes"], "beginner", "bodyweight", 10),
    ("sumo_squat_and_leg_raises", "Sumo Squat & Leg Raises", "legs", ["legs", "glutes"], "intermediate", "bodyweight", 10),
    ("sumo_squat_calf_raises_with_wall", "Sumo Squat Calf Raises With Wall", "legs", ["legs", "calves"], "intermediate", "bodyweight", 10),
    ("superman", "Superman", "back", ["back"], "beginner", "bodyweight", 10),
    ("supine_push_up", "Supine Push Up", "chest", ["chest", "arms"], "intermediate", "bodyweight", 10),
    ("swimmer_and_superman", "Swimmer And Superman", "back", ["back"], "intermediate", "bodyweight", 10),
    # T exercises
    ("toy_soldiers", "Toy Soldiers", "legs", ["legs", "full_body"], "beginner", "bodyweight", 10),
    ("triceps_dips", "Triceps Dips", "arms", ["arms", "triceps"], "intermediate", "bodyweight", 10),
    ("triceps_kickbacks", "Triceps Kickbacks", "arms", ["arms", "triceps"], "intermediate", "dumbbell", 10),
    ("triceps_stretch_left", "Triceps Stretch Left", "stretching", ["arms", "triceps"], "beginner", "bodyweight", 20),
    ("triceps_stretch_right", "Triceps Stretch Right", "stretching", ["arms", "triceps"], "beginner", "bodyweight", 20),
    ("twisting_piston", "Twisting Piston", "abs", ["abs", "arms"], "intermediate", "bodyweight", 10),
    # V exercises
    ("v_crunch", "V Crunch", "abs", ["abs"], "intermediate", "bodyweight", 10),
    ("v_up", "V-Up", "abs", ["abs"], "intermediate", "bodyweight", 10),
    # W exercises
    ("walking_squats", "Walking Squats", "legs", ["legs", "glutes"], "beginner", "bodyweight", 20),
    ("wall_calf_raises", "Wall Calf Raises", "legs", ["legs", "calves"], "beginner", "bodyweight", 10),
    ("wall_glute_kickback_left_hold", "Wall Glute Kickback Left Hold", "glutes", ["glutes"], "intermediate", "bodyweight", 10),
    ("wall_glute_kickback_right_hold", "Wall Glute Kickback Right Hold", "glutes", ["glutes"], "intermediate", "bodyweight", 10),
    ("wall_push_ups", "Wall Push-Ups", "chest", ["chest", "arms"], "beginner", "bodyweight", 10),
    ("wall_resisting_single_leg_calf_raise_left", "Wall Resisting Single Leg Calf Raise Left", "legs", ["legs", "calves"], "intermediate", "bodyweight", 10),
    ("wall_resisting_single_leg_calf_raise_right", "Wall Resisting Single Leg Calf Raise Right", "legs", ["legs", "calves"], "intermediate", "bodyweight", 10),
    ("wall_sit", "Wall Sit", "legs", ["legs"], "beginner", "bodyweight", 20),
    ("wide_arm_push_ups", "Wide Arm Push-Ups", "chest", ["chest", "arms"], "intermediate", "bodyweight", 10),
    ("windshield_wipers", "Windshield Wipers", "abs", ["abs", "obliques"], "intermediate", "bodyweight", 20),
]

# Instructions map
instructions_map = {
    "abs": [
        "Lie on your back on a mat with knees bent",
        "Engage your core muscles throughout the movement",
        "Perform the movement in a slow, controlled manner",
        "Breathe out as you contract, breathe in as you release",
        "Keep your lower back pressed against the floor"
    ],
    "chest": [
        "Position your hands at shoulder-width apart",
        "Keep your body in a straight line from head to heels",
        "Lower yourself in a controlled manner",
        "Push back up to the starting position",
        "Engage your core throughout the movement"
    ],
    "legs": [
        "Stand with feet shoulder-width apart",
        "Keep your back straight and core engaged",
        "Lower your body in a controlled motion",
        "Push through your heels to return to starting position",
        "Keep your knees aligned with your toes"
    ],
    "arms": [
        "Stand with feet hip-width apart",
        "Keep your elbows close to your body",
        "Perform the movement with controlled tempo",
        "Squeeze the target muscles at the top of the movement",
        "Return to starting position slowly"
    ],
    "shoulders": [
        "Stand tall with your core engaged",
        "Keep a slight bend in your elbows",
        "Raise your arms in a controlled manner",
        "Hold briefly at the top of the movement",
        "Lower back down with control"
    ],
    "back": [
        "Lie face down on a mat or stand with slight forward lean",
        "Engage your back muscles to initiate the movement",
        "Squeeze your shoulder blades together",
        "Hold the contraction briefly",
        "Return to starting position with control"
    ],
    "glutes": [
        "Start on all fours or lying face up",
        "Engage your glute muscles to initiate the movement",
        "Squeeze your glutes at the top of the movement",
        "Lower back down with control",
        "Keep your core engaged throughout"
    ],
    "full_body": [
        "Start in a standing position",
        "Engage your entire body throughout the movement",
        "Maintain proper form and alignment",
        "Move through each phase with control",
        "Land softly if the exercise involves jumping"
    ],
    "stretching": [
        "Move into the stretch position slowly",
        "Hold the stretch for the recommended duration",
        "Breathe deeply and relax into the stretch",
        "Do not bounce or force the stretch",
        "You should feel a gentle pull, not pain"
    ],
}

# Build exercises list
exercises = []
for i, (eid, name, category, muscle_group, difficulty, equipment, reps_or_dur) in enumerate(exercises_data):
    cat_key = category if category in instructions_map else "full_body"
    instr = instructions_map.get(cat_key, instructions_map["full_body"])

    is_timed = difficulty == "beginner" and reps_or_dur == 20
    # Exercises with 00:20 in screenshots are timed
    timed_exercises = [
        "elbows_back", "arm_scissors", "floor_slides", "flutter_kicks", "high_stepping",
        "jumping_jacks", "punches", "scissors", "side_hop", "plank", "knee_plank",
        "side_plank_left", "side_plank_right", "plank_hip_dips", "windshield_wipers",
        "skipping_without_rope", "wall_sit", "modified_push_up_low_hold", "push_up_hold",
        "diagonal_plank", "slow_mountain_climber", "squat_pulses", "squat_reach_ups",
        "walking_squats", "side_lunges", "fast_spider_lunges", "butt_kicks",
        "arm_circles", "arm_circles_counterclockwise", "side_arm_raise",
        "shoulder_stretch", "starfish_crunch", "spiderman_plank",
        # stretches
        "adductor_stretch_in_standing", "calf_stretch_left_right", "cat_cow_pose",
        "chest_stretch", "child_pose", "clasp_hands_behind_back", "cobra_stretch",
        "double_knees_to_chest", "downward_facing_dog_on_wall", "glute_stretch_left",
        "glute_stretch_right", "kneeling_lunge_stretch_left", "kneeling_lunge_stretch_right",
        "knee_to_chest_stretch_left", "knee_to_chest_stretch_right",
        "left_quad_stretch_with_wall", "right_quad_stretch_with_wall",
        "lying_butterfly_stretch", "pigeon_pose_left", "pigeon_pose_right",
        "seated_butterfly_stretch", "side_lying_floor_stretch_left",
        "side_lying_floor_stretch_right", "spine_lumbar_twist_stretch_left",
        "spine_lumbar_twist_stretch_right", "standing_biceps_stretch_left",
        "standing_biceps_stretch_right", "triceps_stretch_left", "triceps_stretch_right",
        "in_and_outs", "prone_flutter_kicks",
        "swimmer_and_superman",
    ]

    if eid in timed_exercises:
        duration = 30
        reps = None
    else:
        duration = 30
        reps = "10-15"

    exercise = {
        "id": eid,
        "name": name,
        "category": category,
        "muscle_group": muscle_group,
        "difficulty": difficulty,
        "equipment": equipment,
        "image": "assets/all_exercises/" + name.lower().replace(" ", "_").replace("/", "_").replace("&", "and").replace("-", "_").replace("'", "") + ".png",
        "instructions": instr,
        "duration": duration,
    }
    if reps:
        exercise["reps"] = reps
    else:
        exercise["reps"] = "N/A"

    exercises.append(exercise)

output = {"exercises": exercises}

with open(r"c:\Users\nsraw\StudioProjects\fitness_app\assets\exercises.json", "w", encoding="utf-8") as f:
    json.dump(output, f, indent=2, ensure_ascii=False)

print(f"Generated {len(exercises)} exercises in exercises.json")
