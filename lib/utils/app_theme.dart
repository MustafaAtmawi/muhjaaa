// lib/utils/app_theme.dart
import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryRed,
      scaffoldBackgroundColor: AppColors.screenBackground,
      fontFamily: 'Cairo',
      appBarTheme: const AppBarTheme(
        // Made const
        backgroundColor: AppColors.screenBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkGreyText),
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.darkGreyText,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      textTheme: const TextTheme(
        // Made const
        bodyLarge: TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.darkGreyText,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.darkGreyText,
        ),
        displayLarge: TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.darkGreyText,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.darkGreyText,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.darkGreyText,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        // Made const
        hintStyle: TextStyle(
          color: AppColors.lightGrey,
          fontFamily: 'Cairo',
          fontSize: 16.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
        ),
      ),
    );
  }
}
