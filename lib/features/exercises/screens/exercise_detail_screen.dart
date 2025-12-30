import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/providers/exercise_filter_provider.dart';

/// Exercise Detail Screen
/// Shows comprehensive information about a single exercise
class ExerciseDetailScreen extends ConsumerWidget {
  final String exerciseId;

  const ExerciseDetailScreen({
    super.key,
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseAsync = ref.watch(exerciseProvider(exerciseId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: exerciseAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: AppColors.error, size: 48),
              AppSpacing.verticalMD,
              Text(
                'Failed to load exercise',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
              ),
              AppSpacing.verticalSM,
              TextButton(
                onPressed: () => ref.invalidate(exerciseProvider(exerciseId)),
                child: Text('Retry', style: AppTypography.labelMedium.copyWith(color: AppColors.primary)),
              ),
            ],
          ),
        ),
        data: (exercise) {
          if (exercise == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, color: AppColors.textMuted, size: 64),
                  AppSpacing.verticalMD,
                  Text(
                    'Exercise not found',
                    style: AppTypography.headlineSmall.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Hero GIF/Image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppColors.surface,
                flexibleSpace: FlexibleSpaceBar(
                  background: exercise.bestGifUrl != null
                      ? Image.network(
                          exercise.bestGifUrl!,
                          fit: BoxFit.cover,
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
                          errorBuilder: (context, error, stack) {
                            return Container(
                              color: AppColors.surface,
                              child: Center(
                                child: Icon(
                                  Icons.fitness_center,
                                  color: AppColors.textMuted,
                                  size: 80,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: AppColors.surface,
                          child: Center(
                            child: Icon(
                              Icons.fitness_center,
                              color: AppColors.textMuted,
                              size: 80,
                            ),
                          ),
                        ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and difficulty badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              exercise.name,
                              style: AppTypography.headlineLarge,
                            ),
                          ),
                          AppSpacing.horizontalSM,
                          _DifficultyBadge(difficulty: exercise.difficulty ?? 'intermediate'),
                        ],
                      ),

                      AppSpacing.verticalMD,

                      // Movement pattern and mechanics badges
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (exercise.movementPattern != null)
                            _InfoChip(
                              icon: Icons.swap_horiz,
                              label: _formatLabel(exercise.movementPattern!),
                              color: AppColors.primary,
                            ),
                          if (exercise.mechanicsType != null)
                            _InfoChip(
                              icon: Icons.settings_suggest,
                              label: _formatLabel(exercise.mechanicsType!),
                              color: AppColors.tertiary,
                            ),
                          if (exercise.forceType != null)
                            _InfoChip(
                              icon: Icons.arrow_forward,
                              label: _formatLabel(exercise.forceType!),
                              color: AppColors.info,
                            ),
                        ],
                      ),

                      AppSpacing.verticalLG,

                      // Equipment required
                      if (exercise.equipment != null || exercise.equipmentRequired.isNotEmpty) ...[
                        _SectionTitle(title: 'Equipment Required'),
                        AppSpacing.verticalSM,
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (exercise.equipment != null)
                              _EquipmentChip(label: _formatLabel(exercise.equipment!)),
                            ...exercise.equipmentRequired.map(
                              (e) => _EquipmentChip(label: _formatLabel(e)),
                            ),
                          ],
                        ),
                        AppSpacing.verticalLG,
                      ],

                      // Target muscles
                      _SectionTitle(title: 'Target Muscles'),
                      AppSpacing.verticalSM,
                      _MusclesSection(
                        primaryMuscles: exercise.primaryMuscles.isNotEmpty 
                            ? exercise.primaryMuscles 
                            : (exercise.targetMuscle != null ? [exercise.targetMuscle!] : []),
                        secondaryMuscles: exercise.secondaryMuscles,
                      ),

                      AppSpacing.verticalLG,

