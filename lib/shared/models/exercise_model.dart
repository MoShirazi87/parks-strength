import 'package:equatable/equatable.dart';

/// Exercise model for the exercise library
/// Supports comprehensive filtering and multi-source media
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
  
  // Classification
  final String? difficulty;
  final int? difficultyScore;
  final String? movementPattern;
  final String? exerciseType;
  final String? mechanicsType; // 'compound' or 'isolation'
  final String? forceType; // 'push', 'pull', 'static'
  final String? bodyPart;
  final String? targetMuscle;
  final String? equipment; // Simple equipment string from API
  final List<String> locationTags; // ['home', 'gym', 'outdoor', 'travel']
  
  // Media (multi-source)
  final String? videoUrl;
  final String? videoUrlAlt;
  final String? thumbnailUrl;
  final String? gifUrl; // ExerciseDB GIF
  final String? muscleWikiGif; // MuscleWiki GIF
  final String? wgerImageUrl; // Wger static image
  
  // Metadata
  final bool isBilateral;
  final bool isPublished;
  final bool requiresSpotter;
  final bool requiresRack;
  final DateTime createdAt;
  
  // Progression
  final String? progressionFrom;
  final String? progressionTo;

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
    this.difficultyScore,
    this.movementPattern,
    this.exerciseType,
    this.mechanicsType,
    this.forceType,
    this.bodyPart,
    this.targetMuscle,
    this.equipment,
    this.locationTags = const [],
    this.videoUrl,
    this.videoUrlAlt,
    this.thumbnailUrl,
    this.gifUrl,
    this.muscleWikiGif,
    this.wgerImageUrl,
    this.isBilateral = true,
    this.isPublished = true,
    this.requiresSpotter = false,
    this.requiresRack = false,
    required this.createdAt,
    this.progressionFrom,
    this.progressionTo,
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
          (json['primary_muscles'] as List<dynamic>?)?.cast<String>() ?? 
          (json['muscle_tags'] as List<dynamic>?)?.cast<String>() ?? [],
      secondaryMuscles:
          (json['secondary_muscles'] as List<dynamic>?)?.cast<String>() ?? [],
      equipmentRequired:
          (json['equipment_required'] as List<dynamic>?)?.cast<String>() ?? 
          (json['equipment_tags'] as List<dynamic>?)?.cast<String>() ?? [],
      difficulty: json['difficulty'] as String?,
      difficultyScore: json['difficulty_score'] as int?,
      movementPattern: json['movement_pattern'] as String?,
      exerciseType: json['exercise_type'] as String?,
      mechanicsType: json['mechanics_type'] as String?,
      forceType: json['force_type'] as String?,
      bodyPart: json['body_part'] as String?,
      targetMuscle: json['target_muscle'] as String?,
      equipment: json['equipment'] as String?,
      locationTags: (json['location_tags'] as List<dynamic>?)?.cast<String>() ?? [],
      videoUrl: json['video_url'] as String?,
      videoUrlAlt: json['video_url_alt'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      gifUrl: json['gif_url'] as String?,
      muscleWikiGif: json['musclewiki_gif'] as String?,
      wgerImageUrl: json['wger_image'] as String?,
      isBilateral: json['is_bilateral'] as bool? ?? true,
      isPublished: json['is_published'] as bool? ?? true,
      requiresSpotter: json['requires_spotter'] as bool? ?? false,
      requiresRack: json['requires_rack'] as bool? ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      progressionFrom: json['progression_from'] as String?,
      progressionTo: json['progression_to'] as String?,
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
      'difficulty_score': difficultyScore,
      'movement_pattern': movementPattern,
      'exercise_type': exerciseType,
      'mechanics_type': mechanicsType,
      'force_type': forceType,
      'body_part': bodyPart,
      'target_muscle': targetMuscle,
      'equipment': equipment,
      'location_tags': locationTags,
      'video_url': videoUrl,
      'video_url_alt': videoUrlAlt,
      'thumbnail_url': thumbnailUrl,
      'gif_url': gifUrl,
      'musclewiki_gif': muscleWikiGif,
      'wger_image': wgerImageUrl,
      'is_bilateral': isBilateral,
      'is_published': isPublished,
      'requires_spotter': requiresSpotter,
      'requires_rack': requiresRack,
      'created_at': createdAt.toIso8601String(),
      'progression_from': progressionFrom,
      'progression_to': progressionTo,
    };
  }

  /// Get primary muscle display text
  String get primaryMuscleDisplay {
    if (targetMuscle != null && targetMuscle!.isNotEmpty) {
      return _formatMuscle(targetMuscle!);
    }
    if (primaryMuscles.isEmpty) return 'Full Body';
    return primaryMuscles.take(2).map(_formatMuscle).join(', ');
  }

  String _formatMuscle(String muscle) {
    return muscle
        .split('_')
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '')
        .join(' ');
  }

  /// Get equipment display text
  String get equipmentDisplay {
    if (equipment != null && equipment!.isNotEmpty) {
      return _formatMuscle(equipment!);
    }
    if (equipmentRequired.isEmpty) return 'Bodyweight';
    return equipmentRequired.map(_formatMuscle).join(', ');
  }

  /// Get the best available GIF URL
  String? get bestGifUrl {
    // Priority: MuscleWiki > ExerciseDB > video thumbnail
    if (muscleWikiGif != null && muscleWikiGif!.isNotEmpty) {
      return muscleWikiGif;
    }
    if (gifUrl != null && gifUrl!.isNotEmpty) {
      return gifUrl;
    }
    if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty) {
      return thumbnailUrl;
    }
    return null;
  }

  /// Get the best available video URL
  String? get bestVideoUrl {
    if (videoUrl != null && videoUrl!.isNotEmpty) {
      return videoUrl;
    }
    if (videoUrlAlt != null && videoUrlAlt!.isNotEmpty) {
      return videoUrlAlt;
    }
    return null;
  }

  /// Get the best available image URL
  String? get bestImageUrl {
    if (wgerImageUrl != null && wgerImageUrl!.isNotEmpty) {
      return wgerImageUrl;
    }
    if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty) {
      return thumbnailUrl;
    }
    return bestGifUrl;
  }

  /// Check if exercise is suitable for home workout
  bool get isSuitableForHome {
    return locationTags.contains('home') || 
           equipment == 'body weight' ||
           equipment == 'bodyweight' ||
           equipmentRequired.isEmpty;
  }

  /// Check if exercise is a compound movement
  bool get isCompound => mechanicsType == 'compound';

  /// Check if exercise is an isolation movement
  bool get isIsolation => mechanicsType == 'isolation';

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
    int? difficultyScore,
    String? movementPattern,
    String? exerciseType,
    String? mechanicsType,
    String? forceType,
    String? bodyPart,
    String? targetMuscle,
    String? equipment,
    List<String>? locationTags,
    String? videoUrl,
    String? videoUrlAlt,
    String? thumbnailUrl,
    String? gifUrl,
    String? muscleWikiGif,
    String? wgerImageUrl,
    bool? isBilateral,
    bool? isPublished,
    bool? requiresSpotter,
    bool? requiresRack,
    DateTime? createdAt,
    String? progressionFrom,
    String? progressionTo,
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
      difficultyScore: difficultyScore ?? this.difficultyScore,
      movementPattern: movementPattern ?? this.movementPattern,
      exerciseType: exerciseType ?? this.exerciseType,
      mechanicsType: mechanicsType ?? this.mechanicsType,
      forceType: forceType ?? this.forceType,
      bodyPart: bodyPart ?? this.bodyPart,
      targetMuscle: targetMuscle ?? this.targetMuscle,
      equipment: equipment ?? this.equipment,
      locationTags: locationTags ?? this.locationTags,
      videoUrl: videoUrl ?? this.videoUrl,
      videoUrlAlt: videoUrlAlt ?? this.videoUrlAlt,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      gifUrl: gifUrl ?? this.gifUrl,
      muscleWikiGif: muscleWikiGif ?? this.muscleWikiGif,
      wgerImageUrl: wgerImageUrl ?? this.wgerImageUrl,
      isBilateral: isBilateral ?? this.isBilateral,
      isPublished: isPublished ?? this.isPublished,
      requiresSpotter: requiresSpotter ?? this.requiresSpotter,
      requiresRack: requiresRack ?? this.requiresRack,
      createdAt: createdAt ?? this.createdAt,
      progressionFrom: progressionFrom ?? this.progressionFrom,
      progressionTo: progressionTo ?? this.progressionTo,
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
        difficultyScore,
        movementPattern,
        exerciseType,
        mechanicsType,
        forceType,
        bodyPart,
        targetMuscle,
        equipment,
        locationTags,
        videoUrl,
        videoUrlAlt,
        thumbnailUrl,
        gifUrl,
        muscleWikiGif,
        wgerImageUrl,
        isBilateral,
        isPublished,
        requiresSpotter,
        requiresRack,
        createdAt,
        progressionFrom,
        progressionTo,
      ];
}
