import 'dart:math' as math;

/// Progressive Overload Engine
/// Implements intelligent algorithms for strength training progression
/// Based on Coach Brian Parks' functional strength methodology
class ProgressiveOverloadEngine {
  ProgressiveOverloadEngine._();
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Weight increment for upper body exercises (lbs)
  static const double upperBodyIncrement = 5.0;
  
  /// Weight increment for lower body exercises (lbs)
  static const double lowerBodyIncrement = 10.0;
  
  /// Micro-loading increment (lbs)
  static const double microLoadIncrement = 2.5;
  
  /// Number of sessions meeting criteria for progression
  static const int twoForTwoSessions = 2;
  
  /// Reps above target to trigger progression
  static const int twoForTwoRepsAboveTarget = 2;
  
  /// Sessions with same performance to detect plateau
  static const int plateauThreshold = 3;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // 1RM ESTIMATION FORMULAS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Epley Formula (best for 1-5 reps)
  /// 1RM = weight × (1 + reps/30)
  static double estimateOneRepMaxEpley(double weight, int reps) {
    if (reps <= 0 || weight <= 0) return 0;
    if (reps == 1) return weight;
    return weight * (1 + reps / 30);
  }
  
  /// Brzycki Formula (best for 6-10 reps)
  /// 1RM = weight × (36 / (37 - reps))
  static double estimateOneRepMaxBrzycki(double weight, int reps) {
    if (reps <= 0 || weight <= 0) return 0;
    if (reps == 1) return weight;
    if (reps >= 37) return weight; // Formula breaks down at high reps
    return weight * (36 / (37 - reps));
  }
  
  /// Lander Formula (alternative)
  /// 1RM = (100 × weight) / (101.3 - 2.67123 × reps)
  static double estimateOneRepMaxLander(double weight, int reps) {
    if (reps <= 0 || weight <= 0) return 0;
    if (reps == 1) return weight;
    final denominator = 101.3 - (2.67123 * reps);
    if (denominator <= 0) return weight;
    return (100 * weight) / denominator;
  }
  
  /// Combined 1RM estimation (weighted average based on rep range)
  static double estimateOneRepMax(double weight, int reps) {
    if (reps <= 0 || weight <= 0) return 0;
    if (reps == 1) return weight;
    
    if (reps <= 5) {
      // Low reps: use Epley
      return estimateOneRepMaxEpley(weight, reps);
    } else if (reps <= 10) {
      // Mid reps: average Epley and Brzycki
      final epley = estimateOneRepMaxEpley(weight, reps);
      final brzycki = estimateOneRepMaxBrzycki(weight, reps);
      return (epley + brzycki) / 2;
    } else {
      // High reps: use Brzycki (more conservative)
      return estimateOneRepMaxBrzycki(weight, reps);
    }
  }
  
  /// Calculate weight for target reps based on 1RM
  static double calculateWeightForReps(double oneRepMax, int targetReps) {
    if (targetReps <= 0 || oneRepMax <= 0) return 0;
    if (targetReps == 1) return oneRepMax;
    
    // Using inverted Epley formula
    return oneRepMax / (1 + targetReps / 30);
  }
  
