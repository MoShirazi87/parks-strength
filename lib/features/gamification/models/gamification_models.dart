import 'package:equatable/equatable.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════
// STREAK SYSTEM
// ═══════════════════════════════════════════════════════════════════════════

/// User's current streak information
class StreakInfo extends Equatable {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastWorkoutDate;
  final int freezesAvailable;
  final int freezesUsed;
  final StreakTier tier;
  
  const StreakInfo({
    required this.currentStreak,
    required this.longestStreak,
    this.lastWorkoutDate,
    this.freezesAvailable = 0,
    this.freezesUsed = 0,
    required this.tier,
  });
  
  /// Check if streak is at risk (no workout today)
  bool get isAtRisk {
    if (lastWorkoutDate == null) return false;
    final now = DateTime.now();
    final daysSinceLastWorkout = now.difference(lastWorkoutDate!).inDays;
    return daysSinceLastWorkout >= 1 && currentStreak > 0;
  }
  
  /// Check if streak is still valid
  bool get isActive {
    if (lastWorkoutDate == null) return false;
    final now = DateTime.now();
    final daysSinceLastWorkout = now.difference(lastWorkoutDate!).inDays;
    return daysSinceLastWorkout <= 1;
  }
  
  /// Calculate days until next freeze earned
  int get daysUntilNextFreeze {
    final daysInCurrentCycle = currentStreak % 7;
    return 7 - daysInCurrentCycle;
  }
  
  /// Points multiplier based on streak tier
  double get pointsMultiplier => tier.pointsMultiplier;
  
  @override
  List<Object?> get props => [
    currentStreak, longestStreak, lastWorkoutDate,
    freezesAvailable, freezesUsed, tier,
  ];
  
  StreakInfo copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastWorkoutDate,
    int? freezesAvailable,
    int? freezesUsed,
    StreakTier? tier,
  }) {
    return StreakInfo(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
      freezesAvailable: freezesAvailable ?? this.freezesAvailable,
      freezesUsed: freezesUsed ?? this.freezesUsed,
      tier: tier ?? this.tier,
    );
  }
}

/// Streak tier levels
enum StreakTier {
  none(0, 'No Streak', 1.0, Colors.grey),
  bronze(3, 'Bronze', 1.1, Color(0xFFCD7F32)),
  silver(7, 'Silver', 1.2, Color(0xFFC0C0C0)),
  gold(14, 'Gold', 1.3, Color(0xFFFFD700)),
  platinum(30, 'Platinum', 1.5, Color(0xFFE5E4E2)),
  diamond(100, 'Diamond', 2.0, Color(0xFFB9F2FF));
  
  final int minDays;
  final String name;
  final double pointsMultiplier;
  final Color color;
  
  const StreakTier(this.minDays, this.name, this.pointsMultiplier, this.color);
  
  static StreakTier fromDays(int days) {
    if (days >= 100) return diamond;
    if (days >= 30) return platinum;
    if (days >= 14) return gold;
    if (days >= 7) return silver;
    if (days >= 3) return bronze;
    return none;
  }
  
  StreakTier? get nextTier {
    final tiers = StreakTier.values;
    final currentIndex = tiers.indexOf(this);
    if (currentIndex < tiers.length - 1) {
      return tiers[currentIndex + 1];
    }
    return null;
  }
  
  int get daysToNextTier {
    final next = nextTier;
    if (next == null) return 0;
    return next.minDays - minDays;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// POINTS SYSTEM
// ═══════════════════════════════════════════════════════════════════════════

/// Points transaction
class PointsTransaction extends Equatable {
  final String id;
  final int points;
  final PointsType type;
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  
  const PointsTransaction({
    required this.id,
    required this.points,
    required this.type,
    required this.description,
    required this.timestamp,
    this.metadata,
  });
  
  @override
  List<Object?> get props => [id, points, type, description, timestamp];
}

/// Types of points transactions
enum PointsType {
  workoutComplete('Workout Complete', 10),
  workout30Min('30+ Minute Workout', 25),
  weeklyGoal('Weekly Goal Achieved', 50),
  streakBonus('Streak Bonus', 0), // Varies by streak tier
  personalRecord('Personal Record', 15),
  firstPR('First PR', 25),
  badgeUnlocked('Badge Unlocked', 20),
  challengeComplete('Challenge Complete', 100);
  
  final String displayName;
  final int basePoints;
  
  const PointsType(this.displayName, this.basePoints);
}

// ═══════════════════════════════════════════════════════════════════════════
// BADGE SYSTEM
// ═══════════════════════════════════════════════════════════════════════════

/// User achievement badge
class Badge extends Equatable {
  final String id;
  final String name;
  final String description;
  final BadgeCategory category;
  final BadgeRarity rarity;
  final String iconAsset;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress;
  final int targetValue;
  final int currentValue;
  
  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.rarity,
    required this.iconAsset,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0,
    this.targetValue = 1,
    this.currentValue = 0,
  });
  
