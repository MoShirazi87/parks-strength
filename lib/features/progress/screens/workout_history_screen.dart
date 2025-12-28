import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';

/// Workout history screen
class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Workout History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: const [
          _DateHeader(date: 'This Week'),
          _WorkoutHistoryItem(
            name: 'Push Day',
            program: 'Foundation Strength',
            date: 'Dec 28, 2024',
            duration: '48 min',
            volume: '12,450 lbs',
            hasPR: true,
          ),
          _WorkoutHistoryItem(
            name: 'Pull Day',
            program: 'Foundation Strength',
            date: 'Dec 26, 2024',
            duration: '52 min',
            volume: '14,200 lbs',
            hasPR: false,
          ),
          _WorkoutHistoryItem(
            name: 'Leg Day',
            program: 'Foundation Strength',
            date: 'Dec 24, 2024',
            duration: '55 min',
            volume: '18,500 lbs',
            hasPR: true,
          ),
          _DateHeader(date: 'Last Week'),
          _WorkoutHistoryItem(
            name: 'Push Day',
            program: 'Foundation Strength',
            date: 'Dec 21, 2024',
            duration: '45 min',
            volume: '11,800 lbs',
            hasPR: false,
          ),
          _WorkoutHistoryItem(
            name: 'Pull Day',
            program: 'Foundation Strength',
            date: 'Dec 19, 2024',
            duration: '50 min',
            volume: '13,600 lbs',
            hasPR: false,
          ),
        ],
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String date;

  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        date,
        style: AppTypography.titleMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _WorkoutHistoryItem extends StatelessWidget {
  final String name;
  final String program;
  final String date;
  final String duration;
  final String volume;
  final bool hasPR;

  const _WorkoutHistoryItem({
    required this.name,
    required this.program,
    required this.date,
    required this.duration,
    required this.volume,
    required this.hasPR,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name, style: AppTypography.titleMedium),
                        if (hasPR) ...[
                          AppSpacing.horizontalSM,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.emoji_events,
                                  size: 12,
                                  color: AppColors.secondary,
                                ),
                                AppSpacing.horizontalXS,
                                Text(
                                  'PR',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    AppSpacing.verticalXS,
                    Text(
                      program,
                      style: AppTypography.caption,
                    ),
                  ],
                ),
                Text(
                  date,
                  style: AppTypography.caption,
                ),
              ],
            ),
            AppSpacing.verticalMD,
            Row(
              children: [
                _StatItem(icon: Icons.timer, value: duration),
                AppSpacing.horizontalLG,
                _StatItem(icon: Icons.fitness_center, value: volume),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;

  const _StatItem({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        AppSpacing.horizontalXS,
        Text(value, style: AppTypography.bodySmall),
      ],
    );
  }
}

