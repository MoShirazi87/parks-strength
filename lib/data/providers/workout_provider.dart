import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../shared/models/workout_model.dart';
import '../../shared/models/exercise_model.dart';

/// Provider for fetching a single workout by ID
final workoutProvider = FutureProvider.family<WorkoutModel?, String>((ref, workoutId) async {
  return WorkoutRepository().getWorkoutById(workoutId);
});

/// Provider for fetching all workouts for a program
final programWorkoutsProvider = FutureProvider.family<List<WorkoutModel>, String>((ref, programId) async {
  return WorkoutRepository().getWorkoutsByProgram(programId);
});

/// Provider for fetching today's scheduled workout
final todaysWorkoutProvider = FutureProvider<WorkoutModel?>((ref) async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return null;
  return WorkoutRepository().getTodaysWorkout(userId);
});

/// Provider for fetching recent workout logs
final recentWorkoutLogsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return [];
  return WorkoutRepository().getRecentWorkoutLogs(userId, limit: 5);
});

/// Provider for all exercises
final exercisesProvider = FutureProvider<List<ExerciseModel>>((ref) async {
  return WorkoutRepository().getAllExercises();
});

/// Provider for exercises by movement pattern
final exercisesByPatternProvider = FutureProvider.family<List<ExerciseModel>, String>((ref, pattern) async {
  return WorkoutRepository().getExercisesByPattern(pattern);
});

/// Workout Repository for Supabase operations
class WorkoutRepository {
  
  /// Get a single workout by ID with all sections and exercises
  Future<WorkoutModel?> getWorkoutById(String workoutId) async {
    try {
      // Fetch workout with nested sections and exercises
      final response = await supabase
          .from('workouts')
          .select('''
            *,
            workout_sections (
              *,
              workout_exercises (
                *,
                exercise:exercises (*)
              )
            )
          ''')
          .eq('id', workoutId)
          .maybeSingle();
      
      if (response == null) return null;
      return WorkoutModel.fromJson(response);
    } catch (e) {
      print('Error fetching workout: $e');
      return null;
    }
  }
  
