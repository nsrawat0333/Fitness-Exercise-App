import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants/app_theme.dart';
import 'screens/main_navigation.dart';
import 'screens/account/login_register_screen.dart';
import 'l10n/app_localizations.dart';
import 'screens/settings/language_settings_screen.dart';

import 'services/notification_service.dart';
import 'services/step_counter_service.dart';
import 'services/water_storage_service.dart';
import 'services/health_storage_service.dart';
import 'services/gamification_service.dart';
import 'services/scheduling_service.dart';
import 'services/voice_coach_service.dart';
import 'services/performance/performance_manager.dart';
import 'screens/splash_screen.dart';

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
  
  // Initialize Performance Manager FIRST (profiles device, sets cache limits)
  await PerformanceManager().init();

  // Initialize Background & Storage Services
  await NotificationService().init();
  await WaterStorageService().init();
  await HealthStorageService().init();
  await StepCounterService().init();
  GamificationService().init();
  await SchedulingService().init();
  await VoiceCoachService().init();

  // Initialize locale provider
  final localeProvider = LocaleProvider();
  await localeProvider.loadSavedLocale();

  runApp(FitFiApp(localeProvider: localeProvider));
}

/// Root widget for the FitFi app.
class FitFiApp extends StatelessWidget {
  final LocaleProvider localeProvider;

  const FitFiApp({super.key, required this.localeProvider});

  @override
  Widget build(BuildContext context) {
    return LocaleProviderFinder(
      provider: localeProvider,
      child: ListenableBuilder(
        listenable: localeProvider,
        builder: (context, _) {
          return MaterialApp(
            title: 'FitFi',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SplashScreen(),
          );
        },
      ),
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
