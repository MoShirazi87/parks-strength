import 'package:flutter/material.dart';

/// Spacing system for Parks Strength app
/// Based on 4px base unit with consistent scale
class AppSpacing {
  AppSpacing._();

  // Base spacing values
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Screen edge padding
  static const double screenHorizontal = 20.0;
  static const double screenVertical = 16.0;
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: screenHorizontal,
    vertical: screenVertical,
  );
  static const EdgeInsets screenHorizontalPadding = EdgeInsets.symmetric(
    horizontal: screenHorizontal,
  );

  // Card padding
  static const double cardPadding = 16.0;
  static const EdgeInsets cardPaddingAll = EdgeInsets.all(cardPadding);
  static const EdgeInsets cardPaddingCompact = EdgeInsets.all(12.0);

  // List item spacing
  static const double listItemSpacing = 12.0;
  static const double listSectionSpacing = 24.0;

  // Section spacing
  static const double sectionSpacing = 32.0;
  static const double sectionSpacingSmall = 24.0;

  // Icon spacing from text
  static const double iconTextGap = 8.0;
  static const double iconTextGapSmall = 4.0;

  // Form field spacing
  static const double formFieldSpacing = 16.0;
  static const double formLabelSpacing = 8.0;

  // Button spacing
  static const double buttonSpacing = 12.0;
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 24.0,
    vertical: 16.0,
  );
  static const EdgeInsets buttonPaddingCompact = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  // Chip spacing
  static const double chipSpacing = 8.0;
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 8.0,
  );

  // Bottom sheet
  static const double bottomSheetHandleMargin = 12.0;
  static const double bottomSheetContentPadding = 24.0;

  // Modal/Dialog
  static const EdgeInsets dialogPadding = EdgeInsets.all(24.0);

  // Safe area additions
  static const double bottomNavSafeArea = 80.0;

  // Gaps (for use with Row, Column, Wrap)
  static SizedBox get gapXXS => const SizedBox(width: xxs, height: xxs);
  static SizedBox get gapXS => const SizedBox(width: xs, height: xs);
  static SizedBox get gapSM => const SizedBox(width: sm, height: sm);
  static SizedBox get gapMD => const SizedBox(width: md, height: md);
  static SizedBox get gapLG => const SizedBox(width: lg, height: lg);
  static SizedBox get gapXL => const SizedBox(width: xl, height: xl);
  static SizedBox get gapXXL => const SizedBox(width: xxl, height: xxl);

  // Vertical gaps
  static SizedBox get verticalXXS => const SizedBox(height: xxs);
  static SizedBox get verticalXS => const SizedBox(height: xs);
  static SizedBox get verticalSM => const SizedBox(height: sm);
  static SizedBox get verticalMD => const SizedBox(height: md);
  static SizedBox get verticalLG => const SizedBox(height: lg);
  static SizedBox get verticalXL => const SizedBox(height: xl);
  static SizedBox get verticalXXL => const SizedBox(height: xxl);

  // Horizontal gaps
  static SizedBox get horizontalXXS => const SizedBox(width: xxs);
  static SizedBox get horizontalXS => const SizedBox(width: xs);
  static SizedBox get horizontalSM => const SizedBox(width: sm);
  static SizedBox get horizontalMD => const SizedBox(width: md);
  static SizedBox get horizontalLG => const SizedBox(width: lg);
  static SizedBox get horizontalXL => const SizedBox(width: xl);
  static SizedBox get horizontalXXL => const SizedBox(width: xxl);
}

