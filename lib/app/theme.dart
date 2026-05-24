// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFF5F5F5);
  static const darkSurface = Color(0xFF1C1C1E);
  static const darkSurfaceAlt = Color(0xFF2C2C2E);
  static const secondary = Color(0xFF8E8E93);
  static const divider = Color(0xFFE0E0E0);
}

TextTheme _buildTextTheme(Color onSurface) {
  return GoogleFonts.interTextTheme(
    ThemeData.light().textTheme.apply(
          bodyColor: onSurface,
          displayColor: onSurface,
        ),
  ).copyWith(
    displayLarge: GoogleFonts.inter(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      letterSpacing: -1.5,
      color: onSurface,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 34,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.8,
      color: onSurface,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: onSurface,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: onSurface,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.secondary,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
  );
}

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.white,
  colorScheme: const ColorScheme.light(
    primary: AppColors.black,
    onPrimary: AppColors.white,
    secondary: AppColors.black,
    onSecondary: AppColors.white,
    surface: AppColors.lightSurface,
    onSurface: AppColors.black,
    error: AppColors.black,
    onError: AppColors.white,
  ),
  textTheme: _buildTextTheme(AppColors.black),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.black,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 34,
      fontWeight: FontWeight.bold,
      color: AppColors.black,
      letterSpacing: -0.8,
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.lightSurface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 0,
    margin: EdgeInsets.zero,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.black,
      foregroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minimumSize: const Size(double.infinity, 52),
      textStyle: GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      elevation: 0,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.black,
      side: const BorderSide(color: AppColors.divider),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minimumSize: const Size(double.infinity, 52),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: AppColors.black),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightSurface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      borderSide: const BorderSide(color: AppColors.black, width: 1),
    ),
    hintStyle: const TextStyle(color: AppColors.secondary),
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.divider,
    thickness: 0.5,
    space: 0.5,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.white,
    indicatorColor: AppColors.black,
    surfaceTintColor: AppColors.white,
    elevation: 0,
    height: 64,
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      return GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: states.contains(WidgetState.selected)
            ? AppColors.black
            : AppColors.secondary,
      );
    }),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected)
          ? const IconThemeData(color: AppColors.white, size: 22)
          : const IconThemeData(color: AppColors.secondary, size: 24);
    }),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.black,
    foregroundColor: AppColors.white,
    elevation: 0,
    shape: CircleBorder(),
  ),
  segmentedButtonTheme: SegmentedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.black;
        return AppColors.lightSurface;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.white;
        return AppColors.black;
      }),
      side: WidgetStatePropertyAll(
        BorderSide(color: AppColors.divider.withOpacity(0)),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  ),
);

final ThemeData darkTheme = lightTheme.copyWith(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.black,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.white,
    onPrimary: AppColors.black,
    secondary: AppColors.white,
    onSecondary: AppColors.black,
    surface: AppColors.darkSurface,
    onSurface: AppColors.white,
    error: AppColors.white,
    onError: AppColors.black,
  ),
  textTheme: _buildTextTheme(AppColors.white),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.black,
    foregroundColor: AppColors.white,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 34,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
      letterSpacing: -0.8,
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.darkSurface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 0,
    margin: EdgeInsets.zero,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minimumSize: const Size(double.infinity, 52),
      textStyle: GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      elevation: 0,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.darkSurfaceAlt),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minimumSize: const Size(double.infinity, 52),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: AppColors.white),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      borderSide: const BorderSide(color: AppColors.white, width: 1),
    ),
    hintStyle: const TextStyle(color: AppColors.secondary),
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.darkSurfaceAlt,
    thickness: 0.5,
    space: 0.5,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.darkSurface,
    indicatorColor: AppColors.white,
    surfaceTintColor: AppColors.darkSurface,
    elevation: 0,
    height: 64,
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      return GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: states.contains(WidgetState.selected)
            ? AppColors.white
            : AppColors.secondary,
      );
    }),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected)
          ? const IconThemeData(color: AppColors.black, size: 22)
          : const IconThemeData(color: AppColors.secondary, size: 24);
    }),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.black,
    elevation: 0,
    shape: CircleBorder(),
  ),
  segmentedButtonTheme: SegmentedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.white;
        return AppColors.darkSurface;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.black;
        return AppColors.white;
      }),
      side: WidgetStatePropertyAll(
        BorderSide(color: AppColors.divider.withOpacity(0)),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  ),
);
