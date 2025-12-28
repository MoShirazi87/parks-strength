import 'package:flutter/material.dart';

/// App-wide constants for the Parks Strength application
class AppConstants {
  AppConstants._();

  // ═══════════════════════════════════════════════════════════════════════════
  // APP INFO
  // ═══════════════════════════════════════════════════════════════════════════
  static const String appName = 'Parks Strength';
  static const String appTagline = 'Functional Strength That Transfers to Life';
  static const String coachName = 'Coach Brian Parks';
  static const String coachTitle = 'Certified Strength Coach';

  // ═══════════════════════════════════════════════════════════════════════════
  // LEGACY COLORS (Use AppColors instead)
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color primaryBackground = Color(0xFF0A0A0A);
  static const Color secondaryBackground = Color(0xFF121212);
  static const Color cardBackground = Color(0xFF1A1A1A);
  static const Color elevatedCardBackground = Color(0xFF222222);
  static const Color inputBackground = Color(0xFF1A1A1A);

  // ═══════════════════════════════════════════════════════════════════════════
  // BORDER RADIUS
  // ═══════════════════════════════════════════════════════════════════════════
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusHero = 28.0;
  static const double radiusFull = 999.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // ANIMATION DURATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  static const Duration animationInstant = Duration(milliseconds: 100);
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 400);
  static const Duration animationSlowest = Duration(milliseconds: 600);
  static const Duration animationPageTransition = Duration(milliseconds: 300);

  // Animation curves
  static const Curve curveDefault = Curves.easeOutCubic;
  static const Curve curveEmphasized = Curves.easeOutExpo;
  static const Curve curveBounce = Curves.elasticOut;
  static const Curve curveSnap = Curves.easeOutBack;

  // ═══════════════════════════════════════════════════════════════════════════
  // BOTTOM NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════════
  static const double bottomNavHeight = 72.0;
  static const double bottomNavIconSize = 24.0;
  static const double bottomNavActiveIndicatorWidth = 64.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // WORKOUT DEFAULTS
  // ═══════════════════════════════════════════════════════════════════════════
  static const int defaultRestSeconds = 90;
  static const int minRestSeconds = 30;
  static const int maxRestSeconds = 300;
  static const int defaultWarmupSeconds = 30;
  static const int defaultStretchSeconds = 30;
  static const int defaultSets = 3;
  static const int defaultReps = 10;

  // Exercise grouping letters
  static const List<String> exerciseGroupLetters = ['A', 'B', 'C', 'D', 'E', 'F'];

  // RPE scale
  static const int rpeMin = 1;
  static const int rpeMax = 10;
  static const int rpeDefault = 7;

  // ═══════════════════════════════════════════════════════════════════════════
  // POINTS & GAMIFICATION
  // ═══════════════════════════════════════════════════════════════════════════
  static const int pointsWorkoutComplete = 10;
  static const int pointsWorkout30Min = 25;
  static const int pointsWeeklyGoal = 50;
  static const int pointsStreakDay1to7 = 2;
  static const int pointsStreakDay8to30 = 3;
  static const int pointsStreakDay31Plus = 5;
  static const int pointsFirstPR = 25;
  static const int pointsPR = 15;

  // Streak thresholds
  static const int streakBronze = 3;
  static const int streakSilver = 7;
  static const int streakGold = 14;
  static const int streakPlatinum = 30;
  static const int streakDiamond = 100;

  // ═══════════════════════════════════════════════════════════════════════════
  // PROGRESSIVE OVERLOAD
  // ═══════════════════════════════════════════════════════════════════════════
  static const double weightIncreaseUpper = 5.0; // lbs
  static const double weightIncreaseLower = 10.0; // lbs
  static const double weightIncreaseSmall = 2.5; // lbs
  static const int plateauSessionThreshold = 3;
  static const int twoForTwoSessionThreshold = 2;
  static const int twoForTwoRepThreshold = 2;

  // ═══════════════════════════════════════════════════════════════════════════
  // API ENDPOINTS
  // ═══════════════════════════════════════════════════════════════════════════
  static const String exerciseDbBaseUrl = 'https://exercisedb.p.rapidapi.com';
  static const String pixabayBaseUrl = 'https://pixabay.com/api';
  static const String mixkitBaseUrl = 'https://mixkit.co';

  // ═══════════════════════════════════════════════════════════════════════════
  // SIZES
  // ═══════════════════════════════════════════════════════════════════════════
  static const double heroCardHeight = 320.0;
  static const double workoutCardHeight = 140.0;
  static const double categoryButtonSize = 56.0;
  static const double avatarSizeSm = 32.0;
  static const double avatarSizeMd = 48.0;
  static const double avatarSizeLg = 72.0;
  static const double avatarSizeXl = 96.0;
  static const double floatingBubbleMinSize = 60.0;
  static const double floatingBubbleMaxSize = 100.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // SHADOWS
  // ═══════════════════════════════════════════════════════════════════════════
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: Colors.black.withAlpha(40),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: Colors.black.withAlpha(60),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: Colors.black.withAlpha(80),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> glowShadow(Color color) => [
    BoxShadow(
      color: color.withAlpha(60),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];
}

