import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/gym_challenge_data.dart';
import '../../../data/gym_user_data.dart';
import '../../../data/exercise_assets.dart';
import 'gym_custom_plan_generation_screen.dart';

class CustomWorkoutBuilderScreen extends StatefulWidget {
  const CustomWorkoutBuilderScreen({super.key});

  @override
  State<CustomWorkoutBuilderScreen> createState() => _CustomWorkoutBuilderScreenState();
}

class _CustomWorkoutBuilderScreenState extends State<CustomWorkoutBuilderScreen> {
  late List<GymExercise> _allExercises;
  List<GymExercise> _filteredExercises = [];
  final Set<int> _selectedIndices = {};
  final Map<int, int> _exerciseTimers = {}; // index → seconds
  String _filterQuery = '';
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All', 'Abs', 'Arms', 'Chest', 'Legs', 'Back', 'Shoulders', 'Glutes', 'Full Body', 'Stretching'
  ];

  @override
  void initState() {
    super.initState();
    try {
      _allExercises = GymChallengeData.getAllExercises();
    } catch (e) {
      debugPrint('CustomWorkoutBuilder: Error loading exercises: $e');
      _allExercises = [];
    }
    _filteredExercises = _allExercises;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filteredExercises = _allExercises.where((ex) {
        // Search filter
        if (_filterQuery.isNotEmpty) {
          if (!ex.name.toLowerCase().contains(_filterQuery.toLowerCase())) return false;
        }
        // Category filter
        if (_selectedCategory != 'All') {
          final cat = _selectedCategory.toLowerCase();
          if (ex.category != cat && !ex.muscleGroup.contains(cat)) return false;
        }
        return true;
      }).toList();
    });
  }

  void _showTimerDialog(int exerciseIndex) {
    int currentTimer = _exerciseTimers[exerciseIndex] ?? 30;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Set Timer',
                    style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black),
                  ),
                  Text(
                    _allExercises[exerciseIndex].name,
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [15, 30, 45, 60, 90, 120].map((seconds) {
                      bool isSelected = currentTimer == seconds;
                      return GestureDetector(
                        onTap: () {
                          setSheetState(() => currentTimer = seconds);
                        },
                        child: Container(
                          width: 80,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(14),
                            border: isSelected ? null : Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${seconds}s',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _exerciseTimers[exerciseIndex] = currentTimer;
                        });
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('CONFIRM', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _savePlan() {
    if (_selectedIndices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one exercise', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    // Save to GymUserData
    List<Map<String, dynamic>> planData = [];
    List<GymExercise> selectedExercises = [];

    for (int idx in _selectedIndices) {
      final ex = _allExercises[idx];
      int duration = _exerciseTimers[idx] ?? 30;
      planData.add({
        'name': ex.name,
        'duration': duration,
        'image': ex.imageAsset,
        'lottie': ex.animationLottie,
      });
      selectedExercises.add(GymExercise(
        name: ex.name,
        durationSeconds: duration,
        imageAsset: ex.imageAsset,
        animationLottie: ex.animationLottie,
        instructions: ex.instructions,
      ));
    }

    GymUserData().customPlanExercises = planData;

    // Navigate to the loading/progress animation screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GymCustomPlanGenerationScreen(
          exercises: selectedExercises,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Leave Builder?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              content: const Text('Are you sure you want to go back? Your custom plan will not be saved.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('LEAVE', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          if (shouldPop == true) {
            if (context.mounted) Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Your Plan',
          style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black),
        ),
        actions: [
          if (_selectedIndices.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_selectedIndices.length} selected',
                    style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Icon(Icons.search, color: Color(0xFF9E9E9E), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) {
                        _filterQuery = v;
                        _applyFilters();
                      },
                      style: GoogleFonts.outfit(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search exercises...',
                        hintStyle: GoogleFonts.outfit(fontSize: 14, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Category tabs
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (ctx, i) {
                bool isSelected = _selectedCategory == _categories[i];
                return GestureDetector(
                  onTap: () {
                    _selectedCategory = _categories[i];
                    _applyFilters();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _categories[i],
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Exercise count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredExercises.length} exercises',
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
                ),
                Text(
                  'Tap to select, long press for timer',
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ),

          // Exercise list
          Expanded(
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filteredExercises.length,
              itemBuilder: (context, index) {
                final ex = _filteredExercises[index];
                // Find the real index in _allExercises
                int realIndex = _allExercises.indexOf(ex);
                bool isSelected = _selectedIndices.contains(realIndex);
                int timer = _exerciseTimers[realIndex] ?? 30;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedIndices.remove(realIndex);
                      } else {
                        _selectedIndices.add(realIndex);
                      }
                    });
                  },
                  onLongPress: () => _showTimerDialog(realIndex),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF3B82F6).withValues(alpha: 0.08)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF3B82F6)
                            : const Color(0xFFE8E8E8),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Select checkbox
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? const Color(0xFF3B82F6) : Colors.grey[400]!,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white, size: 16)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        // Image/Animation (Safe rendering with Fallback)
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ExerciseMediaWidget(
                              assetPath: ex.animationLottie ?? ex.imageAsset ?? GymChallengeData.getFallbackImage(ex.name),
                              fit: BoxFit.cover,
                              isThumbnail: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Name + category
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ex.name,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ex.category.toUpperCase(),
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF3B82F6),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Timer badge
                        if (isSelected)
                          GestureDetector(
                            onTap: () => _showTimerDialog(realIndex),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${timer}s',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF3B82F6),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Bottom save button
      bottomNavigationBar: _selectedIndices.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _savePlan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      'GENERATE EXERCISES (${_selectedIndices.length})',
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
                    ),
                  ),
                ),
              ),
            )
          : null,
    ),
    );
  }
}
