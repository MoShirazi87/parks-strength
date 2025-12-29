import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../shared/models/program_model.dart';

/// Provider for fetching all published programs
final programsProvider = FutureProvider<List<ProgramModel>>((ref) async {
  return ProgramRepository().getPublishedPrograms();
});

/// Provider for fetching a single program by ID
final programProvider = FutureProvider.family<ProgramModel?, String>((ref, programId) async {
  return ProgramRepository().getProgramById(programId);
});

/// Provider for fetching a program by slug
final programBySlugProvider = FutureProvider.family<ProgramModel?, String>((ref, slug) async {
  return ProgramRepository().getProgramBySlug(slug);
});

/// Provider for user's active program enrollment
final activeEnrollmentProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return null;
  return ProgramRepository().getActiveEnrollment(userId);
});

/// Program Repository for Supabase operations
class ProgramRepository {
  
  /// Get all published programs
  Future<List<ProgramModel>> getPublishedPrograms() async {
    try {
      final response = await supabase
          .from('programs')
          .select()
          .eq('is_published', true)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => ProgramModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching programs: $e');
      return [];
    }
  }
  
  /// Get a program by ID with full details
  Future<ProgramModel?> getProgramById(String programId) async {
    try {
      final response = await supabase
          .from('programs')
          .select('''
            *,
            program_weeks (
              *,
              workouts (*)
            )
          ''')
          .eq('id', programId)
          .maybeSingle();
      
      if (response == null) return null;
      return ProgramModel.fromJson(response);
    } catch (e) {
      print('Error fetching program: $e');
      return null;
    }
  }
  
  /// Get a program by slug
  Future<ProgramModel?> getProgramBySlug(String slug) async {
    try {
      final response = await supabase
          .from('programs')
          .select('''
            *,
            program_weeks (
              *,
              workouts (*)
            )
          ''')
          .eq('slug', slug)
          .maybeSingle();
      
      if (response == null) return null;
      return ProgramModel.fromJson(response);
    } catch (e) {
      print('Error fetching program by slug: $e');
      return null;
    }
  }
  
  /// Get user's active program enrollment
  Future<Map<String, dynamic>?> getActiveEnrollment(String userId) async {
    try {
      final response = await supabase
          .from('user_program_enrollments')
          .select('''
            *,
            program:programs (*)
          ''')
          .eq('user_id', userId)
          .eq('status', 'active')
          .maybeSingle();
      
      return response;
    } catch (e) {
      print('Error fetching active enrollment: $e');
      return null;
    }
  }
  
  /// Enroll user in a program
  Future<bool> enrollInProgram(String programId) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        print('ERROR: No user logged in for enrollment');
        return false;
      }
      
      print('Enrolling user $userId in program $programId');
      
      // Check if enrollment already exists
      final existing = await supabase
          .from('user_program_enrollments')
          .select('id')
          .eq('user_id', userId)
          .eq('program_id', programId)
          .maybeSingle();
      
      if (existing != null) {
        // Update existing enrollment
        print('Updating existing enrollment ${existing['id']}');
        await supabase
            .from('user_program_enrollments')
            .update({
              'status': 'active',
              'current_week': 1,
              'current_day': 1,
              'started_at': DateTime.now().toIso8601String(),
            })
            .eq('id', existing['id']);
      } else {
        // Create new enrollment
        print('Creating new enrollment');
        await supabase.from('user_program_enrollments').insert({
          'user_id': userId,
          'program_id': programId,
          'status': 'active',
          'current_week': 1,
          'current_day': 1,
          'started_at': DateTime.now().toIso8601String(),
        });
      }
      
      // Pause other active enrollments (ignore errors)
      try {
        await supabase
            .from('user_program_enrollments')
            .update({'status': 'paused'})
            .eq('user_id', userId)
            .eq('status', 'active')
            .neq('program_id', programId);
      } catch (e) {
        print('Note: Could not pause other enrollments: $e');
      }
      
      print('Enrollment successful!');
      return true;
    } catch (e) {
      print('ERROR enrolling in program: $e');
      return false;
    }
  }
  
  /// Update enrollment progress
  Future<bool> updateEnrollmentProgress({
    required String enrollmentId,
    int? currentWeek,
    int? currentDay,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (currentWeek != null) updates['current_week'] = currentWeek;
      if (currentDay != null) updates['current_day'] = currentDay;
      
      await supabase
          .from('user_program_enrollments')
          .update(updates)
          .eq('id', enrollmentId);
      
      return true;
    } catch (e) {
      print('Error updating enrollment progress: $e');
      return false;
    }
  }
  
  /// Complete a program
  Future<bool> completeProgram(String enrollmentId) async {
    try {
      await supabase
          .from('user_program_enrollments')
          .update({
            'status': 'completed',
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', enrollmentId);
      
      return true;
    } catch (e) {
      print('Error completing program: $e');
      return false;
    }
  }
  
  /// Get first workout of a program
  Future<String?> getFirstWorkoutId(String programId) async {
    try {
      // Try direct lookup by program_id first (simpler approach)
      final workout = await supabase
          .from('workouts')
          .select('id')
          .eq('program_id', programId)
          .order('day_number')
          .limit(1)
          .maybeSingle();
      
      if (workout != null) {
        print('Found first workout: ${workout['id']}');
        return workout['id'] as String?;
      }
      
      // Fallback: try via program_weeks
      final week = await supabase
          .from('program_weeks')
          .select('id')
          .eq('program_id', programId)
          .eq('week_number', 1)
          .maybeSingle();
      
      if (week != null) {
        final weekWorkout = await supabase
            .from('workouts')
            .select('id')
            .eq('week_id', week['id'])
            .order('day_number')
            .limit(1)
            .maybeSingle();
        
        return weekWorkout?['id'] as String?;
      }
      
      print('No workouts found for program $programId');
      return null;
    } catch (e) {
      print('Error getting first workout: $e');
      return null;
    }
  }
}

