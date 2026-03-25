import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class FamilyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Creates a random 6-character alphanumeric Family ID
  String _generateFamilyId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  /// Create a new Family group
  Future<String> createFamily() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Must be logged in to create a family.");

    String newFamilyId = _generateFamilyId();
    
    // Ensure uniqueness (usually a loop, but 6 chars is highly likely unique early on)
    final existing = await _firestore.collection('users').where('familyId', isEqualTo: newFamilyId).get();
    if (existing.docs.isNotEmpty) {
      newFamilyId = _generateFamilyId(); // Retry once for safety
    }

    await _firestore.collection('users').doc(user.uid).update({
      'familyId': newFamilyId,
    });

    return newFamilyId;
  }

  /// Join an existing family using a 6-character code
  Future<void> joinFamily(String familyId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Must be logged in to join a family.");
    if (familyId.length != 6) {
      throw Exception("Invalid Family Code format. Must be 6 characters.");
    }

    final familyUsers = await _firestore.collection('users').where('familyId', isEqualTo: familyId.toUpperCase()).limit(1).get();

    if (familyUsers.docs.isEmpty) {
      throw Exception("Family not found. Please check the code.");
    }

    await _firestore.collection('users').doc(user.uid).update({
      'familyId': familyId.toUpperCase(),
    });
  }

  /// Leave the current family
  Future<void> leaveFamily() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Must be logged in.");

    await _firestore.collection('users').doc(user.uid).update({
      'familyId': FieldValue.delete(),
    });
  }
}
