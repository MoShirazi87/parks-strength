import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../features/auth/providers/auth_provider.dart';

/// Home screen placeholder per Phase 1 spec
/// Shows welcome message and logout button
/// Only accessible when authenticated AND onboarding_completed = true
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? 'User';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppSpacing.verticalXL,
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    'PS',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              AppSpacing.verticalXL,
              
              // Welcome message
              Text(
                'Welcome!',
                style: AppTypography.displaySmall,
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalSM,
              Text(
                email,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalXL,
              
              // Success message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.success.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                    ),
                    AppSpacing.horizontalSM,
                    Text(
                      'Authentication complete!',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalXXL,
              
              // Quick Action Buttons
              Row(
                children: [
                  // Browse Exercises
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.fitness_center,
                      label: 'Exercise\nLibrary',
                      color: AppColors.primary,
                      onTap: () => context.push(AppRoutes.exercises),
                    ),
                  ),
                  AppSpacing.horizontalMD,
                  // Browse Programs
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.calendar_month,
                      label: 'Browse\nPrograms',
                      color: AppColors.tertiary,
                      onTap: () => context.push(AppRoutes.programs),
                    ),
                  ),
                ],
              ),
              AppSpacing.verticalMD,
              
              Row(
                children: [
                  // Quick Workout
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.bolt,
                      label: 'Quick\nWorkout',
                      color: AppColors.secondary,
                      onTap: () => context.push('/quick-workout/fullbody'),
                    ),
                  ),
                  AppSpacing.horizontalMD,
                  // Progress
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.trending_up,
                      label: 'View\nProgress',
                      color: AppColors.success,
                      onTap: () => context.push(AppRoutes.progress),
                    ),
                  ),
                ],
              ),
              
              AppSpacing.verticalXXL,
              
              // Logout button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    final authService = ref.read(authServiceProvider);
                    await authService.signOut();
                    if (context.mounted) {
                      context.go(AppRoutes.welcome);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Quick action card widget for home screen
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            AppSpacing.verticalSM,
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
