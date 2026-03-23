import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import 'gym_daily_workout_screen.dart';

class GymChallengeDetailScreen extends StatefulWidget {
  const GymChallengeDetailScreen({super.key});

  @override
  State<GymChallengeDetailScreen> createState() => _GymChallengeDetailScreenState();
}

class _GymChallengeDetailScreenState extends State<GymChallengeDetailScreen> {
  // Let's assume day 2 is the current active day for UI demonstration
  final int currentDay = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(context),
          SliverToBoxAdapter(
            child: _buildBodyContent(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: FloatingActionButton.extended(
            onPressed: () {
              // Pressing "GO" opens the current day's workout
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => GymDailyWorkoutScreen(dayIndex: currentDay))
              );
            },
            backgroundColor: const Color(0xFF005FF9),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            label: Text(
              'GO',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final isCollapsed = constraints.biggest.height <= kToolbarHeight + 40;
          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 48, bottom: 16),
            title: isCollapsed
                ? Text(
                    'FULL BODY CHALLENGE',
                    style: GoogleFonts.outfit(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                : null,
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/gym/goal_keep_fit_male.png', // A wide male torso image placeholder
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FULL BODY CHALLENGE',
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            'BEGINNER',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white70,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.edit, color: Colors.white70, size: 14),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '27 Days left',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '4%',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Progress bar
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: 0.04, // 4%
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBodyContent() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      // To shift the content up over the app bar slightly like a card sheet:
      transform: Matrix4.translationValues(0.0, -20.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Motivation card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE9EEF5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/gym/gender_male.png'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Feeling more strength in your body! You're on the right track!",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Timeline
            Stack(
              children: [
                // Vertical connecting line
                Positioned(
                  left: 11,
                  top: 10,
                  bottom: 0,
                  child: Container(
                    width: 2,
                    color: const Color(0xFFE0E0E0), // dashed in real life, solid is ok
                  ),
                ),
                Positioned(
                  left: 11,
                  top: 10,
                  height: 200, // Make part of the line solid blue to match progress
                  child: Container(
                    width: 2,
                    color: const Color(0xFF005FF9),
                  ),
                ),
                Column(
                  children: [
                    _buildWeekSection(
                      weekNumber: 1,
                      isCurrentWeek: true,
                      progressText: '2/7',
                      startDayOffset: 0,
                    ),
                    const SizedBox(height: 24),
                    _buildWeekSection(
                      weekNumber: 2,
                      isCurrentWeek: false,
                      progressText: '',
                      startDayOffset: 7,
                    ),
                    const SizedBox(height: 24),
                    _buildWeekSection(
                      weekNumber: 3,
                      isCurrentWeek: false,
                      progressText: '',
                      startDayOffset: 14,
                    ),
                    const SizedBox(height: 24),
                    _buildWeekSection(
                      weekNumber: 4,
                      isCurrentWeek: false,
                      progressText: '',
                      startDayOffset: 21,
                    ),
                    const SizedBox(height: 80), // Fab space
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekSection({
    required int weekNumber,
    required bool isCurrentWeek,
    required String progressText,
    required int startDayOffset,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Week Title Row
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCurrentWeek ? const Color(0xFF005FF9) : const Color(0xFFB0BEC5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCurrentWeek ? Icons.check : Icons.bolt,
                size: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Week $weekNumber',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isCurrentWeek ? const Color(0xFF005FF9) : const Color(0xFF546E7A),
              ),
            ),
            const Spacer(),
            if (progressText.isNotEmpty)
              Text(
                progressText,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF546E7A),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        // Week Card
        Container(
          margin: const EdgeInsets.only(left: 36), // Offset from the line
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDaysRow(startDayOffset + 1, 4),
              const SizedBox(height: 16),
              _buildDaysRow(startDayOffset + 5, 3, hasTrophy: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDaysRow(int startDay, int count, {bool hasTrophy = false}) {
    List<Widget> children = [];
    for (int i = 0; i < count; i++) {
      final overrideDayIndex = (startDay + i) - ((startDay - 1) ~/ 7) * 7; 
      // ensures we print 1..7 for each week box instead of 1..28
      children.add(_buildDayCircle(startDay + i, displayNum: overrideDayIndex));
      if (i < count - 1 || hasTrophy) {
        children.add(const Icon(Icons.chevron_right, color: Color(0xFFE0E0E0), size: 16));
      }
    }
    
    if (hasTrophy) {
      children.add(
        const Icon(Icons.emoji_events, color: Colors.grey, size: 30) // placeholder for trophy
      );
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }

  Widget _buildDayCircle(int globalDay, {required int displayNum}) {
    // Current state mock logic:
    // globalDay == 1 : Completed
    // globalDay == 2 : Active/Current
    // globalDay > 2 : Future
    
    bool isCompleted = globalDay < currentDay;
    bool isActive = globalDay == currentDay;
    bool isFuture = globalDay > currentDay;

    return GestureDetector(
      onTap: () {
        if (!isFuture) {
           Navigator.push(context, MaterialPageRoute(
             builder: (_) => GymDailyWorkoutScreen(dayIndex: globalDay)
           ));
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isCompleted ? const Color(0xFF005FF9) 
              : (isActive ? Colors.white : const Color(0xFFF0F2F5)),
          shape: BoxShape.circle,
          border: isActive ? Border.all(color: const Color(0xFF005FF9), width: 1.5) : null,
        ),
        alignment: Alignment.center,
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : Text(
                '$displayNum',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isActive ? const Color(0xFF005FF9) : const Color(0xFF78909C),
                ),
              ),
      ),
    );
  }
}
