import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // App Information
  static String get appName => dotenv.env['APP_NAME'] ?? 'Goal Mate';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';

  // API Constants
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.goalmate.com';
  static int get connectionTimeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;
  static int get receiveTimeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String goalsCollection = 'goals';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 50.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}