  /// Get all workouts for a program
  Future<List<WorkoutModel>> getWorkoutsByProgram(String programId) async {
    try {
      final response = await supabase
          .from('workouts')
          .select('''
            *,
            workout_sections (
              *,
              workout_exercises (
                *,
                exercise:exercises (*)
              )
            )
          ''')
          .eq('program_id', programId)
          .order('day_number');
      
      return (response as List)
          .map((json) => WorkoutModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching program workouts: $e');
      return [];
    }
  }
  
  /// Get today's scheduled workout for user
  Future<WorkoutModel?> getTodaysWorkout(String userId) async {
    try {
      // Get user's active program enrollment
      final enrollment = await supabase
          .from('user_program_enrollments')
          .select('program_id, current_week, current_day')
          .eq('user_id', userId)
          .eq('status', 'active')
          .maybeSingle();
      
      if (enrollment == null) return null;
      
      // Get the workout for current day
      final dayOfWeek = DateTime.now().weekday; // 1 = Monday
      final dayNames = ['', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
      
      final response = await supabase
          .from('workouts')
          .select('''
            *,
            workout_sections (
              *,
              workout_exercises (
                *,
                exercise:exercises (*)
              )
            )
          ''')
          .eq('program_id', enrollment['program_id'])
          .eq('day_of_week', dayNames[dayOfWeek])
          .maybeSingle();
      
      if (response == null) return null;
      return WorkoutModel.fromJson(response);
    } catch (e) {
      print('Error fetching today\'s workout: $e');
      return null;
    }
  }
  
  /// Get recent workout logs for user
  Future<List<Map<String, dynamic>>> getRecentWorkoutLogs(String userId, {int limit = 5}) async {
    try {
      final response = await supabase
          .from('workout_logs')
          .select('''
            *,
            workout:workouts (name)
          ''')
          .eq('user_id', userId)
          .order('completed_at', ascending: false)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching workout logs: $e');
      return [];
    }
  }
  
  /// Get all exercises
  Future<List<ExerciseModel>> getAllExercises() async {
    try {
      final response = await supabase
          .from('exercises')
          .select()
          .order('name');
      
      return (response as List)
          .map((json) => ExerciseModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching exercises: $e');
      return [];
    }
  }
  
  /// Get exercises by movement pattern
  Future<List<ExerciseModel>> getExercisesByPattern(String pattern) async {
    try {
      final response = await supabase
          .from('exercises')
          .select()
          .eq('movement_pattern', pattern)
          .order('difficulty');
      
      return (response as List)
          .map((json) => ExerciseModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching exercises by pattern: $e');
      return [];
    }
  }
  
  /// Log a completed workout
  Future<String?> logWorkout({
    required String workoutId,
    required int durationSeconds,
    required List<Map<String, dynamic>> exerciseLogs,
    String? notes,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return null;
      
      // Calculate total volume and points
      double totalVolume = 0;
      int totalSets = 0;
      
      for (final log in exerciseLogs) {
        final sets = log['sets'] as List<dynamic>? ?? [];
        for (final set in sets) {
          totalVolume += (set['weight'] ?? 0) * (set['reps'] ?? 0);
          totalSets++;
        }
      }
      
      // Calculate points (base + volume bonus)
      int pointsEarned = 50 + (totalSets * 5) + (totalVolume ~/ 1000);
      
      // Insert workout log
      final logResponse = await supabase
          .from('workout_logs')
          .insert({
            'user_id': userId,
            'workout_id': workoutId,
            'started_at': DateTime.now().subtract(Duration(seconds: durationSeconds)).toIso8601String(),
            'completed_at': DateTime.now().toIso8601String(),
            'duration_seconds': durationSeconds,
            'total_volume': totalVolume,
            'total_sets': totalSets,
            'points_earned': pointsEarned,
            'notes': notes,
          })
          .select()
          .single();
      
      final workoutLogId = logResponse['id'] as String;
      
      // Insert exercise logs
      for (final exerciseLog in exerciseLogs) {
        final exerciseLogResponse = await supabase
            .from('exercise_logs')
            .insert({
              'workout_log_id': workoutLogId,
              'exercise_id': exerciseLog['exercise_id'],
              'notes': exerciseLog['notes'],
            })
            .select()
            .single();
        
        final exerciseLogId = exerciseLogResponse['id'] as String;
        
        // Insert set logs
        final sets = exerciseLog['sets'] as List<dynamic>? ?? [];
        for (int i = 0; i < sets.length; i++) {
          final set = sets[i];
          await supabase.from('set_logs').insert({
            'exercise_log_id': exerciseLogId,
            'set_number': i + 1,
            'weight': set['weight'],
            'reps': set['reps'],
            'rpe': set['rpe'],
            'is_warmup': set['is_warmup'] ?? false,
            'is_pr': set['is_pr'] ?? false,
          });
        }
      }
      
      // Update user points and streak
      await _updateUserStats(userId, pointsEarned, totalVolume.toInt());
      
      return workoutLogId;
    } catch (e) {
      print('Error logging workout: $e');
      return null;
    }
  }
  
  /// Log a demo workout (no workout_id required)
  Future<String?> logDemoWorkout({
    required int durationSeconds,
    required List<Map<String, dynamic>> exerciseLogs,
    String? notes,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return null;
      
      // Calculate total volume and points
      double totalVolume = 0;
      int totalSets = 0;
      
      for (final log in exerciseLogs) {
        final sets = log['sets'] as List<dynamic>? ?? [];
        for (final set in sets) {
          totalVolume += ((set['weight'] as num?) ?? 0).toDouble() * ((set['reps'] as num?) ?? 0).toInt();
          totalSets++;
        }
      }
      
      // Calculate points (base + volume bonus)
      int pointsEarned = 50 + (totalSets * 5) + (totalVolume ~/ 1000);
      
      // Insert workout log without workout_id (can be null for quick/demo workouts)
      final logResponse = await supabase
          .from('workout_logs')
          .insert({
            'user_id': userId,
            'workout_id': null, // Demo workouts have no workout template
            'started_at': DateTime.now().subtract(Duration(seconds: durationSeconds)).toIso8601String(),
            'completed_at': DateTime.now().toIso8601String(),
            'duration_seconds': durationSeconds,
            'total_volume': totalVolume,
            'total_sets': totalSets,
            'points_earned': pointsEarned,
            'notes': notes ?? 'Quick Workout',
          })
          .select()
          .single();
      
      final workoutLogId = logResponse['id'] as String;
      
      // Insert exercise logs (only for exercises with valid IDs)
      for (final exerciseLog in exerciseLogs) {
        final exerciseId = exerciseLog['exercise_id'] as String?;
        if (exerciseId == null) continue; // Skip if no exercise ID
        
        try {
          final exerciseLogResponse = await supabase
              .from('exercise_logs')
              .insert({
                'workout_log_id': workoutLogId,
                'exercise_id': exerciseId,
                'notes': exerciseLog['notes'],
              })
              .select()
              .single();
          
          final exLogId = exerciseLogResponse['id'] as String;
          
          // Insert set logs
          final sets = exerciseLog['sets'] as List<dynamic>? ?? [];
          for (int i = 0; i < sets.length; i++) {
            final set = sets[i];
            await supabase.from('set_logs').insert({
              'exercise_log_id': exLogId,
              'set_number': i + 1,
              'weight': (set['weight'] as num?)?.toDouble() ?? 0,
              'reps': (set['reps'] as num?)?.toInt() ?? 0,
              'rpe': (set['rpe'] as num?)?.toInt() ?? 7,
              'is_warmup': set['is_warmup'] ?? false,
              'is_pr': set['is_pr'] ?? false,
            });
          }
        } catch (e) {
          print('Error logging exercise: $e');
          // Continue with other exercises
        }
      }
      
      // Update user stats
      await _updateUserStats(userId, pointsEarned, totalVolume.toInt());
      
      return workoutLogId;
    } catch (e) {
      print('Error logging demo workout: $e');
      return null;
    }
  }
  
  /// Update user stats after workout
  Future<void> _updateUserStats(String userId, int pointsEarned, [int volumeAdded = 0]) async {
    try {
      // Get current user data
      final user = await supabase
          .from('users')
          .select('points, current_streak, longest_streak, last_workout_date, total_workouts, total_volume_lifted')
          .eq('id', userId)
          .single();
      
      final currentPoints = user['points'] as int? ?? 0;
      final currentStreak = user['current_streak'] as int? ?? 0;
      final longestStreak = user['longest_streak'] as int? ?? 0;
      final lastWorkoutDateStr = user['last_workout_date'] as String?;
      final totalWorkouts = user['total_workouts'] as int? ?? 0;
      final totalVolume = ((user['total_volume_lifted'] as num?) ?? 0).toDouble();
      
      // Calculate new streak
      int newStreak = currentStreak;
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      
      if (lastWorkoutDateStr != null) {
        final lastWorkoutDate = DateTime.parse(lastWorkoutDateStr);
        final lastDate = DateTime(lastWorkoutDate.year, lastWorkoutDate.month, lastWorkoutDate.day);
        final difference = todayDate.difference(lastDate).inDays;
        
        if (difference == 1) {
          // Consecutive day - increment streak
          newStreak = currentStreak + 1;
        } else if (difference > 1) {
          // Streak broken - reset to 1
          newStreak = 1;
        }
        // If difference is 0, same day workout - keep streak
      } else {
        // First workout ever
        newStreak = 1;
      }
      
      // Calculate new longest streak
      final newLongestStreak = newStreak > longestStreak ? newStreak : longestStreak;
      
      // Update user
      await supabase.from('users').update({
        'points': currentPoints + pointsEarned,
        'current_streak': newStreak,
        'longest_streak': newLongestStreak,
        'last_workout_date': todayDate.toIso8601String().split('T')[0],
        'last_active_at': DateTime.now().toIso8601String(),
        'total_workouts': totalWorkouts + 1,
        'total_volume_lifted': totalVolume + volumeAdded,
      }).eq('id', userId);
    } catch (e) {
      print('Error updating user stats: $e');
    }
  }
}

