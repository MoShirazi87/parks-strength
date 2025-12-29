import 'dart:math';
import '../../shared/models/exercise_model.dart';
import '../providers/exercise_filter_provider.dart';
import '../../main.dart';

/// A dynamically generated workout
class GeneratedWorkout {
  final String id;
  final String name;
  final String type; // push, pull, legs, core, fullbody, upper, lower
  final String description;
  final List<GeneratedExercise> warmup;
  final List<GeneratedExercise> training;
  final List<GeneratedExercise> cooldown;
  final int estimatedMinutes;
  final String difficulty;
  final DateTime generatedAt;

  GeneratedWorkout({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.warmup = const [],
    required this.training,
    this.cooldown = const [],
    required this.estimatedMinutes,
    required this.difficulty,
    required this.generatedAt,
  });

  List<GeneratedExercise> get allExercises => [...warmup, ...training, ...cooldown];
  
  int get exerciseCount => training.length;
  int get totalSets => training.fold(0, (sum, e) => sum + e.sets);
}

/// A single exercise within a generated workout
class GeneratedExercise {
  final String exerciseId;
  final String name;
  final String? description;
  final String? gifUrl;
  final int sets;
  final int reps;
  final int restSeconds;
  final String? letter; // A, B, C for superset grouping
  final bool isWarmup;
  final bool isCooldown;
  final List<String> cues;
  final String? equipmentNeeded;

  GeneratedExercise({
    required this.exerciseId,
    required this.name,
    this.description,
    this.gifUrl,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    this.letter,
    this.isWarmup = false,
    this.isCooldown = false,
    this.cues = const [],
    this.equipmentNeeded,
  });
}

/// Service for generating intelligent workouts
class WorkoutGenerator {
  static final WorkoutGenerator _instance = WorkoutGenerator._internal();
  factory WorkoutGenerator() => _instance;
  WorkoutGenerator._internal();

  final _random = Random();
  
  /// Generate a workout based on type and user preferences
  Future<GeneratedWorkout> generateWorkout({
    required String workoutType,
    String? difficulty,
    int targetExercises = 5,
    int targetMinutes = 45,
  }) async {
    // Fetch user preferences
    final userId = supabase.auth.currentUser?.id;
    List<String> userEquipment = ['bodyweight']; // Always include bodyweight
    String? userLocation;
    String userDifficulty = difficulty ?? 'intermediate';
    
    if (userId != null) {
      try {
        // Get user equipment
        final equipmentResponse = await supabase
            .from('user_equipment')
            .select('equipment:equipment(name)')
            .eq('user_id', userId);
        
        final equipment = (equipmentResponse as List)
            .map((e) => (e['equipment']?['name'] as String?)?.toLowerCase() ?? '')
            .where((e) => e.isNotEmpty)
            .toList();
        
        if (equipment.isNotEmpty) {
          userEquipment = [...userEquipment, ...equipment];
        }
        
        // Get user profile
        final userResponse = await supabase
            .from('users')
            .select('training_location, experience_level')
            .eq('id', userId)
            .maybeSingle();
        
        if (userResponse != null) {
          userLocation = userResponse['training_location'] as String?;
          if (difficulty == null) {
            userDifficulty = userResponse['experience_level'] as String? ?? 'intermediate';
          }
        }
      } catch (e) {
        print('Error fetching user preferences for workout generation: $e');
      }
    }
    
    // Create filter based on workout type
    final filter = ExerciseFilter.forWorkoutType(
      workoutType,
      equipment: userEquipment,
      location: userLocation,
      difficulty: userDifficulty,
    );
    
    // Fetch matching exercises
    final exerciseRepo = ExerciseRepository();
    final exercises = await exerciseRepo.getFilteredExercises(filter);
    
    if (exercises.isEmpty) {
      // Fallback to demo exercises if no matches
      return _generateFallbackWorkout(workoutType, userDifficulty);
    }
    
    // Build the workout
    return _buildWorkout(
      type: workoutType,
      exercises: exercises,
      targetExercises: targetExercises,
      difficulty: userDifficulty,
    );
  }
  