  /// Calculate percentage of 1RM based on rep count
  static double calculatePercentageOfOneRM(int reps) {
    if (reps <= 0) return 0;
    if (reps == 1) return 100;
    
    // Approximate %1RM based on rep count
    final percentages = {
      1: 100.0, 2: 95.0, 3: 93.0, 4: 90.0, 5: 87.0,
      6: 85.0, 7: 83.0, 8: 80.0, 9: 77.0, 10: 75.0,
      12: 70.0, 15: 65.0, 20: 60.0, 25: 55.0, 30: 50.0,
    };
    
    if (percentages.containsKey(reps)) {
      return percentages[reps]!;
    }
    
    // Interpolate for unlisted rep counts
    final sortedReps = percentages.keys.toList()..sort();
    for (int i = 0; i < sortedReps.length - 1; i++) {
      if (reps > sortedReps[i] && reps < sortedReps[i + 1]) {
        final ratio = (reps - sortedReps[i]) / 
                      (sortedReps[i + 1] - sortedReps[i]);
        return percentages[sortedReps[i]]! - 
               (ratio * (percentages[sortedReps[i]]! - 
                        percentages[sortedReps[i + 1]]!));
      }
    }
    
    return 50.0; // Very high reps
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // 2-FOR-2 RULE PROGRESSION
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Check if user should increase weight based on 2-for-2 rule
  /// Returns true if user exceeded target reps by 2+ for 2 consecutive sessions
  static ProgressionResult checkTwoForTwoProgression({
    required List<SetLog> recentSets,
    required int targetReps,
    required double currentWeight,
    required bool isUpperBody,
  }) {
    if (recentSets.length < 2) {
      return ProgressionResult(
        shouldProgress: false,
        reason: 'Need more data (${recentSets.length}/2 sessions)',
      );
    }
    
    // Check last two sessions
    int sessionsExceedingTarget = 0;
    int totalRepsAboveTarget = 0;
    
    for (final setLog in recentSets.take(2)) {
      if (setLog.reps >= targetReps + twoForTwoRepsAboveTarget) {
        sessionsExceedingTarget++;
        totalRepsAboveTarget += setLog.reps - targetReps;
      }
    }
    
    if (sessionsExceedingTarget >= twoForTwoSessions) {
      final increment = isUpperBody ? upperBodyIncrement : lowerBodyIncrement;
      return ProgressionResult(
        shouldProgress: true,
        suggestedWeight: currentWeight + increment,
        reason: '2-for-2 rule met! Exceeded target by ${totalRepsAboveTarget ~/ 2} reps on average',
        progressionType: ProgressionType.twoForTwo,
      );
    }
    
    return ProgressionResult(
      shouldProgress: false,
      reason: 'Keep working at current weight ($sessionsExceedingTarget/2 sessions meeting criteria)',
    );
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PLATEAU DETECTION
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Detect if user has plateaued
  static PlateauResult detectPlateau({
    required List<SetLog> recentSets,
    int sessionsToCheck = 3,
  }) {
    if (recentSets.length < sessionsToCheck) {
      return PlateauResult(
        isPlateaued: false,
        reason: 'Insufficient data',
      );
    }
    
    final setsToAnalyze = recentSets.take(sessionsToCheck).toList();
    
    // Check if weight and reps are unchanged
    final firstSet = setsToAnalyze.first;
    bool sameWeight = true;
    bool sameReps = true;
    
    for (final set in setsToAnalyze) {
      if ((set.weight - firstSet.weight).abs() > 0.1) {
        sameWeight = false;
      }
      if (set.reps != firstSet.reps) {
        sameReps = false;
      }
    }
    
    if (sameWeight && sameReps) {
      return PlateauResult(
        isPlateaued: true,
        sessionCount: sessionsToCheck,
        reason: 'Same weight and reps for $sessionsToCheck sessions',
        suggestions: _getPlateauSuggestions(),
      );
    }
    
    // Check for declining performance
    bool declining = true;
    for (int i = 1; i < setsToAnalyze.length; i++) {
      final volume = setsToAnalyze[i].weight * setsToAnalyze[i].reps;
      final prevVolume = setsToAnalyze[i - 1].weight * setsToAnalyze[i - 1].reps;
      if (volume >= prevVolume) {
        declining = false;
        break;
      }
    }
    
    if (declining) {
      return PlateauResult(
        isPlateaued: true,
        sessionCount: sessionsToCheck,
        reason: 'Performance declining over $sessionsToCheck sessions',
        suggestions: ['Consider a deload week', 'Check recovery and sleep'],
      );
    }
    
    return PlateauResult(
      isPlateaued: false,
      reason: 'Progress detected',
    );
  }
  
  static List<String> _getPlateauSuggestions() {
    return [
      'Try micro-loading (+2.5 lbs)',
      'Add an extra set',
      'Adjust rep range (add 1-2 reps)',
      'Try a different variation of the exercise',
      'Consider a deload week',
      'Increase protein intake',
    ];
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // RPE-BASED AUTO-REGULATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Calculate weight adjustment based on RPE
  static WeightAdjustment calculateRPEBasedAdjustment({
    required int targetRPE,
    required int actualRPE,
    required double currentWeight,
    required bool isUpperBody,
  }) {
    final rpeDiff = actualRPE - targetRPE;
    final increment = isUpperBody ? upperBodyIncrement : lowerBodyIncrement;
    
    if (rpeDiff == 0) {
      return WeightAdjustment(
        adjustment: 0,
        suggestedWeight: currentWeight,
        message: 'Perfect! Keep the same weight',
      );
    }
    
    if (rpeDiff > 0) {
      // Too hard - suggest decreasing weight
      final adjustmentFactor = _getRPEAdjustmentFactor(rpeDiff);
      final weightReduction = currentWeight * adjustmentFactor;
      final roundedReduction = (weightReduction / 2.5).round() * 2.5;
      
      return WeightAdjustment(
        adjustment: -roundedReduction,
        suggestedWeight: currentWeight - roundedReduction,
        message: 'Consider reducing weight by ${roundedReduction.toStringAsFixed(1)} lbs',
      );
    } else {
      // Too easy - suggest increasing weight
      final adjustmentFactor = _getRPEAdjustmentFactor(-rpeDiff);
      final weightIncrease = math.max(increment * adjustmentFactor, microLoadIncrement);
      final roundedIncrease = (weightIncrease / 2.5).round() * 2.5;
      
      return WeightAdjustment(
        adjustment: roundedIncrease,
        suggestedWeight: currentWeight + roundedIncrease,
        message: 'Consider increasing weight by ${roundedIncrease.toStringAsFixed(1)} lbs',
      );
    }
  }
  
  static double _getRPEAdjustmentFactor(int rpeDiff) {
    // RPE difference to adjustment factor (approximate percentage)
    return switch (rpeDiff) {
      1 => 0.02,   // 2% adjustment
      2 => 0.05,   // 5% adjustment
      3 => 0.08,   // 8% adjustment
      _ => 0.10,   // 10% adjustment for large differences
    };
  }
  
  /// Convert RIR (Reps in Reserve) to RPE
  static int rirToRPE(int rir) => 10 - rir;
  
  /// Convert RPE to RIR (Reps in Reserve)
  static int rpeToRIR(int rpe) => 10 - rpe;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // VOLUME CALCULATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Calculate total volume (sets × reps × weight)
  static double calculateVolume(List<SetLog> sets) {
    return sets.fold(0.0, (sum, set) => sum + (set.reps * set.weight));
  }
  
  /// Calculate average intensity (weight relative to 1RM)
  static double calculateAverageIntensity(List<SetLog> sets, double oneRepMax) {
    if (sets.isEmpty || oneRepMax <= 0) return 0;
    final totalWeight = sets.fold(0.0, (sum, set) => sum + set.weight);
    return (totalWeight / sets.length) / oneRepMax * 100;
  }
  
  /// Calculate weekly volume per muscle group
  static double calculateWeeklyVolume(
    List<WorkoutSession> weekSessions,
    String muscleGroup,
  ) {
    double totalVolume = 0;
    for (final session in weekSessions) {
      for (final exercise in session.exercises) {
        if (exercise.targetMuscle.toLowerCase() == muscleGroup.toLowerCase()) {
          totalVolume += calculateVolume(exercise.sets);
        }
      }
    }
    return totalVolume;
  }
  
  /// Check if weekly volume is in optimal range
  static VolumeStatus checkVolumeStatus({
    required double weeklyVolume,
    required String muscleGroup,
    required ExperienceLevel level,
  }) {
    final (minSets, maxSets) = _getOptimalSetRange(muscleGroup, level);
    // Assuming average set = 10 reps × average weight
    // This is a simplified check
    
    if (weeklyVolume < minSets * 500) {
      return VolumeStatus.underVolume;
    } else if (weeklyVolume > maxSets * 1500) {
      return VolumeStatus.overVolume;
    }
    return VolumeStatus.optimal;
  }
  
  static (int min, int max) _getOptimalSetRange(
    String muscleGroup,
    ExperienceLevel level,
  ) {
    // Weekly set recommendations per muscle group
    return switch (level) {
      ExperienceLevel.beginner => (10, 12),
      ExperienceLevel.intermediate => (12, 18),
      ExperienceLevel.advanced => (18, 25),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════════════════

/// Individual set log entry
class SetLog {
  final double weight;
  final int reps;
  final int? rpe;
  final DateTime timestamp;
  
  const SetLog({
    required this.weight,
    required this.reps,
    this.rpe,
    required this.timestamp,
  });
  
  double get volume => weight * reps;
}

/// Workout session data
class WorkoutSession {
  final String id;
  final DateTime date;
  final List<ExerciseSession> exercises;
  
  const WorkoutSession({
    required this.id,
    required this.date,
    required this.exercises,
  });
}

/// Exercise within a session
class ExerciseSession {
  final String exerciseId;
  final String exerciseName;
  final String targetMuscle;
  final List<SetLog> sets;
  
  const ExerciseSession({
    required this.exerciseId,
    required this.exerciseName,
    required this.targetMuscle,
    required this.sets,
  });
}

/// Progression check result
class ProgressionResult {
  final bool shouldProgress;
  final double? suggestedWeight;
  final String reason;
  final ProgressionType? progressionType;
  
  const ProgressionResult({
    required this.shouldProgress,
    this.suggestedWeight,
    required this.reason,
    this.progressionType,
  });
}

/// Plateau detection result
class PlateauResult {
  final bool isPlateaued;
  final int? sessionCount;
  final String reason;
  final List<String>? suggestions;
  
  const PlateauResult({
    required this.isPlateaued,
    this.sessionCount,
    required this.reason,
    this.suggestions,
  });
}

/// Weight adjustment recommendation
class WeightAdjustment {
  final double adjustment;
  final double suggestedWeight;
  final String message;
  
  const WeightAdjustment({
    required this.adjustment,
    required this.suggestedWeight,
    required this.message,
  });
}

/// Types of progression
enum ProgressionType {
  twoForTwo,
  rpeBasedIncrease,
  volumeIncrease,
  microLoading,
}

/// Experience level for volume recommendations
enum ExperienceLevel {
  beginner,
  intermediate,
  advanced,
}

/// Volume status
enum VolumeStatus {
  underVolume,
  optimal,
  overVolume,
}

