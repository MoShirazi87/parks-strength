import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';

/// Equipment item from database
class EquipmentItem {
  final String id;
  final String name;
  final String category;
  final String? iconName;
  final bool isHomeFriendly;

  const EquipmentItem({
    required this.id,
    required this.name,
    required this.category,
    this.iconName,
    required this.isHomeFriendly,
  });

  factory EquipmentItem.fromJson(Map<String, dynamic> json) {
    return EquipmentItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String? ?? 'accessories',
      iconName: json['icon_name'] as String?,
      isHomeFriendly: json['is_home_friendly'] as bool? ?? false,
    );
  }
}

/// Provider to fetch equipment catalog from Supabase
final equipmentCatalogProvider = FutureProvider<List<EquipmentItem>>((ref) async {
  try {
    final response = await supabase
        .from('equipment')
        .select()
        .order('name');
    
    return (response as List)
        .map((e) => EquipmentItem.fromJson(e))
        .toList();
  } catch (e) {
    print('Error fetching equipment catalog: $e');
    return [];
  }
});

/// Onboarding data model holding all user preferences
class OnboardingData {
  // Step 1: Profile
  final String? avatarUrl;
  final String firstName;
  final String lastName;
  
  // Step 2: Experience
  final String? experienceLevel;
  
  // Step 3: Goals
  final List<String> goals;
  
  // Step 4: Exercise Types
  final List<String> exerciseTypes;
  
  // Step 5: Equipment
  final String? trainingLocation;
  final List<String> selectedEquipmentIds;
  
  // Step 6: Schedule
  final List<String> preferredDays;
  final TimeOfDay reminderTime;
  
  // Step 7: Injuries
  final List<String> injuries;
  final String? injuryNotes;
  
  // Step 8: Notifications
  final bool workoutReminders;
  final bool restDayCheckins;
  final bool coachTips;
  final bool weeklySummary;

  const OnboardingData({
    this.avatarUrl,
    this.firstName = '',
    this.lastName = '',
    this.experienceLevel,
    this.goals = const [],
    this.exerciseTypes = const [],
    this.trainingLocation,
    this.selectedEquipmentIds = const [],
    this.preferredDays = const [],
    this.reminderTime = const TimeOfDay(hour: 7, minute: 0),
    this.injuries = const [],
    this.injuryNotes,
    this.workoutReminders = true,
    this.restDayCheckins = true,
    this.coachTips = true,
    this.weeklySummary = true,
  });

  OnboardingData copyWith({
    String? avatarUrl,
    String? firstName,
    String? lastName,
    String? experienceLevel,
    List<String>? goals,
    List<String>? exerciseTypes,
    String? trainingLocation,
    List<String>? selectedEquipmentIds,
    List<String>? preferredDays,
    TimeOfDay? reminderTime,
    List<String>? injuries,
    String? injuryNotes,
    bool? workoutReminders,
    bool? restDayCheckins,
    bool? coachTips,
    bool? weeklySummary,
  }) {
    return OnboardingData(
      avatarUrl: avatarUrl ?? this.avatarUrl,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      goals: goals ?? this.goals,
      exerciseTypes: exerciseTypes ?? this.exerciseTypes,
      trainingLocation: trainingLocation ?? this.trainingLocation,
      selectedEquipmentIds: selectedEquipmentIds ?? this.selectedEquipmentIds,
      preferredDays: preferredDays ?? this.preferredDays,
      reminderTime: reminderTime ?? this.reminderTime,
      injuries: injuries ?? this.injuries,
      injuryNotes: injuryNotes ?? this.injuryNotes,
      workoutReminders: workoutReminders ?? this.workoutReminders,
      restDayCheckins: restDayCheckins ?? this.restDayCheckins,
      coachTips: coachTips ?? this.coachTips,
      weeklySummary: weeklySummary ?? this.weeklySummary,
    );
  }

  /// Convert reminder time to string format for database
  String get reminderTimeString {
    final hour = reminderTime.hour.toString().padLeft(2, '0');
    final minute = reminderTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  /// Convert notification preferences to Map
  Map<String, bool> get notificationPreferencesMap => {
    'workout_reminders': workoutReminders,
    'rest_day_checkins': restDayCheckins,
    'coach_tips': coachTips,
    'weekly_summary': weeklySummary,
  };
}

/// Onboarding state notifier for managing wizard state
class OnboardingNotifier extends StateNotifier<OnboardingData> {
  OnboardingNotifier() : super(const OnboardingData());

  // Step 1: Profile
  void updateProfile({String? firstName, String? lastName, String? avatarUrl}) {
    state = state.copyWith(
      firstName: firstName,
      lastName: lastName,
      avatarUrl: avatarUrl,
    );
  }

  // Step 2: Experience
  void updateExperienceLevel(String level) {
    state = state.copyWith(experienceLevel: level);
  }

  // Step 3: Goals
  void toggleGoal(String goal) {
    final goals = List<String>.from(state.goals);
    if (goals.contains(goal)) {
      goals.remove(goal);
    } else {
      goals.add(goal);
    }
    state = state.copyWith(goals: goals);
  }

