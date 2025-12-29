/// Exercise Filter Provider
///
/// Provides intelligent exercise filtering based on user preferences
/// from onboarding: equipment, location, experience level, goals, and injuries.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../shared/models/exercise_model.dart';
import '../services/exercise_enhancement_engine.dart';

/// Represents the comprehensive filter criteria for exercises
class ExerciseFilter {
  // User Profile (from onboarding)
  final List<String> availableEquipment;
  final String? trainingLocation; // 'home', 'gym', 'outdoor', 'travel'
  final String? experienceLevel; // 'beginner', 'intermediate', 'advanced'
  final List<String> goals; // ['build_strength', 'build_muscle', 'lose_weight', 'functional_movement']
  final List<String> injuries; // ['shoulder', 'knee', 'back', etc.]

  // Workout-specific filters
  final List<String> targetMuscles;
  final List<String> movementPatterns;
  final String? mechanicsType; // 'compound', 'isolation'
  final String? forceType; // 'push', 'pull', 'static'
  final int? maxDifficultyScore;
  final int? minDifficultyScore;

  // Search/browse filters
  final String? searchQuery;
  final List<String> tags;
  final bool? requiresSpotter;
  final bool? requiresRack;

  const ExerciseFilter({
    this.availableEquipment = const [],
    this.trainingLocation,
    this.experienceLevel,
    this.goals = const [],
    this.injuries = const [],
    this.targetMuscles = const [],
    this.movementPatterns = const [],
    this.mechanicsType,
    this.forceType,
    this.maxDifficultyScore,
    this.minDifficultyScore,
    this.searchQuery,
    this.tags = const [],
    this.requiresSpotter,
    this.requiresRack,
  });

  /// Create filter from user onboarding data
  factory ExerciseFilter.fromUserProfile({
    List<String>? equipment,
    String? location,
    String? experience,
    List<String>? goals,
    List<String>? injuries,
  }) {
    return ExerciseFilter(
      availableEquipment: equipment ?? [],
      trainingLocation: location,
      experienceLevel: experience,
      goals: goals ?? [],
      injuries: injuries ?? [],
      maxDifficultyScore: ExerciseEnhancementEngine.getMaxDifficultyForLevel(experience ?? 'intermediate'),
    );
  }

  /// Create filter for a specific workout type
  factory ExerciseFilter.forWorkoutType(
    String workoutType, {
    List<String>? equipment,
    String? location,
    String? difficulty,
  }) {
    List<String> targetMuscles;
    List<String> movementPatterns;

    switch (workoutType.toLowerCase()) {
      case 'push':
        targetMuscles = ['chest', 'shoulders', 'triceps'];
        movementPatterns = ['push_horizontal', 'push_vertical'];
        break;
      case 'pull':
        targetMuscles = ['back', 'biceps', 'lats'];
        movementPatterns = ['pull_horizontal', 'pull_vertical'];
        break;
      case 'legs':
        targetMuscles = ['quadriceps', 'hamstrings', 'glutes', 'calves'];
        movementPatterns = ['squat', 'hinge', 'lunge'];
        break;
      case 'core':
        targetMuscles = ['abs', 'obliques', 'core'];
        movementPatterns = ['core', 'rotation'];
        break;
      case 'upper':
        targetMuscles = ['chest', 'back', 'shoulders', 'biceps', 'triceps'];
        movementPatterns = ['push_horizontal', 'push_vertical', 'pull_horizontal', 'pull_vertical'];
        break;
      case 'lower':
        targetMuscles = ['quadriceps', 'hamstrings', 'glutes', 'calves'];
        movementPatterns = ['squat', 'hinge', 'lunge'];
        break;
      case 'fullbody':
      case 'full_body':
      default:
        targetMuscles = ['chest', 'back', 'quadriceps', 'shoulders'];
        movementPatterns = ['squat', 'hinge', 'push_horizontal', 'pull_vertical'];
        break;
    }

    return ExerciseFilter(
      availableEquipment: equipment ?? [],
      trainingLocation: location,
      experienceLevel: difficulty,
      targetMuscles: targetMuscles,
      movementPatterns: movementPatterns,
      maxDifficultyScore: ExerciseEnhancementEngine.getMaxDifficultyForLevel(difficulty ?? 'intermediate'),
    );
  }

