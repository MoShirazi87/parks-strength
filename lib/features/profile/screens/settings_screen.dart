import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';

/// Settings screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.verticalSM,
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Email'),
                    subtitle: Text(
                      'user@example.com',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textMuted,
                    ),
                    onTap: () {},
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  ListTile(
                    title: const Text('Password'),
                    subtitle: Text(
                      '••••••••',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textMuted,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            AppSpacing.verticalLG,

            Text(
              'Preferences',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.verticalSM,
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Units'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Imperial (lbs)'),
                    ),
                    onTap: () {},
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  ListTile(
                    title: const Text('Appearance'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Dark'),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            AppSpacing.verticalLG,

            Text(
              'Legal',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.verticalSM,
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Terms of Service'),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textMuted,
                    ),
                    onTap: () {},
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  ListTile(
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textMuted,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            AppSpacing.verticalLG,

            Text(
              'Danger Zone',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.error,
              ),
            ),
            AppSpacing.verticalSM,
            AppCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                title: Text(
                  'Delete Account',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.error,
                ),
                onTap: () {
                  // Show confirmation dialog
                },
              ),
            ),
            AppSpacing.verticalXL,

            Center(
              child: Text(
                'Parks Strength v1.0.0',
                style: AppTypography.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

