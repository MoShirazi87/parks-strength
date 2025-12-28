import 'package:flutter/material.dart';

/// Color palette for Parks Strength app
/// Onemor/TITAN-inspired dark theme with electric purple accent and lime green highlights
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIMARY BACKGROUNDS (Deep blacks for true OLED-dark aesthetic)
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color background = Color(0xFF0A0A0A);
  static const Color backgroundSecondary = Color(0xFF121212);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceElevated = Color(0xFF222222);
  static const Color surfaceCard = Color(0xFF1E1E1E);
  static const Color inputFill = Color(0xFF1A1A1A);

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCENT COLORS (Electric purple/indigo primary, lime green secondary)
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color primary = Color(0xFF6366F1);        // Electric indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryMuted = Color(0xFF4338CA);
  
  static const Color secondary = Color(0xFFBFFF00);      // Lime/neon green
  static const Color secondaryDark = Color(0xFF9ACD00);
  static const Color secondaryMuted = Color(0xFF84CC16);
  
  static const Color tertiary = Color(0xFF8B5CF6);       // Purple
  static const Color tertiaryLight = Color(0xFFA78BFA);
  
  static const Color accent = Color(0xFFFF6B6B);         // Coral for highlights

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC COLORS
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFF4ADE80);
  static const Color successBg = Color(0xFF052E16);
  
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningBg = Color(0xFF422006);
  
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorBg = Color(0xFF450A0A);
  
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoBg = Color(0xFF172554);

  // ═══════════════════════════════════════════════════════════════════════════
  // SPECIAL PURPOSE (Gamification & Features)
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color streak = Color(0xFFF97316);         // Orange flame
  static const Color streakGlow = Color(0xFFFF8C42);
  static const Color points = Color(0xFF22C55E);         // Green points
  static const Color pointsGlow = Color(0xFF4ADE80);
  static const Color pr = Color(0xFFFFD700);             // Gold PRs
  static const Color prGlow = Color(0xFFFFE55C);
  static const Color rest = Color(0xFF64748B);           // Muted rest
  static const Color badge = Color(0xFFE879F9);          // Pink badges
  static const Color leaderboard = Color(0xFF06B6D4);    // Cyan leaderboard

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT COLORS
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFF71717A);
  static const Color textDisabled = Color(0xFF52525B);
  static const Color textInverse = Color(0xFF0A0A0A);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFF0A0A0A);

  // ═══════════════════════════════════════════════════════════════════════════
  // BORDER COLORS
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color border = Color(0xFF27272A);
  static const Color borderLight = Color(0xFF3F3F46);
  static const Color borderSubtle = Color(0xFF1F1F23);
  static const Color borderFocused = primary;

  // ═══════════════════════════════════════════════════════════════════════════
  // OVERLAY & EFFECTS
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color overlay = Color(0xCC000000);
  static const Color overlayLight = Color(0x80000000);
  static const Color overlaySubtle = Color(0x40000000);
  static const Color shimmerBase = Color(0xFF1A1A1A);
  static const Color shimmerHighlight = Color(0xFF2A2A2A);
  static const Color glassBg = Color(0x1AFFFFFF);
  static const Color glassStroke = Color(0x33FFFFFF);

  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENT PRESETS
  // ═══════════════════════════════════════════════════════════════════════════
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, tertiary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, Color(0xFF84CC16)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [surfaceCard, Color(0xFF151515)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient heroOverlay = LinearGradient(
    colors: [Colors.transparent, Color(0xF2000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.2, 1.0],
  );

  static const LinearGradient onboardingGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient streakGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient prGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // PROGRAM ACCENT COLORS (Distinct branding per program)
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color programTitan = Color(0xFFF97316);   // Orange
  static const Color programBlaze = Color(0xFFEC4899);   // Pink
  static const Color programAura = Color(0xFF22C55E);    // Green
  static const Color programNomad = Color(0xFF3B82F6);   // Blue
  static const Color programForge = Color(0xFFA855F7);   // Purple
  static const Color programZen = Color(0xFF14B8A6);     // Teal

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Get color with opacity without using deprecated withOpacity
  static Color withAlpha(Color color, double opacity) {
    return color.withAlpha((opacity * 255).round());
  }
}