  /// Copy with new values
  ExerciseFilter copyWith({
    List<String>? availableEquipment,
    String? trainingLocation,
    String? experienceLevel,
    List<String>? goals,
    List<String>? injuries,
    List<String>? targetMuscles,
    List<String>? movementPatterns,
    String? mechanicsType,
    String? forceType,
    int? maxDifficultyScore,
    int? minDifficultyScore,
    String? searchQuery,
    List<String>? tags,
    bool? requiresSpotter,
    bool? requiresRack,
  }) {
    return ExerciseFilter(
      availableEquipment: availableEquipment ?? this.availableEquipment,
      trainingLocation: trainingLocation ?? this.trainingLocation,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      goals: goals ?? this.goals,
      injuries: injuries ?? this.injuries,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      movementPatterns: movementPatterns ?? this.movementPatterns,
      mechanicsType: mechanicsType ?? this.mechanicsType,
      forceType: forceType ?? this.forceType,
      maxDifficultyScore: maxDifficultyScore ?? this.maxDifficultyScore,
      minDifficultyScore: minDifficultyScore ?? this.minDifficultyScore,
      searchQuery: searchQuery ?? this.searchQuery,
      tags: tags ?? this.tags,
      requiresSpotter: requiresSpotter ?? this.requiresSpotter,
      requiresRack: requiresRack ?? this.requiresRack,
    );
  }

  /// Check if filter is empty (no constraints)
  bool get isEmpty =>
      availableEquipment.isEmpty &&
      trainingLocation == null &&
      experienceLevel == null &&
      goals.isEmpty &&
      injuries.isEmpty &&
      targetMuscles.isEmpty &&
      movementPatterns.isEmpty &&
      mechanicsType == null &&
      forceType == null &&
      maxDifficultyScore == null &&
      minDifficultyScore == null &&
      searchQuery == null &&
      tags.isEmpty &&
      requiresSpotter == null &&
      requiresRack == null;

  @override
  String toString() {
    return 'ExerciseFilter(equipment: $availableEquipment, location: $trainingLocation, level: $experienceLevel, muscles: $targetMuscles)';
  }
}

/// Current filter state provider
final exerciseFilterProvider = StateNotifierProvider<ExerciseFilterNotifier, ExerciseFilter>((ref) {
  return ExerciseFilterNotifier();
});

class ExerciseFilterNotifier extends StateNotifier<ExerciseFilter> {
  ExerciseFilterNotifier() : super(const ExerciseFilter());

  void setFilter(ExerciseFilter filter) {
    state = filter;
  }

  void updateEquipment(List<String> equipment) {
    state = state.copyWith(availableEquipment: equipment);
  }

  void updateLocation(String location) {
    state = state.copyWith(trainingLocation: location);
  }

  void updateExperienceLevel(String level) {
    state = state.copyWith(
      experienceLevel: level,
      maxDifficultyScore: ExerciseEnhancementEngine.getMaxDifficultyForLevel(level),
    );
  }

  void updateTargetMuscles(List<String> muscles) {
    state = state.copyWith(targetMuscles: muscles);
  }

  void updateMovementPatterns(List<String> patterns) {
    state = state.copyWith(movementPatterns: patterns);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query.isEmpty ? null : query);
  }

  void clearFilters() {
    state = const ExerciseFilter();
  }

  void loadFromUserProfile({
    List<String>? equipment,
    String? location,
    String? experience,
    List<String>? goals,
    List<String>? injuries,
  }) {
    state = ExerciseFilter.fromUserProfile(
      equipment: equipment,
      location: location,
      experience: experience,
      goals: goals,
      injuries: injuries,
    );
  }
}