                      // Instructions
                      if (exercise.instructions.isNotEmpty) ...[
                        _SectionTitle(title: 'Instructions'),
                        AppSpacing.verticalSM,
                        ...exercise.instructions.asMap().entries.map(
                          (entry) => _NumberedItem(
                            number: entry.key + 1,
                            text: entry.value,
                          ),
                        ),
                        AppSpacing.verticalLG,
                      ],

                      // Coaching cues
                      if (exercise.cues.isNotEmpty) ...[
                        _SectionTitle(title: 'Coaching Cues'),
                        AppSpacing.verticalSM,
                        ...exercise.cues.map(
                          (cue) => _CueItem(text: cue),
                        ),
                        AppSpacing.verticalLG,
                      ],

                      // Common mistakes
                      if (exercise.commonMistakes.isNotEmpty) ...[
                        _SectionTitle(title: 'Common Mistakes'),
                        AppSpacing.verticalSM,
                        ...exercise.commonMistakes.map(
                          (mistake) => _MistakeItem(text: mistake),
                        ),
                        AppSpacing.verticalLG,
                      ],

                      // Location tags
                      if (exercise.locationTags.isNotEmpty) ...[
                        _SectionTitle(title: 'Suitable Locations'),
                        AppSpacing.verticalSM,
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: exercise.locationTags.map(
                            (loc) => _LocationChip(label: _formatLabel(loc)),
                          ).toList(),
                        ),
                        AppSpacing.verticalLG,
                      ],

                      // Bottom padding for safe area
                      AppSpacing.verticalXXL,
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatLabel(String value) {
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }
}

/// Section title widget
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimary),
    );
  }
}

/// Difficulty badge widget
class _DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        color = AppColors.success;
        break;
      case 'intermediate':
        color = AppColors.warning;
        break;
      case 'advanced':
        color = AppColors.error;
        break;
      default:
        color = AppColors.textMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Info chip widget for movement pattern, mechanics, etc.
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          AppSpacing.horizontalXS,
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// Equipment chip widget
class _EquipmentChip extends StatelessWidget {
  final String label;

  const _EquipmentChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.fitness_center, size: 14, color: AppColors.textSecondary),
          AppSpacing.horizontalXS,
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

/// Location chip widget
class _LocationChip extends StatelessWidget {
  final String label;

  const _LocationChip({required this.label});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (label.toLowerCase()) {
      case 'gym':
        icon = Icons.fitness_center;
        break;
      case 'home':
        icon = Icons.home;
        break;
      case 'outdoor':
        icon = Icons.park;
        break;
      case 'travel':
        icon = Icons.flight;
        break;
      default:
        icon = Icons.place;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          AppSpacing.horizontalXS,
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

/// Muscles section widget
class _MusclesSection extends StatelessWidget {
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;

  const _MusclesSection({
    required this.primaryMuscles,
    required this.secondaryMuscles,
  });

  String _formatMuscle(String muscle) {
    return muscle
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (primaryMuscles.isNotEmpty) ...[
          Text(
            'Primary',
            style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
          ),
          AppSpacing.verticalXS,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: primaryMuscles.map((muscle) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withAlpha(60)),
                ),
                child: Text(
                  _formatMuscle(muscle),
                  style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
                ),
              );
            }).toList(),
          ),
        ],
        if (secondaryMuscles.isNotEmpty) ...[
          AppSpacing.verticalMD,
          Text(
            'Secondary',
            style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
          ),
          AppSpacing.verticalXS,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: secondaryMuscles.map((muscle) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _formatMuscle(muscle),
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

/// Numbered instruction item
class _NumberedItem extends StatelessWidget {
  final int number;
  final String text;

  const _NumberedItem({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          AppSpacing.horizontalMD,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: AppTypography.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Coaching cue item with checkmark
class _CueItem extends StatelessWidget {
  final String text;

  const _CueItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: 14,
              color: AppColors.success,
            ),
          ),
          AppSpacing.horizontalMD,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                text,
                style: AppTypography.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Common mistake item with warning icon
class _MistakeItem extends StatelessWidget {
  final String text;

  const _MistakeItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withAlpha(30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 20,
            color: AppColors.error,
          ),
          AppSpacing.horizontalMD,
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

