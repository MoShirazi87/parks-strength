import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';

/// Active workout screen - full-screen workout player with logging
class ActiveWorkoutScreen extends StatefulWidget {
  final String workoutId;

  const ActiveWorkoutScreen({super.key, required this.workoutId});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen>
    with TickerProviderStateMixin {
  // Workout state
  int _currentExerciseIndex = 0;
  int _currentSetIndex = 0;
  Timer? _restTimer;
  int _restTimeRemaining = 0;
  bool _isResting = false;
  DateTime? _workoutStartTime;
  
  // Animation controllers
  late AnimationController _pulseController;

  // Demo exercises data
  final List<_WorkoutExercise> _exercises = [
    _WorkoutExercise(
      id: 'bench-press',
      name: 'Bench Press',
      groupLetter: 'A',
      targetSets: 4,
      targetReps: 8,
      suggestedWeight: 135,
      restSeconds: 90,
      gifUrl: 'https://v2.exercisedb.io/image/yKZ6SZxmFluOWY',
      notes: 'Control the descent, explosive push',
    ),
    _WorkoutExercise(
      id: 'incline-db-press',
      name: 'Incline Dumbbell Press',
      groupLetter: 'B',
      targetSets: 3,
      targetReps: 10,
      suggestedWeight: 50,
      restSeconds: 75,
      gifUrl: 'https://v2.exercisedb.io/image/jKqZ8CxLn2E1wN',
      notes: '30-degree incline angle',
    ),
    _WorkoutExercise(
      id: 'cable-fly',
      name: 'Cable Fly',
      groupLetter: 'C',
      targetSets: 3,
      targetReps: 12,
      suggestedWeight: 30,
      restSeconds: 60,
      gifUrl: 'https://v2.exercisedb.io/image/xKqP8SxNm3A1bB',
      notes: 'Squeeze at the peak contraction',
    ),
    _WorkoutExercise(
      id: 'overhead-press',
      name: 'Overhead Press',
      groupLetter: 'D',
      targetSets: 3,
      targetReps: 8,
      suggestedWeight: 95,
      restSeconds: 90,
      gifUrl: 'https://v2.exercisedb.io/image/pLnM7TvQk4C2dD',
      notes: 'Keep core tight, full lockout',
    ),
  ];

  // Set logs for each exercise
  late List<List<_SetLog>> _setLogs;

  @override
  void initState() {
    super.initState();
    _workoutStartTime = DateTime.now();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    // Initialize empty set logs for each exercise
    _setLogs = _exercises.map((e) => <_SetLog>[]).toList();
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  _WorkoutExercise get _currentExercise => _exercises[_currentExerciseIndex];
  
  int get _completedSets => _setLogs[_currentExerciseIndex].length;

  void _logSet({required int reps, required double weight, int? rpe}) {
    final setLog = _SetLog(
      setNumber: _completedSets + 1,
      reps: reps,
      weight: weight,
      rpe: rpe,
      timestamp: DateTime.now(),
    );

    setState(() {
      _setLogs[_currentExerciseIndex].add(setLog);
      _currentSetIndex = _completedSets;
    });

    // Check if all sets completed
    if (_completedSets >= _currentExercise.targetSets) {
      _nextExercise();
    } else {
      // Start rest timer
      _startRestTimer();
    }

    // Haptic feedback
    HapticFeedback.mediumImpact();
  }

  void _startRestTimer() {
    setState(() {
      _isResting = true;
      _restTimeRemaining = _currentExercise.restSeconds;
    });

    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restTimeRemaining > 0) {
        setState(() => _restTimeRemaining--);
      } else {
        _skipRest();
      }
    });
  }

  void _skipRest() {
    _restTimer?.cancel();
    setState(() => _isResting = false);
    HapticFeedback.lightImpact();
  }

  void _addRestTime(int seconds) {
    setState(() => _restTimeRemaining += seconds);
  }

  void _nextExercise() {
    _restTimer?.cancel();
    setState(() => _isResting = false);

    if (_currentExerciseIndex < _exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _currentSetIndex = 0;
      });
    } else {
      _completeWorkout();
    }
  }

  void _previousExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
        _currentSetIndex = _setLogs[_currentExerciseIndex].length;
      });
    }
  }

  void _completeWorkout() {
    final duration = DateTime.now().difference(_workoutStartTime!);
    // Navigate to completion screen
    context.go(AppRoutes.workoutComplete, extra: widget.workoutId);
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Exercise demo (top section)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: _ExerciseDemoSection(
              exercise: _currentExercise,
              onBack: () => _showExitDialog(context),
            ),
          ),

          // Bottom control panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _isResting
                ? _RestTimerPanel(
                    timeRemaining: _restTimeRemaining,
                    onSkip: _skipRest,
                    onAddTime: () => _addRestTime(30),
                    nextExerciseName: _completedSets >= _currentExercise.targetSets
                        ? (_currentExerciseIndex < _exercises.length - 1
                            ? _exercises[_currentExerciseIndex + 1].name
                            : 'Workout Complete')
                        : 'Set ${_completedSets + 1}',
                  )
                : _SetLoggingPanel(
                    exercise: _currentExercise,
                    currentSet: _completedSets + 1,
                    previousSets: _setLogs[_currentExerciseIndex],
                    onLogSet: _logSet,
                    onNextExercise: _nextExercise,
                    isLastExercise: _currentExerciseIndex == _exercises.length - 1,
                  ),
          ),

          // Exercise navigation dots
          Positioned(
            top: MediaQuery.of(context).size.height * 0.42,
            left: 0,
            right: 0,
            child: _ExerciseProgressDots(
              totalExercises: _exercises.length,
              currentIndex: _currentExerciseIndex,
              completedIndices: List.generate(
                _exercises.length,
                (i) => _setLogs[i].length >= _exercises[i].targetSets,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AppSpacing.verticalLG,
            Text(
              'End Workout?',
              style: AppTypography.headlineMedium,
            ),
            AppSpacing.verticalSM,
            Text(
              'Your progress will be saved.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.verticalLG,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: AppTypography.buttonMedium,
                    ),
                  ),
                ),
                AppSpacing.horizontalMD,
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'End & Save',
                      style: AppTypography.buttonMedium,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.verticalLG,
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EXERCISE DEMO SECTION
// ═══════════════════════════════════════════════════════════════════════════

class _ExerciseDemoSection extends StatelessWidget {
  final _WorkoutExercise exercise;
  final VoidCallback onBack;

  const _ExerciseDemoSection({
    required this.exercise,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // GIF background with placeholder
        Container(
          color: AppColors.surface,
          child: exercise.gifUrl != null
              ? CachedNetworkImage(
                  imageUrl: exercise.gifUrl!,
                  fit: BoxFit.contain,
                  placeholder: (_, __) => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                  errorWidget: (_, __, ___) => _ExercisePlaceholder(
                    exerciseName: exercise.name,
                  ),
                )
              : _ExercisePlaceholder(exerciseName: exercise.name),
        ),

        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withAlpha(120),
                Colors.transparent,
                Colors.transparent,
                AppColors.background,
              ],
              stops: const [0.0, 0.2, 0.7, 1.0],
            ),
          ),
        ),

        // Top controls
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                GestureDetector(
                  onTap: onBack,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.glassBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.glassStroke),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),

                // Exercise group letter
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      exercise.groupLetter,
                      style: AppTypography.exerciseLetter.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Exercise info at bottom
        Positioned(
          bottom: 16,
          left: AppSpacing.screenHorizontal,
          right: AppSpacing.screenHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercise.name.toUpperCase(),
                style: AppTypography.headlineLarge.copyWith(
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              if (exercise.notes != null) ...[
                AppSpacing.verticalXS,
                Text(
                  exercise.notes!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ExercisePlaceholder extends StatelessWidget {
  final String exerciseName;

  const _ExercisePlaceholder({required this.exerciseName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withAlpha(40),
            AppColors.tertiary.withAlpha(30),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center_rounded,
              size: 64,
              color: AppColors.primary.withAlpha(150),
            ),
            AppSpacing.verticalMD,
            Text(
              exerciseName,
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SET LOGGING PANEL
// ═══════════════════════════════════════════════════════════════════════════

class _SetLoggingPanel extends StatefulWidget {
  final _WorkoutExercise exercise;
  final int currentSet;
  final List<_SetLog> previousSets;
  final void Function({required int reps, required double weight, int? rpe}) onLogSet;
  final VoidCallback onNextExercise;
  final bool isLastExercise;

  const _SetLoggingPanel({
    required this.exercise,
    required this.currentSet,
    required this.previousSets,
    required this.onLogSet,
    required this.onNextExercise,
    required this.isLastExercise,
  });

  @override
  State<_SetLoggingPanel> createState() => _SetLoggingPanelState();
}

class _SetLoggingPanelState extends State<_SetLoggingPanel> {
  late int _reps;
  late double _weight;
  int? _rpe;

  @override
  void initState() {
    super.initState();
    // Initialize with suggested or last logged values
    if (widget.previousSets.isNotEmpty) {
      final lastSet = widget.previousSets.last;
      _reps = lastSet.reps;
      _weight = lastSet.weight;
    } else {
      _reps = widget.exercise.targetReps;
      _weight = widget.exercise.suggestedWeight;
    }
  }

  void _adjustReps(int delta) {
    setState(() {
      _reps = (_reps + delta).clamp(1, 99);
    });
    HapticFeedback.selectionClick();
  }

  void _adjustWeight(double delta) {
    setState(() {
      _weight = (_weight + delta).clamp(0, 999);
    });
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = widget.currentSet > widget.exercise.targetSets;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AppSpacing.verticalMD,

              // Set indicator
              Text(
                isComplete
                    ? 'All Sets Complete!'
                    : 'SET ${widget.currentSet} OF ${widget.exercise.targetSets}',
                style: AppTypography.labelMedium.copyWith(
                  color: isComplete ? AppColors.success : Colors.grey.shade600,
                  letterSpacing: 1.5,
                ),
              ),
              AppSpacing.verticalLG,

              if (!isComplete) ...[
                // Weight and reps inputs
                Row(
                  children: [
                    // Weight input
                    Expanded(
                      child: _InputCard(
                        label: 'WEIGHT (LBS)',
                        value: _weight.toStringAsFixed(1),
                        onIncrement: () => _adjustWeight(5),
                        onDecrement: () => _adjustWeight(-5),
                        onLongPressIncrement: () => _adjustWeight(10),
                        onLongPressDecrement: () => _adjustWeight(-10),
                      ),
                    ),
                    AppSpacing.horizontalMD,
                    // Reps input
                    Expanded(
                      child: _InputCard(
                        label: 'REPS',
                        value: _reps.toString(),
                        onIncrement: () => _adjustReps(1),
                        onDecrement: () => _adjustReps(-1),
                        onLongPressIncrement: () => _adjustReps(5),
                        onLongPressDecrement: () => _adjustReps(-5),
                      ),
                    ),
                  ],
                ),
                AppSpacing.verticalLG,

                // Previous sets summary
                if (widget.previousSets.isNotEmpty)
                  _PreviousSetsSummary(sets: widget.previousSets),

                AppSpacing.verticalMD,

                // Log set button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => widget.onLogSet(
                      reps: _reps,
                      weight: _weight,
                      rpe: _rpe,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_rounded, color: Colors.white),
                        AppSpacing.horizontalSM,
                        Text(
                          'LOG SET',
                          style: AppTypography.buttonLarge.copyWith(
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().scale(
                  duration: 200.ms,
                  curve: Curves.easeOut,
                ),
              ] else ...[
                // All sets complete - show next button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: widget.onNextExercise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      widget.isLastExercise ? 'FINISH WORKOUT' : 'NEXT EXERCISE',
                      style: AppTypography.buttonLarge.copyWith(
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback? onLongPressIncrement;
  final VoidCallback? onLongPressDecrement;

  const _InputCard({
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    this.onLongPressIncrement,
    this.onLongPressDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: Colors.grey.shade600,
              letterSpacing: 1,
            ),
          ),
          AppSpacing.verticalSM,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onDecrement,
                onLongPress: onLongPressDecrement,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(Icons.remove, color: Colors.black54),
                ),
              ),
              Text(
                value,
                style: AppTypography.statValue.copyWith(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
              GestureDetector(
                onTap: onIncrement,
                onLongPress: onLongPressIncrement,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviousSetsSummary extends StatelessWidget {
  final List<_SetLog> sets;

  const _PreviousSetsSummary({required this.sets});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: sets.map((set) {
          return Column(
            children: [
              Text(
                'Set ${set.setNumber}',
                style: AppTypography.caption.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              AppSpacing.verticalXS,
              Text(
                '${set.weight.toStringAsFixed(0)} × ${set.reps}',
                style: AppTypography.labelMedium.copyWith(
                  color: Colors.black87,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// REST TIMER PANEL
// ═══════════════════════════════════════════════════════════════════════════

class _RestTimerPanel extends StatelessWidget {
  final int timeRemaining;
  final VoidCallback onSkip;
  final VoidCallback onAddTime;
  final String nextExerciseName;

  const _RestTimerPanel({
    required this.timeRemaining,
    required this.onSkip,
    required this.onAddTime,
    required this.nextExerciseName,
  });

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'REST',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                ),
              ),
              AppSpacing.verticalMD,

              // Timer display
              Text(
                _formatTime(timeRemaining),
                style: AppTypography.timerHuge.copyWith(
                  color: timeRemaining <= 10 
                      ? AppColors.error 
                      : AppColors.textPrimary,
                ),
              ).animate(target: timeRemaining <= 10 ? 1 : 0)
                .shake(duration: 500.ms),
              
              AppSpacing.verticalLG,

              // Controls
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onAddTime,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('+30s'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.horizontalMD,
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: onSkip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'SKIP REST',
                        style: AppTypography.buttonMedium.copyWith(
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              AppSpacing.verticalMD,

              // Next up
              Text(
                'Next: $nextExerciseName',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EXERCISE PROGRESS DOTS
// ═══════════════════════════════════════════════════════════════════════════

class _ExerciseProgressDots extends StatelessWidget {
  final int totalExercises;
  final int currentIndex;
  final List<bool> completedIndices;

  const _ExerciseProgressDots({
    required this.totalExercises,
    required this.currentIndex,
    required this.completedIndices,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalExercises, (index) {
        final isCompleted = completedIndices[index];
        final isCurrent = index == currentIndex;

        return Container(
          width: isCurrent ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.success
                : isCurrent
                    ? AppColors.primary
                    : AppColors.textMuted.withAlpha(80),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════════════════

class _WorkoutExercise {
  final String id;
  final String name;
  final String groupLetter;
  final int targetSets;
  final int targetReps;
  final double suggestedWeight;
  final int restSeconds;
  final String? gifUrl;
  final String? notes;

  const _WorkoutExercise({
    required this.id,
    required this.name,
    required this.groupLetter,
    required this.targetSets,
    required this.targetReps,
    required this.suggestedWeight,
    required this.restSeconds,
    this.gifUrl,
    this.notes,
  });
}

class _SetLog {
  final int setNumber;
  final int reps;
  final double weight;
  final int? rpe;
  final DateTime timestamp;

  const _SetLog({
    required this.setNumber,
    required this.reps,
    required this.weight,
    this.rpe,
    required this.timestamp,
  });

  double get volume => weight * reps;
}