/// Provider to fetch filtered exercises from Supabase
final filteredExercisesProvider = FutureProvider.family<List<ExerciseModel>, ExerciseFilter>((ref, filter) async {
  var query = supabase.from('exercises').select('*');

  // Apply search query
  if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
    query = query.ilike('name', '%${filter.searchQuery}%');
  }

  // Apply equipment filter - exercise equipment must be available to user
  if (filter.availableEquipment.isNotEmpty) {
    // Include bodyweight exercises always
    final equipmentWithBodyweight = [...filter.availableEquipment, 'bodyweight', 'body weight'];
    query = query.or(
      equipmentWithBodyweight.map((e) => 'equipment.ilike.%$e%').join(',')
    );
  }

  // Apply location filter
  if (filter.trainingLocation != null) {
    query = query.contains('location_tags', [filter.trainingLocation]);
  }

  // Apply difficulty filter
  if (filter.maxDifficultyScore != null) {
    query = query.lte('difficulty_score', filter.maxDifficultyScore!);
  }
  if (filter.minDifficultyScore != null) {
    query = query.gte('difficulty_score', filter.minDifficultyScore!);
  }

  // Apply target muscles filter
  if (filter.targetMuscles.isNotEmpty) {
    query = query.or(
      filter.targetMuscles.map((m) => 'target_muscle.ilike.%$m%').join(',')
    );
  }

  // Apply movement pattern filter
  if (filter.movementPatterns.isNotEmpty) {
    query = query.inFilter('movement_pattern', filter.movementPatterns);
  }

  // Apply mechanics type filter
  if (filter.mechanicsType != null) {
    query = query.eq('mechanics_type', filter.mechanicsType!);
  }

  // Apply force type filter
  if (filter.forceType != null) {
    query = query.eq('force_type', filter.forceType!);
  }

  // Apply spotter/rack requirements
  if (filter.requiresSpotter == false) {
    query = query.eq('requires_spotter', false);
  }
  if (filter.requiresRack == false) {
    query = query.eq('requires_rack', false);
  }

  // Only published exercises
  query = query.eq('is_published', true);

  // Order by name and limit results
  final response = await query
      .order('name', ascending: true)
      .limit(100);

  List<ExerciseModel> exercises = (response as List)
      .map((json) => ExerciseModel.fromJson(json))
      .toList();

  // Apply client-side injury filtering (more complex logic)
  if (filter.injuries.isNotEmpty) {
    exercises = exercises.where((ex) {
      return !_exerciseConflictsWithInjuries(ex, filter.injuries);
    }).toList();
  }

  return exercises;
});

/// Check if exercise conflicts with user's injuries
bool _exerciseConflictsWithInjuries(ExerciseModel exercise, List<String> injuries) {
  final contraindications = _getContraindicationsForExercise(exercise);
  return injuries.any((injury) => contraindications.contains(injury.toLowerCase()));
}

/// Get contraindications for an exercise based on body part and movement
List<String> _getContraindicationsForExercise(ExerciseModel exercise) {
  final contraindications = <String>[];
  final bodyPart = exercise.bodyPart?.toLowerCase() ?? '';
  final name = exercise.name.toLowerCase();

  // Shoulder exercises
  if (bodyPart == 'shoulders' || name.contains('press') || name.contains('raise')) {
    contraindications.addAll(['shoulder', 'rotator cuff']);
  }

  // Chest pressing movements
  if (bodyPart == 'chest' && (name.contains('press') || name.contains('fly'))) {
    contraindications.addAll(['shoulder', 'pec', 'chest']);
  }

  // Back exercises
  if (bodyPart == 'back' || name.contains('row') || name.contains('pull')) {
    if (name.contains('deadlift') || name.contains('row')) {
      contraindications.addAll(['lower back', 'spine']);
    }
    contraindications.add('shoulder');
  }

  // Leg exercises
  if (bodyPart.contains('leg') || name.contains('squat') || name.contains('lunge')) {
    contraindications.addAll(['knee', 'hip']);
  }

  // Deadlifts and hinges
  if (name.contains('deadlift') || name.contains('hinge')) {
    contraindications.addAll(['lower back', 'spine', 'hamstring']);
  }

  // Core exercises
  if (bodyPart.contains('waist') || name.contains('crunch') || name.contains('twist')) {
    contraindications.addAll(['lower back', 'spine', 'ab']);
  }

  return contraindications;
}

