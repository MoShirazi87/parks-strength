import 'package:equatable/equatable.dart';

/// Exercise model for the exercise library
class ExerciseModel extends Equatable {
  final String id;
  final String name;
  final String? slug;
  final String? description;
  final List<String> instructions;
  final List<String> cues;
  final List<String> commonMistakes;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final List<String> equipmentRequired;
  final String? difficulty;
  final String? movementPattern;
  final String? exerciseType;
  final String? videoUrl;
  final String? videoUrlAlt;
  final String? thumbnailUrl;
  final bool isBilateral;
  final bool isPublished;
  final DateTime createdAt;

  const ExerciseModel({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.instructions = const [],
    this.cues = const [],
    this.commonMistakes = const [],
    this.primaryMuscles = const [],
    this.secondaryMuscles = const [],
    this.equipmentRequired = const [],
    this.difficulty,
    this.movementPattern,
    this.exerciseType,
    this.videoUrl,
    this.videoUrlAlt,
    this.thumbnailUrl,
    this.isBilateral = true,
    this.isPublished = true,
    required this.createdAt,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      instructions:
          (json['instructions'] as List<dynamic>?)?.cast<String>() ?? [],
      cues: (json['cues'] as List<dynamic>?)?.cast<String>() ?? [],
      commonMistakes:
          (json['common_mistakes'] as List<dynamic>?)?.cast<String>() ?? [],
      primaryMuscles:
          (json['primary_muscles'] as List<dynamic>?)?.cast<String>() ?? [],
      secondaryMuscles:
          (json['secondary_muscles'] as List<dynamic>?)?.cast<String>() ?? [],
      equipmentRequired:
          (json['equipment_required'] as List<dynamic>?)?.cast<String>() ?? [],
      difficulty: json['difficulty'] as String?,
      movementPattern: json['movement_pattern'] as String?,
      exerciseType: json['exercise_type'] as String?,
      videoUrl: json['video_url'] as String?,
      videoUrlAlt: json['video_url_alt'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      isBilateral: json['is_bilateral'] as bool? ?? true,
      isPublished: json['is_published'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'instructions': instructions,
      'cues': cues,
      'common_mistakes': commonMistakes,
      'primary_muscles': primaryMuscles,
      'secondary_muscles': secondaryMuscles,
      'equipment_required': equipmentRequired,
      'difficulty': difficulty,
      'movement_pattern': movementPattern,
      'exercise_type': exerciseType,
      'video_url': videoUrl,
      'video_url_alt': videoUrlAlt,
      'thumbnail_url': thumbnailUrl,
      'is_bilateral': isBilateral,
      'is_published': isPublished,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Get primary muscle display text
  String get primaryMuscleDisplay {
    if (primaryMuscles.isEmpty) return 'Full Body';
    return primaryMuscles.take(2).map(_formatMuscle).join(', ');
  }

  String _formatMuscle(String muscle) {
    return muscle
        .split('_')
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  /// Get equipment display text
  String get equipmentDisplay {
    if (equipmentRequired.isEmpty) return 'Bodyweight';
    return equipmentRequired.join(', ');
  }

  ExerciseModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    List<String>? instructions,
    List<String>? cues,
    List<String>? commonMistakes,
    List<String>? primaryMuscles,
    List<String>? secondaryMuscles,
    List<String>? equipmentRequired,
    String? difficulty,
    String? movementPattern,
    String? exerciseType,
    String? videoUrl,
    String? videoUrlAlt,
    String? thumbnailUrl,
    bool? isBilateral,
    bool? isPublished,
    DateTime? createdAt,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      cues: cues ?? this.cues,
      commonMistakes: commonMistakes ?? this.commonMistakes,
      primaryMuscles: primaryMuscles ?? this.primaryMuscles,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      equipmentRequired: equipmentRequired ?? this.equipmentRequired,
      difficulty: difficulty ?? this.difficulty,
      movementPattern: movementPattern ?? this.movementPattern,
      exerciseType: exerciseType ?? this.exerciseType,
      videoUrl: videoUrl ?? this.videoUrl,
      videoUrlAlt: videoUrlAlt ?? this.videoUrlAlt,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isBilateral: isBilateral ?? this.isBilateral,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        description,
        instructions,
        cues,
        commonMistakes,
        primaryMuscles,
        secondaryMuscles,
        equipmentRequired,
        difficulty,
        movementPattern,
        exerciseType,
        videoUrl,
        videoUrlAlt,
        thumbnailUrl,
        isBilateral,
        isPublished,
        createdAt,
      ];
}