  /// Build a workout from a list of exercises
  GeneratedWorkout _buildWorkout({
    required String type,
    required List<ExerciseModel> exercises,
    required int targetExercises,
    required String difficulty,
  }) {
    // Shuffle and select exercises
    final shuffled = List<ExerciseModel>.from(exercises)..shuffle(_random);
    final selectedExercises = shuffled.take(targetExercises.clamp(3, 8)).toList();
    
    // Determine sets/reps based on difficulty and workout type
    final setRepScheme = _getSetRepScheme(type, difficulty);
    
    // Build training exercises
    final training = selectedExercises.asMap().entries.map((entry) {
      final index = entry.key;
      final exercise = entry.value;
      
      return GeneratedExercise(
        exerciseId: exercise.id,
        name: exercise.name,
        description: exercise.description,
        gifUrl: exercise.videoUrl,
        sets: setRepScheme['sets'] as int,
        reps: setRepScheme['reps'] as int,
        restSeconds: setRepScheme['rest'] as int,
        letter: String.fromCharCode(65 + index), // A, B, C, ...
        cues: exercise.cues,
        equipmentNeeded: exercise.equipmentRequired.isNotEmpty 
            ? exercise.equipmentRequired.first 
            : 'Bodyweight',
      );
    }).toList();
    
    // Calculate estimated time
    final totalSets = training.fold(0, (sum, e) => sum + e.sets);
    final avgSetTime = 45; // seconds per set
    final avgRest = setRepScheme['rest'] as int;
    final estimatedMinutes = ((totalSets * avgSetTime + totalSets * avgRest) / 60).round();
    
    return GeneratedWorkout(
      id: 'generated_${DateTime.now().millisecondsSinceEpoch}',
      name: _getWorkoutName(type),
      type: type,
      description: _getWorkoutDescription(type, selectedExercises.length),
      training: training,
      estimatedMinutes: estimatedMinutes.clamp(20, 90),
      difficulty: difficulty,
      generatedAt: DateTime.now(),
    );
  }
  
  /// Get sets, reps, and rest based on workout type and difficulty
  Map<String, int> _getSetRepScheme(String type, String difficulty) {
    // Base schemes by type
    switch (type.toLowerCase()) {
      case 'push':
      case 'pull':
        // Strength focus
        switch (difficulty) {
          case 'beginner':
            return {'sets': 3, 'reps': 10, 'rest': 90};
          case 'advanced':
            return {'sets': 4, 'reps': 6, 'rest': 120};
          default:
            return {'sets': 4, 'reps': 8, 'rest': 90};
        }
      
      case 'legs':
        // Higher volume for legs
        switch (difficulty) {
          case 'beginner':
            return {'sets': 3, 'reps': 12, 'rest': 90};
          case 'advanced':
            return {'sets': 5, 'reps': 8, 'rest': 150};
          default:
            return {'sets': 4, 'reps': 10, 'rest': 120};
        }
      
      case 'core':
        // Higher reps, shorter rest
        switch (difficulty) {
          case 'beginner':
            return {'sets': 2, 'reps': 15, 'rest': 45};
          case 'advanced':
            return {'sets': 4, 'reps': 20, 'rest': 60};
          default:
            return {'sets': 3, 'reps': 15, 'rest': 60};
        }
      
      case 'fullbody':
      case 'full_body':
        // Balanced approach
        switch (difficulty) {
          case 'beginner':
            return {'sets': 2, 'reps': 12, 'rest': 60};
          case 'advanced':
            return {'sets': 4, 'reps': 8, 'rest': 90};
          default:
            return {'sets': 3, 'reps': 10, 'rest': 75};
        }
      
      default:
        return {'sets': 3, 'reps': 10, 'rest': 90};
    }
  }
  
  /// Get a descriptive name for the workout
  String _getWorkoutName(String type) {
    final names = {
      'push': ['Push Power', 'Upper Push Day', 'Chest & Shoulders', 'Press Day'],
      'pull': ['Pull Strength', 'Back Builder', 'Upper Pull Day', 'Row & Grow'],
      'legs': ['Leg Day', 'Lower Body Power', 'Squat Session', 'Leg Strength'],
      'core': ['Core Crusher', 'Ab Attack', 'Core Stability', 'Midsection Focus'],
      'upper': ['Upper Body Blast', 'Arms & Torso', 'Upper Strength'],
      'lower': ['Lower Body Focus', 'Leg & Glutes', 'Lower Power'],
      'fullbody': ['Full Body Burn', 'Total Body Training', 'Complete Workout'],
    };
    
    final options = names[type.toLowerCase()] ?? ['Custom Workout'];
    return options[_random.nextInt(options.length)];
  }
  
