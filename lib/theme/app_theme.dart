import 'package:flutter/material.dart';

class EduCamColors {
  static const Color primary = Color(0xFF0D1B2A);
  static const Color accent = Color(0xFF4F46E5);
  static const Color highlight = Color(0xFFF59E0B);
  static const Color background = Color(0xFFF8FAFC);
  static const Color secondaryText = Color(0xFF94A3B8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color chatBubbleAI = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE2E8F0);
  static const Color progressTrack = Color(0xFFE2E8F0);

  static const Color subjectMaths = Color(0xFF4F46E5);
  static const Color subjectSVT = Color(0xFF10B981);
  static const Color subjectHistoire = Color(0xFFF59E0B);
  static const Color subjectPhysique = Color(0xFFEF4444);
  static const Color subjectFrancais = Color(0xFFEC4899);
  static const Color subjectAnglais = Color(0xFF06B6D4);

  static const Color darkPrimary = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkBackground = Color(0xFF0A0F1A);
}

class EduCamTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'PlusJakartaSans',
      scaffoldBackgroundColor: EduCamColors.background,
      colorScheme: const ColorScheme.light(
        primary: EduCamColors.accent,
        secondary: EduCamColors.highlight,
        surface: EduCamColors.surface,
        error: EduCamColors.error,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: EduCamColors.primary,
          height: 1.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: EduCamColors.primary,
          height: 1.3,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: EduCamColors.primary,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: EduCamColors.primary,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: EduCamColors.primary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: EduCamColors.primary,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: EduCamColors.secondaryText,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: EduCamColors.surface,
          height: 1.2,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: EduCamColors.accent,
          foregroundColor: EduCamColors.surface,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: EduCamColors.accent,
          side: const BorderSide(color: EduCamColors.accent, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: EduCamColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: EduCamColors.cardBorder, width: 0.5),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: EduCamColors.surface,
        selectedItemColor: EduCamColors.accent,
        unselectedItemColor: EduCamColors.secondaryText,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: EduCamColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: EduCamColors.accent, width: 1.5),
        ),
        hintStyle: const TextStyle(
          color: EduCamColors.secondaryText,
          fontSize: 14,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'PlusJakartaSans',
      scaffoldBackgroundColor: EduCamColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: EduCamColors.accent,
        secondary: EduCamColors.highlight,
        surface: EduCamColors.darkSurface,
        error: EduCamColors.error,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: EduCamColors.surface,
          height: 1.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: EduCamColors.surface,
          height: 1.3,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: EduCamColors.surface,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: EduCamColors.surface,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: EduCamColors.surface,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: EduCamColors.surface,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: EduCamColors.secondaryText,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: EduCamColors.surface,
          height: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: EduCamColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide.none,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: EduCamColors.darkSurface,
        selectedItemColor: EduCamColors.accent,
        unselectedItemColor: EduCamColors.secondaryText,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];
}
