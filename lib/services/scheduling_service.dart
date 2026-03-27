import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course_schedule_model.dart';
import 'notification_service.dart';

class SchedulingService {
  static final SchedulingService _instance = SchedulingService._internal();
  factory SchedulingService() => _instance;
  SchedulingService._internal();

  final ValueNotifier<List<ScheduledCourse>> coursesNotifier = ValueNotifier([]);

  Future<void> init() async {
    await _loadCourses();
  }

  Future<void> _loadCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('scheduled_courses');
    if (dataString != null) {
      final List<dynamic> jsonList = jsonDecode(dataString);
      coursesNotifier.value = jsonList.map((m) => ScheduledCourse.fromMap(m)).toList();
    }
  }

  Future<void> _saveCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = coursesNotifier.value.map((c) => c.toMap()).toList();
    await prefs.setString('scheduled_courses', jsonEncode(jsonList));
  }

  Future<void> subscribeToCourse(ScheduledCourse course) async {
    final list = List<ScheduledCourse>.from(coursesNotifier.value);
    
    // Replace if exists, otherwise add
    final index = list.indexWhere((c) => c.courseId == course.courseId);
    if (index >= 0) {
      list[index] = course;
    } else {
      list.add(course);
    }
    
    coursesNotifier.value = list;
    await _saveCourses();
    
    // Schedule alarms in the background — don't block the caller
    if (course.preferredTime != null) {
      _scheduleCourseNotifications(course); // fire-and-forget
    }
  }
  
  Future<void> completeCourseDay(String courseId, int dayIndex) async {
    final list = List<ScheduledCourse>.from(coursesNotifier.value);
    final index = list.indexWhere((c) => c.courseId == courseId);
    if (index >= 0) {
      final current = list[index];
      current.completedDays[dayIndex] = true;
      list[index] = ScheduledCourse(
        courseId: current.courseId,
        courseName: current.courseName,
        totalDays: current.totalDays,
        preferredTime: current.preferredTime,
        startDate: current.startDate,
        completedDays: current.completedDays,
      );
      coursesNotifier.value = list;
      await _saveCourses();
    }
  }

  Future<void> _scheduleCourseNotifications(ScheduledCourse course) async {
    final time = course.preferredTime!;
    
    // Instead of scheduling 30 instances, let's schedule a recurring daily alarm, 
    // or specifically schedule the next 7 upcoming days using localized scheduling.
    
    for (int i = 0; i < course.totalDays; i++) {
        if (course.completedDays[i] == true) continue;
        
        final scheduledDate = DateTime(
          course.startDate.year,
          course.startDate.month,
          course.startDate.day + i,
          time.hour,
          time.minute
        );
        
        if (scheduledDate.isAfter(DateTime.now())) {
           // We derive a unique ID for this course's specific day
           int notificationId = (course.courseId.hashCode + i).abs();
           
           try {
             await NotificationService().scheduleNotification(
               id: notificationId,
               title: 'Time for ${course.courseName} 💪',
               body: 'Day ${i + 1} is waiting for you! Let\'s go!',
               scheduledDate: scheduledDate,
               payload: 'course|${course.courseId}|$i',
             );
           } catch (e) {
             debugPrint('Failed to schedule notification: $e');
             // Proceed without crashing so the user can still start their course
           }
        }
    }
  }
}