  Color get rarityColor => rarity.color;
  
  @override
  List<Object?> get props => [id, isUnlocked, progress];
  
  Badge copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
    double? progress,
    int? currentValue,
  }) {
    return Badge(
      id: id,
      name: name,
      description: description,
      category: category,
      rarity: rarity,
      iconAsset: iconAsset,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
      targetValue: targetValue,
      currentValue: currentValue ?? this.currentValue,
    );
  }
}

/// Badge categories
enum BadgeCategory {
  consistency('Consistency', '🔥'),
  strength('Strength', '💪'),
  volume('Volume', '📊'),
  personalRecords('PRs', '🏆'),
  movement('Movement Patterns', '🎯'),
  milestones('Milestones', '⭐'),
  special('Special', '✨');
  
  final String displayName;
  final String emoji;
  
  const BadgeCategory(this.displayName, this.emoji);
}

/// Badge rarity levels
enum BadgeRarity {
  common(AppColors.textSecondary, 'Common'),
  uncommon(Color(0xFF22C55E), 'Uncommon'),
  rare(Color(0xFF3B82F6), 'Rare'),
  epic(Color(0xFF8B5CF6), 'Epic'),
  legendary(Color(0xFFFFD700), 'Legendary');
  
  final Color color;
  final String name;
  
  const BadgeRarity(this.color, this.name);
}

