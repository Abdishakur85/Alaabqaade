import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF4A0CBD);
  static const Color secondary = Color(0xFFE040FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFD32F2F);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF212121);
  static const Color onSurface = Color(0xFF212121);
  static const Color form = Color.fromARGB(34, 121, 91, 203);
}

class AppTextStyles {
  static TextStyle heading = GoogleFonts.jost(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.onSurface,
  );

  static TextStyle subHeading = GoogleFonts.jost(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onSecondary,
  );

  static TextStyle body = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.onSecondary,
  );

  static TextStyle description = GoogleFonts.jost(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onSecondary,
  );

  static TextStyle button = GoogleFonts.jost(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimary,
  );
}
