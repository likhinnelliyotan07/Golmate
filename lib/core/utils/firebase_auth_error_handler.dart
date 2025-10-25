import 'package:firebase_auth/firebase_auth.dart';

/// Handles Firebase Authentication errors and provides user-friendly error messages
class FirebaseAuthErrorHandler {
  /// Maps Firebase Auth error codes to user-friendly messages
  static String getErrorMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      // Email/Password Authentication Errors
      case 'invalid-credential':
        return 'errors.invalidCredentials';
      case 'user-disabled':
        return 'errors.userDisabled';
      case 'user-not-found':
        return 'errors.userNotFound';
      case 'wrong-password':
        return 'errors.wrongPassword';
      case 'email-already-in-use':
        return 'errors.emailAlreadyInUse';
      case 'invalid-email':
        return 'errors.invalidEmail';
      case 'weak-password':
        return 'errors.weakPassword';
      case 'operation-not-allowed':
        return 'errors.operationNotAllowed';
      case 'requires-recent-login':
        return 'errors.requiresRecentLogin';

      // Network and Server Errors
      case 'network-request-failed':
        return 'errors.networkError';
      case 'too-many-requests':
        return 'errors.tooManyRequests';
      case 'internal-error':
        return 'errors.serverError';

      // Google Sign-In Errors
      case 'account-exists-with-different-credential':
        return 'errors.accountExistsWithDifferentCredential';
      case 'invalid-verification-code':
        return 'errors.invalidVerificationCode';
      case 'invalid-verification-id':
        return 'errors.invalidVerificationId';
      case 'credential-already-in-use':
        return 'errors.credentialAlreadyInUse';

      // Phone Authentication Errors
      case 'invalid-phone-number':
        return 'errors.invalidPhoneNumber';
      case 'missing-phone-number':
        return 'errors.missingPhoneNumber';
      case 'quota-exceeded':
        return 'errors.quotaExceeded';

      // Session and Token Errors
      case 'invalid-user-token':
        return 'errors.invalidUserToken';
      case 'user-token-expired':
        return 'errors.userTokenExpired';
      case 'invalid-api-key':
        return 'errors.invalidApiKey';

      // Default case for unknown errors
      default:
        return 'errors.unknownError';
    }
  }

  /// Gets a user-friendly error message from any exception
  static String handleException(dynamic exception) {
    if (exception is FirebaseAuthException) {
      return getErrorMessage(exception);
    }

    // Handle other types of exceptions
    final errorString = exception.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'errors.networkError';
    }

    if (errorString.contains('timeout')) {
      return 'errors.timeoutError';
    }

    if (errorString.contains('permission') ||
        errorString.contains('unauthorized')) {
      return 'errors.permissionDenied';
    }

    return 'errors.unknownError';
  }

  /// Checks if the error is a network-related error
  static bool isNetworkError(dynamic exception) {
    if (exception is FirebaseAuthException) {
      return exception.code == 'network-request-failed';
    }

    final errorString = exception.toString().toLowerCase();
    return errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout');
  }

  /// Checks if the error is a credential-related error
  static bool isCredentialError(dynamic exception) {
    if (exception is FirebaseAuthException) {
      return [
        'invalid-credential',
        'wrong-password',
        'user-not-found',
        'invalid-email',
        'invalid-verification-code',
        'invalid-verification-id',
      ].contains(exception.code);
    }
    return false;
  }

  /// Checks if the error is a rate limiting error
  static bool isRateLimitError(dynamic exception) {
    if (exception is FirebaseAuthException) {
      return exception.code == 'too-many-requests';
    }
    return false;
  }

  /// Gets the original error code for debugging purposes
  static String getErrorCode(dynamic exception) {
    if (exception is FirebaseAuthException) {
      return exception.code;
    }
    return 'unknown';
  }
}
