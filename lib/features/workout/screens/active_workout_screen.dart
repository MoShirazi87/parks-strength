import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/algorithms/progressive_overload.dart';
import '../../../core/utils/exercise_assets.dart';
import '../../../data/providers/workout_provider.dart';
import '../../../data/services/gif_service.dart';
import '../../../shared/models/workout_model.dart';
import '../../../main.dart';

/// Active workout screen - full workout player with logging
class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  final String workoutId;

  const ActiveWorkoutScreen({super.key, required this.workoutId});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  // Workout state
  int _currentExerciseIndex = 0;
  int _currentSetIndex = 0;
  bool _isResting = false;
  int _restTimeRemaining = 0;
  Timer? _restTimer;
  Timer? _workoutTimer;
  int _totalWorkoutSeconds = 0;
  bool _isPaused = false;
  
  // Exercise logs
  final List<Map<String, dynamic>> _exerciseLogs = [];
  final List<Map<String, dynamic>> _currentExerciseSets = [];
  
  // Current set inputs
  double _currentWeight = 0;
  int _currentReps = 0;
  int _currentRPE = 7;
  
  // All exercises (flattened from sections)
  List<WorkoutExercise> _allExercises = [];
  
  // Last workout data for suggestions
  Map<String, Map<String, dynamic>> _lastPerformance = {};
  String? _weightSuggestion;

  @override
  void initState() {
    super.initState();
    _startWorkoutTimer();
    _loadLastPerformance();
  }
  
  Future<void> _loadLastPerformance() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    
    try {
      // Fetch last workout performance for exercises in this workout
      final exerciseLogs = await supabase
          .from('exercise_logs')
          .select('''
            exercise_id,
            set_logs (weight, reps, rpe)
          ''')
          .eq('workout_log_id', widget.workoutId)
          .order('created_at', ascending: false)
          .limit(10);
      
      // Process into map
      for (final log in exerciseLogs as List) {
        final exerciseId = log['exercise_id'] as String?;
        if (exerciseId == null) continue;
        
        final sets = log['set_logs'] as List?;
        if (sets != null && sets.isNotEmpty) {
          // Get best set (highest weight)
          double maxWeight = 0;
          int repsAtMaxWeight = 0;
          
          for (final set in sets) {
            final weight = (set['weight'] as num?)?.toDouble() ?? 0;
            if (weight > maxWeight) {
              maxWeight = weight;
              repsAtMaxWeight = set['reps'] as int? ?? 0;
            }
          }
          
          if (maxWeight > 0) {
            _lastPerformance[exerciseId] = {
              'weight': maxWeight,
              'reps': repsAtMaxWeight,
            };
          }
        }
      }
      
      _updateWeightSuggestion();
    } catch (e) {
      print('Error loading last performance: $e');
    }
  }
  
  void _updateWeightSuggestion() {
    if (_allExercises.isEmpty || _currentExerciseIndex >= _allExercises.length) {
      setState(() => _weightSuggestion = null);
      return;
    }
    
    final exercise = _allExercises[_currentExerciseIndex];
    final exerciseId = exercise.exerciseId;
    
    if (!_lastPerformance.containsKey(exerciseId)) {
      setState(() => _weightSuggestion = null);
      return;
    }
    
    final lastData = _lastPerformance[exerciseId]!;
    final lastWeight = lastData['weight'] as double;
    final lastReps = lastData['reps'] as int;
    final targetReps = exercise.reps ?? 10;
    
    // Check if they exceeded target last time
    if (lastReps >= targetReps + 2) {
      // Apply 2-for-2 progression
      final increment = _isUpperBodyExercise(exercise) ? 5.0 : 10.0;
      final newWeight = lastWeight + increment;
      setState(() {
        _weightSuggestion = 'Try ${newWeight.toStringAsFixed(0)} lbs (↑${increment.toStringAsFixed(0)})';
        if (_currentWeight == 0) _currentWeight = newWeight;
      });
    } else if (lastReps < targetReps - 2) {
      // Suggest reducing weight
      final reduction = 5.0;
      final newWeight = lastWeight - reduction;
      setState(() {
        _weightSuggestion = 'Consider ${newWeight.toStringAsFixed(0)} lbs (↓${reduction.toStringAsFixed(0)})';
        if (_currentWeight == 0) _currentWeight = newWeight > 0 ? newWeight : lastWeight;
      });
    } else {
      // Keep same weight
      setState(() {
        _weightSuggestion = 'Repeat ${lastWeight.toStringAsFixed(0)} lbs';
        if (_currentWeight == 0) _currentWeight = lastWeight;
      });
    }
  }
  
  bool _isUpperBodyExercise(WorkoutExercise exercise) {
    final upperBodyPatterns = ['push', 'pull', 'isolation'];
    final upperBodyMuscles = ['chest', 'back', 'lats', 'shoulders', 'biceps', 'triceps', 'delts'];
    
    final pattern = exercise.exercise?.movementPattern?.toLowerCase() ?? '';
    final primaryMuscles = exercise.exercise?.primaryMuscles ?? [];
    
    if (upperBodyPatterns.contains(pattern)) return true;
    for (final muscle in primaryMuscles) {
      if (upperBodyMuscles.contains(muscle.toLowerCase())) return true;
    }
    
    return false;
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    _workoutTimer?.cancel();
    super.dispose();
  }

  void _startWorkoutTimer() {
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _totalWorkoutSeconds++;
        });
      }
    });
  }

  void _startRestTimer(int seconds) {
    setState(() {
      _isResting = true;
      _restTimeRemaining = seconds;
    });
    
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restTimeRemaining > 0) {
        setState(() {
          _restTimeRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isResting = false;
        });
        // Vibrate to signal rest is over
        HapticFeedback.mediumImpact();
      }
    });
  }

  void _skipRest() {
    _restTimer?.cancel();
    setState(() {
      _isResting = false;
      _restTimeRemaining = 0;
    });
  }

  void _logSet() {
    print('LOG SET called: weight=$_currentWeight, reps=$_currentReps');
    
    if (_currentWeight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a weight'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    if (_currentReps <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter reps'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    // Get target sets based on mode
    int targetSets = 4; // Default for demo
    int restSeconds = 90;
    
    if (_isDemoMode && _demoExercises.isNotEmpty && _currentExerciseIndex < _demoExercises.length) {
      targetSets = _demoExercises[_currentExerciseIndex]['sets'] as int? ?? 4;
      restSeconds = _demoExercises[_currentExerciseIndex]['rest'] as int? ?? 90;
    } else if (_allExercises.isNotEmpty && _currentExerciseIndex < _allExercises.length) {
      final exercise = _allExercises[_currentExerciseIndex];
      targetSets = exercise.sets ?? 4;
      restSeconds = exercise.restSeconds ?? 90;
    }
    
    print('Target sets: $targetSets, current set index: $_currentSetIndex');
    
    // Calculate estimated 1RM
    final estimated1RM = ProgressiveOverloadEngine.estimateOneRepMax(
      _currentWeight,
      _currentReps,
    );
    
    // Add set to current exercise sets
    _currentExerciseSets.add({
      'set_number': _currentSetIndex + 1,
      'weight': _currentWeight,
      'reps': _currentReps,
      'rpe': _currentRPE,
      'estimated_1rm': estimated1RM,
      'is_pr': false,
    });
    
    // Increment set counter
    final completedSetNumber = _currentSetIndex + 1;
    _currentSetIndex++;
    
    print('Set $completedSetNumber logged! Total sets now: ${_currentExerciseSets.length}');
    
    // Force UI update
    setState(() {});
    
    // Immediate feedback
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Set $completedSetNumber: ${_currentWeight.toStringAsFixed(0)}lbs × $_currentReps reps'),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
    
    // Check if all sets completed for this exercise
    if (_currentSetIndex >= targetSets) {
      print('All sets complete! Moving to next exercise...');
      _completeExercise();
    } else {
      // Start rest timer
      print('Starting rest timer: $restSeconds seconds');
      _startRestTimer(restSeconds);
    }
  }

  void _completeExercise() {
    String? exerciseId;
    String exerciseName;
    
    if (_isDemoMode && _demoExercises.isNotEmpty) {
      final demoEx = _demoExercises[_currentExerciseIndex];
      exerciseId = demoEx['id'] as String?;
      exerciseName = demoEx['name'] as String;
    } else if (_allExercises.isNotEmpty) {
      final exercise = _allExercises[_currentExerciseIndex];
      exerciseId = exercise.exerciseId;
      exerciseName = exercise.exercise?.name ?? 'Unknown';
    } else {
      exerciseName = 'Unknown Exercise';
    }
    
    // Save exercise log
    _exerciseLogs.add({
      'exercise_id': exerciseId,
      'exercise_name': exerciseName,
      'sets': List.from(_currentExerciseSets),
      'notes': null,
    });
    
    // Move to next exercise
    final maxExercises = _isDemoMode ? _demoExercises.length : _allExercises.length;
    if (_currentExerciseIndex < maxExercises - 1) {
      setState(() {
        _currentExerciseIndex++;
        _currentSetIndex = 0;
        _currentExerciseSets.clear();
        _currentWeight = 0;
        _currentReps = 0;
      });
      _updateWeightSuggestion();
    } else {
      // Workout complete
      if (_isDemoMode) {
        _completeDemoWorkout();
      } else {
        _completeWorkout();
      }
    }
  }

  Future<void> _completeWorkout() async {
    _workoutTimer?.cancel();
    _restTimer?.cancel();
    
    // Log workout to database
    final workoutLogId = await WorkoutRepository().logWorkout(
      workoutId: widget.workoutId,
      durationSeconds: _totalWorkoutSeconds,
      exerciseLogs: _exerciseLogs,
    );
    
    if (mounted) {
      context.go('/workout-complete', extra: workoutLogId);
    }
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final workoutAsync = ref.watch(workoutProvider(widget.workoutId));
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: workoutAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (workout) {
          if (workout == null) {
            // Use demo workout
            return _buildDemoWorkout();
          }
          
          // Flatten all exercises from training sections
          // Include 'training', 'main', and 'strength' section types as they contain primary exercises
          if (_allExercises.isEmpty) {
            final trainingTypes = {'training', 'main', 'strength', 'power', 'volume', 'heavy compound'};
            final trainingSections = workout.sections
                ?.where((s) => trainingTypes.contains(s.sectionType.toLowerCase()))
                .toList() ?? [];
            
            if (trainingSections.isNotEmpty) {
              _allExercises = trainingSections
                  .expand((s) => s.exercises ?? <WorkoutExercise>[])
                  .toList();
            }
            
            // Fallback: use all exercises from all sections if still empty
            if (_allExercises.isEmpty) {
              _allExercises = workout.allExercises;
            }
          }
          
          if (_allExercises.isEmpty) {
            return _buildDemoWorkout();
          }
          
          final currentExercise = _allExercises[_currentExerciseIndex];
          final targetSets = currentExercise.sets ?? 3;
          final targetReps = currentExercise.reps ?? 10;
          
          // Get the best available GIF/Image URL from the exercise model
          final exerciseImageUrl = currentExercise.exercise?.bestGifUrl ?? 
                                  currentExercise.exercise?.bestImageUrl;
          
          return _buildWorkoutUI(
            workoutName: workout.name,
            exerciseName: currentExercise.exercise?.name ?? 'Exercise',
            targetSets: targetSets,
            targetReps: targetReps,
            restSeconds: currentExercise.restSeconds ?? 90,
            exerciseImageUrl: exerciseImageUrl,
          );
        },
      ),
    );
  }
  
  List<Map<String, dynamic>> _demoExercises = [];
  
  Widget _buildDemoWorkout() {
    // Demo exercises for when no data is loaded
    // IDs match the 016_comprehensive_exercise_library.sql migration format
    // If exercises don't exist, the workout will still log without exercise_id references
    if (_demoExercises.isEmpty) {
      _demoExercises = [
        {'id': 'ex_barbell_bench_press', 'name': 'Barbell Bench Press', 'sets': 4, 'reps': 8, 'rest': 120},
        {'id': 'ex_overhead_press', 'name': 'Overhead Press', 'sets': 3, 'reps': 10, 'rest': 90},
        {'id': 'ex_incline_dumbbell_press', 'name': 'Incline Dumbbell Press', 'sets': 3, 'reps': 12, 'rest': 90},
        {'id': 'ex_dips', 'name': 'Dips', 'sets': 3, 'reps': 10, 'rest': 90},
        {'id': 'ex_cable_tricep_pushdown', 'name': 'Tricep Pushdowns', 'sets': 3, 'reps': 15, 'rest': 60},
        {'id': 'ex_lateral_raise', 'name': 'Lateral Raise', 'sets': 3, 'reps': 12, 'rest': 60},
      ];
    }
    
    if (_currentExerciseIndex >= _demoExercises.length) {
      _completeDemoWorkout();
      return const Center(child: CircularProgressIndicator());
    }
    
    final exercise = _demoExercises[_currentExerciseIndex];
    
    return _buildWorkoutUI(
      workoutName: 'Push Day',
      exerciseName: exercise['name'] as String,
      targetSets: exercise['sets'] as int,
      targetReps: exercise['reps'] as int,
      restSeconds: exercise['rest'] as int,
      isDemo: true,
    );
  }
  
  Future<void> _completeDemoWorkout() async {
    _workoutTimer?.cancel();
    _restTimer?.cancel();
    
    // Log workout to database with demo workout ID
    try {
      final workoutLogId = await WorkoutRepository().logDemoWorkout(
        durationSeconds: _totalWorkoutSeconds,
        exerciseLogs: _exerciseLogs,
      );
      
      if (mounted) {
        context.go('/workout-complete', extra: workoutLogId);
      }
    } catch (e) {
      print('Error completing demo workout: $e');
      if (mounted) {
        context.go('/workout-complete');
      }
    }
  }
  
  bool _isDemoMode = false;
  
  Widget _buildWorkoutUI({
    required String workoutName,
    required String exerciseName,
    required int targetSets,
    required int targetReps,
    required int restSeconds,
    bool isDemo = false,
    String? exerciseImageUrl,
  }) {
    _isDemoMode = isDemo;
    return Stack(
      children: [
        // Main content
        SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: AppSpacing.screenHorizontalPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => _showExitDialog(),
                      child: Row(
                        children: [
                          const Icon(Icons.close, size: 24),
                          AppSpacing.horizontalSM,
                          Text('Exit', style: AppTypography.bodyMedium),
                        ],
                      ),
                    ),
                    // Workout timer
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isPaused ? Icons.pause : Icons.timer_outlined,
                            size: 16,
                            color: AppColors.secondary,
                          ),
                          AppSpacing.horizontalXS,
                          Text(
                            _formatTime(_totalWorkoutSeconds),
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                      onPressed: _togglePause,
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalMD,
              
              // Exercise progress
              Padding(
                padding: AppSpacing.screenHorizontalPadding,
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: (_currentExerciseIndex + (_currentSetIndex / targetSets)) / 
                             (_allExercises.isEmpty ? 5 : _allExercises.length),
                      backgroundColor: AppColors.surface,
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    ),
                    AppSpacing.verticalSM,
                    Text(
                      'Exercise ${_currentExerciseIndex + 1}/${_allExercises.isEmpty ? 5 : _allExercises.length}',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalLG,
              
              // Current exercise
              Expanded(
                child: _isResting 
                    ? _buildRestScreen(restSeconds)
                    : _buildExerciseScreen(
                        exerciseName: exerciseName,
                        targetSets: targetSets,
                        targetReps: targetReps,
                        exerciseImageUrl: exerciseImageUrl,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildExerciseScreen({
    required String exerciseName,
    required int targetSets,
    required int targetReps,
    String? exerciseImageUrl,
  }) {
    // Try local asset first, then network URL
    final localAsset = ExerciseAssets.getLocalAsset(exerciseName);
    final networkUrl = exerciseImageUrl ?? GifService().getGifUrl(exerciseName);
    debugPrint('Exercise "$exerciseName": local=$localAsset, network=$networkUrl');
    
    return SingleChildScrollView(
      padding: AppSpacing.screenHorizontalPadding,
      child: Column(
        children: [
          // Exercise GIF/Image
          Container(
            height: 180,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildExerciseImage(exerciseName, localAsset, networkUrl),
            ),
          ),
          
          // Exercise name
          Text(
            exerciseName,
            style: AppTypography.displaySmall,
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalSM,
          Text(
            'Set ${_currentSetIndex + 1} of $targetSets  •  Target: $targetReps reps',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          AppSpacing.verticalMD,
          
          // Show completed sets
          if (_currentExerciseSets.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Completed Sets:',
                    style: AppTypography.labelMedium.copyWith(color: Colors.green),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _currentExerciseSets.map((set) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Set ${set['set_number']}: ${(set['weight'] as double).toStringAsFixed(0)}lb × ${set['reps']}',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          
          AppSpacing.verticalMD,
          
          // Weight input with suggestion
          _InputCard(
            label: 'Weight (lbs)',
            value: _currentWeight,
            onChanged: (v) => setState(() => _currentWeight = v),
            increment: 5,
            suggestion: _weightSuggestion,
          ),
          AppSpacing.verticalMD,
          
          // Reps input
          _InputCard(
            label: 'Reps',
            value: _currentReps.toDouble(),
            onChanged: (v) => setState(() => _currentReps = v.toInt()),
            increment: 1,
            isWholeNumber: true,
          ),
          AppSpacing.verticalMD,
          
          // RPE slider
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('RPE (Rate of Perceived Exertion)', style: AppTypography.labelMedium),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRPEColor(_currentRPE).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$_currentRPE',
                        style: AppTypography.titleMedium.copyWith(
                          color: _getRPEColor(_currentRPE),
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.verticalMD,
                Slider(
                  value: _currentRPE.toDouble(),
                  min: 5,
                  max: 10,
                  divisions: 5,
                  activeColor: _getRPEColor(_currentRPE),
                  onChanged: (v) => setState(() => _currentRPE = v.toInt()),
                ),
                Text(
                  _getRPEDescription(_currentRPE),
                  style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          AppSpacing.verticalLG,
          
          // Completed sets
          if (_currentExerciseSets.isNotEmpty) ...[
            Text('Completed Sets', style: AppTypography.titleMedium),
            AppSpacing.verticalMD,
            ..._currentExerciseSets.asMap().entries.map((entry) {
              final set = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.success.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Set ${set['set_number']}', style: AppTypography.labelMedium),
                      Text(
                        '${set['weight']} lbs × ${set['reps']} reps  @RPE ${set['rpe']}',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.success),
                      ),
                    ],
                  ),
                ),
              );
            }),
            AppSpacing.verticalMD,
          ],
          
          // Log set button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _logSet,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                _currentSetIndex == ((_allExercises.isEmpty ? 4 : (_allExercises[_currentExerciseIndex].sets ?? 3)) - 1)
                    ? 'Complete Exercise'
                    : 'Log Set',
                style: AppTypography.buttonLarge,
              ),
            ),
          ),
          AppSpacing.verticalXL,
        ],
      ),
    );
  }
  
  Widget _buildExerciseImage(String exerciseName, String? localAsset, String networkUrl) {
    // Try local asset first
    if (localAsset != null) {
      return Image.asset(
        localAsset,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // If local asset fails, try network
          return _buildNetworkImage(networkUrl);
        },
      );
    }
    
    // Fall back to network image
    return _buildNetworkImage(networkUrl);
  }
  
  Widget _buildNetworkImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Center(
        child: Icon(
          Icons.fitness_center,
          size: 48,
          color: AppColors.textMuted,
        ),
      );
    }
    
    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / 
                  loadingProgress.expectedTotalBytes!
                : null,
            color: AppColors.primary,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Icon(
            Icons.fitness_center,
            size: 48,
            color: AppColors.textMuted,
          ),
        );
      },
    );
  }
  
  Widget _buildRestScreen(int totalRestSeconds) {
    // Get the last logged set for display
    final lastSet = _currentExerciseSets.isNotEmpty ? _currentExerciseSets.last : null;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Show what was just logged
          if (lastSet != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Set ${lastSet['set_number']}: ${lastSet['weight']}lbs × ${lastSet['reps']} reps',
                    style: AppTypography.titleSmall.copyWith(color: AppColors.success),
                  ),
                ],
              ),
            ),
            AppSpacing.verticalXL,
          ],
          
          Text(
            'REST',
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 4,
            ),
          ),
          AppSpacing.verticalLG,
          Text(
            _formatTime(_restTimeRemaining),
            style: AppTypography.timer.copyWith(
              fontSize: 72,
              color: AppColors.secondary,
            ),
          ),
          AppSpacing.verticalLG,
          // Rest progress
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: LinearProgressIndicator(
              value: 1 - (_restTimeRemaining / totalRestSeconds),
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation(AppColors.secondary),
            ),
          ),
          AppSpacing.verticalXL,
          // Large skip rest button
          ElevatedButton.icon(
            onPressed: _skipRest,
            icon: const Icon(Icons.skip_next),
            label: const Text('Continue to Next Set'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
          AppSpacing.verticalLG,
          Text(
            'Next: Set ${_currentSetIndex + 1}',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
  
  Color _getRPEColor(int rpe) {
    if (rpe <= 6) return AppColors.success;
    if (rpe <= 8) return AppColors.warning;
    return AppColors.error;
  }
  
  String _getRPEDescription(int rpe) {
    return switch (rpe) {
      5 => 'Very Light - Could do 5+ more reps',
      6 => 'Light - Could do 4 more reps',
      7 => 'Moderate - Could do 3 more reps',
      8 => 'Hard - Could do 2 more reps',
      9 => 'Very Hard - Could do 1 more rep',
      10 => 'Maximum - Could not do another rep',
      _ => '',
    };
  }
  
  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Exit Workout?'),
        content: const Text('Your progress will be lost if you exit now.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Workout'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: Text(
              'Exit',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final double increment;
  final bool isWholeNumber;
  final String? suggestion;

  const _InputCard({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.increment,
    this.isWholeNumber = false,
    this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(label, style: AppTypography.labelMedium),
          AppSpacing.verticalMD,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (value > 0) {
                    onChanged(value - increment);
                    HapticFeedback.selectionClick();
                  }
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.inputFill,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.remove, size: 20),
                ),
              ),
              AppSpacing.horizontalMD,
              Text(
                isWholeNumber ? value.toInt().toString() : value.toStringAsFixed(1),
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.horizontalMD,
              IconButton(
                onPressed: () {
                  onChanged(value + increment);
                  HapticFeedback.selectionClick();
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, size: 20, color: AppColors.primary),
                ),
              ),
            ],
          ),
          // Weight suggestion (progressive overload)
          if (suggestion != null) ...[
            AppSpacing.verticalMD,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.secondary.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.secondary.withAlpha(60),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 14,
                    color: AppColors.secondary,
                  ),
                  AppSpacing.horizontalXS,
                  Text(
                    suggestion!,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
