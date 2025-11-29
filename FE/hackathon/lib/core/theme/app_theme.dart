import 'package:flutter/material.dart';

/// App Theme Configuration
/// Based on Figma design specifications
class AppTheme {
  // Color Palette
  static const Color primaryBlue = Color(0xFF155DFC);
  static const Color textPrimary = Color(0xFF101828);
  static const Color textSecondary = Color(0xFF4A5565);
  static const Color textTertiary = Color(0xFF6A7282);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF9FAFB);

  // Feature Card Colors
  static const Color featureCard1Bg = Color(0xFFEFF6FF);
  static const Color featureCard1IconBg = Color(0xFFDBEAFE);
  static const Color featureCard2Bg = Color(0xFFFAF5FF);
  static const Color featureCard2IconBg = Color(0xFFF3E8FF);
  static const Color featureCard3Bg = Color(0xFFFEF2F2);
  static const Color featureCard3IconBg = Color(0xFFFFE2E2);

  // Gradient Colors
  static const Color gradientStart = Color(0xFF2B7FFF);
  static const Color gradientEnd = Color(0xFF1447E6);

  // Notification Gradients
  static LinearGradient get dangerGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFB2C36),
        Color(0xFFE7000B),
      ],
    );
  }

  static LinearGradient get warningGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFE9A00),
        Color(0xFFE17100),
      ],
    );
  }

  // Status Colors
  static const Color statusGreen = Color(0xFF00C950);
  static const Color statusGreenLight = Color(0xFFDCFCE7);
  static const Color statusGreenText = Color(0xFF008236);

  /// App Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        surface: backgroundWhite,
        onPrimary: backgroundWhite,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: backgroundLight,
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w400,
          height: 1.2,
          letterSpacing: 0.013,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          height: 1.4,
          letterSpacing: -0.022,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: -0.02,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: -0.02,
          color: textSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.43,
          letterSpacing: -0.011,
          color: textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.43,
          letterSpacing: -0.011,
          color: textTertiary,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.33,
          letterSpacing: 0,
          color: textTertiary,
        ),
      ),
    );
  }

  /// Permission Icon Gradient
  static LinearGradient get permissionIconGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFDBEAFE), Color(0xFFBEDBFF)],
    );
  }

  /// App Icon Gradient
  static LinearGradient get appIconGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [gradientStart, gradientEnd],
    );
  }

  /// Box Shadow for Cards and Buttons
  static List<BoxShadow> get cardShadow {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        offset: const Offset(0, 4),
        blurRadius: 6,
        spreadRadius: -4,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        offset: const Offset(0, 10),
        blurRadius: 15,
        spreadRadius: -3,
      ),
    ];
  }
}
