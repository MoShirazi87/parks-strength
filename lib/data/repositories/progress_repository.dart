import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';

/// Repository for progress and PR tracking
class ProgressRepository {
  /// Get user's personal records
  Future<List<Map<String, dynamic>>> getPersonalRecords(String userId) async {
    final response = await supabase
        .from('personal_records')
        .select('''
          *,
          exercise:exercises(name, slug)
        ''')
        .eq('user_id', userId)
        .order('achieved_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Get PRs for a specific exercise
  Future<List<Map<String, dynamic>>> getExercisePRs({
    required String userId,
    required String exerciseId,
  }) async {
    final response = await supabase
        .from('personal_records')
        .select()
        .eq('user_id', userId)
        .eq('exercise_id', exerciseId)
        .order('rep_range');

    return List<Map<String, dynamic>>.from(response);
  }

  /// Record a new personal record
  Future<void> recordPR({
    required String userId,
    required String exerciseId,
    required int repRange,
    required double weight,
    String weightUnit = 'lbs',
    double? estimated1RM,
    String? setLogId,
  }) async {
    // Upsert to update if exists for this rep range
    await supabase.from('personal_records').upsert({
      'user_id': userId,
      'exercise_id': exerciseId,
      'rep_range': repRange,
      'weight': weight,
      'weight_unit': weightUnit,
      'estimated_1rm': estimated1RM ?? _calculate1RM(weight, repRange),
      'achieved_at': DateTime.now().toIso8601String(),
      'set_log_id': setLogId,
    }, onConflict: 'user_id,exercise_id,rep_range');

    // Mark the set as a PR
    if (setLogId != null) {
      await supabase
          .from('set_logs')
          .update({'is_pr': true})
          .eq('id', setLogId);
    }
  }

  double _calculate1RM(double weight, int reps) {
    // Epley formula
    if (reps == 1) return weight;
    return weight * (1 + reps / 30);
  }

  /// Check if a lift is a PR
  Future<bool> isPR({
    required String userId,
    required String exerciseId,
    required int reps,
    required double weight,
  }) async {
    final response = await supabase
        .from('personal_records')
        .select('weight')
        .eq('user_id', userId)
        .eq('exercise_id', exerciseId)
        .eq('rep_range', reps)
        .maybeSingle();

    if (response == null) return true; // No existing PR, so this is a PR
    return weight > (response['weight'] as num);
  }

  /// Get user's streak info
  Future<Map<String, dynamic>?> getStreak(String userId) async {
    final response = await supabase
        .from('user_streaks')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    return response;
  }

  /// Update user's streak
  Future<void> updateStreak(String userId) async {
    final streak = await getStreak(userId);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (streak == null) {
      await supabase.from('user_streaks').insert({
        'user_id': userId,
        'current_streak': 1,
        'longest_streak': 1,
        'last_workout_date': todayDate.toIso8601String(),
        'streak_updated_at': DateTime.now().toIso8601String(),
      });
      return;
    }

    final lastWorkoutDate = streak['last_workout_date'] != null
        ? DateTime.parse(streak['last_workout_date'])
        : null;

    if (lastWorkoutDate != null) {
      final lastDate = DateTime(
        lastWorkoutDate.year,
        lastWorkoutDate.month,
        lastWorkoutDate.day,
      );

      if (lastDate == todayDate) {
        // Already worked out today
        return;
      }

      final yesterday = todayDate.subtract(const Duration(days: 1));
      if (lastDate == yesterday) {
        // Continuing streak
        final newStreak = (streak['current_streak'] as int) + 1;
        final longestStreak = streak['longest_streak'] as int;
        await supabase.from('user_streaks').update({
          'current_streak': newStreak,
          'longest_streak': newStreak > longestStreak ? newStreak : longestStreak,
          'last_workout_date': todayDate.toIso8601String(),
          'streak_updated_at': DateTime.now().toIso8601String(),
        }).eq('user_id', userId);
      } else {
        // Streak broken, start new
        await supabase.from('user_streaks').update({
          'current_streak': 1,
          'last_workout_date': todayDate.toIso8601String(),
          'streak_updated_at': DateTime.now().toIso8601String(),
        }).eq('user_id', userId);
      }
    }
  }

  /// Get bodyweight logs
  Future<List<Map<String, dynamic>>> getBodyweightLogs({
    required String userId,
    int? limit,
  }) async {
    var query = supabase
        .from('bodyweight_logs')
        .select()
        .eq('user_id', userId)
        .order('logged_at', ascending: false);

    if (limit != null) {
      query = query.limit(limit);
    }

    return List<Map<String, dynamic>>.from(await query);
  }

  /// Log bodyweight
  Future<void> logBodyweight({
    required String userId,
    required double weight,
    String weightUnit = 'lbs',
    String? notes,
  }) async {
    await supabase.from('bodyweight_logs').insert({
      'user_id': userId,
      'weight': weight,
      'weight_unit': weightUnit,
      'notes': notes,
    });
  }

  /// Get body measurements
  Future<List<Map<String, dynamic>>> getBodyMeasurements({
    required String userId,
    String? measurementType,
  }) async {
    var query = supabase
        .from('body_measurements')
        .select()
        .eq('user_id', userId);

    if (measurementType != null) {
      query = query.eq('measurement_type', measurementType);
    }

    return List<Map<String, dynamic>>.from(
      await query.order('logged_at', ascending: false),
    );
  }

  /// Log body measurement
  Future<void> logBodyMeasurement({
    required String userId,
    required String measurementType,
    required double value,
    String unit = 'in',
  }) async {
    await supabase.from('body_measurements').insert({
      'user_id': userId,
      'measurement_type': measurementType,
      'value': value,
      'unit': unit,
    });
  }
}

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository();
});

