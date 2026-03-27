import 'package:flutter/material.dart';

class ScheduledCourse {
  final String courseId;
  final String courseName;
  final int totalDays;
  final TimeOfDay? preferredTime;
  final DateTime startDate;
  final Map<int, bool> completedDays; // Day Index -> Is Completed

  ScheduledCourse({
    required this.courseId,
    required this.courseName,
    required this.totalDays,
    this.preferredTime,
    required this.startDate,
    this.completedDays = const {},
  });

  factory ScheduledCourse.fromMap(Map<String, dynamic> map) {
    TimeOfDay? time;
    if (map['preferredTime'] != null) {
      final parts = map['preferredTime'].toString().split(':');
      if (parts.length == 2) {
         time = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    }

    return ScheduledCourse(
      courseId: map['courseId'] ?? '',
      courseName: map['courseName'] ?? '',
      totalDays: map['totalDays'] ?? 0,
      preferredTime: time,
      startDate: DateTime.parse(map['startDate'] ?? DateTime.now().toIso8601String()),
      completedDays: Map<int, bool>.from(map['completedDays'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      'totalDays': totalDays,
      'preferredTime': preferredTime != null ? '${preferredTime!.hour}:${preferredTime!.minute}' : null,
      'startDate': startDate.toIso8601String(),
      'completedDays': completedDays,
    };
  }
}
