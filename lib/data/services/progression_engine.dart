/// Progression Engine
///
/// Handles exercise progressions and regressions for intelligent program design.
/// Links exercises in progression chains and recommends next steps based on performance.
library;

import 'dart:convert';
import 'package:flutter/services.dart';

class ProgressionEngine {
  static ProgressionEngine? _instance;
  Map<String, List<ProgressionStep>>? _progressionChains;

  ProgressionEngine._();

  static ProgressionEngine get instance {
    _instance ??= ProgressionEngine._();
    return _instance!;
  }

  /// Load progression chains from JSON
  Future<void> loadProgressions() async {
    if (_progressionChains != null) return;

    try {
      final jsonString = await rootBundle.loadString('assets/seed/progressions.json');
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final chains = data['progression_chains'] as List;

      _progressionChains = {};
      for (final chain in chains) {
        final chainId = chain['id'] as String;
        final exercises = (chain['exercises'] as List).map((e) => ProgressionStep.fromJson(e)).toList();
        _progressionChains![chainId] = exercises;
      }
    } catch (e) {
      print('Error loading progressions: $e');
      _progressionChains = _getDefaultProgressions();
    }
  }

  /// Get default progressions if JSON loading fails
  Map<String, List<ProgressionStep>> _getDefaultProgressions() {
    return {
      'push_up_progression': [
        ProgressionStep(order: 1, exerciseSlug: 'wall-push-up', difficultyScore: 1, prerequisiteReps: null),
        ProgressionStep(order: 2, exerciseSlug: 'incline-push-up', difficultyScore: 2, prerequisiteReps: 15),
        ProgressionStep(order: 3, exerciseSlug: 'knee-push-up', difficultyScore: 3, prerequisiteReps: 15),
        ProgressionStep(order: 4, exerciseSlug: 'push-up', difficultyScore: 4, prerequisiteReps: 15),
        ProgressionStep(order: 5, exerciseSlug: 'diamond-push-up', difficultyScore: 5, prerequisiteReps: 12),
        ProgressionStep(order: 6, exerciseSlug: 'decline-push-up', difficultyScore: 6, prerequisiteReps: 12),
        ProgressionStep(order: 7, exerciseSlug: 'archer-push-up', difficultyScore: 7, prerequisiteReps: 10),
        ProgressionStep(order: 8, exerciseSlug: 'one-arm-push-up', difficultyScore: 9, prerequisiteReps: 8),
      ],
      'pull_up_progression': [
        ProgressionStep(order: 1, exerciseSlug: 'dead-hang', difficultyScore: 1, prerequisiteReps: null),
        ProgressionStep(order: 2, exerciseSlug: 'scapular-pull-up', difficultyScore: 2, prerequisiteReps: 10),
        ProgressionStep(order: 3, exerciseSlug: 'negative-pull-up', difficultyScore: 3, prerequisiteReps: 8),
        ProgressionStep(order: 4, exerciseSlug: 'band-assisted-pull-up', difficultyScore: 4, prerequisiteReps: 10),
        ProgressionStep(order: 5, exerciseSlug: 'chin-up', difficultyScore: 5, prerequisiteReps: 5),
        ProgressionStep(order: 6, exerciseSlug: 'pull-up', difficultyScore: 6, prerequisiteReps: 5),
        ProgressionStep(order: 7, exerciseSlug: 'wide-grip-pull-up', difficultyScore: 7, prerequisiteReps: 8),
        ProgressionStep(order: 8, exerciseSlug: 'weighted-pull-up', difficultyScore: 8, prerequisiteReps: 10),
      ],
      'squat_progression': [
        ProgressionStep(order: 1, exerciseSlug: 'assisted-squat', difficultyScore: 1, prerequisiteReps: null),
        ProgressionStep(order: 2, exerciseSlug: 'bodyweight-squat', difficultyScore: 2, prerequisiteReps: 15),
        ProgressionStep(order: 3, exerciseSlug: 'goblet-squat', difficultyScore: 3, prerequisiteReps: 12),
        ProgressionStep(order: 4, exerciseSlug: 'dumbbell-squat', difficultyScore: 4, prerequisiteReps: 12),
        ProgressionStep(order: 5, exerciseSlug: 'barbell-back-squat', difficultyScore: 5, prerequisiteReps: 10),
        ProgressionStep(order: 6, exerciseSlug: 'front-squat', difficultyScore: 6, prerequisiteReps: 8),
        ProgressionStep(order: 7, exerciseSlug: 'bulgarian-split-squat', difficultyScore: 7, prerequisiteReps: 10),
        ProgressionStep(order: 8, exerciseSlug: 'pistol-squat', difficultyScore: 9, prerequisiteReps: 5),
      ],
      'hinge_progression': [
        ProgressionStep(order: 1, exerciseSlug: 'hip-hinge-drill', difficultyScore: 1, prerequisiteReps: null),
        ProgressionStep(order: 2, exerciseSlug: 'glute-bridge', difficultyScore: 2, prerequisiteReps: 15),
        ProgressionStep(order: 3, exerciseSlug: 'kettlebell-deadlift', difficultyScore: 3, prerequisiteReps: 12),
        ProgressionStep(order: 4, exerciseSlug: 'romanian-deadlift', difficultyScore: 4, prerequisiteReps: 10),
        ProgressionStep(order: 5, exerciseSlug: 'conventional-deadlift', difficultyScore: 5, prerequisiteReps: 8),
        ProgressionStep(order: 6, exerciseSlug: 'single-leg-rdl', difficultyScore: 6, prerequisiteReps: 8),
        ProgressionStep(order: 7, exerciseSlug: 'deficit-deadlift', difficultyScore: 7, prerequisiteReps: 6),
      ],
      'bench_progression': [
        ProgressionStep(order: 1, exerciseSlug: 'machine-chest-press', difficultyScore: 1, prerequisiteReps: null),
        ProgressionStep(order: 2, exerciseSlug: 'dumbbell-floor-press', difficultyScore: 2, prerequisiteReps: 12),
        ProgressionStep(order: 3, exerciseSlug: 'dumbbell-bench-press', difficultyScore: 3, prerequisiteReps: 12),
        ProgressionStep(order: 4, exerciseSlug: 'barbell-bench-press', difficultyScore: 5, prerequisiteReps: 10),
        ProgressionStep(order: 5, exerciseSlug: 'incline-barbell-bench-press', difficultyScore: 5, prerequisiteReps: 8),
        ProgressionStep(order: 6, exerciseSlug: 'close-grip-bench-press', difficultyScore: 5, prerequisiteReps: 8),
        ProgressionStep(order: 7, exerciseSlug: 'pause-bench-press', difficultyScore: 6, prerequisiteReps: 6),
      ],
      'row_progression': [
        ProgressionStep(order: 1, exerciseSlug: 'seated-cable-row', difficultyScore: 2, prerequisiteReps: null),
        ProgressionStep(order: 2, exerciseSlug: 'chest-supported-row', difficultyScore: 3, prerequisiteReps: 12),
        ProgressionStep(order: 3, exerciseSlug: 'single-arm-dumbbell-row', difficultyScore: 4, prerequisiteReps: 10),
        ProgressionStep(order: 4, exerciseSlug: 'barbell-row', difficultyScore: 5, prerequisiteReps: 10),
        ProgressionStep(order: 5, exerciseSlug: 't-bar-row', difficultyScore: 5, prerequisiteReps: 10),
        ProgressionStep(order: 6, exerciseSlug: 'pendlay-row', difficultyScore: 6, prerequisiteReps: 8),
      ],
      'overhead_press_progression': [
        ProgressionStep(order: 1, exerciseSlug: 'seated-dumbbell-shoulder-press', difficultyScore: 2, prerequisiteReps: null),
        ProgressionStep(order: 2, exerciseSlug: 'standing-dumbbell-shoulder-press', difficultyScore: 3, prerequisiteReps: 12),
        ProgressionStep(order: 3, exerciseSlug: 'arnold-press', difficultyScore: 4, prerequisiteReps: 10),
        ProgressionStep(order: 4, exerciseSlug: 'overhead-press', difficultyScore: 5, prerequisiteReps: 8),
        ProgressionStep(order: 5, exerciseSlug: 'push-press', difficultyScore: 5, prerequisiteReps: 8),
        ProgressionStep(order: 6, exerciseSlug: 'z-press', difficultyScore: 7, prerequisiteReps: 6),
      ],
    };
  }

