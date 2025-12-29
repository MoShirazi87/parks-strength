import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../data/providers/progress_provider.dart';
import '../../../shared/widgets/app_card.dart';

/// Workout history screen with real data
class WorkoutHistoryScreen extends ConsumerWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(workoutHistoryProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Workout History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              AppSpacing.verticalMD,
              Text('Error loading history', style: AppTypography.bodyLarge),
              AppSpacing.verticalSM,
              Text('$e', style: AppTypography.caption),
            ],
          ),
        ),
        data: (history) {
          if (history.isEmpty) {
            return _buildEmptyState();
          }
          
          // Group by date
          final groupedHistory = _groupByDate(history);
          
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(workoutHistoryProvider);
            },
            child: ListView.builder(
              padding: AppSpacing.screenPadding,
              itemCount: groupedHistory.length,
              itemBuilder: (context, index) {
                final group = groupedHistory[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date header
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, top: 8),
                      child: Text(
                        group.dateLabel,
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    // Workout cards for this date
                    ...group.workouts.map((workout) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _HistoryCard(workout: workout),
                    )),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            AppSpacing.verticalLG,
            Text(
              'No Workouts Yet',
              style: AppTypography.headlineMedium,
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalMD,
            Text(
              'Complete a workout to see it here.\nYour training history will be tracked automatically.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<_DateGroup> _groupByDate(List<WorkoutHistoryItem> workouts) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    
    final groups = <String, List<WorkoutHistoryItem>>{};
    
    for (final workout in workouts) {
      final workoutDate = DateTime(
        workout.completedAt.year,
        workout.completedAt.month,
        workout.completedAt.day,
      );
      
      String key;
      if (workoutDate == today) {
        key = 'Today';
      } else if (workoutDate == yesterday) {
        key = 'Yesterday';
      } else if (workoutDate.isAfter(today.subtract(const Duration(days: 7)))) {
        key = DateFormat('EEEE').format(workoutDate);
      } else {
        key = DateFormat('MMM d, yyyy').format(workoutDate);
      }
      
      groups.putIfAbsent(key, () => []).add(workout);
    }
    
    return groups.entries
        .map((e) => _DateGroup(dateLabel: e.key, workouts: e.value))
        .toList();
  }
}

class _DateGroup {
  final String dateLabel;
  final List<WorkoutHistoryItem> workouts;

  const _DateGroup({
    required this.dateLabel,
    required this.workouts,
  });
}

class _HistoryCard extends StatelessWidget {
  final WorkoutHistoryItem workout;

  const _HistoryCard({required this.workout});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('h:mm a');
    
    return AppCard(
      onTap: () {
        // TODO: Navigate to workout detail/summary
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.horizontalMD,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.workoutName,
                      style: AppTypography.titleMedium,
                    ),
                    Text(
                      timeFormat.format(workout.completedAt),
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              // Points earned
              if (workout.pointsEarned > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.points.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, size: 14, color: AppColors.points),
                      AppSpacing.horizontalXS,
                      Text(
                        '+${workout.pointsEarned}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.points,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          AppSpacing.verticalMD,
          
          // Stats row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.timer_outlined,
                  value: workout.formattedDuration,
                  label: 'Duration',
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: AppColors.border,
                ),
                _StatItem(
                  icon: Icons.fitness_center,
                  value: workout.totalSets.toString(),
                  label: 'Sets',
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: AppColors.border,
                ),
                _StatItem(
                  icon: Icons.trending_up,
                  value: workout.formattedVolume,
                  label: 'Volume',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.textMuted),
            AppSpacing.horizontalXS,
            Text(
              value,
              style: AppTypography.labelMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        AppSpacing.verticalXS,
        Text(
          label,
          style: AppTypography.caption.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}
