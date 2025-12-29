import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../data/providers/progress_provider.dart';
import '../../../shared/widgets/app_card.dart';

/// Personal records screen with real data
class PersonalRecordsScreen extends ConsumerWidget {
  const PersonalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prsAsync = ref.watch(personalRecordsProvider);
    
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
      body: prsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              AppSpacing.verticalMD,
              Text('Error loading PRs', style: AppTypography.bodyLarge),
              AppSpacing.verticalSM,
              Text('$e', style: AppTypography.caption),
            ],
          ),
        ),
        data: (prs) {
          if (prs.isEmpty) {
            return _buildEmptyState();
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(personalRecordsProvider);
            },
            child: ListView.builder(
              padding: AppSpacing.screenPadding,
              itemCount: prs.length,
              itemBuilder: (context, index) {
                final pr = prs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PRCard(pr: pr),
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
                color: AppColors.pr.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events_outlined,
                size: 40,
                color: AppColors.pr,
              ),
            ),
            AppSpacing.verticalLG,
            Text(
              'No Personal Records Yet',
              style: AppTypography.headlineMedium,
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalMD,
            Text(
              'Complete workouts to start setting PRs!\nWe track your best lifts automatically.',
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
}

class _PRCard extends StatelessWidget {
  final PersonalRecord pr;

  const _PRCard({required this.pr});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.pr.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: AppColors.pr,
                  size: 24,
                ),
              ),
              AppSpacing.horizontalMD,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pr.exerciseName,
                      style: AppTypography.titleMedium,
                    ),
                    Text(
                      dateFormat.format(pr.achievedAt),
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.verticalMD,
          const Divider(color: AppColors.border),
          AppSpacing.verticalMD,
          
          // Stats row
          Row(
            children: [
              Expanded(
                child: _StatColumn(
                  label: 'Weight',
                  value: '${pr.weight.toStringAsFixed(1)} lbs',
                ),
              ),
              Expanded(
                child: _StatColumn(
                  label: 'Reps',
                  value: pr.reps.toString(),
                ),
              ),
              Expanded(
                child: _StatColumn(
                  label: 'Est. 1RM',
                  value: '${pr.estimated1RM.toStringAsFixed(1)} lbs',
                  isHighlighted: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;

  const _StatColumn({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            color: isHighlighted ? AppColors.pr : null,
          ),
        ),
        AppSpacing.verticalXS,
        Text(
          label,
          style: AppTypography.caption,
        ),
      ],
    );
  }
}