  /// Find progression chain for an exercise
  String? findChainForExercise(String exerciseSlug) {
    if (_progressionChains == null) return null;

    for (final entry in _progressionChains!.entries) {
      if (entry.value.any((step) => step.exerciseSlug == exerciseSlug)) {
        return entry.key;
      }
    }
    return null;
  }

  /// Get current position in progression chain
  ProgressionStep? getCurrentStep(String chainId, String exerciseSlug) {
    final chain = _progressionChains?[chainId];
    if (chain == null) return null;

    return chain.firstWhere(
      (step) => step.exerciseSlug == exerciseSlug,
      orElse: () => chain.first,
    );
  }

  /// Get next exercise in progression
  ProgressionStep? getNextProgression(String chainId, String currentExerciseSlug) {
    final chain = _progressionChains?[chainId];
    if (chain == null) return null;

    final currentIndex = chain.indexWhere((step) => step.exerciseSlug == currentExerciseSlug);
    if (currentIndex == -1 || currentIndex >= chain.length - 1) return null;

    return chain[currentIndex + 1];
  }

  /// Get previous (regression) exercise in chain
  ProgressionStep? getRegression(String chainId, String currentExerciseSlug) {
    final chain = _progressionChains?[chainId];
    if (chain == null) return null;

    final currentIndex = chain.indexWhere((step) => step.exerciseSlug == currentExerciseSlug);
    if (currentIndex <= 0) return null;

    return chain[currentIndex - 1];
  }

