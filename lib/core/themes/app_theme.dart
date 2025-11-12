import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme(
        primary: AppColors.primary,
        primaryContainer: AppColors.primary.withValues(alpha: 0.8),
        secondary: AppColors.accent,
        secondaryContainer: AppColors.accent.withValues(alpha: 0.8),
        surface: Colors.white,
        // background & onBackground đã deprecated → bỏ
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.text,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      // Dùng scaffoldBackgroundColor để thay cho background
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColors.text),
        bodyMedium: TextStyle(color: AppColors.text),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          // Thay withOpacity() bằng withValues(alpha: …)
          borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.6)),
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: TextStyle(color: AppColors.primary),
      ),
    );
  }
}
