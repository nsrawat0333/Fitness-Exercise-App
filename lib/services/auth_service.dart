import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream of user auth state to handle auto-login
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Gets the current authorized user
  User? get currentUser => _auth.currentUser;

  /// Sign Up with Email and Password
  Future<UserCredential?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a default user document in Firestore "users" collection (STEP 4)
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'points': 0,
          'familyId': null,
          'workoutHistory': {},
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code));
    } catch (e) {
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  /// Log in with Email and Password
  Future<UserCredential?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e.code));
    } catch (e) {
      throw Exception('Login failed. Please try again.');
    }
  }

  /// Log out
  Future<void> logOut() async {
    await _auth.signOut();
  }

  /// Helper to convert Firebase error codes to readable messages
  String _handleAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password. Try again.';
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is invalid.';
      default:
        return 'Authentication failed ($code).';
    }
  }
}
