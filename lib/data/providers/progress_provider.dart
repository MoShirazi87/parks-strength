import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';

/// Provider for user progress stats
final progressStatsProvider = FutureProvider<ProgressStats>((ref) async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return ProgressStats.empty();
  return ProgressRepository().getProgressStats(userId);
});

/// Provider for personal records
final personalRecordsProvider = FutureProvider<List<PersonalRecord>>((ref) async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return [];
  return ProgressRepository().getPersonalRecords(userId);
});

/// Provider for workout history
final workoutHistoryProvider = FutureProvider<List<WorkoutHistoryItem>>((ref) async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return [];
  return ProgressRepository().getWorkoutHistory(userId);
});

/// Provider for weekly volume data (for charts)
final weeklyVolumeProvider = FutureProvider<List<double>>((ref) async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return List.filled(7, 0);
  return ProgressRepository().getWeeklyVolume(userId);
});

/// Provider for streak history
final streakHistoryProvider = FutureProvider<StreakData>((ref) async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return StreakData.empty();
  return ProgressRepository().getStreakData(userId);
});

/// Progress Repository for Supabase operations
class ProgressRepository {
  
  /// Get comprehensive progress stats
  Future<ProgressStats> getProgressStats(String userId, {int days = 30}) async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(Duration(days: days));
      
      // Get user data
      final user = await supabase
          .from('users')
          .select('points, current_streak, total_workouts, total_volume_lifted')
          .eq('id', userId)
          .maybeSingle();
      
      // Get workout count for period
      final workoutLogs = await supabase
          .from('workout_logs')
          .select('id, total_volume')
          .eq('user_id', userId)
          .gte('completed_at', startDate.toIso8601String())
          .order('completed_at', ascending: false);
      
      // Get PR count for period
      final prCount = await supabase
          .from('personal_records')
          .select('id')
          .eq('user_id', userId)
          .gte('achieved_at', startDate.toIso8601String());
      
      // Calculate total volume for period
      double periodVolume = 0;
      for (final log in workoutLogs as List) {
        periodVolume += (log['total_volume'] as num?)?.toDouble() ?? 0;
      }
      
