import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';
import '../../../shared/models/user_model.dart';

/// Auth state provider - listens to Supabase auth changes
final authStateProvider = StreamProvider<User?>((ref) {
  return supabase.auth.onAuthStateChange.map((event) => event.session?.user);
});

/// Current user provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  
  return authState.when(
    data: (user) async {
      if (user == null) return null;
      
      final response = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      
      if (response == null) return null;
      return UserModel.fromJson(response);
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Check if user has completed onboarding
final hasCompletedOnboardingProvider = FutureProvider<bool>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  return user?.onboardingCompleted ?? false;
});

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Auth service for handling authentication operations
class AuthService {
  /// Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'first_name': firstName,
        'last_name': lastName,
      },
    );
    
    // User profile is created automatically by database trigger
    // Update with first/last name after signup
    if (response.user != null && (firstName != null || lastName != null)) {
      // Small delay to let trigger complete
      await Future.delayed(const Duration(milliseconds: 500));
      
      try {
        await supabase.from('users').update({
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', response.user!.id);
      } catch (e) {
        // Ignore update errors - profile was still created
        print('Note: Could not update profile with name: $e');
      }
    }
    
    return response;
  }
  
  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  /// Sign in with Apple
  Future<bool> signInWithApple() async {
    return await supabase.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: 'io.supabase.parksstrength://login-callback/',
    );
  }
  
  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    return await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.parksstrength://login-callback/',
    );
  }
  
  /// Send password reset email
  Future<void> resetPassword(String email) async {
    await supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: 'io.supabase.parksstrength://reset-callback/',
    );
  }
  
  /// Sign out
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
  
  /// Update user profile
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? displayName,
    String? avatarUrl,
    String? experienceLevel,
    List<String>? goals,
    List<String>? exercisePreferences,
    List<String>? exerciseTypes,
    List<String>? injuries,
    String? injuryNotes,
    String? trainingLocation,
    List<String>? equipment,
    List<String>? preferredDays,
    String? preferredTime,
    String? reminderTime,
    int? trainingDaysPerWeek,
    String? workoutReminderTime,
    bool? onboardingCompleted,
    bool? notificationWorkoutReminders,
    bool? notificationRestDayCheckins,
    bool? notificationCoachUpdates,
    bool? notificationWeeklyProgress,
    bool? receiveWorkoutReminders,
    bool? receiveRestDayCheckins,
    bool? receiveCoachUpdates,
    bool? receiveWeeklyProgressReports,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      print('Error: No user logged in for profile update');
      return false;
    }
    
    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };
    
    if (firstName != null) updates['first_name'] = firstName;
    if (lastName != null) updates['last_name'] = lastName;
    if (displayName != null) updates['display_name'] = displayName;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    if (experienceLevel != null) updates['experience_level'] = experienceLevel;
    if (goals != null) updates['goals'] = goals;
    if (exercisePreferences != null) updates['exercise_preferences'] = exercisePreferences;
    if (exerciseTypes != null) updates['exercise_types'] = exerciseTypes;
    if (injuries != null) updates['injuries'] = injuries;
    if (injuryNotes != null) updates['injury_notes'] = injuryNotes;
    if (trainingLocation != null) updates['training_location'] = trainingLocation;
    if (preferredDays != null) updates['preferred_days'] = preferredDays;
    if (preferredTime != null) updates['preferred_time'] = preferredTime;
    if (reminderTime != null) updates['reminder_time'] = reminderTime;
    if (trainingDaysPerWeek != null) updates['training_days_per_week'] = trainingDaysPerWeek;
    if (workoutReminderTime != null) updates['workout_reminder_time'] = workoutReminderTime;
    if (onboardingCompleted != null) updates['onboarding_completed'] = onboardingCompleted;
    if (notificationWorkoutReminders != null) updates['notification_workout_reminders'] = notificationWorkoutReminders;
    if (notificationRestDayCheckins != null) updates['notification_rest_day_checkins'] = notificationRestDayCheckins;
    if (notificationCoachUpdates != null) updates['notification_coach_updates'] = notificationCoachUpdates;
    if (notificationWeeklyProgress != null) updates['notification_weekly_progress'] = notificationWeeklyProgress;
    if (receiveWorkoutReminders != null) updates['notification_workout_reminders'] = receiveWorkoutReminders;
    if (receiveRestDayCheckins != null) updates['notification_rest_day_checkins'] = receiveRestDayCheckins;
    if (receiveCoachUpdates != null) updates['notification_coach_updates'] = receiveCoachUpdates;
    if (receiveWeeklyProgressReports != null) updates['notification_weekly_progress'] = receiveWeeklyProgressReports;
    
    try {
      // First check if user profile exists
      final existingUser = await supabase
          .from('users')
          .select('id')
          .eq('id', userId)
          .maybeSingle();
      
      if (existingUser != null) {
        // User exists, update
        await supabase
            .from('users')
            .update(updates)
            .eq('id', userId);
        print('Profile updated successfully: ${updates.keys.join(', ')}');
      } else {
        // User doesn't exist, create with upsert
        final email = supabase.auth.currentUser?.email ?? '';
        final insertData = {
          'id': userId,
          'email': email,
          'created_at': DateTime.now().toIso8601String(),
          ...updates,
        };
        
        await supabase
            .from('users')
            .upsert(insertData, onConflict: 'id');
        print('Profile created successfully: ${updates.keys.join(', ')}');
      }
      
      // Save user equipment if provided
      if (equipment != null && equipment.isNotEmpty) {
        await _saveUserEquipment(userId, equipment);
      }
      
      return true;
    } catch (e) {
      print('Error updating profile: $e');
      // Try upsert as fallback
      try {
        final email = supabase.auth.currentUser?.email ?? '';
        final insertData = {
          'id': userId,
          'email': email,
          'created_at': DateTime.now().toIso8601String(),
          ...updates,
        };
        
        await supabase
            .from('users')
            .upsert(insertData, onConflict: 'id');
        print('Profile upserted successfully (fallback): ${updates.keys.join(', ')}');
        
        // Save user equipment if provided
        if (equipment != null && equipment.isNotEmpty) {
          await _saveUserEquipment(userId, equipment);
        }
        
        return true;
      } catch (e2) {
        print('Error upserting profile: $e2');
        return false;
      }
    }
  }
  
  /// Save user equipment preferences
  Future<void> _saveUserEquipment(String userId, List<String> equipmentNames) async {
    try {
      // First, delete existing user equipment
      await supabase
          .from('user_equipment')
          .delete()
          .eq('user_id', userId);
      
      // Get equipment IDs by name
      final equipmentLower = equipmentNames.map((e) => e.toLowerCase()).toList();
      final equipmentResponse = await supabase
          .from('equipment')
          .select('id, name')
          .inFilter('name', equipmentLower);
      
      // Build list of user_equipment records
      final records = <Map<String, dynamic>>[];
      for (final eq in (equipmentResponse as List)) {
        records.add({
          'user_id': userId,
          'equipment_id': eq['id'],
        });
      }
      
      // Also try matching by checking if name is contained
      if (records.isEmpty) {
        // Fallback - get all equipment and match by partial name
        final allEquipment = await supabase.from('equipment').select('id, name');
        for (final eq in (allEquipment as List)) {
          final eqName = (eq['name'] as String).toLowerCase();
          for (final userEq in equipmentLower) {
            if (eqName.contains(userEq) || userEq.contains(eqName)) {
              records.add({
                'user_id': userId,
                'equipment_id': eq['id'],
              });
              break;
            }
          }
        }
      }
      
      // Insert new user equipment
      if (records.isNotEmpty) {
        await supabase.from('user_equipment').insert(records);
        print('Saved ${records.length} equipment items for user');
      }
    } catch (e) {
      print('Error saving user equipment: $e');
    }
  }
  
  /// Complete onboarding
  Future<void> completeOnboarding() async {
    await updateProfile(onboardingCompleted: true);
  }
  
  /// Get current user ID
  String? get currentUserId => supabase.auth.currentUser?.id;
  
  /// Check if user is logged in
  bool get isLoggedIn => supabase.auth.currentUser != null;
}

/// Auth state notifier for managing loading states
class AuthStateNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;
  
  AuthStateNotifier(this._authService) : super(const AsyncValue.data(null));
  
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _authService.signUpWithEmail(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> signInWithApple() async {
    state = const AsyncValue.loading();
    try {
      await _authService.signInWithApple();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      await _authService.signInWithGoogle();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    try {
      await _authService.resetPassword(email);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AsyncValue<void>>((ref) {
  return AuthStateNotifier(ref.watch(authServiceProvider));
});

