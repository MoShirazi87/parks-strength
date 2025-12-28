import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';

/// Workout overview before starting
class WorkoutOverviewScreen extends StatelessWidget {
  final String workoutId;

  const WorkoutOverviewScreen({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
                    Text('Chest Day', style: AppTypography.displaySmall),
                    AppSpacing.verticalSM,
                    Text(
                      'Description dolor sit amet, eiusmod consectetur adipiscing elit, sed ...',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    AppSpacing.verticalLG,

                    // Quick add buttons
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          _QuickAddButton(
                            icon: Icons.fitness_center,
                            label: 'Add\nExercise',
                          ),
                          _QuickAddButton(
                            icon: Icons.directions_run,
                            label: 'Add\nWarm-up',
                          ),
                          _QuickAddButton(
                            icon: Icons.self_improvement,
                            label: 'Add\nStretching',
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.verticalLG,

                    // Training section
                    Text('Training', style: AppTypography.titleLarge),
                    AppSpacing.verticalMD,
                    _ExerciseItem(letter: 'A', name: 'Butterfly Sit Ups', sets: 2),
                    _ExerciseItem(letter: 'B', name: 'Bent knee windscreen Wipers', sets: 2),
                    _ExerciseItem(letter: 'C', name: 'Neck roll from side to side', sets: 2),
                    _ExerciseItem(letter: 'D', name: 'Cable Mid Chops', sets: 2),
                    AppSpacing.verticalLG,

                    // Warm-up section
                    _CollapsibleSection(
                      title: 'Warm-up',
                      initiallyExpanded: false,
                      children: [
                        _TimedExerciseItem(name: 'Bent knee wind...', time: '00:30'),
                        _TimedExerciseItem(name: 'Pause', time: '00:30'),
                        _TimedExerciseItem(name: 'Neck roll from side to side', reps: '2x'),
                        _TimedExerciseItem(name: 'Pause', time: '00:90'),
                      ],
                    ),
                    AppSpacing.verticalMD,

                    // Stretching section
                    _CollapsibleSection(
                      title: 'Stretching',
                      initiallyExpanded: false,
                      children: [
                        _TimedExerciseItem(name: 'Cable Mid Chops', reps: '2x'),
                        _TimedExerciseItem(name: 'Pause', time: '00:30'),
                        _TimedExerciseItem(name: 'Bent knee windscreen Wip...', time: '00:30'),
                        _TimedExerciseItem(name: 'Pause', time: '00:30'),
                      ],
                    ),
                    AppSpacing.verticalMD,

                    // Equipment section
                    _CollapsibleSection(
                      title: 'Equipment',
                      initiallyExpanded: false,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _EquipmentChip(label: 'Body bars'),
                            _EquipmentChip(label: 'Battle ropes'),
                            _EquipmentChip(label: 'Barbells'),
                            _EquipmentChip(label: 'Jump ropes'),
                            _EquipmentChip(label: 'Legs press'),
                          ],
                        ),
                      ],
                    ),
                    AppSpacing.verticalMD,

                    // Goals section
                    _CollapsibleSection(
                      title: 'Goals',
                      initiallyExpanded: false,
                      children: [
                        Text(
                          'Build chest strength and improve pressing power.',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
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
}

class _QuickAddButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickAddButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const Icon(Icons.add, color: Colors.white, size: 20),
            ],
          ),
          const Spacer(),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseItem extends StatelessWidget {
  final String letter;
  final String name;
  final int sets;

  const _ExerciseItem({
    required this.letter,
    required this.name,
    required this.sets,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              letter,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            Text(
              '${sets}x Set',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        AppSpacing.verticalSM,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: AppTypography.bodyMedium),
              const Icon(Icons.drag_handle, color: AppColors.textMuted),
            ],
          ),
        ),
        AppSpacing.verticalMD,
      ],
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
          Row(
            children: [
              if (time != null)
                Icon(Icons.schedule, size: 14, color: AppColors.primary),
              if (reps != null)
                Icon(Icons.repeat, size: 14, color: AppColors.primary),
              AppSpacing.horizontalXS,
              Text(
                time ?? reps ?? '',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
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

