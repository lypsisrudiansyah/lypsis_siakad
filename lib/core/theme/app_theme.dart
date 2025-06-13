import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';

/*
* Never set default padding or margin for buttons
*/
class RKAppTheme {
  static const defaultScaffoldPadding = 20.0;
  static const defaultColumnOrRowSpacing = 6.0;
  static const defaultCardPadding = 8.0;

  static ThemeData get theme {
    return ThemeData(
      // Warna Primer
      useMaterial3: true, // Enable Material 3 design system
      listTileTheme: ListTileThemeData(
        minTileHeight: 0.0,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 0.0,
          vertical: 0.0,
        ),
        minVerticalPadding: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        titleTextStyle: TextStyle(
          fontSize: fsLg,
          color: textColor,
        ),
      ),
      // Tipografi
      textTheme: GoogleFonts.interTextTheme().copyWith(),
      dividerColor: Colors.grey[300],
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
        labelStyle: TextStyle(
          fontSize: fsMd,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: fsMd,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: Colors.white,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      hintColor: const Color(0xFF6B7280), // Gray

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0.6,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: fsXl,
          color: Colors.white,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        fillColor: secondaryColor,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: spSm,
          vertical: 0.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFF6B7280), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: primaryColor, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.0),
        ),
        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: const Color(0xFF6B7280),
        error: const Color(0xFFEF4444),
      ).copyWith(error: const Color(0xFFEF4444)),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        selectedShadowColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: BorderSide.none,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
