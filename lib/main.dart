import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'constants/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'screens/settings/language_settings_screen.dart';

import 'services/notification_service.dart';
import 'services/step_counter_service.dart';
import 'services/water_storage_service.dart';
import 'services/health_storage_service.dart';
import 'services/scheduling_service.dart';

import 'services/performance/performance_manager.dart';
import 'screens/splash_screen.dart';

Future<void> _safeInit(String name, Future<void> Function() init) async {
  try {
    await init();
  } catch (e) {
    debugPrint('$name init failed: $e');
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  // Initialize Performance Manager FIRST (profiles device, sets cache limits)
  await PerformanceManager().init();

  // Initialize Background & Storage Services
  await NotificationService().init();
  await Future.wait([
    _safeInit('WaterStorageService', () => WaterStorageService().init()),
    _safeInit('HealthStorageService', () => HealthStorageService().init()),
    _safeInit('StepCounterService', () => StepCounterService().init()),
    _safeInit('SchedulingService', () => SchedulingService().init()),
  ]);


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
