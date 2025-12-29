/// Exercise Enhancement Engine
///
/// Enhances raw exercise data with intelligent attributes based on
/// exercise properties, movement patterns, and fitness science principles.
library;

class ExerciseEnhancementEngine {
  /// Get maximum difficulty score for a given experience level
  static int getMaxDifficultyForLevel(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return 4;
      case 'intermediate':
        return 6;
      case 'advanced':
        return 10;
      default:
        return 6;
    }
  }

  /// Get minimum difficulty score for a given experience level
  static int getMinDifficultyForLevel(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return 1;
      case 'intermediate':
        return 3;
      case 'advanced':
        return 5;
      default:
        return 1;
    }
  }

  /// Determines the primary movement pattern based on body part and exercise name
  static String getMovementPattern(String? bodyPart, String? equipment, String name) {
    final nameLower = name.toLowerCase();
    final bodyPartLower = (bodyPart ?? '').toLowerCase();
    // Equipment may be used in future for pattern detection
    final _ = (equipment ?? '').toLowerCase();

    // Explicit pattern recognition from name
    if (nameLower.contains('squat') || nameLower.contains('leg press')) {
      return 'squat';
    }
    if (nameLower.contains('deadlift') || nameLower.contains('hip thrust') || 
        nameLower.contains('good morning') || nameLower.contains('swing')) {
      return 'hinge';
    }
    if (nameLower.contains('push up') || nameLower.contains('pushup') || 
        nameLower.contains('press') && !nameLower.contains('leg')) {
      if (nameLower.contains('incline') || nameLower.contains('overhead') || 
          nameLower.contains('shoulder') || nameLower.contains('military')) {
        return 'push_vertical';
      }
      return 'push_horizontal';
    }
    if (nameLower.contains('pull up') || nameLower.contains('pullup') || 
        nameLower.contains('chin up') || nameLower.contains('lat pull')) {
      return 'pull_vertical';
    }
    if (nameLower.contains('row') || nameLower.contains('face pull')) {
      return 'pull_horizontal';
    }
    if (nameLower.contains('carry') || nameLower.contains('walk') && nameLower.contains('farmer')) {
      return 'carry';
    }
    if (nameLower.contains('lunge') || nameLower.contains('step') || 
        nameLower.contains('sprint') || nameLower.contains('run')) {
      return 'lunge';
    }
    if (nameLower.contains('twist') || nameLower.contains('rotate') || 
        nameLower.contains('wood chop') || nameLower.contains('russian')) {
      return 'rotation';
    }
    if (nameLower.contains('plank') || nameLower.contains('crunch') || 
        nameLower.contains('sit up') || nameLower.contains('ab ') ||
        bodyPartLower.contains('waist') || bodyPartLower.contains('core')) {
      return 'core';
    }
    if (nameLower.contains('curl') || nameLower.contains('extension') ||
        nameLower.contains('raise') || nameLower.contains('fly')) {
      return 'isolation';
    }

    // Fallback based on body part
    if (bodyPartLower.contains('chest') || bodyPartLower.contains('triceps')) {
      return 'push_horizontal';
    }
    if (bodyPartLower.contains('back') || bodyPartLower.contains('biceps')) {
      return 'pull_horizontal';
    }
    if (bodyPartLower.contains('shoulder')) {
      return 'push_vertical';
    }
    if (bodyPartLower.contains('leg') || bodyPartLower.contains('glute')) {
      return nameLower.contains('curl') ? 'hinge' : 'squat';
    }

    return 'other';
  }

  /// Determines valid training locations based on equipment
  static List<String> getLocations(List<String>? equipmentRequired, String? equipment) {
    final eq = (equipment ?? '').toLowerCase();
    final eqList = (equipmentRequired ?? []).map((e) => e.toLowerCase()).toList();

    // Bodyweight exercises can be done anywhere
    if (eq.contains('body weight') || eq.contains('bodyweight') || eq == 'no equipment') {
      return ['home', 'gym', 'outdoor', 'travel'];
    }

    // Portable equipment
    final portableEquipment = [
      'dumbbell', 'kettlebell', 'resistance band', 'band',
      'jump rope', 'yoga mat', 'foam roller', 'ab wheel'
    ];
    
    if (portableEquipment.any((e) => eq.contains(e) || eqList.contains(e))) {
      return ['home', 'gym'];
    }

    // Outdoor-friendly
    if (eq.contains('pull up bar') || eq.contains('parallel bar') || eq.contains('dip')) {
      return ['home', 'gym', 'outdoor'];
    }

    // Gym-only equipment
    final gymOnlyEquipment = [
      'cable', 'machine', 'smith', 'leg press', 'hack squat',
      'lat pulldown', 'pec deck', 'preacher', 'ez bar'
    ];

    if (gymOnlyEquipment.any((e) => eq.contains(e) || eqList.contains(e))) {
      return ['gym'];
    }

    // Barbell can be home or gym
    if (eq.contains('barbell')) {
      return ['gym', 'home']; // Some people have home gyms
    }

    // Default to gym
    return ['gym'];
  }

  /// Determines difficulty level based on exercise properties
  static String getDifficulty(String name, String? equipment, String? mechanicsType) {
    final nameLower = name.toLowerCase();
    final equipmentLower = (equipment ?? '').toLowerCase();

    // Beginner indicators
    final beginnerIndicators = [
      'assisted', 'machine', 'seated', 'lying', 'wall', 'knee', 'modified'
    ];
    if (beginnerIndicators.any((i) => nameLower.contains(i))) {
      return 'beginner';
    }

    // Advanced indicators
    final advancedIndicators = [
      'weighted', 'one arm', 'one leg', 'single arm', 'single leg',
      'pistol', 'archer', 'deficit', 'pause', 'tempo', 'explosive',
      'plyo', 'plyometric', 'muscle up', 'handstand', 'dragon'
    ];
    if (advancedIndicators.any((i) => nameLower.contains(i))) {
      return 'advanced';
    }

    // Olympic lifts are advanced
    final olympicLifts = ['snatch', 'clean', 'jerk', 'power clean'];
    if (olympicLifts.any((l) => nameLower.contains(l))) {
      return 'advanced';
    }

    // Machine exercises tend to be easier
    if (equipmentLower.contains('machine') || equipmentLower.contains('cable')) {
      return 'beginner';
    }

    return 'intermediate';
  }

  /// Converts difficulty string to numeric score (1-10)
  static int getDifficultyScore(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return 3;
      case 'easy':
        return 2;
      case 'intermediate':
        return 5;
      case 'medium':
        return 5;
      case 'advanced':
        return 7;
      case 'hard':
        return 8;
      case 'expert':
        return 9;
      default:
        return 5;
    }
  }

  /// Determines force type (push, pull, static)
  static String getForceType(String? bodyPart, String name) {
    final bodyPartLower = (bodyPart ?? '').toLowerCase();
    final nameLower = name.toLowerCase();

    // Explicit push movements
    if (nameLower.contains('press') || nameLower.contains('push') || 
        nameLower.contains('dip') || nameLower.contains('extension')) {
      return 'push';
    }

    // Explicit pull movements
    if (nameLower.contains('pull') || nameLower.contains('row') || 
        nameLower.contains('curl') || nameLower.contains('deadlift')) {
      return 'pull';
    }

    // Static/isometric movements
    if (nameLower.contains('plank') || nameLower.contains('hold') || 
        nameLower.contains('hang') || nameLower.contains('l-sit')) {
      return 'static';
    }

    // Body part based
    if (bodyPartLower.contains('chest') || bodyPartLower.contains('shoulder') || 
        bodyPartLower.contains('triceps')) {
      return 'push';
    }
    if (bodyPartLower.contains('back') || bodyPartLower.contains('biceps')) {
      return 'pull';
    }

    return 'other';
  }

  /// Determines mechanics type (compound vs isolation)
  static String getMechanicsType(String name, String? equipment) {
    final nameLower = name.toLowerCase();
    final equipmentLower = (equipment ?? '').toLowerCase();

    // Major compound movements
    final compoundMovements = [
      'squat', 'deadlift', 'bench press', 'overhead press', 'row',
      'pull up', 'chin up', 'dip', 'push up', 'lunge', 'clean',
      'snatch', 'jerk', 'hip thrust', 'step up', 'farmer'
    ];
    if (compoundMovements.any((m) => nameLower.contains(m))) {
      return 'compound';
    }

    // Isolation movements
    final isolationMovements = [
      'curl', 'extension', 'fly', 'raise', 'shrug', 'calf raise',
      'leg curl', 'leg extension', 'kickback', 'crossover', 'pullover'
    ];
    if (isolationMovements.any((m) => nameLower.contains(m))) {
      return 'isolation';
    }

    // Machine exercises tend to be isolation
    if (equipmentLower.contains('machine') && !nameLower.contains('press')) {
      return 'isolation';
    }

    return 'compound'; // Default to compound
  }

  /// Check if exercise requires a spotter
  static bool requiresSpotter(String name, String? equipment) {
    final nameLower = name.toLowerCase();
    final equipmentLower = (equipment ?? '').toLowerCase();

    final spotterExercises = [
      'bench press', 'skull crusher', 'barbell squat'
    ];
    
    if (spotterExercises.any((e) => nameLower.contains(e))) {
      return true;
    }

    // Heavy barbell work generally benefits from spotter
    if (equipmentLower == 'barbell' && 
        (nameLower.contains('press') || nameLower.contains('squat'))) {
      return true;
    }

    return false;
  }

  /// Check if exercise requires a rack/station
  static bool requiresRack(String name, String? equipment) {
    final nameLower = name.toLowerCase();
    final equipmentLower = (equipment ?? '').toLowerCase();

    final rackExercises = [
      'barbell squat', 'barbell bench press', 'rack pull',
      'barbell overhead press', 'front squat'
    ];
    
    return rackExercises.any((e) => nameLower.contains(e)) ||
           (equipmentLower == 'barbell' && nameLower.contains('squat'));
  }

  /// Get target rep range based on exercise type
  static String getTargetRepRange(String mechanicsType, String difficulty) {
    if (mechanicsType == 'compound') {
      switch (difficulty) {
        case 'beginner':
          return '8-12';
        case 'intermediate':
          return '6-10';
        case 'advanced':
          return '3-6';
        default:
          return '6-10';
      }
    } else {
      // Isolation exercises
      switch (difficulty) {
        case 'beginner':
          return '12-15';
        case 'intermediate':
          return '10-12';
        case 'advanced':
          return '8-12';
        default:
          return '10-12';
      }
    }
  }

  /// Get recommended rest time in seconds
  static int getRecommendedRest(String mechanicsType, String difficulty) {
    if (mechanicsType == 'compound') {
      switch (difficulty) {
        case 'beginner':
          return 90;
        case 'intermediate':
          return 120;
        case 'advanced':
          return 180;
        default:
          return 120;
      }
    } else {
      switch (difficulty) {
        case 'beginner':
          return 60;
        case 'intermediate':
          return 60;
        case 'advanced':
          return 90;
        default:
          return 60;
      }
    }
  }

  /// Get exercise category for grouping
  static String getCategory(String? bodyPart, String movementPattern) {
    if (movementPattern == 'push_horizontal' || movementPattern == 'push_vertical') {
      return 'push';
    }
    if (movementPattern == 'pull_horizontal' || movementPattern == 'pull_vertical') {
      return 'pull';
    }
    if (movementPattern == 'squat' || movementPattern == 'hinge' || movementPattern == 'lunge') {
      return 'legs';
    }
    if (movementPattern == 'core' || movementPattern == 'rotation') {
      return 'core';
    }
    if (movementPattern == 'carry') {
      return 'carry';
    }
    return 'other';
  }

  /// Get muscle priority (primary, secondary, tertiary)
  static Map<String, List<String>> getMuscleActivation(String? bodyPart, String? targetMuscle, List<String>? secondaryMuscles) {
    return {
      'primary': targetMuscle != null ? [targetMuscle] : [],
      'secondary': secondaryMuscles ?? [],
      'tertiary': [], // Could be computed based on movement pattern
    };
  }

  /// Enhance an exercise map with computed attributes
  static Map<String, dynamic> enhanceExercise(Map<String, dynamic> raw) {
    final name = raw['name'] as String? ?? '';
    final bodyPart = raw['body_part'] as String?;
    final equipment = raw['equipment'] as String?;
    final equipmentRequired = (raw['equipment_required'] as List?)?.cast<String>();

    final difficulty = getDifficulty(name, equipment, raw['mechanics_type'] as String?);
    final movementPattern = getMovementPattern(bodyPart, equipment, name);
    final mechanicsType = getMechanicsType(name, equipment);

    return {
      ...raw,
      'movement_pattern': movementPattern,
      'location_tags': getLocations(equipmentRequired, equipment),
      'difficulty': difficulty,
      'difficulty_score': getDifficultyScore(difficulty),
      'force_type': getForceType(bodyPart, name),
      'mechanics_type': mechanicsType,
      'requires_spotter': requiresSpotter(name, equipment),
      'requires_rack': requiresRack(name, equipment),
      'target_rep_range': getTargetRepRange(mechanicsType, difficulty),
      'recommended_rest': getRecommendedRest(mechanicsType, difficulty),
      'category': getCategory(bodyPart, movementPattern),
    };
  }
}
