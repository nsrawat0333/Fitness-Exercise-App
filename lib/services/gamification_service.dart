import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class GamificationData {
  final int totalPoints;
  final int currentStreak;
  final DateTime? lastWorkoutDate;

  GamificationData({
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.lastWorkoutDate,
  });

  factory GamificationData.fromMap(Map<String, dynamic> map) {
    return GamificationData(
      totalPoints: map['points'] ?? 0,
      currentStreak: map['currentStreak'] ?? 0,
      lastWorkoutDate: map['lastWorkoutDate'] != null 
          ? (map['lastWorkoutDate'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'points': totalPoints,
      'currentStreak': currentStreak,
      'lastWorkoutDate': lastWorkoutDate,
    };
  }
}

class GamificationService {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;
  GamificationService._internal();

  final ValueNotifier<GamificationData> dataNotifier = ValueNotifier(GamificationData());
  StreamSubscription? _userSub;

  void init() {
    // Listen to Firebase auth changes to bind data to the correct user.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _subscribeToUserData(user.uid);
      } else {
        _userSub?.cancel();
        dataNotifier.value = GamificationData();
      }
    });
  }

  void _subscribeToUserData(String uid) {
    _userSub?.cancel();
    _userSub = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((doc) {
      if (doc.exists && doc.data() != null) {
        dataNotifier.value = GamificationData.fromMap(doc.data()!);
      } else {
        // Initialize new user gamification data if doc missing basic fields
        if (doc.data() == null || !(doc.data()!.containsKey('points'))) {
           FirebaseFirestore.instance.collection('users').doc(uid).set(
             {'points': 0, 'currentStreak': 0},
             SetOptions(merge: true)
           );
        }
      }
    });
  }

  /// Award points for completing an activity. Calculates streak bonuses automatically.
  Future<void> awardPoints(int amount, String reason) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      int currentPoints = snapshot.data()?['points'] ?? 0;
      int currentStreak = snapshot.data()?['currentStreak'] ?? 0;
      Timestamp? lastWorkoutTs = snapshot.data()?['lastWorkoutDate'];
      
      final now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      
      int pointsToAward = amount;
      int newStreak = currentStreak;

      // Handle Streaks
      if (lastWorkoutTs != null) {
        DateTime lastWorkout = lastWorkoutTs.toDate();
        DateTime lastWorkoutDay = DateTime(lastWorkout.year, lastWorkout.month, lastWorkout.day);
        
        // If last workout was yesterday, increment streak
        if (today.difference(lastWorkoutDay).inDays == 1) {
          newStreak += 1;
          pointsToAward += (20); // 20 extra points for extending a streak!
        } else if (today.difference(lastWorkoutDay).inDays > 1) {
          // Streak broken
          newStreak = 0; 
        }
      } else {
        // First workout ever!
        newStreak = 1;
      }

      transaction.update(docRef, {
        'points': currentPoints + pointsToAward,
        'currentStreak': newStreak,
        'lastWorkoutDate': FieldValue.serverTimestamp(),
      });
      
      // Log the reward reason (optional, could be used for history)
      final historyRef = docRef.collection('point_history').doc();
      transaction.set(historyRef, {
        'amount': pointsToAward,
        'baseAmount': amount,
        'streakBonus': pointsToAward - amount,
        'reason': reason,
        'timestamp': FieldValue.serverTimestamp(),
      });
    });
  }
}
