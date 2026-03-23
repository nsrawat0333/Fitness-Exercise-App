import 'dart:convert';
import 'gym_exercises_catalog.dart';
import 'gym_user_data.dart';

class GymExercise {
  final String name;
  final int durationSeconds;
  final String? animationLottie;
  final String? videoAsset;
  final String? imageAsset;
  final List<String> instructions;
  
  const GymExercise({
    required this.name,
    this.durationSeconds = 30, // Default 30s per user request
    this.animationLottie,
    this.videoAsset,
    this.imageAsset,
    this.instructions = const [],
  });
}

class GymChallengeData {
  static List<GymExercise> getExercisesForDay(int overallDayIndex) {
    // 1. Parse JSON
    final Map<String, dynamic> parsedJson = jsonDecode(gymExercisesJson);
    final List<dynamic> allExercises = parsedJson['exercises'];

    // 2. Map Focus Area to Muscle Groups
    String focus = GymUserData().focusArea.toLowerCase();
    List<String> targetGroups = [];
    if (focus.contains('abs')) targetGroups.add('abs');
    if (focus.contains('arm')) targetGroups.add('arms');
    if (focus.contains('chest')) targetGroups.add('chest');
    if (focus.contains('leg')) targetGroups.add('legs');
    if (focus.contains('shoulder')) targetGroups.add('shoulders');
    if (focus.contains('back')) targetGroups.add('back');
    if (focus.contains('butt')) targetGroups.add('glutes');
    if (focus.contains('full body')) targetGroups.add('full_body');

    // 3. Filter the exercises
    List<dynamic> filtered = allExercises.where((ex) {
      if (targetGroups.isEmpty || targetGroups.contains('full_body')) return true;
      List<dynamic> muscles = ex['muscle_group'] as List<dynamic>;
      for (var mg in muscles) {
        if (targetGroups.contains(mg)) return true;
      }
      return false;
    }).toList();

    // Fallback if empty
    if (filtered.isEmpty) {
      filtered = allExercises;
    }

    // 4. Select exactly 10 exercises deterministically per day
    List<GymExercise> dailyExercises = [];
    int poolSize = filtered.length;
    int startIndex = (overallDayIndex * 5) % poolSize;
    
    for (int i = 0; i < 10; i++) {
      int index = (startIndex + i * 3) % poolSize;
      final exData = filtered[index];
      String exName = exData['name'];
      
      String? lottiePath;
      String? videoPath;
      String imagePath = exData['image'] ?? '';
      List<String> instrs = (exData['instructions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      int duration = exData['duration'] ?? 30;

      // Special overrides for Lottie Animations based on names
      if (exName == 'Jumping Jacks') {
        lottiePath = 'assets/images/jsonanimation/animationjumpingjaks.json';
      } else if (exName.toLowerCase().contains('squat')) {
        lottiePath = 'assets/images/jsonanimation/sqauts.json';
      }

      // Pushup exercises get the pushup MP4 video
      if (exName.toLowerCase().contains('push')) {
        videoPath = 'assets/images/mp4videofolder/pushup.mp4';
      }
      
      dailyExercises.add(GymExercise(
        name: exName, 
        durationSeconds: duration,
        animationLottie: lottiePath,
        videoAsset: videoPath,
        imageAsset: imagePath,
        instructions: instrs,
      ));
    }
    
    return dailyExercises;
  }
}
