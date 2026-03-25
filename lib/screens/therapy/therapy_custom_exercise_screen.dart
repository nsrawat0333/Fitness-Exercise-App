import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../constants/app_colors.dart';
import '../../data/gym_challenge_data.dart';
import '../gym/courses/workout_flow_screen.dart';
import 'therapy_screen.dart';

class TherapyCustomExerciseScreen extends StatefulWidget {
  const TherapyCustomExerciseScreen({super.key});

  @override
  State<TherapyCustomExerciseScreen> createState() => _TherapyCustomExerciseScreenState();
}

class _TherapyCustomExerciseScreenState extends State<TherapyCustomExerciseScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _selectedIndices = {};
  String _searchQuery = '';

  late final List<TherapyExerciseEntry> _allExercises;

  @override
  void initState() {
    super.initState();
    _allExercises = allTherapyExercises;
  }

  List<TherapyExerciseEntry> get _filteredExercises {
    if (_searchQuery.isEmpty) return _allExercises;
    return _allExercises
        .where((e) => e.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _toggleSelection(int globalIndex) {
    setState(() {
      if (_selectedIndices.contains(globalIndex)) {
        _selectedIndices.remove(globalIndex);
      } else {
        _selectedIndices.add(globalIndex);
      }
    });
  }

  void _startSession() {
    if (_selectedIndices.isEmpty) return;

    final selected = _selectedIndices
        .map((i) => _allExercises[i])
        .toList();

    final gymExercises = selected.map((entry) {
      return GymExercise(
        id: entry.name.replaceAll(' ', '_').toLowerCase(),
        name: entry.name,
        category: 'Therapy',
        muscleGroup: ['Custom'],
        difficulty: 'Beginner',
        durationSeconds: 60,
        instructions: ['Follow the animation and breathe deeply for ${entry.name}.'],
        animationLottie: entry.animationPath,
        breathingDuration: 20,
        previewDuration: 10,
        performDuration: 60,
        recoveryDuration: 20,
      );
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutFlowScreen(
          exercises: gymExercises,
          dayIndex: 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredExercises;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Custom Exercise',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (_selectedIndices.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF667EEA).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_selectedIndices.length} selected',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF667EEA),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Search Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[400], size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        decoration: InputDecoration(
                          hintText: 'Search exercises...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        child: Icon(Icons.close, color: Colors.grey[400], size: 20),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Exercise List ──
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          Text(
                            'No exercises found',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final exercise = filtered[index];
                        final globalIndex = _allExercises.indexOf(exercise);
                        final isSelected = _selectedIndices.contains(globalIndex);

                        return _ExerciseSelectCard(
                          exercise: exercise,
                          isSelected: isSelected,
                          onTap: () => _toggleSelection(globalIndex),
                        );
                      },
                    ),
            ),

            // ── Start Session Button ──
            if (_selectedIndices.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: GestureDetector(
                  onTap: _startSession,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_circle_filled, color: Colors.white, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          'Start Session (${_selectedIndices.length} exercises)',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Exercise Select Card with Lottie thumbnail
// ═══════════════════════════════════════════════════════════

class _ExerciseSelectCard extends StatelessWidget {
  final TherapyExerciseEntry exercise;
  final bool isSelected;
  final VoidCallback onTap;

  const _ExerciseSelectCard({
    required this.exercise,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF667EEA).withValues(alpha: 0.08) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? const Color(0xFF667EEA) : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Lottie thumbnail
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF667EEA).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Lottie.asset(
                      exercise.animationPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.self_improvement,
                        color: Color(0xFF667EEA),
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Exercise name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '60 seconds',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Selection checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF667EEA) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF667EEA) : Colors.grey.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