  /// Check if user is ready to progress based on performance
  bool isReadyToProgress({
    required String chainId,
    required String currentExerciseSlug,
    required int lastRepsCompleted,
    required int lastSetsCompleted,
    required int targetSets,
  }) {
    final nextStep = getNextProgression(chainId, currentExerciseSlug);
    if (nextStep == null) return false;

    // User needs to complete required reps for all target sets
    final prerequisiteReps = nextStep.prerequisiteReps ?? 10;
    return lastRepsCompleted >= prerequisiteReps && lastSetsCompleted >= targetSets;
  }

  /// Get appropriate exercise for user's level in a chain
  ProgressionStep? getExerciseForLevel({
    required String chainId,
    required int userDifficultyScore,
  }) {
    final chain = _progressionChains?[chainId];
    if (chain == null) return null;

    // Find exercise closest to but not exceeding user's level
    ProgressionStep? bestMatch;
    for (final step in chain) {
      if (step.difficultyScore <= userDifficultyScore) {
        if (bestMatch == null || step.difficultyScore > bestMatch.difficultyScore) {
          bestMatch = step;
        }
      }
    }

    return bestMatch ?? chain.first;
  }

  /// Get all exercises in a chain
  List<ProgressionStep>? getChain(String chainId) {
    return _progressionChains?[chainId];
  }

  /// Get all available chains
  List<String> getAvailableChains() {
    return _progressionChains?.keys.toList() ?? [];
  }

  /// Recommend progression based on user's recent performance
  ProgressionRecommendation getRecommendation({
    required String exerciseSlug,
    required int avgRepsLastWeek,
    required double avgRPELastWeek,
    required int totalSetsCompleted,
  }) {
    final chainId = findChainForExercise(exerciseSlug);
    if (chainId == null) {
      return ProgressionRecommendation(
        action: ProgressionAction.maintain,
        reason: 'Exercise not in a progression chain',
        currentExercise: exerciseSlug,
      );
    }

    final currentStep = getCurrentStep(chainId, exerciseSlug);
    if (currentStep == null) {
      return ProgressionRecommendation(
        action: ProgressionAction.maintain,
        reason: 'Unable to find current position',
        currentExercise: exerciseSlug,
      );
    }

    // Check for progression
    if (avgRepsLastWeek >= (currentStep.prerequisiteReps ?? 10) + 2 && 
        avgRPELastWeek < 7 && 
        totalSetsCompleted >= 12) {
      final nextStep = getNextProgression(chainId, exerciseSlug);
      if (nextStep != null) {
        return ProgressionRecommendation(
          action: ProgressionAction.progress,
          reason: 'Consistently exceeding target reps with low RPE',
          currentExercise: exerciseSlug,
          recommendedExercise: nextStep.exerciseSlug,
          targetReps: nextStep.prerequisiteReps,
        );
      }
    }

    // Check for regression
    if (avgRepsLastWeek < (currentStep.prerequisiteReps ?? 10) - 4 && 
        avgRPELastWeek > 9) {
      final prevStep = getRegression(chainId, exerciseSlug);
      if (prevStep != null) {
        return ProgressionRecommendation(
          action: ProgressionAction.regress,
          reason: 'Struggling with current exercise, consider stepping back',
          currentExercise: exerciseSlug,
          recommendedExercise: prevStep.exerciseSlug,
          targetReps: prevStep.prerequisiteReps,
        );
      }
    }

    // Maintain current
    return ProgressionRecommendation(
      action: ProgressionAction.maintain,
      reason: 'Current exercise is appropriate for your level',
      currentExercise: exerciseSlug,
      targetReps: currentStep.prerequisiteReps,
    );
  }
}

/// Represents a step in a progression chain
class ProgressionStep {
  final int order;
  final String exerciseSlug;
  final int difficultyScore;
  final int? prerequisiteReps;

  ProgressionStep({
    required this.order,
    required this.exerciseSlug,
    required this.difficultyScore,
    this.prerequisiteReps,
  });

  factory ProgressionStep.fromJson(Map<String, dynamic> json) {
    return ProgressionStep(
      order: json['order'] as int,
      exerciseSlug: json['exercise_slug'] as String,
      difficultyScore: json['difficulty_score'] as int,
      prerequisiteReps: json['prerequisite_reps'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'exercise_slug': exerciseSlug,
      'difficulty_score': difficultyScore,
      'prerequisite_reps': prerequisiteReps,
    };
  }
}

/// Actions for progression recommendation
enum ProgressionAction {
  progress,
  maintain,
  regress,
}

/// Recommendation for exercise progression
class ProgressionRecommendation {
  final ProgressionAction action;
  final String reason;
  final String currentExercise;
  final String? recommendedExercise;
  final int? targetReps;

  ProgressionRecommendation({
    required this.action,
    required this.reason,
    required this.currentExercise,
    this.recommendedExercise,
    this.targetReps,
  });

  String get actionDescription {
    switch (action) {
      case ProgressionAction.progress:
        return 'Ready to progress to $recommendedExercise';
      case ProgressionAction.regress:
        return 'Consider stepping back to $recommendedExercise';
      case ProgressionAction.maintain:
        return 'Continue with current exercise';
    }
  }
}

