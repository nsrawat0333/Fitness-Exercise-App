import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants/app_theme.dart';
import 'screens/main_navigation.dart';
import 'screens/account/login_register_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init failed: $e");
  }
  runApp(const FitFiApp());
}

/// Root widget for the FitFi app.
class FitFiApp extends StatelessWidget {
  const FitFiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitFi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}

/// AuthWrapper listens to Firebase Auth to determine the starting screen
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Color(0xFF5B7E5F))),
          );
        }
        // If logged in
        if (snapshot.hasData) {
          return const MainNavigation();
        }
        // If not logged in
        return const LoginRegisterScreen();
      },
    );
  }
}
