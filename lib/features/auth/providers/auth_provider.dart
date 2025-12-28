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
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? displayName,
    String? avatarUrl,
    String? experienceLevel,
    List<String>? goals,
    List<String>? exercisePreferences,
    List<String>? injuries,
    String? trainingLocation,
    List<String>? preferredDays,
    String? preferredTime,
    String? reminderTime,
    bool? onboardingCompleted,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    
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
    if (injuries != null) updates['injuries'] = injuries;
    if (trainingLocation != null) updates['training_location'] = trainingLocation;
    if (preferredDays != null) updates['preferred_days'] = preferredDays;
    if (preferredTime != null) updates['preferred_time'] = preferredTime;
    if (reminderTime != null) updates['reminder_time'] = reminderTime;
    if (onboardingCompleted != null) updates['onboarding_completed'] = onboardingCompleted;
    
    await supabase
        .from('users')
        .update(updates)
        .eq('id', userId);
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