  /// Get a description for the workout
  String _getWorkoutDescription(String type, int exerciseCount) {
    final typeDesc = {
      'push': 'chest, shoulders, and triceps',
      'pull': 'back and biceps',
      'legs': 'quads, hamstrings, and glutes',
      'core': 'abs and core stability',
      'upper': 'upper body muscles',
      'lower': 'lower body muscles',
      'fullbody': 'all major muscle groups',
    };
    
    final target = typeDesc[type.toLowerCase()] ?? 'various muscles';
    return 'A $exerciseCount-exercise workout targeting $target, tailored to your equipment and fitness level.';
  }
  
  /// Generate a fallback workout when no exercises match
  GeneratedWorkout _generateFallbackWorkout(String type, String difficulty) {
    // Create demo exercises based on type
    final demoExercises = _getFallbackExercises(type);
    
    final training = demoExercises.asMap().entries.map((entry) {
      final index = entry.key;
      final ex = entry.value;
      
      return GeneratedExercise(
        exerciseId: 'demo_${index + 1}',
        name: ex['name'] as String,
        sets: ex['sets'] as int,
        reps: ex['reps'] as int,
        restSeconds: ex['rest'] as int,
        letter: String.fromCharCode(65 + index),
        equipmentNeeded: 'Bodyweight',
      );
    }).toList();
    
    return GeneratedWorkout(
      id: 'fallback_${DateTime.now().millisecondsSinceEpoch}',
      name: _getWorkoutName(type),
      type: type,
      description: 'A bodyweight workout since no equipment-specific exercises were found.',
      training: training,
      estimatedMinutes: 30,
      difficulty: difficulty,
      generatedAt: DateTime.now(),
    );
  }
  
  /// Get fallback exercises for each workout type
  List<Map<String, dynamic>> _getFallbackExercises(String type) {
    switch (type.toLowerCase()) {
      case 'push':
        return [
          {'name': 'Push-ups', 'sets': 3, 'reps': 15, 'rest': 60},
          {'name': 'Diamond Push-ups', 'sets': 3, 'reps': 12, 'rest': 60},
          {'name': 'Pike Push-ups', 'sets': 3, 'reps': 10, 'rest': 60},
          {'name': 'Wide Push-ups', 'sets': 3, 'reps': 15, 'rest': 60},
        ];
      case 'pull':
        return [
          {'name': 'Inverted Rows', 'sets': 3, 'reps': 12, 'rest': 60},
          {'name': 'Chin-ups', 'sets': 3, 'reps': 8, 'rest': 90},
          {'name': 'Superman Holds', 'sets': 3, 'reps': 15, 'rest': 45},
          {'name': 'Doorway Rows', 'sets': 3, 'reps': 12, 'rest': 60},
        ];
      case 'legs':
        return [
          {'name': 'Bodyweight Squats', 'sets': 4, 'reps': 20, 'rest': 60},
          {'name': 'Lunges', 'sets': 3, 'reps': 12, 'rest': 60},
          {'name': 'Glute Bridges', 'sets': 3, 'reps': 15, 'rest': 45},
          {'name': 'Calf Raises', 'sets': 3, 'reps': 20, 'rest': 45},
          {'name': 'Jump Squats', 'sets': 3, 'reps': 10, 'rest': 60},
        ];
      case 'core':
        return [
          {'name': 'Plank', 'sets': 3, 'reps': 45, 'rest': 30}, // reps = seconds
          {'name': 'Bicycle Crunches', 'sets': 3, 'reps': 20, 'rest': 30},
          {'name': 'Mountain Climbers', 'sets': 3, 'reps': 30, 'rest': 30},
          {'name': 'Dead Bug', 'sets': 3, 'reps': 12, 'rest': 30},
          {'name': 'Russian Twists', 'sets': 3, 'reps': 20, 'rest': 30},
        ];
      case 'fullbody':
      default:
        return [
          {'name': 'Burpees', 'sets': 3, 'reps': 10, 'rest': 60},
          {'name': 'Push-ups', 'sets': 3, 'reps': 15, 'rest': 45},
          {'name': 'Squats', 'sets': 3, 'reps': 20, 'rest': 45},
          {'name': 'Plank', 'sets': 3, 'reps': 45, 'rest': 30},
          {'name': 'Lunges', 'sets': 3, 'reps': 12, 'rest': 45},
        ];
    }
  }
}

