import '../constants/app_constants.dart';

class ValidationHandler {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.emailRequired';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'validation.emailInvalid';
    }
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.passwordRequired';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'validation.passwordTooShort';
    }
    if (value.length > AppConstants.maxPasswordLength) {
      return 'validation.passwordTooLong';
    }
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'validation.passwordRequired';
    }
    if (value != password) {
      return 'validation.passwordsDoNotMatch';
    }
    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.nameRequired';
    }
    if (value.length < AppConstants.minNameLength) {
      return 'validation.nameTooShort';
    }
    if (value.length > AppConstants.maxNameLength) {
      return 'validation.nameTooLong';
    }
    return null;
  }

  // Phone validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.phoneRequired';
    }
    if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value)) {
      return 'validation.phoneInvalid';
    }
    return null;
  }

  // Generic required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'validation.${fieldName}Required';
    }
    return null;
  }

  // Custom validation with custom message
  static String? validateCustom(
    String? value,
    bool Function(String) validator,
    String errorMessage,
  ) {
    if (value == null || value.isEmpty) {
      return 'validation.fieldRequired';
    }
    if (!validator(value)) {
      return errorMessage;
    }
    return null;
  }
}