/// Provider for exercises by body part (quick access)
final exercisesByBodyPartProvider = FutureProvider.family<List<ExerciseModel>, String>((ref, bodyPart) async {
  final response = await supabase
      .from('exercises')
      .select('*')
      .eq('body_part', bodyPart)
      .eq('is_published', true)
      .order('difficulty_score', ascending: true)
      .limit(50);

  return (response as List).map((json) => ExerciseModel.fromJson(json)).toList();
});

/// Provider for exercises by movement pattern
final exercisesByMovementProvider = FutureProvider.family<List<ExerciseModel>, String>((ref, pattern) async {
  final response = await supabase
      .from('exercises')
      .select('*')
      .eq('movement_pattern', pattern)
      .eq('is_published', true)
      .order('difficulty_score', ascending: true)
      .limit(50);

  return (response as List).map((json) => ExerciseModel.fromJson(json)).toList();
});

/// Provider for exercises by equipment
final exercisesByEquipmentProvider = FutureProvider.family<List<ExerciseModel>, String>((ref, equipment) async {
  final response = await supabase
      .from('exercises')
      .select('*')
      .ilike('equipment', '%$equipment%')
      .eq('is_published', true)
      .order('name', ascending: true)
      .limit(50);

  return (response as List).map((json) => ExerciseModel.fromJson(json)).toList();
});

/// Provider for search results
final exerciseSearchProvider = FutureProvider.family<List<ExerciseModel>, String>((ref, query) async {
  if (query.isEmpty || query.length < 2) return [];

  final response = await supabase
      .from('exercises')
      .select('*')
      .ilike('name', '%$query%')
      .eq('is_published', true)
      .order('name', ascending: true)
      .limit(20);

  return (response as List).map((json) => ExerciseModel.fromJson(json)).toList();
});

/// Provider for exercise recommendations based on user profile
final recommendedExercisesProvider = FutureProvider<List<ExerciseModel>>((ref) async {
  final filter = ref.watch(exerciseFilterProvider);
  
  // Get exercises matching user's profile
  var query = supabase.from('exercises').select('*');

  // Filter by location
  if (filter.trainingLocation != null) {
    query = query.contains('location_tags', [filter.trainingLocation!]);
  }

  // Filter by difficulty
  if (filter.maxDifficultyScore != null) {
    query = query.lte('difficulty_score', filter.maxDifficultyScore!);
  }

  // Prioritize compound movements
  query = query.eq('mechanics_type', 'compound');

  // Only published
  query = query.eq('is_published', true);

  // Order by difficulty and limit
  final response = await query
      .order('difficulty_score', ascending: true)
      .limit(20);

  return (response as List).map((json) => ExerciseModel.fromJson(json)).toList();
});

/// Quick workout generator data class
class QuickWorkoutParams {
  final String workoutType; // 'push', 'pull', 'legs', 'core', 'full_body'
  final String location;
  final String experienceLevel;
  final List<String> equipment;
  final int exerciseCount;

  QuickWorkoutParams({
    required this.workoutType,
    this.location = 'gym',
    this.experienceLevel = 'intermediate',
    this.equipment = const [],
    this.exerciseCount = 6,
  });
}

