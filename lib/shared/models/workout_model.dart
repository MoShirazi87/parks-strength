import 'package:equatable/equatable.dart';
import 'exercise_model.dart';

/// Workout model representing a single workout session
class WorkoutModel extends Equatable {
  final String id;
  final String? programId;
  final String? weekId;
  final String name;
  final String? description;
  final String? dayOfWeek;
  final int? dayNumber;
  final int estimatedDurationMinutes;
  final bool isIntro;
  final String? coachNotes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<WorkoutSection>? sections;

  const WorkoutModel({
    required this.id,
    this.programId,
    this.weekId,
    required this.name,
    this.description,
    this.dayOfWeek,
    this.dayNumber,
    this.estimatedDurationMinutes = 45,
    this.isIntro = false,
    this.coachNotes,
    required this.createdAt,
    this.updatedAt,
    this.sections,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    // Handle both 'workout_sections' (from Supabase) and 'sections' (direct)
    final sectionsData = json['workout_sections'] as List<dynamic>? ?? 
                         json['sections'] as List<dynamic>?;
    
    return WorkoutModel(
      id: json['id'] as String,
      programId: json['program_id'] as String?,
      weekId: json['week_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      dayOfWeek: json['day_of_week'] as String?,
      dayNumber: json['day_number'] as int?,
      estimatedDurationMinutes:
          json['estimated_duration_minutes'] as int? ?? 45,
      isIntro: json['is_intro'] as bool? ?? false,
      coachNotes: json['coach_notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      sections: sectionsData
          ?.map((s) => WorkoutSection.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'program_id': programId,
      'week_id': weekId,
      'name': name,
      'description': description,
      'day_of_week': dayOfWeek,
      'day_number': dayNumber,
      'estimated_duration_minutes': estimatedDurationMinutes,
      'is_intro': isIntro,
      'coach_notes': coachNotes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Get all exercises in the workout
  List<WorkoutExercise> get allExercises {
    if (sections == null) return [];
    return sections!.expand((s) => s.exercises ?? <WorkoutExercise>[]).toList();
  }

  /// Get total sets in workout
  int get totalSets {
    return allExercises.fold(0, (sum, e) => sum + (e.sets ?? 0));
  }

  /// Get training section
  WorkoutSection? get trainingSection {
    return sections?.firstWhere(
      (s) => s.sectionType == 'training',
      orElse: () => sections!.first,
    );
  }

  /// Get warmup section
  WorkoutSection? get warmupSection {
    return sections?.firstWhere(
      (s) => s.sectionType == 'warmup',
      orElse: () => const WorkoutSection(
        id: '',
        workoutId: '',
        name: '',
        sectionType: 'warmup',
        orderIndex: 0,
      ),
    );
  }

  /// Get stretching section
  WorkoutSection? get stretchingSection {
    return sections?.firstWhere(
      (s) => s.sectionType == 'stretching',
      orElse: () => const WorkoutSection(
        id: '',
        workoutId: '',
        name: '',
        sectionType: 'stretching',
        orderIndex: 0,
      ),
    );
  }

  WorkoutModel copyWith({
    String? id,
    String? programId,
    String? weekId,
    String? name,
    String? description,
    String? dayOfWeek,
    int? dayNumber,
    int? estimatedDurationMinutes,
    bool? isIntro,
    String? coachNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<WorkoutSection>? sections,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      programId: programId ?? this.programId,
      weekId: weekId ?? this.weekId,
      name: name ?? this.name,
      description: description ?? this.description,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      dayNumber: dayNumber ?? this.dayNumber,
      estimatedDurationMinutes:
          estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      isIntro: isIntro ?? this.isIntro,
      coachNotes: coachNotes ?? this.coachNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sections: sections ?? this.sections,
    );
  }

  @override
  List<Object?> get props => [
        id,
        programId,
        weekId,
        name,
        description,
        dayOfWeek,
        dayNumber,
        estimatedDurationMinutes,
        isIntro,
        coachNotes,
        createdAt,
        updatedAt,
      ];
}

/// Workout section (Training, Warmup, Stretching)
class WorkoutSection extends Equatable {
  final String id;
  final String workoutId;
  final String name;
  final String sectionType;
  final int orderIndex;
  final bool isCollapsedByDefault;
  final List<WorkoutExercise>? exercises;

  const WorkoutSection({
    required this.id,
    required this.workoutId,
    required this.name,
    required this.sectionType,
    required this.orderIndex,
    this.isCollapsedByDefault = false,
    this.exercises,
  });

  factory WorkoutSection.fromJson(Map<String, dynamic> json) {
    // Handle both 'workout_exercises' (from Supabase) and 'exercises' (direct)
    final exercisesData = json['workout_exercises'] as List<dynamic>? ?? 
                          json['exercises'] as List<dynamic>?;
    
    return WorkoutSection(
      id: json['id'] as String,
      workoutId: json['workout_id'] as String,
      name: json['name'] as String,
      sectionType: json['section_type'] as String,
      orderIndex: json['order_index'] as int,
      isCollapsedByDefault: json['is_collapsed_by_default'] as bool? ?? false,
      exercises: exercisesData
          ?.map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workout_id': workoutId,
      'name': name,
      'section_type': sectionType,
      'order_index': orderIndex,
      'is_collapsed_by_default': isCollapsedByDefault,
    };
  }

  @override
  List<Object?> get props => [
        id,
        workoutId,
        name,
        sectionType,
        orderIndex,
        isCollapsedByDefault,
      ];
}

/// Exercise within a workout
class WorkoutExercise extends Equatable {
  final String id;
  final String workoutId;
  final String sectionId;
  final String exerciseId;
  final int orderIndex;
  final String? letterDesignation;
  final int? sets;
  final int? reps;
  final int? timeSeconds;
  final bool isPerSide;
  final int? restSeconds;
  final String? notes;
  final double? weightSuggestion;
  final ExerciseModel? exercise;

  const WorkoutExercise({
    required this.id,
    required this.workoutId,
    required this.sectionId,
    required this.exerciseId,
    required this.orderIndex,
    this.letterDesignation,
    this.sets,
    this.reps,
    this.timeSeconds,
    this.isPerSide = false,
    this.restSeconds,
    this.notes,
    this.weightSuggestion,
    this.exercise,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      id: json['id'] as String,
      workoutId: json['workout_id'] as String,
      sectionId: json['section_id'] as String,
      exerciseId: json['exercise_id'] as String,
      orderIndex: json['order_index'] as int,
      letterDesignation: json['letter_designation'] as String?,
      sets: json['sets'] as int?,
      reps: json['reps'] as int?,
      timeSeconds: json['time_seconds'] as int?,
      isPerSide: json['is_per_side'] as bool? ?? false,
      restSeconds: json['rest_seconds'] as int?,
      notes: json['notes'] as String?,
      weightSuggestion: (json['weight_suggestion'] as num?)?.toDouble(),
      exercise: json['exercise'] != null
          ? ExerciseModel.fromJson(json['exercise'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workout_id': workoutId,
      'section_id': sectionId,
      'exercise_id': exerciseId,
      'order_index': orderIndex,
      'letter_designation': letterDesignation,
      'sets': sets,
      'reps': reps,
      'time_seconds': timeSeconds,
      'is_per_side': isPerSide,
      'rest_seconds': restSeconds,
      'notes': notes,
      'weight_suggestion': weightSuggestion,
    };
  }

  /// Check if this is a time-based exercise
  bool get isTimeBased => timeSeconds != null && timeSeconds! > 0;

  /// Check if this is a rep-based exercise
  bool get isRepBased => reps != null && reps! > 0;

  /// Get display text for sets/reps
  String get setsRepsDisplay {
    if (sets != null && reps != null) {
      return '${sets}x$reps';
    } else if (sets != null && timeSeconds != null) {
      return '${sets}x${timeSeconds}s';
    } else if (reps != null) {
      return '$reps reps';
    } else if (timeSeconds != null) {
      return '${timeSeconds}s';
    }
    return '';
  }

  @override
  List<Object?> get props => [
        id,
        workoutId,
        sectionId,
        exerciseId,
        orderIndex,
        letterDesignation,
        sets,
        reps,
        timeSeconds,
        isPerSide,
        restSeconds,
        notes,
        weightSuggestion,
      ];
}

