import 'package:equatable/equatable.dart';
import 'workout_model.dart';

/// Program model representing training programs
class ProgramModel extends Equatable {
  final String id;
  final String name;
  final String? slug;
  final String? description;
  final String? shortDescription;
  final String? thumbnailUrl;
  final String? heroImageUrl;
  final String? accentColor;
  final int durationWeeks;
  final int daysPerWeek;
  final String difficulty;
  final List<String> focusAreas;
  final List<String> equipmentRequired;
  final List<String> goals;
  final bool isPublished;
  final bool isPremium;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<ProgramWeek>? weeks;

  const ProgramModel({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.shortDescription,
    this.thumbnailUrl,
    this.heroImageUrl,
    this.accentColor,
    this.durationWeeks = 8,
    this.daysPerWeek = 4,
    this.difficulty = 'intermediate',
    this.focusAreas = const [],
    this.equipmentRequired = const [],
    this.goals = const [],
    this.isPublished = false,
    this.isPremium = false,
    this.displayOrder = 0,
    required this.createdAt,
    this.updatedAt,
    this.weeks,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      shortDescription: json['short_description'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      heroImageUrl: json['hero_image_url'] as String?,
      accentColor: json['accent_color'] as String?,
      durationWeeks: json['duration_weeks'] as int? ?? 8,
      daysPerWeek: json['days_per_week'] as int? ?? 4,
      difficulty: json['difficulty'] as String? ?? 'intermediate',
      focusAreas:
          (json['focus_areas'] as List<dynamic>?)?.cast<String>() ?? [],
      equipmentRequired:
          (json['equipment_required'] as List<dynamic>?)?.cast<String>() ?? [],
      goals: (json['goals'] as List<dynamic>?)?.cast<String>() ?? [],
      isPublished: json['is_published'] as bool? ?? false,
      isPremium: json['is_premium'] as bool? ?? false,
      displayOrder: json['display_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      weeks: (json['weeks'] as List<dynamic>?)
          ?.map((w) => ProgramWeek.fromJson(w as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'short_description': shortDescription,
      'thumbnail_url': thumbnailUrl,
      'hero_image_url': heroImageUrl,
      'accent_color': accentColor,
      'duration_weeks': durationWeeks,
      'days_per_week': daysPerWeek,
      'difficulty': difficulty,
      'focus_areas': focusAreas,
      'equipment_required': equipmentRequired,
      'goals': goals,
      'is_published': isPublished,
      'is_premium': isPremium,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Get estimated workout duration in minutes
  int get estimatedWorkoutMinutes {
    // Default estimate: 45-60 min
    return 50;
  }

  /// Get difficulty display text
  String get difficultyDisplay {
    return difficulty.substring(0, 1).toUpperCase() + difficulty.substring(1);
  }

  ProgramModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? shortDescription,
    String? thumbnailUrl,
    String? heroImageUrl,
    String? accentColor,
    int? durationWeeks,
    int? daysPerWeek,
    String? difficulty,
    List<String>? focusAreas,
    List<String>? equipmentRequired,
    List<String>? goals,
    bool? isPublished,
    bool? isPremium,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ProgramWeek>? weeks,
  }) {
    return ProgramModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      heroImageUrl: heroImageUrl ?? this.heroImageUrl,
      accentColor: accentColor ?? this.accentColor,
      durationWeeks: durationWeeks ?? this.durationWeeks,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      difficulty: difficulty ?? this.difficulty,
      focusAreas: focusAreas ?? this.focusAreas,
      equipmentRequired: equipmentRequired ?? this.equipmentRequired,
      goals: goals ?? this.goals,
      isPublished: isPublished ?? this.isPublished,
      isPremium: isPremium ?? this.isPremium,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      weeks: weeks ?? this.weeks,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        description,
        shortDescription,
        thumbnailUrl,
        heroImageUrl,
        accentColor,
        durationWeeks,
        daysPerWeek,
        difficulty,
        focusAreas,
        equipmentRequired,
        goals,
        isPublished,
        isPremium,
        displayOrder,
        createdAt,
        updatedAt,
      ];
}

/// Program week model
class ProgramWeek extends Equatable {
  final String id;
  final String programId;
  final int weekNumber;
  final String? name;
  final String? description;
  final bool isDeload;
  final List<WorkoutModel>? workouts;

  const ProgramWeek({
    required this.id,
    required this.programId,
    required this.weekNumber,
    this.name,
    this.description,
    this.isDeload = false,
    this.workouts,
  });

  factory ProgramWeek.fromJson(Map<String, dynamic> json) {
    return ProgramWeek(
      id: json['id'] as String,
      programId: json['program_id'] as String,
      weekNumber: json['week_number'] as int,
      name: json['name'] as String?,
      description: json['description'] as String?,
      isDeload: json['is_deload'] as bool? ?? false,
      workouts: (json['workouts'] as List<dynamic>?)
          ?.map((w) => WorkoutModel.fromJson(w as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'program_id': programId,
      'week_number': weekNumber,
      'name': name,
      'description': description,
      'is_deload': isDeload,
    };
  }

  @override
  List<Object?> get props => [
        id,
        programId,
        weekNumber,
        name,
        description,
        isDeload,
      ];
}

