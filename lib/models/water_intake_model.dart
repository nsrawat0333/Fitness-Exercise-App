import 'package:flutter/material.dart';

/// Model for a single water intake history entry.
class WaterHistoryEntry {
  final String label;
  final String time;
  final int amountMl;

  const WaterHistoryEntry({
    required this.label,
    required this.time,
    required this.amountMl,
  });
}

/// Model for a hydration reminder.
class WaterReminder {
  TimeOfDay time;
  bool enabled;

  WaterReminder({required this.time, this.enabled = true});
}

/// Vessel (cup) size option.
class VesselSize {
  final String label;
  final int ml;
  final IconData icon;

  const VesselSize({
    required this.label,
    required this.ml,
    required this.icon,
  });
}

/// Water intake data model.
/// Ready for future Firebase integration.
class WaterIntakeModel {
  int currentIntakeMl;
  int dailyGoalMl;
  int selectedVesselIndex;
  bool remindersEnabled;
  String reminderInterval;
  List<WaterHistoryEntry> history;
  List<WaterReminder> reminders;

  WaterIntakeModel({
    required this.currentIntakeMl,
    required this.dailyGoalMl,
    this.selectedVesselIndex = 1,
    this.remindersEnabled = true,
    this.reminderInterval = 'Every 2 hours (8 AM - 8 PM)',
    required this.history,
    required this.reminders,
  });

  double get progressFraction => (currentIntakeMl / dailyGoalMl).clamp(0.0, 1.0);
  int get progressPercent => (progressFraction * 100).round();
  double get currentLiters => currentIntakeMl / 1000;
  double get goalLiters => dailyGoalMl / 1000;

  static const List<VesselSize> vessels = [
    VesselSize(label: '150ml', ml: 150, icon: Icons.local_cafe_outlined),
    VesselSize(label: '250ml', ml: 250, icon: Icons.local_drink),
    VesselSize(label: '500ml', ml: 500, icon: Icons.local_cafe_outlined),
  ];

  /// Mock data matching the screenshot.
  factory WaterIntakeModel.mock() => WaterIntakeModel(
        currentIntakeMl: 1200,
        dailyGoalMl: 2000,
        selectedVesselIndex: 1,
        remindersEnabled: true,
        reminderInterval: 'Every 2 hours (8 AM - 8 PM)',
        history: const [
          WaterHistoryEntry(label: 'Medium Glass', time: '09:15 AM', amountMl: 250),
          WaterHistoryEntry(label: 'Large Bottle', time: '12:30 PM', amountMl: 500),
          WaterHistoryEntry(label: 'Large Bottle', time: '02:45 PM', amountMl: 450),
        ],
        reminders: [
          WaterReminder(time: const TimeOfDay(hour: 8, minute: 0)),
          WaterReminder(time: const TimeOfDay(hour: 10, minute: 0)),
          WaterReminder(time: const TimeOfDay(hour: 12, minute: 0)),
          WaterReminder(time: const TimeOfDay(hour: 14, minute: 0)),
          WaterReminder(time: const TimeOfDay(hour: 16, minute: 0)),
        ],
      );
}
