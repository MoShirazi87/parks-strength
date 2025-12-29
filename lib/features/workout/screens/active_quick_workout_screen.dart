import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/algorithms/progressive_overload.dart';
import '../../../data/services/gif_service.dart';
import '../../../data/services/workout_generator.dart';
import '../../../data/providers/workout_provider.dart';

/// Active workout screen for dynamically generated workouts
class ActiveQuickWorkoutScreen extends ConsumerStatefulWidget {
  final GeneratedWorkout workout;

  const ActiveQuickWorkoutScreen({super.key, required this.workout});

  @override
  ConsumerState<ActiveQuickWorkoutScreen> createState() => _ActiveQuickWorkoutScreenState();
}

class _ActiveQuickWorkoutScreenState extends ConsumerState<ActiveQuickWorkoutScreen> {
  // Workout state
  int _currentExerciseIndex = 0;
  int _currentSetIndex = 0;
  bool _isResting = false;
  int _restTimeRemaining = 0;
  Timer? _restTimer;
  Timer? _workoutTimer;
  int _totalWorkoutSeconds = 0;
  
  // Exercise logs
  final List<Map<String, dynamic>> _exerciseLogs = [];
  final List<Map<String, dynamic>> _currentExerciseSets = [];
  
  // Current set inputs
  double _currentWeight = 0;
  int _currentReps = 0;
  int _currentRPE = 7;

  GeneratedExercise get _currentExercise => widget.workout.training[_currentExerciseIndex];
  int get _totalExercises => widget.workout.training.length;

  @override
  void initState() {
    super.initState();
    _startWorkoutTimer();
  }

  void _startWorkoutTimer() {
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _totalWorkoutSeconds++;
        });
      }
    });
  }

  @override
  void dispose() {
    _workoutTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }

  void _logSet() {
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
    
    final targetSets = _currentExercise.sets;
    final restSeconds = _currentExercise.restSeconds;
    
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
      _completeExercise();
    } else {
      // Start rest timer
      _startRestTimer(restSeconds);
    }
  }

  void _startRestTimer(int seconds) {
    setState(() {
      _isResting = true;
      _restTimeRemaining = seconds;
    });
    
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_restTimeRemaining > 0) {
            _restTimeRemaining--;
          } else {
            _isResting = false;
            timer.cancel();
          }
        });
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

  void _completeExercise() {
    // Save exercise log
    _exerciseLogs.add({
      'exercise_id': _currentExercise.exerciseId,
      'exercise_name': _currentExercise.name,
      'sets': List.from(_currentExerciseSets),
      'notes': null,
    });
    
    // Move to next exercise
    if (_currentExerciseIndex < _totalExercises - 1) {
      setState(() {
        _currentExerciseIndex++;
        _currentSetIndex = 0;
        _currentExerciseSets.clear();
        _currentWeight = 0;
        _currentReps = _currentExercise.reps;
      });
    } else {
      // Workout complete
      _completeWorkout();
    }
  }

  Future<void> _completeWorkout() async {
    _workoutTimer?.cancel();
    _restTimer?.cancel();
    
    // Log workout to database
    try {
      final workoutLogId = await WorkoutRepository().logDemoWorkout(
        durationSeconds: _totalWorkoutSeconds,
        exerciseLogs: _exerciseLogs,
      );
      
      if (mounted) {
        context.go('/workout-complete', extra: workoutLogId);
      }
    } catch (e) {
      debugPrint('Error completing workout: $e');
      if (mounted) {
        context.go('/workout-complete');
      }
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(),
        ),
        title: Text(
          widget.workout.name,
          style: AppTypography.titleMedium,
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  _formatTime(_totalWorkoutSeconds),
                  style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isResting ? _buildRestScreen() : _buildExerciseScreen(),
    );
  }

  Widget _buildExerciseScreen() {
    final exercise = _currentExercise;
    final gifUrl = GifService().getGifUrl(exercise.name);
    
    return SingleChildScrollView(
      padding: AppSpacing.screenHorizontalPadding,
      child: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentExerciseIndex + 1) / _totalExercises,
            backgroundColor: AppColors.surface,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          AppSpacing.verticalMD,
          
          // Exercise GIF
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
              child: Image.network(
                gifUrl,
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
              ),
            ),
          ),
          
          // Exercise name and progress
          Text(
            exercise.name,
            style: AppTypography.displaySmall,
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalSM,
          Text(
            'Set ${_currentSetIndex + 1} of ${exercise.sets}  •  Target: ${exercise.reps} reps',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          if (exercise.equipmentNeeded != null) ...[
            AppSpacing.verticalXS,
            Text(
              'Equipment: ${exercise.equipmentNeeded}',
              style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
            ),
          ],
          AppSpacing.verticalMD,
          
          // Completed sets
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
                          '${set['weight']}lbs × ${set['reps']}',
                          style: AppTypography.labelMedium.copyWith(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          
          // Weight input
          _buildInputRow(
            label: 'Weight (lbs)',
            value: _currentWeight,
            onDecrement: () => setState(() => _currentWeight = (_currentWeight - 5).clamp(0, 1000)),
            onIncrement: () => setState(() => _currentWeight = (_currentWeight + 5).clamp(0, 1000)),
            onChanged: (val) => setState(() => _currentWeight = val),
          ),
          AppSpacing.verticalMD,
          
          // Reps input
          _buildInputRow(
            label: 'Reps',
            value: _currentReps.toDouble(),
            onDecrement: () => setState(() => _currentReps = (_currentReps - 1).clamp(0, 100)),
            onIncrement: () => setState(() => _currentReps = (_currentReps + 1).clamp(0, 100)),
            onChanged: (val) => setState(() => _currentReps = val.toInt()),
            isInteger: true,
          ),
          AppSpacing.verticalXL,
          
          // Log Set button
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
                _currentSetIndex < exercise.sets - 1
                    ? 'Log Set ${_currentSetIndex + 1}'
                    : 'Complete Exercise',
                style: AppTypography.buttonLarge,
              ),
            ),
          ),
          AppSpacing.verticalXL,
        ],
      ),
    );
  }

  Widget _buildInputRow({
    required String label,
    required double value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    required ValueChanged<double> onChanged,
    bool isInteger = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: onDecrement,
              icon: const Icon(Icons.remove_circle_outline),
              iconSize: 32,
              color: AppColors.textSecondary,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isInteger ? value.toInt().toString() : value.toStringAsFixed(0),
                  style: AppTypography.headlineLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 32,
              color: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRestScreen() {
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
          
          // Timer circle
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 4,
              ),
            ),
            child: Center(
              child: Text(
                _formatTime(_restTimeRemaining),
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          AppSpacing.verticalXL,
          
          // Skip button
          TextButton(
            onPressed: _skipRest,
            child: Text(
              'Skip Rest',
              style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
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
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/home');
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

