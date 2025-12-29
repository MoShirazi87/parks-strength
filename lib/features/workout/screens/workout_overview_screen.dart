import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../data/providers/workout_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';

/// Workout overview before starting - connected to real data
class WorkoutOverviewScreen extends ConsumerWidget {
  final String workoutId;

  const WorkoutOverviewScreen({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutAsync = ref.watch(workoutProvider(workoutId));
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: workoutAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              AppSpacing.verticalMD,
              Text('Error loading workout', style: AppTypography.bodyLarge),
              AppSpacing.verticalSM,
              Text('$e', style: AppTypography.caption),
              AppSpacing.verticalLG,
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
        data: (workout) {
          if (workout == null) {
            return _buildDemoWorkout(context);
          }
          
          // Group sections by type
          final warmupSection = workout.sections?.firstWhere(
            (s) => s.sectionType == 'warmup',
            orElse: () => workout.sections!.first,
          );
          final trainingSection = workout.sections?.firstWhere(
            (s) => s.sectionType == 'training',
            orElse: () => workout.sections!.first,
          );
          final cooldownSection = workout.sections?.where(
            (s) => s.sectionType == 'cooldown' || s.sectionType == 'stretch',
          ).firstOrNull;
          
          return SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: AppSpacing.screenHorizontalPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_back),
                            AppSpacing.horizontalSM,
                            Text('Go Back', style: AppTypography.bodyMedium),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.info_outline),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AppSpacing.verticalMD,

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppSpacing.screenHorizontalPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Workout title
                        Text(workout.name, style: AppTypography.displaySmall),
                        AppSpacing.verticalSM,
                        Text(
                          workout.description ?? 'Complete this workout with proper form and intensity.',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        AppSpacing.verticalSM,
                        
                        // Duration and exercise count
                        Row(
                          children: [
                            Icon(Icons.timer_outlined, size: 16, color: AppColors.textSecondary),
                            AppSpacing.horizontalXS,
                            Text(
                              '${workout.estimatedDurationMinutes} min',
                              style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
                            ),
                            AppSpacing.horizontalMD,
                            Icon(Icons.fitness_center, size: 16, color: AppColors.textSecondary),
                            AppSpacing.horizontalXS,
                            Text(
                              '${workout.allExercises.length} exercises',
                              style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        AppSpacing.verticalLG,

                        // RAMP Warm-up section
                        if (warmupSection != null && warmupSection.exercises != null) ...[
                          _SectionHeader(
                            title: 'RAMP Warm-up',
                            subtitle: 'Raise • Activate • Mobilize • Potentiate',
                            icon: Icons.directions_run,
                            color: AppColors.streak,
                          ),
                          AppSpacing.verticalMD,
                          ...warmupSection.exercises!.map((e) => _TimedExerciseItem(
                            name: e.exercise?.name ?? 'Exercise',
                            time: e.timeSeconds != null ? _formatTime(e.timeSeconds!) : null,
                            reps: e.reps != null ? '${e.reps}x' : null,
                          )),
                          AppSpacing.verticalLG,
                        ],

                        // Training section
                        if (trainingSection != null && trainingSection.exercises != null) ...[
                          _SectionHeader(
                            title: 'Training',
                            subtitle: '${trainingSection.exercises!.length} exercises',
                            icon: Icons.fitness_center,
                            color: AppColors.primary,
                          ),
                          AppSpacing.verticalMD,
                          ...trainingSection.exercises!.asMap().entries.map((entry) {
                            final index = entry.key;
                            final exercise = entry.value;
                            final letter = String.fromCharCode(65 + index); // A, B, C...
                            return _ExerciseItem(
                              letter: exercise.letterDesignation ?? letter,
                              name: exercise.exercise?.name ?? 'Exercise',
                              sets: exercise.sets ?? 3,
                              reps: exercise.reps ?? 10,
                              restSeconds: exercise.restSeconds ?? 90,
                            );
                          }),
                          AppSpacing.verticalLG,
                        ],

                        // Cooldown section
                        if (cooldownSection != null) ...[
                          _CollapsibleSection(
                            title: 'Cooldown / Stretching',
                            initiallyExpanded: false,
                            children: cooldownSection.exercises?.map((e) => 
                              _TimedExerciseItem(
                                name: e.exercise?.name ?? 'Stretch',
                                time: e.timeSeconds != null ? _formatTime(e.timeSeconds!) : '30s',
                              )
                            ).toList() ?? [],
                          ),
                          AppSpacing.verticalMD,
                        ],

                        // Equipment section
                        _CollapsibleSection(
                          title: 'Equipment',
                          initiallyExpanded: false,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _getRequiredEquipment(workout.allExercises)
                                  .map((e) => _EquipmentChip(label: e))
                                  .toList(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(
              color: AppColors.border.withOpacity(0.5),
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: AppButton(
            text: 'Begin Workout',
            onPressed: () => context.push('/workout/$workoutId/active'),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDemoWorkout(BuildContext context) {
    // Fallback demo workout when no data
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.screenHorizontalPadding,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back),
                      AppSpacing.horizontalSM,
                      Text('Go Back', style: AppTypography.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.verticalMD,
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.screenHorizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Push Day', style: AppTypography.displaySmall),
                  AppSpacing.verticalSM,
                  Text(
                    'Upper body pushing focus: chest, shoulders, triceps',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                  ),
                  AppSpacing.verticalLG,
                  
                  _SectionHeader(
                    title: 'RAMP Warm-up',
                    subtitle: 'Raise • Activate • Mobilize • Potentiate',
                    icon: Icons.directions_run,
                    color: AppColors.streak,
                  ),
                  AppSpacing.verticalMD,
                  const _TimedExerciseItem(name: 'Arm Circles', time: '30s'),
                  const _TimedExerciseItem(name: 'Shoulder Dislocates', time: '30s'),
                  const _TimedExerciseItem(name: 'Band Pull-Aparts', reps: '15x'),
                  const _TimedExerciseItem(name: 'Push-up Plus', reps: '10x'),
                  AppSpacing.verticalLG,
                  
                  _SectionHeader(
                    title: 'Training',
                    subtitle: '5 exercises',
                    icon: Icons.fitness_center,
                    color: AppColors.primary,
                  ),
                  AppSpacing.verticalMD,
                  const _ExerciseItem(letter: 'A', name: 'Barbell Bench Press', sets: 4, reps: 8, restSeconds: 120),
                  const _ExerciseItem(letter: 'B', name: 'Overhead Press', sets: 3, reps: 10, restSeconds: 90),
                  const _ExerciseItem(letter: 'C', name: 'Incline Dumbbell Press', sets: 3, reps: 12, restSeconds: 90),
                  const _ExerciseItem(letter: 'D', name: 'Dips', sets: 3, reps: 10, restSeconds: 90),
                  const _ExerciseItem(letter: 'E', name: 'Tricep Pushdowns', sets: 3, reps: 15, restSeconds: 60),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatTime(int seconds) {
    if (seconds >= 60) {
      return '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
    }
    return '${seconds}s';
  }
  
  List<String> _getRequiredEquipment(List exercises) {
    final equipment = <String>{};
    for (final e in exercises) {
      if (e.exercise?.equipmentRequired != null) {
        equipment.addAll(List<String>.from(e.exercise!.equipmentRequired!));
      }
    }
    if (equipment.isEmpty) {
      return ['Barbell', 'Dumbbells', 'Bench'];
    }
    return equipment.toList();
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        AppSpacing.horizontalMD,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.titleLarge),
            Text(
              subtitle,
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ],
    );
  }
}

class _ExerciseItem extends StatelessWidget {
  final String letter;
  final String name;
  final int sets;
  final int reps;
  final int restSeconds;

  const _ExerciseItem({
    required this.letter,
    required this.name,
    required this.sets,
    required this.reps,
    required this.restSeconds,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Text(
                '$sets × $reps  •  ${restSeconds}s rest',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          AppSpacing.verticalSM,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(name, style: AppTypography.bodyMedium),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimedExerciseItem extends StatelessWidget {
  final String name;
  final String? time;
  final String? reps;

  const _TimedExerciseItem({
    required this.name,
    this.time,
    this.reps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: AppTypography.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (time != null)
                  Icon(Icons.schedule, size: 14, color: AppColors.secondary),
                if (reps != null)
                  Icon(Icons.repeat, size: 14, color: AppColors.secondary),
                AppSpacing.horizontalXS,
                Text(
                  time ?? reps ?? '',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsibleSection extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  const _CollapsibleSection({
    required this.title,
    required this.children,
    this.initiallyExpanded = true,
  });

  @override
  State<_CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<_CollapsibleSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: AppTypography.titleMedium),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            AppSpacing.verticalMD,
            ...widget.children,
          ],
        ],
      ),
    );
  }
}

class _EquipmentChip extends StatelessWidget {
  final String label;

  const _EquipmentChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall,
      ),
    );
  }
}
