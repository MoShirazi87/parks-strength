import 'package:equatable/equatable.dart';

/// User model representing app users
class UserModel extends Equatable {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? displayName;
  final String? avatarUrl;
  final DateTime? dateOfBirth;
  final String? experienceLevel;
  final List<String> goals;
  final List<String> exercisePreferences;
  final List<String> injuries;
  final String? trainingLocation;
  final List<String> preferredDays;
  final String? preferredTime;
  final String? reminderTime;
  final String unitsPreference;
  final bool onboardingCompleted;
  final int points;
  final int streakCurrent;
  final int streakLongest;
  final DateTime? streakLastWorkout;
  final int streakFreezes;
  final int totalWorkouts;
  final double totalVolumeLifted;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastActiveAt;

  const UserModel({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.displayName,
    this.avatarUrl,
    this.dateOfBirth,
    this.experienceLevel,
    this.goals = const [],
    this.exercisePreferences = const [],
    this.injuries = const [],
    this.trainingLocation,
    this.preferredDays = const [],
    this.preferredTime,
    this.reminderTime,
    this.unitsPreference = 'imperial',
    this.onboardingCompleted = false,
    this.points = 0,
    this.streakCurrent = 0,
    this.streakLongest = 0,
    this.streakLastWorkout,
    this.streakFreezes = 0,
    this.totalWorkouts = 0,
    this.totalVolumeLifted = 0.0,
    required this.createdAt,
    this.updatedAt,
    this.lastActiveAt,
  });

  /// Create from Supabase JSON response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      experienceLevel: json['experience_level'] as String?,
      goals: (json['goals'] as List<dynamic>?)?.cast<String>() ?? [],
      exercisePreferences:
          (json['exercise_preferences'] as List<dynamic>?)?.cast<String>() ??
              [],
      injuries: (json['injuries'] as List<dynamic>?)?.cast<String>() ?? [],
      trainingLocation: json['training_location'] as String?,
      preferredDays:
          (json['preferred_days'] as List<dynamic>?)?.cast<String>() ?? [],
      preferredTime: json['preferred_time'] as String?,
      reminderTime: json['reminder_time'] as String?,
      unitsPreference: json['units_preference'] as String? ?? 'imperial',
      onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
      points: json['points'] as int? ?? 0,
      streakCurrent: json['current_streak'] as int? ?? json['streak_current'] as int? ?? 0,
      streakLongest: json['longest_streak'] as int? ?? json['streak_longest'] as int? ?? 0,
      streakLastWorkout: json['last_workout_date'] != null
          ? DateTime.tryParse(json['last_workout_date'] as String)
          : (json['streak_last_workout'] != null
              ? DateTime.tryParse(json['streak_last_workout'] as String)
              : null),
      streakFreezes: json['streak_freezes_available'] as int? ?? json['streak_freezes'] as int? ?? 2,
      totalWorkouts: json['total_workouts'] as int? ?? 0,
      totalVolumeLifted: (json['total_volume_lifted'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      lastActiveAt: json['last_active_at'] != null
          ? DateTime.parse(json['last_active_at'] as String)
          : null,
    );
  }

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'experience_level': experienceLevel,
      'goals': goals,
      'exercise_preferences': exercisePreferences,
      'injuries': injuries,
      'training_location': trainingLocation,
      'preferred_days': preferredDays,
      'preferred_time': preferredTime,
      'reminder_time': reminderTime,
      'units_preference': unitsPreference,
      'onboarding_completed': onboardingCompleted,
      'points': points,
      'streak_current': streakCurrent,
      'streak_longest': streakLongest,
      'streak_last_workout': streakLastWorkout?.toIso8601String(),
      'streak_freezes': streakFreezes,
      'total_workouts': totalWorkouts,
      'total_volume_lifted': totalVolumeLifted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_active_at': lastActiveAt?.toIso8601String(),
    };
  }

  /// Get full name
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return firstName ?? lastName ?? displayName ?? email.split('@').first;
  }

  /// Get initials
  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    }
    return email.substring(0, 2).toUpperCase();
  }

  /// Alias for streakCurrent for consistency
  int get currentStreak => streakCurrent;

  /// Copy with new values
  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? displayName,
    String? avatarUrl,
    DateTime? dateOfBirth,
    String? experienceLevel,
    List<String>? goals,
    List<String>? exercisePreferences,
    List<String>? injuries,
    String? trainingLocation,
    List<String>? preferredDays,
    String? preferredTime,
    String? reminderTime,
    String? unitsPreference,
    bool? onboardingCompleted,
    int? points,
    int? streakCurrent,
    int? streakLongest,
    DateTime? streakLastWorkout,
    int? streakFreezes,
    int? totalWorkouts,
    double? totalVolumeLifted,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActiveAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      goals: goals ?? this.goals,
      exercisePreferences: exercisePreferences ?? this.exercisePreferences,
      injuries: injuries ?? this.injuries,
      trainingLocation: trainingLocation ?? this.trainingLocation,
      preferredDays: preferredDays ?? this.preferredDays,
      preferredTime: preferredTime ?? this.preferredTime,
      reminderTime: reminderTime ?? this.reminderTime,
      unitsPreference: unitsPreference ?? this.unitsPreference,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      points: points ?? this.points,
      streakCurrent: streakCurrent ?? this.streakCurrent,
      streakLongest: streakLongest ?? this.streakLongest,
      streakLastWorkout: streakLastWorkout ?? this.streakLastWorkout,
      streakFreezes: streakFreezes ?? this.streakFreezes,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      totalVolumeLifted: totalVolumeLifted ?? this.totalVolumeLifted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        displayName,
        avatarUrl,
        dateOfBirth,
        experienceLevel,
        goals,
        exercisePreferences,
        injuries,
        trainingLocation,
        preferredDays,
        preferredTime,
        reminderTime,
        unitsPreference,
        onboardingCompleted,
        points,
        streakCurrent,
        streakLongest,
        streakLastWorkout,
        streakFreezes,
        totalWorkouts,
        totalVolumeLifted,
        createdAt,
        updatedAt,
        lastActiveAt,
      ];
}

