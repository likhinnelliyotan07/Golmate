import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Font Families
  static const String primaryFont = 'Roboto';
  static const String secondaryFont = 'OpenSans';

  // Display Styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  // Headline Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  // Title Styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: primaryFont,
    color: AppColors.textSecondaryLight,
  );

  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
    color: AppColors.textSecondaryLight,
  );

  // Button Styles
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    color: AppColors.white,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    color: AppColors.white,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    color: AppColors.white,
  );

  // Custom Styles
  static const TextStyle welcomeText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: primaryFont,
    color: AppColors.primary,
  );

  static const TextStyle errorText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: primaryFont,
    color: AppColors.error,
  );

  static const TextStyle successText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: primaryFont,
    color: AppColors.success,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  // Dark Theme Styles
  static TextStyle get displayLargeDark =>
      displayLarge.copyWith(color: AppColors.textPrimaryDark);

  static TextStyle get displayMediumDark =>
      displayMedium.copyWith(color: AppColors.textPrimaryDark);

  static TextStyle get displaySmallDark =>
      displaySmall.copyWith(color: AppColors.textPrimaryDark);

  static TextStyle get headlineLargeDark =>
      headlineLarge.copyWith(color: AppColors.textPrimaryDark);

  static TextStyle get headlineMediumDark =>
      headlineMedium.copyWith(color: AppColors.textPrimaryDark);

  static TextStyle get headlineSmallDark =>
      headlineSmall.copyWith(color: AppColors.textPrimaryDark);

  static TextStyle get titleLargeDark =>
      titleLarge.copyWith(color: AppColors.textPrimaryDark);

  static TextStyle get titleMediumDark =>
      titleMedium.copyWith(color: AppColors.textPrimaryDark);

  static TextStyle get titleSmallDark =>
      titleSmall.copyWith(color: AppColors.textPrimaryDark);

  static TextStyle get bodyLargeDark =>
      bodyLarge.copyWith(color: AppColors.textPrimaryDark);

  static TextStyle get bodyMediumDark =>
      bodyMedium.copyWith(color: AppColors.textPrimaryDark);

  static TextStyle get bodySmallDark =>
      bodySmall.copyWith(color: AppColors.textSecondaryDark);

  static TextStyle get labelLargeDark =>
      labelLarge.copyWith(color: AppColors.textPrimaryDark);

  static TextStyle get labelMediumDark =>
      labelMedium.copyWith(color: AppColors.textPrimaryDark);

  static TextStyle get labelSmallDark =>
      labelSmall.copyWith(color: AppColors.textSecondaryDark);
}
