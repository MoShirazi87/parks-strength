import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Extension methods for String
extension StringExtensions on String {
  /// Capitalizes the first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes each word
  String get titleCase {
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Validates email format
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Checks if string is a valid password (min 8 chars)
  bool get isValidPassword {
    return length >= 8;
  }
}

/// Extension methods for DateTime
extension DateTimeExtensions on DateTime {
  /// Formats date as "Nov 3"
  String get shortDate {
    return DateFormat('MMM d').format(this);
  }

  /// Formats date as "November 3, 2024"
  String get longDate {
    return DateFormat('MMMM d, y').format(this);
  }

  /// Formats time as "7:00 AM"
  String get shortTime {
    return DateFormat('h:mm a').format(this);
  }

  /// Formats as "3 days ago", "Just now", etc.
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Returns day of week abbreviation (Mon, Tue, etc.)
  String get dayAbbreviation {
    return DateFormat('E').format(this);
  }

  /// Checks if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Checks if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Gets start of day
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Gets end of day
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59);
  }
}

/// Extension methods for Duration
extension DurationExtensions on Duration {
  /// Formats as "1:30" or "45" (seconds only if under a minute)
  String get formatted {
    final minutes = inMinutes;
    final seconds = inSeconds % 60;

    if (minutes > 0) {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
    return '$seconds';
  }

  /// Formats as "01:30" (always shows minutes)
  String get mmss {
    final minutes = inMinutes;
    final seconds = inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Formats as "1h 30m" or "45m" or "30s"
  String get humanReadable {
    if (inHours > 0) {
      final minutes = inMinutes % 60;
      return '${inHours}h ${minutes}m';
    } else if (inMinutes > 0) {
      return '${inMinutes}m';
    }
    return '${inSeconds}s';
  }
}

/// Extension methods for num (int, double)
extension NumExtensions on num {
  /// Formats weight with unit (e.g., "135 lbs")
  String formatWeight([String unit = 'lbs']) {
    if (this == toInt()) {
      return '${toInt()} $unit';
    }
    return '${toStringAsFixed(1)} $unit';
  }

  /// Formats as compact number (e.g., 1.2K, 3.5M)
  String get compact {
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }

  /// Formats as volume (e.g., "12,450 lbs")
  String formatVolume([String unit = 'lbs']) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(this)} $unit';
  }
}

/// Extension methods for BuildContext
extension ContextExtensions on BuildContext {
  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Get safe area padding
  EdgeInsets get safePadding => MediaQuery.of(this).padding;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;

  /// Get theme
  ThemeData get theme => Theme.of(this);

  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
      ),
    );
  }

  /// Show loading dialog
  void showLoading() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Hide loading dialog
  void hideLoading() {
    Navigator.of(this).pop();
  }
}

/// Extension methods for List
extension ListExtensions<T> on List<T> {
  /// Safely get element at index, returns null if out of bounds
  T? safeGet(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }

  /// Interleave list with separator
  List<T> intersperse(T separator) {
    if (length <= 1) return this;
    return [
      for (int i = 0; i < length; i++) ...[
        if (i > 0) separator,
        this[i],
      ],
    ];
  }
}

