import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Font Families
  static const String primaryFont = 'Roboto';
  static const String secondaryFont = 'OpenSans';

  // Display Styles
  static TextStyle get displayLarge => TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get displayMedium => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get displaySmall => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  // Headline Styles
  static TextStyle get headlineLarge => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get headlineMedium => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get headlineSmall => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  // Title Styles
  static TextStyle get titleLarge => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get titleMedium => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get titleSmall => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  // Body Styles
  static TextStyle get bodyLarge => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get bodySmall => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    fontFamily: primaryFont,
    color: AppColors.textSecondaryLight,
  );

  // Label Styles
  static TextStyle get labelLarge => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get labelMedium => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle get labelSmall => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    fontFamily: primaryFont,
    color: AppColors.textSecondaryLight,
  );

  // Button Styles
  static TextStyle get buttonLarge => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    color: AppColors.white,
  );

  static TextStyle get buttonMedium => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    color: AppColors.white,
  );

  static TextStyle get buttonSmall => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    fontFamily: primaryFont,
    color: AppColors.white,
  );

  // Custom Styles
  static TextStyle get welcomeText => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    fontFamily: primaryFont,
    color: AppColors.primary,
  );

  static TextStyle get errorText => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    fontFamily: primaryFont,
    color: AppColors.error,
  );

  static TextStyle get successText => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    fontFamily: primaryFont,
    color: AppColors.success,
  );

  static TextStyle get linkText => TextStyle(
    fontSize: 14.sp,
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