/// Provider for quick workout exercise selection
final quickWorkoutExercisesProvider = FutureProvider.family<List<ExerciseModel>, QuickWorkoutParams>((ref, params) async {
  List<String> targetPatterns;
  List<String> targetMuscles;

  switch (params.workoutType.toLowerCase()) {
    case 'push':
      targetPatterns = ['push_horizontal', 'push_vertical'];
      targetMuscles = ['chest', 'shoulders', 'triceps', 'anterior_deltoids'];
      break;
    case 'pull':
      targetPatterns = ['pull_horizontal', 'pull_vertical'];
      targetMuscles = ['back', 'biceps', 'lats', 'rear_deltoids'];
      break;
    case 'legs':
      targetPatterns = ['squat', 'hinge', 'lunge'];
      targetMuscles = ['quadriceps', 'hamstrings', 'glutes', 'calves'];
      break;
    case 'core':
      targetPatterns = ['core', 'rotation'];
      targetMuscles = ['abs', 'obliques', 'core'];
      break;
    case 'full_body':
    default:
      targetPatterns = ['squat', 'hinge', 'push_horizontal', 'pull_vertical'];
      targetMuscles = ['quadriceps', 'back', 'chest', 'shoulders'];
      break;
  }

  final maxDifficulty = ExerciseEnhancementEngine.getMaxDifficultyForLevel(params.experienceLevel);

  var query = supabase.from('exercises').select('*');

  // Filter by location
  query = query.contains('location_tags', [params.location]);

  // Filter by movement patterns
  query = query.inFilter('movement_pattern', targetPatterns);

  // Filter by difficulty
  query = query.lte('difficulty_score', maxDifficulty);

  // Only published
  query = query.eq('is_published', true);

  // Order randomly-ish and limit
  final response = await query
      .order('difficulty_score', ascending: true)
      .limit(params.exerciseCount * 2);

  final exercises = (response as List).map((json) => ExerciseModel.fromJson(json)).toList();

  // Filter by equipment if specified
  List<ExerciseModel> filteredExercises = exercises;
  if (params.equipment.isNotEmpty) {
    final equipmentLower = params.equipment.map((e) => e.toLowerCase()).toList();
    filteredExercises = exercises.where((ex) {
      final exEquipment = ex.equipment?.toLowerCase() ?? '';
      return exEquipment == 'bodyweight' || 
             exEquipment == 'body weight' ||
             equipmentLower.any((eq) => exEquipment.contains(eq));
    }).toList();
  }

  // Return requested count
  if (filteredExercises.length > params.exerciseCount) {
    filteredExercises = filteredExercises.take(params.exerciseCount).toList();
  }

  return filteredExercises;
});

/// Repository for fetching exercises from database
class ExerciseRepository {
  /// Get filtered exercises from database
  Future<List<ExerciseModel>> getFilteredExercises(ExerciseFilter filter) async {
    var query = supabase.from('exercises').select('*');

    // Apply equipment filter
    if (filter.availableEquipment.isNotEmpty) {
      final equipmentWithBodyweight = [...filter.availableEquipment, 'bodyweight', 'body weight'];
      query = query.or(
        equipmentWithBodyweight.map((e) => 'equipment.ilike.%$e%').join(','),
      );
    }

    // Apply location filter
    if (filter.trainingLocation != null) {
      query = query.contains('location_tags', [filter.trainingLocation!]);
    }

    // Apply movement patterns
    if (filter.movementPatterns.isNotEmpty) {
      query = query.inFilter('movement_pattern', filter.movementPatterns);
    }

    // Apply target muscles
    if (filter.targetMuscles.isNotEmpty) {
      query = query.or(
        filter.targetMuscles.map((m) => 'target_muscle.ilike.%$m%').join(','),
      );
    }

    // Apply difficulty filter
    if (filter.maxDifficultyScore != null) {
      query = query.lte('difficulty_score', filter.maxDifficultyScore!);
    }

    // Only published exercises
    query = query.eq('is_published', true);

    // Execute query
    final response = await query
        .order('difficulty_score', ascending: true)
        .limit(50);

    return (response as List)
        .map((json) => ExerciseModel.fromJson(json))
        .toList();
  }

  /// Get exercise by ID
  Future<ExerciseModel?> getExerciseById(String id) async {
    final response = await supabase
        .from('exercises')
        .select('*')
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return ExerciseModel.fromJson(response);
  }

  /// Search exercises by name
  Future<List<ExerciseModel>> searchExercises(String query) async {
    if (query.isEmpty || query.length < 2) return [];

    final response = await supabase
        .from('exercises')
        .select('*')
        .ilike('name', '%$query%')
        .eq('is_published', true)
        .order('name', ascending: true)
        .limit(20);

    return (response as List)
        .map((json) => ExerciseModel.fromJson(json))
        .toList();
  }
}
