import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../shared/models/workout_model.dart';
import '../../shared/models/workout_log_model.dart';

/// Repository for workout operations
class WorkoutRepository {
  /// Get all workouts for a program week
  Future<List<WorkoutModel>> getWorkoutsForWeek(String weekId) async {
    final response = await supabase
        .from('workouts')
        .select('''
          *,
          sections:workout_sections(
            *,
            exercises:workout_exercises(
              *,
              exercise:exercises(*)
            )
          )
        ''')
        .eq('week_id', weekId)
        .order('day_number');

    return (response as List)
        .map((json) => WorkoutModel.fromJson(json))
        .toList();
  }

  /// Get a single workout with all details
  Future<WorkoutModel?> getWorkout(String workoutId) async {
    final response = await supabase
        .from('workouts')
        .select('''
          *,
          sections:workout_sections(
            *,
            exercises:workout_exercises(
              *,
              exercise:exercises(*)
            )
          )
        ''')
        .eq('id', workoutId)
        .maybeSingle();

    if (response == null) return null;
    return WorkoutModel.fromJson(response);
  }

  /// Get today's scheduled workout for user
  Future<WorkoutModel?> getTodaysWorkout(String userId) async {
    final dayOfWeek = _getDayOfWeek();
    
    // Get user's active enrollment
    final enrollment = await supabase
        .from('user_program_enrollments')
        .select('id, program_id, current_week')
        .eq('user_id', userId)
        .eq('status', 'active')
        .maybeSingle();

    if (enrollment == null) return null;

    // Get the week
    final week = await supabase
        .from('program_weeks')
        .select('id')
        .eq('program_id', enrollment['program_id'])
        .eq('week_number', enrollment['current_week'])
        .maybeSingle();

    if (week == null) return null;

    // Get workout for today
    final response = await supabase
        .from('workouts')
        .select('''
          *,
          sections:workout_sections(
            *,
            exercises:workout_exercises(
              *,
              exercise:exercises(*)
            )
          )
        ''')
        .eq('week_id', week['id'])
        .eq('day_of_week', dayOfWeek)
        .maybeSingle();

    if (response == null) return null;
    return WorkoutModel.fromJson(response);
  }

  String _getDayOfWeek() {
    final now = DateTime.now();
    const days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    return days[now.weekday - 1];
  }

  /// Start a workout log
  Future<WorkoutLogModel> startWorkout({
    required String userId,
    String? workoutId,
    String? enrollmentId,
    String? customWorkoutName,
  }) async {
    final response = await supabase.from('workout_logs').insert({
      'user_id': userId,
      'workout_id': workoutId,
      'enrollment_id': enrollmentId,
      'custom_workout_name': customWorkoutName,
      'started_at': DateTime.now().toIso8601String(),
    }).select().single();

    return WorkoutLogModel.fromJson(response);
  }

  /// Complete a workout
  Future<WorkoutLogModel> completeWorkout({
    required String workoutLogId,
    required int durationSeconds,
    double? totalVolume,
    int? totalSets,
    int? totalReps,
    int? rating,
    String? notes,
  }) async {
    final response = await supabase
        .from('workout_logs')
        .update({
          'completed_at': DateTime.now().toIso8601String(),
          'duration_seconds': durationSeconds,
          'total_volume': totalVolume,
          'total_sets': totalSets,
          'total_reps': totalReps,
          'rating': rating,
          'notes': notes,
          'points_earned': 100, // Base points per workout
        })
        .eq('id', workoutLogId)
        .select()
        .single();

    return WorkoutLogModel.fromJson(response);
  }

  /// Log a set
  Future<SetLogModel> logSet({
    required String exerciseLogId,
    required int setNumber,
    int? repsCompleted,
    double? weight,
    String weightUnit = 'lbs',
    int? timeSeconds,
    int? rpe,
    bool isWarmupSet = false,
  }) async {
    final response = await supabase.from('set_logs').insert({
      'exercise_log_id': exerciseLogId,
      'set_number': setNumber,
      'reps_completed': repsCompleted,
      'weight': weight,
      'weight_unit': weightUnit,
      'time_seconds': timeSeconds,
      'rpe': rpe,
      'is_warmup_set': isWarmupSet,
    }).select().single();

    return SetLogModel.fromJson(response);
  }

  /// Get workout history for user
  Future<List<WorkoutLogModel>> getWorkoutHistory({
    required String userId,
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await supabase
        .from('workout_logs')
        .select('''
          *,
          exercise_logs(
            *,
            set_logs(*)
          )
        ''')
        .eq('user_id', userId)
        .not('completed_at', 'is', null)
        .order('completed_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((json) => WorkoutLogModel.fromJson(json))
        .toList();
  }

  /// Get workout stats for user
  Future<Map<String, dynamic>> getWorkoutStats({
    required String userId,
    int? days,
  }) async {
    var query = supabase
        .from('workout_logs')
        .select('completed_at, duration_seconds, total_volume, total_sets, total_reps, points_earned')
        .eq('user_id', userId)
        .not('completed_at', 'is', null);

    if (days != null) {
      final startDate = DateTime.now().subtract(Duration(days: days));
      query = query.gte('completed_at', startDate.toIso8601String());
    }

    final response = await query;
    final logs = response as List;

    return {
      'total_workouts': logs.length,
      'total_volume': logs.fold<double>(
        0,
        (sum, log) => sum + (log['total_volume'] ?? 0),
      ),
      'total_duration_minutes': logs.fold<int>(
        0,
        (sum, log) => sum + (((log['duration_seconds'] as num?) ?? 0) ~/ 60).toInt(),
      ),
      'total_points': logs.fold<int>(
        0,
        (sum, log) => sum + ((log['points_earned'] as num?) ?? 0).toInt(),
      ),
    };
  }
}

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepository();
});

