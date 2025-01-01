import 'package:flutter/material.dart';

class AppTheme {
  // Cores principais
  static const primaryColor = Colors.blue;
  static const secondaryColor = Color(0xFF4F46E5);
  static const surfaceColor = Colors.white;
  static const backgroundColor = Colors.white;
  static const errorColor = Color(0xFFDC2626);
  static const successColor = Color(0xFF059669);
  static const warningColor = Color(0xFFD97706);
  static const accentColor = Color(0xFFFF6B6B);
  static const textColor = Color(0xFF2D3142);

  // Cores de status
  static const onlineColor = Color(0xFF4CAF50);
  static const offlineColor = Color(0xFF9E9E9E);
  static const busyColor = Color(0xFFF44336);
  static const awayColor = Color(0xFFFF9800);

  // Estilos de texto
  static const TextStyle headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: textColor,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: textColor,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: textColor,
  );

  // Duração de animações
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Curve animationCurve = Curves.easeInOut;

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: surfaceColor,
          surfaceContainerHighest: surfaceColor,
          error: errorColor,
        ),
        scaffoldBackgroundColor: surfaceColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          foregroundColor: primaryColor,
          elevation: 0,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: errorColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: errorColor),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
        ),
      );
}