  // Step 4: Exercise Types
  void toggleExerciseType(String type) {
    final types = List<String>.from(state.exerciseTypes);
    if (types.contains(type)) {
      types.remove(type);
    } else {
      types.add(type);
    }
    state = state.copyWith(exerciseTypes: types);
  }

  // Step 5: Equipment
  void updateTrainingLocation(String location) {
    state = state.copyWith(trainingLocation: location);
  }

  void toggleEquipment(String equipmentId) {
    final equipment = List<String>.from(state.selectedEquipmentIds);
    if (equipment.contains(equipmentId)) {
      equipment.remove(equipmentId);
    } else {
      equipment.add(equipmentId);
    }
    state = state.copyWith(selectedEquipmentIds: equipment);
  }

  // Step 6: Schedule
  void toggleDay(String day) {
    final days = List<String>.from(state.preferredDays);
    if (days.contains(day)) {
      days.remove(day);
    } else {
      days.add(day);
    }
    state = state.copyWith(preferredDays: days);
  }

  void updateReminderTime(TimeOfDay time) {
    state = state.copyWith(reminderTime: time);
  }

  // Step 7: Injuries
  void toggleInjury(String injury) {
    final injuries = List<String>.from(state.injuries);
    if (injury == 'None') {
      // Clear all injuries if "None" is selected
      state = state.copyWith(injuries: ['None']);
      return;
    }
    // Remove "None" if selecting a specific injury
    injuries.remove('None');
    if (injuries.contains(injury)) {
      injuries.remove(injury);
    } else {
      injuries.add(injury);
    }
    state = state.copyWith(injuries: injuries);
  }

  void updateInjuryNotes(String notes) {
    state = state.copyWith(injuryNotes: notes.isEmpty ? null : notes);
  }

  // Step 8: Notifications
  void updateNotifications({
    bool? workoutReminders,
    bool? restDayCheckins,
    bool? coachTips,
    bool? weeklySummary,
  }) {
    state = state.copyWith(
      workoutReminders: workoutReminders,
      restDayCheckins: restDayCheckins,
      coachTips: coachTips,
      weeklySummary: weeklySummary,
    );
  }

  /// Save all onboarding data to Supabase
  Future<bool> saveOnboarding() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      print('OnboardingNotifier: No user logged in');
      return false;
    }

    try {
      // 1. Update user profile
      final updates = {
        'first_name': state.firstName,
        'last_name': state.lastName,
        'avatar_url': state.avatarUrl,
        'experience_level': state.experienceLevel,
        'goals': state.goals,
        'exercise_types': state.exerciseTypes,
        'training_location': state.trainingLocation,
        'preferred_days': state.preferredDays,
        'reminder_time': state.reminderTimeString,
        'injuries': state.injuries.where((i) => i != 'None').toList(),
        'injury_notes': state.injuryNotes,
        'notification_preferences': state.notificationPreferencesMap,
        'onboarding_completed': true,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await supabase
          .from('users')
          .update(updates)
          .eq('id', userId);
      
      print('OnboardingNotifier: User profile updated');

      // 2. Save user equipment
      if (state.selectedEquipmentIds.isNotEmpty) {
        // Delete existing equipment
        await supabase
            .from('user_equipment')
            .delete()
            .eq('user_id', userId);

        // Insert new equipment selections
        final equipmentRecords = state.selectedEquipmentIds
            .map((eqId) => {
                  'user_id': userId,
                  'equipment_id': eqId,
                })
            .toList();

        await supabase.from('user_equipment').insert(equipmentRecords);
        print('OnboardingNotifier: Saved ${equipmentRecords.length} equipment items');
      }

      return true;
    } catch (e) {
      print('OnboardingNotifier: Error saving onboarding: $e');
      return false;
    }
  }

  /// Reset onboarding state
  void reset() {
    state = const OnboardingData();
  }
}

/// Provider for onboarding state
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingData>((ref) {
  return OnboardingNotifier();
});

/// Available training goals
const List<String> availableGoals = [
  'Build Muscle',
  'Build Strength',
  'Lose Fat',
  'Improve Mobility',
  'General Fitness',
  'Longevity',
  'Athletic Performance',
  'Rehab',
  'Core Strength',
  'Functional Movement',
];

/// Available exercise types
const List<String> availableExerciseTypes = [
  'Barbell Training',
  'Strength Training',
  'Functional Training',
  'HIIT',
  'Bodyweight',
  'Circuit Training',
  'Kettlebell',
  'Core Training',
  'Muscular Strength',
  'Mobility Work',
];

/// Available injury areas
const List<String> availableInjuryAreas = [
  'Lower Back',
  'Shoulders',
  'Knees',
  'Hips',
  'Wrists/Elbows',
  'Neck',
  'Ankles',
  'None',
];

/// Days of the week
const List<Map<String, String>> weekDays = [
  {'key': 'mon', 'label': 'M'},
  {'key': 'tue', 'label': 'T'},
  {'key': 'wed', 'label': 'W'},
  {'key': 'thu', 'label': 'T'},
  {'key': 'fri', 'label': 'F'},
  {'key': 'sat', 'label': 'S'},
  {'key': 'sun', 'label': 'S'},
];

