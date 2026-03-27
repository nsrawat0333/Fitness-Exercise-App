import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Set<DateTime> _workoutDays = {}; // Loaded from Firebase
  int _currentStreak = 0;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchWorkoutHistory();
  }

  Future<void> _fetchWorkoutHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docSnap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    
    if (docSnap.exists) {
      if (mounted) {
        setState(() {
          _currentStreak = docSnap.data()?['currentStreak'] ?? 0;
        });
      }
      
      final historySnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('point_history')
          .get();

      Set<DateTime> days = {};
      for (var doc in historySnap.docs) {
        final data = doc.data();
        if (data['timestamp'] != null) {
          final ts = (data['timestamp'] as Timestamp).toDate();
          days.add(DateTime(ts.year, ts.month, ts.day)); // Normalize to just the date
        }
      }
      
      if (mounted) {
         setState(() {
           _workoutDays = days;
         });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildStreakCard(),
            const SizedBox(height: 24),
            _buildCalendar(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text('Progress Calendar', style: AppTextStyles.heading2),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_fire_department, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_currentStreak Day Streak!',
                  style: AppTextStyles.heading3.copyWith(color: Colors.white),
                ),
                Text(
                  'Keep the momentum going.',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardLight,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; 
            });
          },
          calendarFormat: CalendarFormat.month,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            markerDecoration: const BoxDecoration(
              color: AppColors.aiTargetGreen,
              shape: BoxShape.circle,
            ),
          ),
          eventLoader: (day) {
            final normalizedDay = DateTime(day.year, day.month, day.day);
            if (_workoutDays.contains(normalizedDay)) {
              return ['Workout']; // Adds a dot marker
            }
            return [];
          },
        ),
      ),
    );
  }
}