      return ProgressStats(
        workoutsCompleted: (workoutLogs as List).length,
        currentStreak: user?['current_streak'] as int? ?? 0,
        totalVolume: periodVolume,
        totalVolumeAllTime: (user?['total_volume_lifted'] as num?)?.toDouble() ?? 0,
        personalRecords: (prCount as List).length,
        points: user?['points'] as int? ?? 0,
      );
    } catch (e) {
      print('Error fetching progress stats: $e');
      return ProgressStats.empty();
    }
  }
  
  /// Get personal records for user
  Future<List<PersonalRecord>> getPersonalRecords(String userId) async {
    try {
      final response = await supabase
          .from('personal_records')
          .select('''
            *,
            exercise:exercises (name, slug)
          ''')
          .eq('user_id', userId)
          .order('achieved_at', ascending: false)
          .limit(50);
      
      return (response as List).map((json) => PersonalRecord.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching personal records: $e');
      return [];
    }
  }
  
  /// Get workout history
  Future<List<WorkoutHistoryItem>> getWorkoutHistory(String userId, {int limit = 30}) async {
    try {
      final response = await supabase
          .from('workout_logs')
          .select('''
            *,
            workout:workouts (name, description)
          ''')
          .eq('user_id', userId)
          .order('completed_at', ascending: false)
          .limit(limit);
      
      return (response as List).map((json) => WorkoutHistoryItem.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching workout history: $e');
      return [];
    }
  }
  
  /// Get weekly volume data for chart
  Future<List<double>> getWeeklyVolume(String userId) async {
    try {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      
      // Initialize volumes for each day (Mon-Sun)
      final volumes = List<double>.filled(7, 0);
      
      final response = await supabase
          .from('workout_logs')
          .select('completed_at, total_volume')
          .eq('user_id', userId)
          .gte('completed_at', DateTime(weekStart.year, weekStart.month, weekStart.day).toIso8601String())
          .lte('completed_at', now.toIso8601String());
      
      for (final log in response as List) {
        final completedAt = DateTime.parse(log['completed_at'] as String);
        final dayIndex = completedAt.weekday - 1; // 0 = Monday
        if (dayIndex >= 0 && dayIndex < 7) {
          volumes[dayIndex] += (log['total_volume'] as num?)?.toDouble() ?? 0;
        }
      }
      
      return volumes;
    } catch (e) {
      print('Error fetching weekly volume: $e');
      return List.filled(7, 0);
    }
  }
  
  /// Get streak data
  Future<StreakData> getStreakData(String userId) async {
    try {
      final user = await supabase
          .from('users')
          .select('current_streak, streak_longest, last_workout_date, streak_freezes')
          .eq('id', userId)
          .maybeSingle();
      
      if (user == null) return StreakData.empty();
      
      return StreakData(
        currentStreak: user['current_streak'] as int? ?? 0,
        longestStreak: user['streak_longest'] as int? ?? 0,
        lastWorkoutDate: user['last_workout_date'] != null 
            ? DateTime.parse(user['last_workout_date'] as String)
            : null,
        streakFreezes: user['streak_freezes'] as int? ?? 0,
      );
    } catch (e) {
      print('Error fetching streak data: $e');
      return StreakData.empty();
    }
  }
  
  /// Record a new personal record
  Future<bool> recordPersonalRecord({
    required String exerciseId,
    required double weight,
    required int reps,
    required double estimated1RM,
    required String workoutLogId,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return false;
      
      // Check if this beats existing PR
      final existingPR = await supabase
          .from('personal_records')
          .select('estimated_1rm')
          .eq('user_id', userId)
          .eq('exercise_id', exerciseId)
          .maybeSingle();
      
      if (existingPR != null) {
        final existingMax = (existingPR['estimated_1rm'] as num?)?.toDouble() ?? 0;
        if (estimated1RM <= existingMax) {
          return false; // Not a new PR
        }
        
        // Update existing PR
        await supabase
            .from('personal_records')
            .update({
              'weight': weight,
              'reps': reps,
              'estimated_1rm': estimated1RM,
              'achieved_at': DateTime.now().toIso8601String(),
              'workout_log_id': workoutLogId,
            })
            .eq('user_id', userId)
            .eq('exercise_id', exerciseId);
      } else {
        // Insert new PR
        await supabase.from('personal_records').insert({
          'user_id': userId,
          'exercise_id': exerciseId,
          'weight': weight,
          'reps': reps,
          'estimated_1rm': estimated1RM,
          'achieved_at': DateTime.now().toIso8601String(),
          'workout_log_id': workoutLogId,
        });
      }
      
      return true;
    } catch (e) {
      print('Error recording personal record: $e');
      return false;
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════════════════

class ProgressStats {
  final int workoutsCompleted;
  final int currentStreak;
  final double totalVolume;
  final double totalVolumeAllTime;
  final int personalRecords;
  final int points;

  const ProgressStats({
    required this.workoutsCompleted,
    required this.currentStreak,
    required this.totalVolume,
    required this.totalVolumeAllTime,
    required this.personalRecords,
    required this.points,
  });

  factory ProgressStats.empty() => const ProgressStats(
    workoutsCompleted: 0,
    currentStreak: 0,
    totalVolume: 0,
    totalVolumeAllTime: 0,
    personalRecords: 0,
    points: 0,
  );
  
  String get formattedVolume {
    if (totalVolume >= 1000000) {
      return '${(totalVolume / 1000000).toStringAsFixed(1)}M';
    } else if (totalVolume >= 1000) {
      return '${(totalVolume / 1000).toStringAsFixed(0)}K';
    }
    return totalVolume.toStringAsFixed(0);
  }
}

class PersonalRecord {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final double weight;
  final int reps;
  final double estimated1RM;
  final DateTime achievedAt;

  const PersonalRecord({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.estimated1RM,
    required this.achievedAt,
  });

  factory PersonalRecord.fromJson(Map<String, dynamic> json) {
    return PersonalRecord(
      id: json['id'] as String,
      exerciseId: json['exercise_id'] as String,
      exerciseName: json['exercise']?['name'] as String? ?? 'Unknown',
      weight: (json['weight'] as num?)?.toDouble() ?? 0,
      reps: json['reps'] as int? ?? 0,
      estimated1RM: (json['estimated_1rm'] as num?)?.toDouble() ?? 0,
      achievedAt: DateTime.parse(json['achieved_at'] as String),
    );
  }
}

class WorkoutHistoryItem {
  final String id;
  final String? workoutId;
  final String workoutName;
  final DateTime completedAt;
  final int durationSeconds;
  final double totalVolume;
  final int totalSets;
  final int pointsEarned;

  const WorkoutHistoryItem({
    required this.id,
    this.workoutId,
    required this.workoutName,
    required this.completedAt,
    required this.durationSeconds,
    required this.totalVolume,
    required this.totalSets,
    required this.pointsEarned,
  });

  factory WorkoutHistoryItem.fromJson(Map<String, dynamic> json) {
    return WorkoutHistoryItem(
      id: json['id'] as String,
      workoutId: json['workout_id'] as String?,
      workoutName: json['workout']?['name'] as String? ?? 'Workout',
      completedAt: DateTime.parse(json['completed_at'] as String),
      durationSeconds: json['duration_seconds'] as int? ?? 0,
      totalVolume: (json['total_volume'] as num?)?.toDouble() ?? 0,
      totalSets: json['total_sets'] as int? ?? 0,
      pointsEarned: json['points_earned'] as int? ?? 0,
    );
  }
  
  String get formattedDuration {
    final mins = durationSeconds ~/ 60;
    return '${mins}m';
  }
  
  String get formattedVolume {
    if (totalVolume >= 1000) {
      return '${(totalVolume / 1000).toStringAsFixed(1)}K lbs';
    }
    return '${totalVolume.toStringAsFixed(0)} lbs';
  }
}

class StreakData {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastWorkoutDate;
  final int streakFreezes;

  const StreakData({
    required this.currentStreak,
    required this.longestStreak,
    this.lastWorkoutDate,
    required this.streakFreezes,
  });

  factory StreakData.empty() => const StreakData(
    currentStreak: 0,
    longestStreak: 0,
    lastWorkoutDate: null,
    streakFreezes: 0,
  );
  
  bool get isAtRisk {
    if (lastWorkoutDate == null) return false;
    final now = DateTime.now();
    final diff = now.difference(lastWorkoutDate!).inDays;
    return diff >= 1 && currentStreak > 0;
  }
}