/// Predefined badges
class BadgeDefinitions {
  static const List<Badge> all = [
    // Consistency Badges
    Badge(
      id: 'streak_starter',
      name: 'Streak Starter',
      description: 'Complete 3 workouts in a row',
      category: BadgeCategory.consistency,
      rarity: BadgeRarity.common,
      iconAsset: 'assets/badges/streak_3.png',
      targetValue: 3,
    ),
    Badge(
      id: 'week_warrior',
      name: 'Week Warrior',
      description: 'Maintain a 7-day streak',
      category: BadgeCategory.consistency,
      rarity: BadgeRarity.uncommon,
      iconAsset: 'assets/badges/streak_7.png',
      targetValue: 7,
    ),
    Badge(
      id: 'month_master',
      name: 'Month Master',
      description: 'Maintain a 30-day streak',
      category: BadgeCategory.consistency,
      rarity: BadgeRarity.epic,
      iconAsset: 'assets/badges/streak_30.png',
      targetValue: 30,
    ),
    Badge(
      id: 'century_club',
      name: 'Century Club',
      description: 'Achieve a 100-day streak',
      category: BadgeCategory.consistency,
      rarity: BadgeRarity.legendary,
      iconAsset: 'assets/badges/streak_100.png',
      targetValue: 100,
    ),
    
    // PR Badges
    Badge(
      id: 'pr_hunter',
      name: 'PR Hunter',
      description: 'Set your first personal record',
      category: BadgeCategory.personalRecords,
      rarity: BadgeRarity.common,
      iconAsset: 'assets/badges/first_pr.png',
      targetValue: 1,
    ),
    Badge(
      id: 'pr_machine',
      name: 'PR Machine',
      description: 'Set 10 personal records',
      category: BadgeCategory.personalRecords,
      rarity: BadgeRarity.rare,
      iconAsset: 'assets/badges/pr_10.png',
      targetValue: 10,
    ),
    Badge(
      id: 'pr_legend',
      name: 'PR Legend',
      description: 'Set 50 personal records',
      category: BadgeCategory.personalRecords,
      rarity: BadgeRarity.legendary,
      iconAsset: 'assets/badges/pr_50.png',
      targetValue: 50,
    ),
    
    // Volume Badges
    Badge(
      id: 'volume_starter',
      name: 'Volume Starter',
      description: 'Lift 10,000 lbs total',
      category: BadgeCategory.volume,
      rarity: BadgeRarity.common,
      iconAsset: 'assets/badges/volume_10k.png',
      targetValue: 10000,
    ),
    Badge(
      id: 'volume_builder',
      name: 'Volume Builder',
      description: 'Lift 100,000 lbs total',
      category: BadgeCategory.volume,
      rarity: BadgeRarity.rare,
      iconAsset: 'assets/badges/volume_100k.png',
      targetValue: 100000,
    ),
    Badge(
      id: 'volume_king',
      name: 'Volume King',
      description: 'Lift 1,000,000 lbs total',
      category: BadgeCategory.volume,
      rarity: BadgeRarity.legendary,
      iconAsset: 'assets/badges/volume_1m.png',
      targetValue: 1000000,
    ),
    
    // Movement Pattern Badges
    Badge(
      id: 'squat_specialist',
      name: 'Squat Specialist',
      description: 'Complete 100 squat-pattern exercises',
      category: BadgeCategory.movement,
      rarity: BadgeRarity.rare,
      iconAsset: 'assets/badges/squat_master.png',
      targetValue: 100,
    ),
    Badge(
      id: 'hinge_hero',
      name: 'Hinge Hero',
      description: 'Complete 100 hinge-pattern exercises',
      category: BadgeCategory.movement,
      rarity: BadgeRarity.rare,
      iconAsset: 'assets/badges/hinge_master.png',
      targetValue: 100,
    ),
    Badge(
      id: 'push_pro',
      name: 'Push Pro',
      description: 'Complete 100 push-pattern exercises',
      category: BadgeCategory.movement,
      rarity: BadgeRarity.rare,
      iconAsset: 'assets/badges/push_master.png',
      targetValue: 100,
    ),
    Badge(
      id: 'pull_power',
      name: 'Pull Power',
      description: 'Complete 100 pull-pattern exercises',
      category: BadgeCategory.movement,
      rarity: BadgeRarity.rare,
      iconAsset: 'assets/badges/pull_master.png',
      targetValue: 100,
    ),
    Badge(
      id: 'carry_champion',
      name: 'Carry Champion',
      description: 'Complete 50 carry exercises',
      category: BadgeCategory.movement,
      rarity: BadgeRarity.epic,
      iconAsset: 'assets/badges/carry_master.png',
      targetValue: 50,
    ),
    Badge(
      id: 'movement_specialist',
      name: 'Movement Specialist',
      description: 'Master all 7 movement patterns',
      category: BadgeCategory.movement,
      rarity: BadgeRarity.legendary,
      iconAsset: 'assets/badges/movement_master.png',
      targetValue: 7,
    ),
    
    // Milestone Badges
    Badge(
      id: 'first_workout',
      name: 'First Step',
      description: 'Complete your first workout',
      category: BadgeCategory.milestones,
      rarity: BadgeRarity.common,
      iconAsset: 'assets/badges/first_workout.png',
      targetValue: 1,
    ),
    Badge(
      id: 'ten_workouts',
      name: 'Getting Started',
      description: 'Complete 10 workouts',
      category: BadgeCategory.milestones,
      rarity: BadgeRarity.uncommon,
      iconAsset: 'assets/badges/workout_10.png',
      targetValue: 10,
    ),
    Badge(
      id: 'fifty_workouts',
      name: 'Dedicated',
      description: 'Complete 50 workouts',
      category: BadgeCategory.milestones,
      rarity: BadgeRarity.rare,
      iconAsset: 'assets/badges/workout_50.png',
      targetValue: 50,
    ),
    Badge(
      id: 'hundred_workouts',
      name: 'Century',
      description: 'Complete 100 workouts',
      category: BadgeCategory.milestones,
      rarity: BadgeRarity.epic,
      iconAsset: 'assets/badges/workout_100.png',
      targetValue: 100,
    ),
  ];
  
  static Badge? getById(String id) {
    try {
      return all.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
  
  static List<Badge> getByCategory(BadgeCategory category) {
    return all.where((b) => b.category == category).toList();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LEADERBOARD
// ═══════════════════════════════════════════════════════════════════════════

/// Leaderboard entry
class LeaderboardEntry extends Equatable {
  final String oderId;
  final String displayName;
  final String? avatarUrl;
  final int points;
  final int rank;
  final int previousRank;
  final bool isCurrentUser;
  
  const LeaderboardEntry({
    required this.oderId,
    required this.displayName,
    this.avatarUrl,
    required this.points,
    required this.rank,
    required this.previousRank,
    this.isCurrentUser = false,
  });
  
  /// Rank change since last period
  int get rankChange => previousRank - rank;
  
  @override
  List<Object?> get props => [oderId, points, rank];
}

/// Leaderboard types
enum LeaderboardType {
  weekly('This Week'),
  monthly('This Month'),
  allTime('All Time'),
  cohort('Your Level');
  
  final String displayName;
  const LeaderboardType(this.displayName);
}

