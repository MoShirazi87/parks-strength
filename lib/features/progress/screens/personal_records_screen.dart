import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';

/// Personal records screen
class PersonalRecordsScreen extends StatelessWidget {
  const PersonalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Personal Records'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: const [
          _PRCard(
            exercise: 'Bench Press',
            records: {
              '1RM': '225 lbs',
              '5RM': '185 lbs',
              '8RM': '165 lbs',
            },
            lastAchieved: 'Dec 20, 2024',
          ),
          _PRCard(
            exercise: 'Squat',
            records: {
              '1RM': '315 lbs',
              '5RM': '265 lbs',
              '8RM': '225 lbs',
            },
            lastAchieved: 'Dec 18, 2024',
          ),
          _PRCard(
            exercise: 'Deadlift',
            records: {
              '1RM': '365 lbs',
              '5RM': '315 lbs',
              '8RM': '275 lbs',
            },
            lastAchieved: 'Dec 15, 2024',
          ),
          _PRCard(
            exercise: 'Overhead Press',
            records: {
              '1RM': '145 lbs',
              '5RM': '115 lbs',
              '8RM': '95 lbs',
            },
            lastAchieved: 'Dec 22, 2024',
          ),
        ],
      ),
    );
  }
}

class _PRCard extends StatelessWidget {
  final String exercise;
  final Map<String, String> records;
  final String lastAchieved;

  const _PRCard({
    required this.exercise,
    required this.records,
    required this.lastAchieved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    AppSpacing.horizontalSM,
                    Text(exercise, style: AppTypography.titleLarge),
                  ],
                ),
                const Icon(Icons.chevron_right, color: AppColors.textMuted),
              ],
            ),
            AppSpacing.verticalMD,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: records.entries
                  .map((e) => Column(
                        children: [
                          Text(
                            e.key,
                            style: AppTypography.caption,
                          ),
                          Text(
                            e.value,
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),
            AppSpacing.verticalMD,
            Text(
              'Last achieved: $lastAchieved',
              style: AppTypography.caption.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

