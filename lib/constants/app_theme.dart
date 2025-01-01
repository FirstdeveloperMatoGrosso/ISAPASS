import 'package:flutter/material.dart';

class AppTheme {
  // Cores principais
  static const primaryColor = Color(0xFF6366F1); // Indigo
  static const secondaryColor = Color(0xFF4F46E5); // Indigo mais escuro
  static const surfaceColor = Color(0xFFF3F4F6); // Cinza claro
  static const backgroundColor = Colors.white;
  static const errorColor = Color(0xFFDC2626); // Vermelho
  static const successColor = Color(0xFF059669); // Verde
  static const warningColor = Color(0xFFD97706); // Laranja
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

  // Sombras
  static List<BoxShadow> get lightShadow => [
        BoxShadow(
          color: Colors.black.withAlpha(26),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get mediumShadow => [
        BoxShadow(
          color: Colors.black.withAlpha(38),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  // Bordas
  static const double borderRadius = 12;
  static const double borderRadiusSmall = 8;
  static const double borderRadiusLarge = 16;

  // Espaçamento
  static const double spacingXSmall = 4;
  static const double spacingSmall = 8;
  static const double spacingMedium = 16;
  static const double spacingLarge = 24;
  static const double spacingXLarge = 32;

  // Animações
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Curve animationCurve = Curves.easeInOut;

  static ThemeData get theme => ThemeData(
        primaryColor: primaryColor,
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
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: spacingMedium,
            vertical: spacingMedium,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: spacingLarge,
              vertical: spacingMedium,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(
              horizontal: spacingMedium,
              vertical: spacingSmall,
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey[100]!,
          selectedColor: primaryColor.withAlpha(51),
          labelStyle: TextStyle(color: Colors.grey[800]),
          secondaryLabelStyle: const TextStyle(color: primaryColor),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMedium,
            vertical: spacingSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusSmall),
          ),
        ),
      );
}
