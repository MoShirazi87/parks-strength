import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography system for Parks Strength app
/// Uses Outfit for headings (modern, geometric) and Plus Jakarta Sans for body
class AppTypography {
  AppTypography._();

  // Font weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // ═══════════════════════════════════════════════════════════════════════════
  // DISPLAY STYLES (Hero titles, splash screens)
  // ═══════════════════════════════════════════════════════════════════════════
  static TextStyle get displayLarge => GoogleFonts.outfit(
    fontSize: 48,
    fontWeight: extraBold,
    color: AppColors.textPrimary,
    height: 1.1,
    letterSpacing: -1.0,
  );

  static TextStyle get displayMedium => GoogleFonts.outfit(
    fontSize: 36,
    fontWeight: bold,
    color: AppColors.textPrimary,
    height: 1.15,
    letterSpacing: -0.5,
  );

  static TextStyle get displaySmall => GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: bold,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.3,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADLINE STYLES (Screen titles, section headers)
  // ═══════════════════════════════════════════════════════════════════════════
  static TextStyle get headlineLarge => GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: bold,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static TextStyle get headlineMedium => GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get headlineSmall => GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // TITLE STYLES (Card titles, list items)
  // ═══════════════════════════════════════════════════════════════════════════
  static TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get titleSmall => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // BODY STYLES (Regular text content)
  // ═══════════════════════════════════════════════════════════════════════════
  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: regular,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: regular,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: regular,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // LABEL STYLES (Buttons, chips, tags)
  // ═══════════════════════════════════════════════════════════════════════════
  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: 0.3,
  );

  static TextStyle get labelMedium => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: medium,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: medium,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // CAPTION STYLES (Timestamps, hints)
  // ═══════════════════════════════════════════════════════════════════════════
  static TextStyle get caption => GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: regular,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static TextStyle get captionBold => GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: semiBold,
    color: AppColors.textMuted,
    height: 1.4,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // BUTTON TEXT STYLES
  // ═══════════════════════════════════════════════════════════════════════════
  static TextStyle get buttonLarge => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: 0.2,
  );

  static TextStyle get buttonMedium => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle get buttonSmall => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // TIMER/COUNTER DISPLAY (Workout timers, countdowns)
  // ═══════════════════════════════════════════════════════════════════════════
  static TextStyle get timerHuge => GoogleFonts.outfit(
    fontSize: 80,
    fontWeight: extraBold,
    color: AppColors.textPrimary,
    height: 1.0,
    letterSpacing: -3,
  );

  static TextStyle get timer => GoogleFonts.outfit(
    fontSize: 64,
    fontWeight: bold,
    color: AppColors.textPrimary,
    height: 1.0,
    letterSpacing: -2,
  );

  static TextStyle get timerSmall => GoogleFonts.outfit(
    fontSize: 48,
    fontWeight: bold,
    color: AppColors.textPrimary,
    height: 1.0,
    letterSpacing: -1,
  );

  static TextStyle get timerMini => GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    height: 1.0,
    letterSpacing: -0.5,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // STATS DISPLAY (Points, PRs, streaks)
  // ═══════════════════════════════════════════════════════════════════════════
  static TextStyle get statLarge => GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: bold,
    color: AppColors.textPrimary,
    height: 1.1,
  );

  static TextStyle get statValue => GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle get statValueSmall => GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle get statLabel => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: medium,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // SPECIAL STYLES
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Workout exercise letter (A, B, C, D groupings)
  static TextStyle get exerciseLetter => GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: bold,
    color: AppColors.secondary,
    height: 1.0,
  );

  /// Badge/achievement text
  static TextStyle get badge => GoogleFonts.plusJakartaSans(
    fontSize: 10,
    fontWeight: bold,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: 0.5,
  );

  /// Program name branding
  static TextStyle get programName => GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: bold,
    letterSpacing: 1.5,
    height: 1.0,
  );

  /// Streak/points counter
  static TextStyle get counter => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: bold,
    color: AppColors.textPrimary,
    height: 1.0,
  );
}

