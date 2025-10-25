# Environment Variables Setup

This document explains how API keys and environment variables are handled in the Goal Mate Flutter project.

## Overview

The project uses `flutter_dotenv` to manage environment variables securely. All sensitive configuration like Firebase API keys, API endpoints, and app settings are stored in environment files rather than hardcoded in the source code.

## Files Structure

```
├── .env                    # Environment variables (DO NOT COMMIT)
├── .env.example           # Template for environment variables
├── lib/core/config/
│   └── env_config.dart    # Environment configuration service
└── ENVIRONMENT_SETUP.md  # This documentation
```

## Setup Instructions

### 1. Install Dependencies

The project already includes `flutter_dotenv: ^5.1.0` in `pubspec.yaml`. Run:

```bash
flutter pub get
```

### 2. Create Environment File

Copy the example file and fill in your actual values:

```bash
cp .env.example .env
```

### 3. Configure Your Environment Variables

Edit the `.env` file with your actual Firebase configuration and other settings:

```env
# Firebase Configuration
FIREBASE_WEB_API_KEY=your_actual_web_api_key
FIREBASE_WEB_APP_ID=your_actual_web_app_id
# ... (and so on for all platforms)

# API Configuration
API_BASE_URL=https://your-api-endpoint.com
API_TIMEOUT=30000

# App Configuration
APP_NAME=Goal Mate
APP_VERSION=1.0.0
```

## Environment Variables Reference

### Firebase Configuration

| Variable | Description | Example |
|----------|-------------|---------|
| `FIREBASE_WEB_API_KEY` | Firebase Web API Key | `AIzaSy...` |
| `FIREBASE_WEB_APP_ID` | Firebase Web App ID | `1:123456789:web:abc123` |
| `FIREBASE_ANDROID_API_KEY` | Firebase Android API Key | `AIzaSy...` |
| `FIREBASE_IOS_API_KEY` | Firebase iOS API Key | `AIzaSy...` |
| `FIREBASE_MACOS_API_KEY` | Firebase macOS API Key | `AIzaSy...` |
| `FIREBASE_WINDOWS_API_KEY` | Firebase Windows API Key | `AIzaSy...` |

### API Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `API_BASE_URL` | Base URL for API calls | `https://api.goalmate.com` |
| `API_TIMEOUT` | API request timeout in milliseconds | `30000` |

### App Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `APP_NAME` | Application name | `Goal Mate` |
| `APP_VERSION` | Application version | `1.0.0` |

## Usage in Code

### Accessing Environment Variables

Use the `EnvConfig` class to access environment variables:

```dart
import 'package:goal_mate/core/config/env_config.dart';

// Get Firebase configuration
String apiKey = EnvConfig.firebaseWebApiKey;
String projectId = EnvConfig.firebaseWebProjectId;

// Get API configuration
String baseUrl = EnvConfig.apiBaseUrl;
int timeout = EnvConfig.apiTimeout;

// Get app configuration
String appName = EnvConfig.appName;
String appVersion = EnvConfig.appVersion;
```

### Validation

The `EnvConfig` class includes validation methods:

```dart
// Check if Firebase is properly configured
if (EnvConfig.isFirebaseWebConfigured) {
  // Firebase Web is ready
}

if (EnvConfig.isFirebaseAndroidConfigured) {
  // Firebase Android is ready
}
```

## Security Best Practices

### 1. Never Commit .env Files

The `.env` file is already added to `.gitignore` to prevent accidental commits:

```gitignore
# Environment variables
.env
.env.local
.env.*.local
```

### 2. Use .env.example for Team Collaboration

The `.env.example` file serves as a template for team members:

1. Copy `.env.example` to `.env`
2. Fill in your actual values
3. Never commit the actual `.env` file

### 3. Environment-Specific Files

For different environments, you can use:

- `.env` - Default environment
- `.env.local` - Local development overrides
- `.env.production` - Production environment
- `.env.staging` - Staging environment

## Firebase Configuration

### Getting Firebase Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to Project Settings > General
4. Scroll down to "Your apps" section
5. For each platform (Web, Android, iOS, etc.), copy the configuration values

### Platform-Specific Configuration

Each platform has its own set of Firebase configuration variables:

- **Web**: `FIREBASE_WEB_*`
- **Android**: `FIREBASE_ANDROID_*`
- **iOS**: `FIREBASE_IOS_*`
- **macOS**: `FIREBASE_MACOS_*`
- **Windows**: `FIREBASE_WINDOWS_*`

## Troubleshooting

### Common Issues

1. **Environment variables not loading**
   - Ensure `.env` file exists in the project root
   - Check that `.env` is listed in `pubspec.yaml` assets
   - Verify `EnvConfig.init()` is called in `main.dart`

2. **Firebase initialization fails**
   - Verify all required Firebase environment variables are set
   - Check that Firebase project ID matches across all platforms
   - Ensure API keys are valid and not expired

3. **Build errors**
   - Run `flutter clean` and `flutter pub get`
   - Check that all environment variables have fallback values
   - Verify import statements are correct

### Debug Environment Variables

Add this to your code to debug environment variable loading:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Print all loaded environment variables
print('Loaded environment variables:');
dotenv.env.forEach((key, value) {
  print('$key: ${value.length > 10 ? '${value.substring(0, 10)}...' : value}');
});
```

## Migration from Hardcoded Values

The project has been migrated from hardcoded Firebase configuration to environment variables. The changes include:

1. **firebase_options.dart**: Now uses `EnvConfig` instead of hardcoded values
2. **app_constants.dart**: API configuration now uses environment variables
3. **main.dart**: Added `EnvConfig.init()` call
4. **pubspec.yaml**: Added `flutter_dotenv` dependency and `.env` asset

## Team Onboarding

For new team members:

1. Clone the repository
2. Copy `.env.example` to `.env`
3. Fill in the environment variables with actual values
4. Run `flutter pub get`
5. Run the application

## Production Deployment

For production deployment:

1. Set up environment variables in your deployment platform
2. Ensure all required variables are configured
3. Test the application in production environment
4. Monitor for any missing configuration

## Support

If you encounter issues with environment variable setup:

1. Check this documentation
2. Verify your `.env` file format
3. Ensure all required variables are present
4. Test with the debug code snippet above
