import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppTheme {
  const AppTheme._();

  static const Color primary = Color(0xFF0F766E);
  static const Color ink = Color(0xFF111827);
  static const Color muted = Color(0xFF6B7280);
  static const Color canvas = Color(0xFFF7F8FA);
  static const Color line = Color(0xFFE5E7EB);
  static const Color amber = Color(0xFFF59E0B);
  static const Color coral = Color(0xFFEF4444);
  static const Color indigo = Color(0xFF4F46E5);

  static ThemeData materialTheme() {
    final textTheme = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: canvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        surface: Colors.white,
      ),
      textTheme: textTheme.apply(bodyColor: ink, displayColor: ink),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: canvas,
        foregroundColor: ink,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: ink,
          fontSize: 20.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        height: 70.h,
        indicatorColor: primary.withValues(alpha: .12),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelSmall?.copyWith(
            color: states.contains(WidgetState.selected) ? primary : muted,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static ShadThemeData shadTheme() {
    return ShadThemeData(
      brightness: Brightness.light,
      colorScheme: const ShadZincColorScheme.light(),
      textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.inter),
      radius: BorderRadius.circular(12.r),
    );
  }
}
