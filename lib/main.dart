import 'package:flutter/material.dart';
import 'constants/app_theme.dart';
import 'screens/main_navigation.dart';

void main() {
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
      home: const MainNavigation(),
    );
  }
}
