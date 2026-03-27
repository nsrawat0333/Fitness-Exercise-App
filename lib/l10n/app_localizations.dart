import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// All translatable strings for the app.
/// Usage: AppLocalizations.of(context).translate('key')
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// Master translation map. Add new languages here.
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // ── General ──
      'app_name': 'FitFi',
      'ok': 'OK',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'back': 'Back',
      'next': 'Next',
      'done': 'Done',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'settings': 'Settings',
      'language': 'Language',
      'select_language': 'Select Language',

      // ── Auth ──
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      'logout': 'Logout',

      // ── Home ──
      'home': 'Home',
      'good_morning': 'Good Morning',
      'good_afternoon': 'Good Afternoon',
      'good_evening': 'Good Evening',
      'today_goal': "Today's Goal",
      'steps': 'Steps',
      'calories': 'Calories',
      'water': 'Water',
      'heart_rate': 'Heart Rate',

      // ── Gym / Workout ──
      'home_workout': 'HOME WORKOUT',
      'start_workout': 'Start Workout',
      'start_plan': 'START PLAN',
      'create_your_plan': 'Create Your Plan',
      'custom_workout': 'Custom Workout',
      'create_your_own_plan': 'Create Your Own Plan',
      'my_custom_plan': 'My Custom Plan',
      'exercises': 'exercises',
      'search_exercises': 'Search exercises...',
      'tap_to_select': 'Tap to select, long press for timer',
      'generate_exercises': 'GENERATE EXERCISES',
      'selected': 'selected',
      'full_body': 'Full Body',
      'chest': 'Chest',
      'back_body': 'Back',
      'shoulders': 'Shoulders',
      'biceps': 'Biceps',
      'triceps': 'Triceps',
      'abs': 'Abs',
      'legs': 'Legs',
      'glutes': 'Glutes',
      'beginner': 'Beginner',
      'intermediate': 'Intermediate',
      'advanced': 'Advanced',

      // ── Workout Flow ──
      'get_ready': 'GET READY',
      'breathe': 'Breathe',
      'preview': 'Preview',
      'perform': 'Perform',
      'recovery': 'Recovery',
      'rest': 'Rest',
      'exercise_complete': 'Exercise Complete!',
      'workout_complete': 'Workout Complete!',
      'great_job': 'Great Job!',
      'sets': 'Sets',
      'reps': 'Reps',
      'duration': 'Duration',

      // ── Diet ──
      'your_diet_plan': 'Your Diet Plan',
      'breakfast': 'Breakfast',
      'lunch': 'Lunch',
      'dinner': 'Dinner',
      'snacks': 'Snacks',

      // ── Challenge ──
      'full_body_challenge': 'FULL BODY CHALLENGE',
      'days_left': 'Days left',
      'program_overview': 'Program Overview',
      'description': 'Description',

      // ── Step Counter ──
      'step_counter': 'Step Counter',
      'daily_steps': 'Daily Steps',
      'weekly_average': 'Weekly Average',
      'distance': 'Distance',

      // ── Water Tracker ──
      'water_tracker': 'Water Tracker',
      'add_water': 'Add Water',
      'daily_goal': 'Daily Goal',
      'glasses': 'glasses',

      // ── Leaderboard ──
      'leaderboard': 'Leaderboard',
      'global': 'Global',
      'friends': 'Friends',

      // ── Settings ──
      'profile': 'Profile',
      'notifications': 'Notifications',
      'dark_mode': 'Dark Mode',
      'about': 'About',
    },
    'hi': {
      // ── General ──
      'app_name': 'फिटफाई',
      'ok': 'ठीक है',
      'cancel': 'रद्द करें',
      'save': 'सहेजें',
      'delete': 'हटाएं',
      'back': 'वापस',
      'next': 'आगे',
      'done': 'पूर्ण',
      'loading': 'लोड हो रहा है...',
      'error': 'त्रुटि',
      'retry': 'पुन: प्रयास करें',
      'settings': 'सेटिंग्स',
      'language': 'भाषा',
      'select_language': 'भाषा चुनें',

      // ── Auth ──
      'login': 'लॉगिन',
      'register': 'रजिस्टर',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'forgot_password': 'पासवर्ड भूल गए?',
      'logout': 'लॉगआउट',

      // ── Home ──
      'home': 'होम',
      'good_morning': 'सुप्रभात',
      'good_afternoon': 'शुभ दोपहर',
      'good_evening': 'शुभ संध्या',
      'today_goal': 'आज का लक्ष्य',
      'steps': 'कदम',
      'calories': 'कैलोरी',
      'water': 'पानी',
      'heart_rate': 'हृदय गति',

      // ── Gym / Workout ──
      'home_workout': 'होम वर्कआउट',
      'start_workout': 'वर्कआउट शुरू करें',
      'start_plan': 'प्लान शुरू करें',
      'create_your_plan': 'अपना प्लान बनाएं',
      'custom_workout': 'कस्टम वर्कआउट',
      'create_your_own_plan': 'अपना खुद का प्लान बनाएं',
      'my_custom_plan': 'मेरा कस्टम प्लान',
      'exercises': 'व्यायाम',
      'search_exercises': 'व्यायाम खोजें...',
      'tap_to_select': 'चुनने के लिए टैप करें, टाइमर के लिए लंबा दबाएं',
      'generate_exercises': 'व्यायाम जनरेट करें',
      'selected': 'चयनित',
      'full_body': 'पूरा शरीर',
      'chest': 'छाती',
      'back_body': 'पीठ',
      'shoulders': 'कंधे',
      'biceps': 'बाइसेप्स',
      'triceps': 'ट्राइसेप्स',
      'abs': 'एब्स',
      'legs': 'टांगें',
      'glutes': 'ग्लूट्स',
      'beginner': 'शुरुआती',
      'intermediate': 'मध्यम',
      'advanced': 'उन्नत',

      // ── Workout Flow ──
      'get_ready': 'तैयार हो जाएं',
      'breathe': 'सांस लें',
      'preview': 'पूर्वावलोकन',
      'perform': 'प्रदर्शन',
      'recovery': 'रिकवरी',
      'rest': 'आराम',
      'exercise_complete': 'व्यायाम पूरा!',
      'workout_complete': 'वर्कआउट पूरा!',
      'great_job': 'शाबाश!',
      'sets': 'सेट',
      'reps': 'रेप्स',
      'duration': 'अवधि',

      // ── Diet ──
      'your_diet_plan': 'आपका डाइट प्लान',
      'breakfast': 'सुबह का नाश्ता',
      'lunch': 'दोपहर का खाना',
      'dinner': 'रात का खाना',
      'snacks': 'स्नैक्स',

      // ── Challenge ──
      'full_body_challenge': 'पूरे शरीर की चुनौती',
      'days_left': 'दिन बाकी',
      'program_overview': 'प्रोग्राम का अवलोकन',
      'description': 'विवरण',

      // ── Step Counter ──
      'step_counter': 'कदम गिनती',
      'daily_steps': 'दैनिक कदम',
      'weekly_average': 'साप्ताहिक औसत',
      'distance': 'दूरी',

      // ── Water Tracker ──
      'water_tracker': 'पानी ट्रैकर',
      'add_water': 'पानी जोड़ें',
      'daily_goal': 'दैनिक लक्ष्य',
      'glasses': 'गिलास',

      // ── Leaderboard ──
      'leaderboard': 'लीडरबोर्ड',
      'global': 'वैश्विक',
      'friends': 'दोस्त',

      // ── Settings ──
      'profile': 'प्रोफ़ाइल',
      'notifications': 'सूचनाएं',
      'dark_mode': 'डार्क मोड',
      'about': 'के बारे में',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? 
           _localizedValues['en']?[key] ?? 
           key;
  }

  /// Shorthand for translate
  String tr(String key) => translate(key);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// Manages locale state with persistence via SharedPreferences.
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  static const String _prefKey = 'app_language';

  Locale get locale => _locale;

  /// Load saved language preference
  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString(_prefKey) ?? 'en';
    _locale = Locale(langCode);
    notifyListeners();
  }

  /// Switch language and save preference
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
    notifyListeners();
  }

  /// Convenience: get available languages
  static List<Map<String, String>> get supportedLanguages => [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'hi', 'name': 'हिन्दी', 'flag': '🇮🇳'},
  ];
}
