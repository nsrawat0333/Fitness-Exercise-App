import 'package:flutter/material.dart';
import '../../models/challenge_model.dart';
import 'challenge_player_screen.dart';

/// Shows the exercise list for a selected challenge level
class ChallengeDetailScreen extends StatelessWidget {
  final ChallengeLevel level;
  const ChallengeDetailScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(level.auraColor.replaceFirst('#', '0xFF')));

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(level.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Header
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.2),
                    border: Border.all(color: color),
                  ),
                  child: Center(
                    child: Text(
                      '${level.exerciseCount}',
                      style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(level.tagline, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                        '${level.exercises.length} exercises to complete',
                        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Exercise list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: level.exercises.length,
              itemBuilder: (context, index) {
                final exercise = level.exercises[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      // Number
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(alpha: 0.15),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise.name,
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _getTargetText(exercise),
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      _TypeBadge(type: exercise.type, color: color),
                    ],
                  ),
                );
              },
            ),
          ),
          // Start button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChallengePlayerScreen(level: level),
                    ),
                  );
                  if (!context.mounted) return;
                  if (result == true) {
                    Navigator.pop(context); // Go back to challenge list if beaten
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  'START CHALLENGE',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTargetText(ChallengeExercise ex) {
    switch (ex.type) {
      case ChallengeExerciseType.rep:
        return '${ex.targetReps} reps';
      case ChallengeExerciseType.time:
        return '${ex.targetSeconds} sec hold';
      case ChallengeExerciseType.speed:
        return '${ex.targetSeconds} sec max speed';
    }
  }
}

class _TypeBadge extends StatelessWidget {
  final ChallengeExerciseType type;
  final Color color;
  const _TypeBadge({required this.type, required this.color});

  @override
  Widget build(BuildContext context) {
    final label = type == ChallengeExerciseType.rep
        ? 'REP'
        : type == ChallengeExerciseType.time
            ? 'TIME'
            : 'SPEED';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }
}
