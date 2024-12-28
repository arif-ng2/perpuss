import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2962FF);
  static const Color secondaryColor = Color(0xFF3D5AFE);
  static const Color successColor = Color(0xFF00C853);
  static const Color errorColor = Color(0xFFD50000);
  static const Color backgroundColor = Color(0xFFF5F5F7);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color subtitleColor = Color(0xFF757575);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      surface: backgroundColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    cardTheme: const CardTheme(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: cardColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: subtitleColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundColor,
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
        borderSide: const BorderSide(color: primaryColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: subtitleColor,
      ),
    ),
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(13),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration gradientDecoration = BoxDecoration(
    gradient: const LinearGradient(
      colors: [primaryColor, secondaryColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: primaryColor.withAlpha(77),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
} 