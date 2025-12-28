import 'package:equatable/equatable.dart';

/// Workout log model for tracking completed workouts
class WorkoutLogModel extends Equatable {
  final String id;
  final String userId;
  final String? workoutId;
  final String? enrollmentId;
  final String? customWorkoutName;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int? durationSeconds;
  final double? totalVolume;
  final int? totalSets;
  final int? totalReps;
  final int? rating;
  final String? notes;
  final int pointsEarned;
  final DateTime createdAt;
  final List<ExerciseLogModel>? exerciseLogs;

  const WorkoutLogModel({
    required this.id,
    required this.userId,
    this.workoutId,
    this.enrollmentId,
    this.customWorkoutName,
    this.startedAt,
    this.completedAt,
    this.durationSeconds,
    this.totalVolume,
    this.totalSets,
    this.totalReps,
    this.rating,
    this.notes,
    this.pointsEarned = 0,
    required this.createdAt,
    this.exerciseLogs,
  });

  factory WorkoutLogModel.fromJson(Map<String, dynamic> json) {
    return WorkoutLogModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      workoutId: json['workout_id'] as String?,
      enrollmentId: json['enrollment_id'] as String?,
      customWorkoutName: json['custom_workout_name'] as String?,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      durationSeconds: json['duration_seconds'] as int?,
      totalVolume: (json['total_volume'] as num?)?.toDouble(),
      totalSets: json['total_sets'] as int?,
      totalReps: json['total_reps'] as int?,
      rating: json['rating'] as int?,
      notes: json['notes'] as String?,
      pointsEarned: json['points_earned'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      exerciseLogs: (json['exercise_logs'] as List<dynamic>?)
          ?.map((e) => ExerciseLogModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'workout_id': workoutId,
      'enrollment_id': enrollmentId,
      'custom_workout_name': customWorkoutName,
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'duration_seconds': durationSeconds,
      'total_volume': totalVolume,
      'total_sets': totalSets,
      'total_reps': totalReps,
      'rating': rating,
      'notes': notes,
      'points_earned': pointsEarned,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Get duration as Duration object
  Duration get duration =>
      Duration(seconds: durationSeconds ?? 0);

  /// Get formatted duration
  String get durationFormatted {
    final d = duration;
    if (d.inHours > 0) {
      return '${d.inHours}h ${d.inMinutes % 60}m';
    }
    return '${d.inMinutes}m';
  }

  WorkoutLogModel copyWith({
    String? id,
    String? userId,
    String? workoutId,
    String? enrollmentId,
    String? customWorkoutName,
    DateTime? startedAt,
    DateTime? completedAt,
    int? durationSeconds,
    double? totalVolume,
    int? totalSets,
    int? totalReps,
    int? rating,
    String? notes,
    int? pointsEarned,
    DateTime? createdAt,
    List<ExerciseLogModel>? exerciseLogs,
  }) {
    return WorkoutLogModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      workoutId: workoutId ?? this.workoutId,
      enrollmentId: enrollmentId ?? this.enrollmentId,
      customWorkoutName: customWorkoutName ?? this.customWorkoutName,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      totalVolume: totalVolume ?? this.totalVolume,
      totalSets: totalSets ?? this.totalSets,
      totalReps: totalReps ?? this.totalReps,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      createdAt: createdAt ?? this.createdAt,
      exerciseLogs: exerciseLogs ?? this.exerciseLogs,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        workoutId,
        enrollmentId,
        customWorkoutName,
        startedAt,
        completedAt,
        durationSeconds,
        totalVolume,
        totalSets,
        totalReps,
        rating,
        notes,
        pointsEarned,
        createdAt,
      ];
}

/// Exercise log within a workout
class ExerciseLogModel extends Equatable {
  final String id;
  final String workoutLogId;
  final String exerciseId;
  final int orderCompleted;
  final List<SetLogModel>? setLogs;

  const ExerciseLogModel({
    required this.id,
    required this.workoutLogId,
    required this.exerciseId,
    required this.orderCompleted,
    this.setLogs,
  });

  factory ExerciseLogModel.fromJson(Map<String, dynamic> json) {
    return ExerciseLogModel(
      id: json['id'] as String,
      workoutLogId: json['workout_log_id'] as String,
      exerciseId: json['exercise_id'] as String,
      orderCompleted: json['order_completed'] as int,
      setLogs: (json['set_logs'] as List<dynamic>?)
          ?.map((s) => SetLogModel.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workout_log_id': workoutLogId,
      'exercise_id': exerciseId,
      'order_completed': orderCompleted,
    };
  }

  /// Get total volume for this exercise
  double get volume {
    if (setLogs == null) return 0;
    return setLogs!.fold(
        0, (sum, set) => sum + (set.weight ?? 0) * (set.repsCompleted ?? 0));
  }

  @override
  List<Object?> get props => [
        id,
        workoutLogId,
        exerciseId,
        orderCompleted,
      ];
}

/// Set log within an exercise
class SetLogModel extends Equatable {
  final String id;
  final String exerciseLogId;
  final int setNumber;
  final int? repsCompleted;
  final double? weight;
  final String weightUnit;
  final int? timeSeconds;
  final int? rpe;
  final bool isWarmupSet;
  final bool isPr;
  final String? notes;
  final DateTime completedAt;

  const SetLogModel({
    required this.id,
    required this.exerciseLogId,
    required this.setNumber,
    this.repsCompleted,
    this.weight,
    this.weightUnit = 'lbs',
    this.timeSeconds,
    this.rpe,
    this.isWarmupSet = false,
    this.isPr = false,
    this.notes,
    required this.completedAt,
  });

  factory SetLogModel.fromJson(Map<String, dynamic> json) {
    return SetLogModel(
      id: json['id'] as String,
      exerciseLogId: json['exercise_log_id'] as String,
      setNumber: json['set_number'] as int,
      repsCompleted: json['reps_completed'] as int?,
      weight: (json['weight'] as num?)?.toDouble(),
      weightUnit: json['weight_unit'] as String? ?? 'lbs',
      timeSeconds: json['time_seconds'] as int?,
      rpe: json['rpe'] as int?,
      isWarmupSet: json['is_warmup_set'] as bool? ?? false,
      isPr: json['is_pr'] as bool? ?? false,
      notes: json['notes'] as String?,
      completedAt: DateTime.parse(json['completed_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercise_log_id': exerciseLogId,
      'set_number': setNumber,
      'reps_completed': repsCompleted,
      'weight': weight,
      'weight_unit': weightUnit,
      'time_seconds': timeSeconds,
      'rpe': rpe,
      'is_warmup_set': isWarmupSet,
      'is_pr': isPr,
      'notes': notes,
      'completed_at': completedAt.toIso8601String(),
    };
  }

  /// Get volume for this set
  double get volume => (weight ?? 0) * (repsCompleted ?? 0);

  /// Get display text
  String get displayText {
    if (weight != null && repsCompleted != null) {
      return '${weight!.toInt()} $weightUnit × $repsCompleted';
    } else if (repsCompleted != null) {
      return '$repsCompleted reps';
    } else if (timeSeconds != null) {
      return '${timeSeconds}s';
    }
    return '';
  }

  @override
  List<Object?> get props => [
        id,
        exerciseLogId,
        setNumber,
        repsCompleted,
        weight,
        weightUnit,
        timeSeconds,
        rpe,
        isWarmupSet,
        isPr,
        notes,
        completedAt,
      ];
}

