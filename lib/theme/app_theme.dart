import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors - ET Money inspired
  static const Color primaryGreen = Color(0xFF00A651);
  static const Color primaryDark = Color(0xFF006B35);
  static const Color accentOrange = Color(0xFFFF6B2B);
  static const Color accentBlue = Color(0xFF1A73E8);
  static const Color goldAccent = Color(0xFFFFB800);

  // Neutrals
  static const Color bgLight = Color(0xFFF8F9FA);
  static const Color bgWhite = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF0F4F8);
  static const Color textPrimary = Color(0xFF1A1F36);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color divider = Color(0xFFE5E7EB);

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Score Colors
  static const Color scoreExcellent = Color(0xFF22C55E);
  static const Color scoreGood = Color(0xFF84CC16);
  static const Color scoreFair = Color(0xFFF59E0B);
  static const Color scorePoor = Color(0xFFEF4444);

  // Dark Theme Colors
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF334155);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.light,
        primary: primaryGreen,
        secondary: accentOrange,
        surface: bgWhite,
        error: error,
      ),
      fontFamily: 'Sora',
      textTheme: _buildTextTheme(textPrimary, textSecondary),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgWhite,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Sora',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: divider, width: 1),
        ),
        color: bgWhite,
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Sora',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: primaryGreen, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Sora',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error),
        ),
        hintStyle: const TextStyle(
          color: textLight,
          fontSize: 14,
          fontFamily: 'DMSans',
        ),
        labelStyle: const TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontFamily: 'DMSans',
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgWhite,
        selectedItemColor: primaryGreen,
        unselectedItemColor: textLight,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: primaryGreen.withValues(alpha: 0.15),
        labelStyle: const TextStyle(fontSize: 13, fontFamily: 'DMSans'),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      scaffoldBackgroundColor: bgLight,
      dividerColor: divider,
      dividerTheme: const DividerThemeData(color: divider, thickness: 1),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.dark,
        primary: primaryGreen,
        secondary: accentOrange,
        surface: darkSurface,
      ),
      fontFamily: 'Sora',
      scaffoldBackgroundColor: darkBg,
      textTheme: _buildTextTheme(Colors.white, const Color(0xFF94A3B8)),
    );
  }

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: primary, fontFamily: 'Sora'),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: primary, fontFamily: 'Sora'),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: primary, fontFamily: 'Sora'),
      headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: primary, fontFamily: 'Sora'),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primary, fontFamily: 'Sora'),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: primary, fontFamily: 'Sora'),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primary, fontFamily: 'Sora'),
      titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: primary, fontFamily: 'DMSans'),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: primary, fontFamily: 'DMSans'),
      bodyLarge: TextStyle(fontSize: 15, color: primary, fontFamily: 'DMSans'),
      bodyMedium: TextStyle(fontSize: 14, color: secondary, fontFamily: 'DMSans'),
      bodySmall: TextStyle(fontSize: 12, color: secondary, fontFamily: 'DMSans'),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primary, fontFamily: 'Sora'),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: secondary, fontFamily: 'DMSans'),
      labelSmall: TextStyle(fontSize: 11, color: secondary, fontFamily: 'DMSans'),
    );
  }
}

class AppGradients {
  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF00A651), Color(0xFF006B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF6B2B), Color(0xFFFF3D00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFB800), Color(0xFFFF8F00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
