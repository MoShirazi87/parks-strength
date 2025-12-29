import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../data/services/workout_generator.dart';
import '../../../data/services/gif_service.dart';
import '../../../shared/widgets/app_button.dart';

/// Provider for generated workout
final generatedWorkoutProvider = FutureProvider.family<GeneratedWorkout, String>((ref, workoutType) async {
  return WorkoutGenerator().generateWorkout(workoutType: workoutType);
});

/// Screen for displaying a dynamically generated quick workout
class QuickWorkoutScreen extends ConsumerStatefulWidget {
  final String workoutType;

  const QuickWorkoutScreen({super.key, required this.workoutType});

  @override
  ConsumerState<QuickWorkoutScreen> createState() => _QuickWorkoutScreenState();
}

class _QuickWorkoutScreenState extends ConsumerState<QuickWorkoutScreen> {
  GeneratedWorkout? _workout;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generateWorkout();
  }

  Future<void> _generateWorkout() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final workout = await WorkoutGenerator().generateWorkout(
        workoutType: widget.workoutType,
        targetExercises: 5,
      );
      
      setState(() {
        _workout = workout;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _startWorkout() {
    if (_workout == null) return;
    
    // Navigate to the active workout screen with the generated workout
    context.push('/active-quick-workout', extra: _workout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? _buildLoading()
          : _error != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          AppSpacing.verticalLG,
          Text(
            'Generating your ${widget.workoutType} workout...',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
          ),
          AppSpacing.verticalSM,
          Text(
            'Based on your equipment & preferences',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: AppSpacing.screenHorizontalPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            AppSpacing.verticalLG,
            Text(
              'Failed to generate workout',
              style: AppTypography.headlineSmall,
            ),
            AppSpacing.verticalSM,
            Text(
              _error ?? 'Unknown error',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalXL,
            AppButton(
              text: 'Try Again',
              onPressed: _generateWorkout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final workout = _workout!;
    
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
        // App bar
        SliverAppBar(
          backgroundColor: AppColors.background,
          pinned: true,
          expandedHeight: 200,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _generateWorkout,
              tooltip: 'Generate new workout',
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              workout.name,
              style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimary),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _getWorkoutColor(widget.workoutType).withOpacity(0.3),
                    AppColors.background,
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  _getWorkoutIcon(widget.workoutType),
                  size: 80,
                  color: _getWorkoutColor(widget.workoutType).withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),

        // Workout info
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.screenHorizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.verticalMD,
                
                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatCard(
                      icon: Icons.fitness_center,
                      value: '${workout.exerciseCount}',
                      label: 'Exercises',
                    ),
                    _StatCard(
                      icon: Icons.layers,
                      value: '${workout.totalSets}',
                      label: 'Total Sets',
                    ),
                    _StatCard(
                      icon: Icons.timer,
                      value: '${workout.estimatedMinutes}',
                      label: 'Minutes',
                    ),
                    _StatCard(
                      icon: Icons.trending_up,
                      value: workout.difficulty[0].toUpperCase(),
                      label: 'Level',
                    ),
                  ],
                ).animate().fadeIn(delay: 100.ms),
                
                AppSpacing.verticalXL,
                
                // Description
                Text(
                  workout.description,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                
                AppSpacing.verticalXL,
                
                // Exercises header
                Text('Exercises', style: AppTypography.headlineSmall),
                AppSpacing.verticalMD,
              ],
            ),
          ),
        ),

        // Exercise list
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final exercise = workout.training[index];
              return _ExerciseCard(
                exercise: exercise,
                index: index,
              ).animate().fadeIn(delay: (150 + index * 50).ms).slideX(begin: 0.1);
            },
            childCount: workout.training.length,
          ),
        ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ),
        ],
      ),
      
      // Start Workout Button
      Positioned(
        bottom: 24,
        left: 24,
        right: 24,
        child: AppButton(
          text: 'Start Workout',
          onPressed: _startWorkout,
          leftIcon: Icons.play_arrow_rounded,
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
      ),
      ],
    );
  }

  Color _getWorkoutColor(String type) {
    switch (type.toLowerCase()) {
      case 'push':
        return AppColors.primary;
      case 'pull':
        return AppColors.accent;
      case 'legs':
        return AppColors.success;
      case 'core':
        return AppColors.warning;
      case 'upper':
        return AppColors.primary;
      case 'lower':
        return AppColors.success;
      case 'fullbody':
        return AppColors.tertiary;
      default:
        return AppColors.primary;
    }
  }

  IconData _getWorkoutIcon(String type) {
    switch (type.toLowerCase()) {
      case 'push':
        return Icons.arrow_upward;
      case 'pull':
        return Icons.arrow_downward;
      case 'legs':
        return Icons.directions_run;
      case 'core':
        return Icons.circle_outlined;
      case 'upper':
        return Icons.accessibility_new;
      case 'lower':
        return Icons.airline_seat_legroom_extra;
      case 'fullbody':
        return Icons.person;
      default:
        return Icons.fitness_center;
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.headlineSmall),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final GeneratedExercise exercise;
  final int index;

  const _ExerciseCard({
    required this.exercise,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final gifUrl = GifService().getGifUrl(exercise.name);
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Exercise GIF
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.network(
                gifUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppColors.surface,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.surface,
                    child: const Center(
                      child: Icon(Icons.fitness_center, color: AppColors.textMuted),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Exercise details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Letter badge + name
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            exercise.letter ?? '${index + 1}',
                            style: AppTypography.labelMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          exercise.name,
                          style: AppTypography.titleSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Sets x Reps
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.layers,
                        text: '${exercise.sets} sets',
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.repeat,
                        text: '${exercise.reps} reps',
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.timer,
                        text: '${exercise.restSeconds}s rest',
                      ),
                    ],
                  ),
                  
                  // Equipment
                  if (exercise.equipmentNeeded != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      exercise.equipmentNeeded!,
                      style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

