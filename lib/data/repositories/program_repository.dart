import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../shared/models/program_model.dart';

/// Repository for program operations
class ProgramRepository {
  /// Get all published programs
  Future<List<ProgramModel>> getPrograms() async {
    final response = await supabase
        .from('programs')
        .select()
        .eq('is_published', true)
        .order('display_order');

    return (response as List)
        .map((json) => ProgramModel.fromJson(json))
        .toList();
  }

  /// Get a single program with all weeks
  Future<ProgramModel?> getProgram(String programId) async {
    final response = await supabase
        .from('programs')
        .select('''
          *,
          weeks:program_weeks(
            *,
            workouts(*)
          )
        ''')
        .eq('id', programId)
        .maybeSingle();

    if (response == null) return null;
    return ProgramModel.fromJson(response);
  }

  /// Get program by slug
  Future<ProgramModel?> getProgramBySlug(String slug) async {
    final response = await supabase
        .from('programs')
        .select('''
          *,
          weeks:program_weeks(
            *,
            workouts(*)
          )
        ''')
        .eq('slug', slug)
        .maybeSingle();

    if (response == null) return null;
    return ProgramModel.fromJson(response);
  }

  /// Enroll user in program
  Future<void> enrollInProgram({
    required String userId,
    required String programId,
    List<String>? scheduledDays,
    String? reminderTime,
  }) async {
    await supabase.from('user_program_enrollments').upsert({
      'user_id': userId,
      'program_id': programId,
      'status': 'active',
      'started_at': DateTime.now().toIso8601String(),
      'current_week': 1,
      'current_day': 1,
      'scheduled_days': scheduledDays ?? [],
      'reminder_time': reminderTime,
    }, onConflict: 'user_id,program_id');
  }

  /// Get user's active enrollment
  Future<Map<String, dynamic>?> getActiveEnrollment(String userId) async {
    final response = await supabase
        .from('user_program_enrollments')
        .select('''
          *,
          program:programs(*)
        ''')
        .eq('user_id', userId)
        .eq('status', 'active')
        .maybeSingle();

    return response;
  }

  /// Get user's enrollment for a specific program
  Future<Map<String, dynamic>?> getEnrollment({
    required String userId,
    required String programId,
  }) async {
    final response = await supabase
        .from('user_program_enrollments')
        .select()
        .eq('user_id', userId)
        .eq('program_id', programId)
        .maybeSingle();

    return response;
  }

  /// Update enrollment progress
  Future<void> updateEnrollmentProgress({
    required String enrollmentId,
    int? currentWeek,
    int? currentDay,
    String? status,
  }) async {
    final updates = <String, dynamic>{};
    if (currentWeek != null) updates['current_week'] = currentWeek;
    if (currentDay != null) updates['current_day'] = currentDay;
    if (status != null) updates['status'] = status;

    if (status == 'completed') {
      updates['completed_at'] = DateTime.now().toIso8601String();
    }

    await supabase
        .from('user_program_enrollments')
        .update(updates)
        .eq('id', enrollmentId);
  }

  /// Get recommended program based on user profile
  Future<ProgramModel?> getRecommendedProgram({
    required String experienceLevel,
    required List<String> goals,
    required String trainingLocation,
  }) async {
    // Simple recommendation logic - get first matching program
    var query = supabase
        .from('programs')
        .select()
        .eq('is_published', true);

    // Filter by difficulty if possible
    if (experienceLevel == 'beginner') {
      query = query.eq('difficulty', 'beginner');
    } else if (experienceLevel == 'advanced') {
      query = query.or('difficulty.eq.advanced,difficulty.eq.intermediate');
    }

    final response = await query.order('display_order').limit(1);
    final programs = response as List;

    if (programs.isEmpty) {
      // Fallback: get any published program
      final fallback = await supabase
          .from('programs')
          .select()
          .eq('is_published', true)
          .order('display_order')
          .limit(1);

      if ((fallback as List).isEmpty) return null;
      return ProgramModel.fromJson(fallback.first);
    }

    return ProgramModel.fromJson(programs.first);
  }
}

final programRepositoryProvider = Provider<ProgramRepository>((ref) {
  return ProgramRepository();
});

