import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FamilyMember {
  final String uid;
  final String name;
  final int points;

  FamilyMember({required this.uid, required this.name, required this.points});

  factory FamilyMember.fromMap(String uid, Map<String, dynamic> data) {
    return FamilyMember(
      uid: uid,
      name: data['name'] ?? 'Family Member',
      points: data['points'] ?? 0,
    );
  }
}

class FamilyService {
  static final FamilyService _instance = FamilyService._internal();
  factory FamilyService() => _instance;
  FamilyService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _generateFamilyCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  /// Creates a new family group and adds the current user as the creator/member.
  Future<String?> createFamily() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final code = _generateFamilyCode();
    try {
      await _firestore.collection('families').doc(code).set({
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': user.uid,
        'members': [user.uid],
      });

      await _firestore.collection('users').doc(user.uid).update({
        'familyCode': code,
      });

      return code;
    } catch (e) {
      debugPrint("Error creating family: $e");
      return null;
    }
  }

  /// Joins an existing family group using the 6-character code.
  Future<bool> joinFamily(String code) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    code = code.trim().toUpperCase();

    try {
      final familyDoc = await _firestore.collection('families').doc(code).get();
      if (!familyDoc.exists) return false;

      // Add user to family
      await _firestore.collection('families').doc(code).update({
        'members': FieldValue.arrayUnion([user.uid]),
      });

      // Add familyCode to user
      await _firestore.collection('users').doc(user.uid).update({
        'familyCode': code,
      });

      return true;
    } catch (e) {
      debugPrint("Error joining family: $e");
      return false;
    }
  }

  /// Leaves the current family group.
  Future<void> leaveFamily() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final code = userDoc.data()?['familyCode'];

      if (code != null && code.toString().isNotEmpty) {
        // Remove from family members array
        await _firestore.collection('families').doc(code).update({
          'members': FieldValue.arrayRemove([user.uid]),
        });
      }

      // Clear from user document
      await _firestore.collection('users').doc(user.uid).update({
        'familyCode': FieldValue.delete(),
      });
    } catch (e) {
      debugPrint("Error leaving family: $e");
    }
  }

  /// Returns a stream of FamilyMember objects ranked by points descending
  Stream<List<FamilyMember>> getFamilyLeaderboard() async* {
    final user = _auth.currentUser;
    if (user == null) yield [];

    // First, listen to the user's document to get their familyCode
    await for (final userSnapshot in _firestore.collection('users').doc(user!.uid).snapshots()) {
      if (!userSnapshot.exists) yield <FamilyMember>[];
      
      final familyCode = userSnapshot.data()?['familyCode'];
      if (familyCode == null || familyCode.toString().isEmpty) {
        yield <FamilyMember>[];
        continue;
      }

      // Then grab the family document
      final familyDoc = await _firestore.collection('families').doc(familyCode).get();
      if (!familyDoc.exists) {
        yield <FamilyMember>[];
        continue;
      }

      final List<dynamic> memberUids = familyDoc.data()?['members'] ?? [];
      
      if (memberUids.isEmpty) {
        yield <FamilyMember>[];
        continue;
      }

      // Fetch all member users (Batched query for leaderboard)
      // Note: `whereIn` accepts max 10 values in Firestore. Assuming families are <= 10.
      List<String> uids = memberUids.cast<String>();
      if (uids.length > 10) uids = uids.sublist(0, 10); 

      final querySnapshot = await _firestore.collection('users').where(FieldPath.documentId, whereIn: uids).get();
      
      List<FamilyMember> membersList = querySnapshot.docs.map((doc) => FamilyMember.fromMap(doc.id, doc.data())).toList();
      
      // Sort by points descending
      membersList.sort((a, b) => b.points.compareTo(a.points));
      
      yield membersList;
    }
  }

  /// Fetch user's current family code
  Future<String?> getMyFamilyCode() async {
     final user = _auth.currentUser;
     if (user == null) return null;
     final doc = await _firestore.collection('users').doc(user.uid).get();
     return doc.data()?['familyCode'] as String?;
  }
}
