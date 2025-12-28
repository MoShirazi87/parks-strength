import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';

/// Program recommendation screen after onboarding
class ProgramRecommendationScreen extends StatelessWidget {
  const ProgramRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.verticalLG,
              Text(
                'Your Recommended\nProgram',
                style: AppTypography.displaySmall,
              ),
              AppSpacing.verticalLG,

              // Program hero card
              HeroCard(
                height: 400,
                overlayGradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.4, 1.0],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Program indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.programTitan.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.programTitan,
                              shape: BoxShape.circle,
                            ),
                          ),
                          AppSpacing.horizontalSM,
                          Text(
                            'FUNCTIONAL',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.programTitan,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Program details
                    Text(
                      'Foundation\nStrength',
                      style: AppTypography.displayMedium,
                    ),
                    AppSpacing.verticalSM,
                    Text(
                      'Coach Brian Parks',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.verticalMD,

                    // Stats row
                    Row(
                      children: [
                        _StatBadge(
                          icon: Icons.calendar_today,
                          label: '8 Weeks',
                        ),
                        AppSpacing.horizontalMD,
                        _StatBadge(
                          icon: Icons.fitness_center,
                          label: '4x/week',
                        ),
                        AppSpacing.horizontalMD,
                        _StatBadge(
                          icon: Icons.timer,
                          label: '45-60 min',
                        ),
                      ],
                    ),
                    AppSpacing.verticalMD,

                    // Duration badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: AppColors.secondary,
                          ),
                          AppSpacing.horizontalXS,
                          Text(
                            'Intermediate',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalLG,

              // Why this program section
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why This Program?',
                      style: AppTypography.titleLarge,
                    ),
                    AppSpacing.verticalMD,
                    Text(
                      'Based on your goals and experience level, Foundation Strength is perfect for building a solid base of functional strength. You\'ll develop proper movement patterns, increase overall strength, and build the foundation for more advanced training.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalLG,

              // What you'll achieve
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('What You\'ll Achieve', style: AppTypography.titleLarge),
                    AppSpacing.verticalMD,
                    _AchievementItem(text: 'Build foundational strength'),
                    _AchievementItem(text: 'Improve movement quality'),
                    _AchievementItem(text: 'Increase core stability'),
                    _AchievementItem(text: 'Develop training consistency'),
                  ],
                ),
              ),
              AppSpacing.verticalXL,

              // Start button
              AppButton(
                text: 'Start This Program',
                onPressed: () => context.go(AppRoutes.home),
              ),
              AppSpacing.verticalMD,

              // Browse all link
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: Text(
                    'Browse All Programs',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              AppSpacing.verticalLG,
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.textMuted,
        ),
        AppSpacing.horizontalXS,
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _AchievementItem extends StatelessWidget {
  final String text;

  const _AchievementItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            size: 20,
            color: AppColors.success,
          ),
          AppSpacing.horizontalMD,
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

