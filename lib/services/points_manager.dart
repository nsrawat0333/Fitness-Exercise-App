import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';

enum SyncStatus { synced, syncing, offlinePending }

class PointsManager {
  // Singleton pattern for centralized status listener
  static final PointsManager _instance = PointsManager._internal();
  factory PointsManager() => _instance;
  PointsManager._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _offlinePointsKey = 'offline_pending_points';
  
  // Expose status for UI to listen to
  final ValueNotifier<SyncStatus> syncStatus = ValueNotifier(SyncStatus.synced);

  /// Adds points for completing a workout. 
  /// Ensures users only get points once per day.
  /// Handles offline caching if Firestore fails.
  Future<bool> addWorkoutPoints(int points) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    // Use current date as the key (e.g., "2023-10-15")
    final String todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      final docRef = _firestore.collection('users').doc(user.uid);
      final snapshot = await docRef.get();

      if (!snapshot.exists) return false;

      final data = snapshot.data();
      final workoutHistory = data?['workoutHistory'] as Map<String, dynamic>? ?? {};

      // Ensure points are only awarded once per day
      if (workoutHistory.containsKey(todayString) && workoutHistory[todayString] == true) {
        return false; // Already earned points today
      }

      // Add points to Firestore
      await docRef.update({
        'points': FieldValue.increment(points),
        'workoutHistory.$todayString': true,
      });

      return true; // Successfully added points online
    } catch (e) {
      // If Firestore fails (e.g., offline), store it locally
      await _cachePointsOffline(points, todayString);
      syncStatus.value = SyncStatus.offlinePending;
      return true; // Return true because they "earned" it, we will sync it later
    }
  }

  /// Caches points locally in SharedPreferences when offline.
  Future<void> _cachePointsOffline(int points, String dateKey) async {
    final prefs = await SharedPreferences.getInstance();
    int currentOfflinePoints = prefs.getInt(_offlinePointsKey) ?? 0;
    await prefs.setInt(_offlinePointsKey, currentOfflinePoints + points);
    
    // Also save the date so we know we marked today
    await prefs.setBool('offline_workout_$dateKey', true);
  }

  /// Called on app startup to sync any points earned while offline.
  Future<void> syncOfflineData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    int offlinePoints = prefs.getInt(_offlinePointsKey) ?? 0;

    if (offlinePoints > 0) {
      syncStatus.value = SyncStatus.syncing;
      try {
        final docRef = _firestore.collection('users').doc(user.uid);
        
        // Find offline dates and add to history
        Map<String, bool> offlineHistoryUpdates = {};
        final keys = prefs.getKeys();
        for (String key in keys) {
          if (key.startsWith('offline_workout_')) {
            String date = key.replaceFirst('offline_workout_', '');
            offlineHistoryUpdates['workoutHistory.$date'] = true;
          }
        }

        // Add both paths into a single update
        Map<String, dynamic> updates = {
          'points': FieldValue.increment(offlinePoints),
        };
        updates.addAll(offlineHistoryUpdates);

        await docRef.update(updates);

        // Clear local cache upon success
        await prefs.remove(_offlinePointsKey);
        for (String key in keys) {
          if (key.startsWith('offline_workout_')) {
            await prefs.remove(key);
          }
        }
        syncStatus.value = SyncStatus.synced;
      } catch (e) {
        syncStatus.value = SyncStatus.offlinePending;
        // Still offline, will try again next time
      }
    } else {
      syncStatus.value = SyncStatus.synced;
    }
  }
}
