import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';

/// Workout completion celebration screen
class WorkoutCompletionScreen extends StatefulWidget {
  final String workoutLogId;

  const WorkoutCompletionScreen({super.key, required this.workoutLogId});

  @override
  State<WorkoutCompletionScreen> createState() =>
      _WorkoutCompletionScreenState();
}

class _WorkoutCompletionScreenState extends State<WorkoutCompletionScreen> {
  late ConfettiController _confettiController;
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              colors: const [
                AppColors.primary,
                AppColors.secondary,
                AppColors.success,
                AppColors.programTitan,
              ],
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  AppSpacing.verticalXL,

                  // Celebration icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 50,
                      color: AppColors.success,
                    ),
                  ),
                  AppSpacing.verticalLG,

                  // Header
                  Text(
                    'Workout Complete!',
                    style: AppTypography.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.verticalSM,
                  Text(
                    '"Great work! Every rep counts."',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.verticalLG,

                  // Workout summary card
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Chest Day', style: AppTypography.titleLarge),
                        AppSpacing.verticalXS,
                        Text(
                          'December 28, 2024',
                          style: AppTypography.caption,
                        ),
                        AppSpacing.verticalMD,
                        const Divider(color: AppColors.border),
                        AppSpacing.verticalMD,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _SummaryItem(
                              icon: Icons.timer,
                              value: '48',
                              label: 'min',
                            ),
                            _SummaryItem(
                              icon: Icons.fitness_center,
                              value: '12,450',
                              label: 'lbs volume',
                            ),
                            _SummaryItem(
                              icon: Icons.check_circle,
                              value: '12/12',
                              label: 'exercises',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.verticalMD,

                  // PR highlight (if any)
                  AppCard(
                    backgroundColor: AppColors.secondary.withOpacity(0.1),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          color: AppColors.secondary,
                          size: 32,
                        ),
                        AppSpacing.horizontalMD,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NEW PR!',
                                style: AppTypography.labelMedium.copyWith(
                                  color: AppColors.secondary,
                                ),
                              ),
                              Text(
                                'Bench Press: 185 lbs × 8',
                                style: AppTypography.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.verticalLG,

                  // Rating
                  Text('How did that feel?', style: AppTypography.titleMedium),
                  AppSpacing.verticalMD,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            size: 40,
                            color: index < _rating
                                ? AppColors.secondary
                                : AppColors.textMuted,
                          ),
                        ),
                      );
                    }),
                  ),
                  AppSpacing.verticalLG,

                  // Streak update
                  AppCard(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: AppColors.streak,
                          size: 40,
                        ),
                        AppSpacing.horizontalMD,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '7 Day Streak!',
                              style: AppTypography.titleLarge.copyWith(
                                color: AppColors.streak,
                              ),
                            ),
                            Text(
                              'Keep it going!',
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.verticalXL,

                  // Buttons
                  AppButton(
                    text: 'Done',
                    onPressed: () => context.go(AppRoutes.home),
                  ),
                  AppSpacing.verticalMD,
                  AppButton(
                    text: 'Share Workout',
                    variant: AppButtonVariant.outline,
                    leftIcon: Icons.share,
                    onPressed: () {
                      // Share workout
                    },
                  ),
                  AppSpacing.verticalXL,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SummaryItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textMuted, size: 20),
        AppSpacing.verticalSM,
        Text(value, style: AppTypography.titleLarge),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}

