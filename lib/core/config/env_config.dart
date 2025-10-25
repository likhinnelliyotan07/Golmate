import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  // Firebase Web Configuration
  static String get firebaseWebApiKey =>
      dotenv.env['FIREBASE_WEB_API_KEY'] ?? '';
  static String get firebaseWebAppId => dotenv.env['FIREBASE_WEB_APP_ID'] ?? '';
  static String get firebaseWebMessagingSenderId =>
      dotenv.env['FIREBASE_WEB_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseWebProjectId =>
      dotenv.env['FIREBASE_WEB_PROJECT_ID'] ?? '';
  static String get firebaseWebAuthDomain =>
      dotenv.env['FIREBASE_WEB_AUTH_DOMAIN'] ?? '';
  static String get firebaseWebStorageBucket =>
      dotenv.env['FIREBASE_WEB_STORAGE_BUCKET'] ?? '';
  static String get firebaseWebMeasurementId =>
      dotenv.env['FIREBASE_WEB_MEASUREMENT_ID'] ?? '';

  // Firebase Android Configuration
  static String get firebaseAndroidApiKey =>
      dotenv.env['FIREBASE_ANDROID_API_KEY'] ?? '';
  static String get firebaseAndroidAppId =>
      dotenv.env['FIREBASE_ANDROID_APP_ID'] ?? '';
  static String get firebaseAndroidMessagingSenderId =>
      dotenv.env['FIREBASE_ANDROID_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseAndroidProjectId =>
      dotenv.env['FIREBASE_ANDROID_PROJECT_ID'] ?? '';
  static String get firebaseAndroidStorageBucket =>
      dotenv.env['FIREBASE_ANDROID_STORAGE_BUCKET'] ?? '';

  // Firebase iOS Configuration
  static String get firebaseIosApiKey =>
      dotenv.env['FIREBASE_IOS_API_KEY'] ?? '';
  static String get firebaseIosAppId => dotenv.env['FIREBASE_IOS_APP_ID'] ?? '';
  static String get firebaseIosMessagingSenderId =>
      dotenv.env['FIREBASE_IOS_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseIosProjectId =>
      dotenv.env['FIREBASE_IOS_PROJECT_ID'] ?? '';
  static String get firebaseIosStorageBucket =>
      dotenv.env['FIREBASE_IOS_STORAGE_BUCKET'] ?? '';
  static String get firebaseIosBundleId =>
      dotenv.env['FIREBASE_IOS_BUNDLE_ID'] ?? '';

  // Firebase macOS Configuration
  static String get firebaseMacosApiKey =>
      dotenv.env['FIREBASE_MACOS_API_KEY'] ?? '';
  static String get firebaseMacosAppId =>
      dotenv.env['FIREBASE_MACOS_APP_ID'] ?? '';
  static String get firebaseMacosMessagingSenderId =>
      dotenv.env['FIREBASE_MACOS_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseMacosProjectId =>
      dotenv.env['FIREBASE_MACOS_PROJECT_ID'] ?? '';
  static String get firebaseMacosStorageBucket =>
      dotenv.env['FIREBASE_MACOS_STORAGE_BUCKET'] ?? '';
  static String get firebaseMacosBundleId =>
      dotenv.env['FIREBASE_MACOS_BUNDLE_ID'] ?? '';

  // Firebase Windows Configuration
  static String get firebaseWindowsApiKey =>
      dotenv.env['FIREBASE_WINDOWS_API_KEY'] ?? '';
  static String get firebaseWindowsAppId =>
      dotenv.env['FIREBASE_WINDOWS_APP_ID'] ?? '';
  static String get firebaseWindowsMessagingSenderId =>
      dotenv.env['FIREBASE_WINDOWS_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseWindowsProjectId =>
      dotenv.env['FIREBASE_WINDOWS_PROJECT_ID'] ?? '';
  static String get firebaseWindowsAuthDomain =>
      dotenv.env['FIREBASE_WINDOWS_AUTH_DOMAIN'] ?? '';
  static String get firebaseWindowsStorageBucket =>
      dotenv.env['FIREBASE_WINDOWS_STORAGE_BUCKET'] ?? '';
  static String get firebaseWindowsMeasurementId =>
      dotenv.env['FIREBASE_WINDOWS_MEASUREMENT_ID'] ?? '';

  // API Configuration
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.goalmate.com';
  static int get apiTimeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;

  // App Configuration
  static String get appName => dotenv.env['APP_NAME'] ?? 'Goal Mate';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';

  // Validation methods
  static bool get isFirebaseWebConfigured =>
      firebaseWebApiKey.isNotEmpty &&
      firebaseWebAppId.isNotEmpty &&
      firebaseWebProjectId.isNotEmpty;

  static bool get isFirebaseAndroidConfigured =>
      firebaseAndroidApiKey.isNotEmpty &&
      firebaseAndroidAppId.isNotEmpty &&
      firebaseAndroidProjectId.isNotEmpty;

  static bool get isFirebaseIosConfigured =>
      firebaseIosApiKey.isNotEmpty &&
      firebaseIosAppId.isNotEmpty &&
      firebaseIosProjectId.isNotEmpty;

  static bool get isFirebaseMacosConfigured =>
      firebaseMacosApiKey.isNotEmpty &&
      firebaseMacosAppId.isNotEmpty &&
      firebaseMacosProjectId.isNotEmpty;

  static bool get isFirebaseWindowsConfigured =>
      firebaseWindowsApiKey.isNotEmpty &&
      firebaseWindowsAppId.isNotEmpty &&
      firebaseWindowsProjectId.isNotEmpty;

  // Initialize environment variables
  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }
}
