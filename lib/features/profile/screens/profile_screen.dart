import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/app_card.dart';
import '../../auth/providers/auth_provider.dart';

/// Profile screen with stats, settings, and account management
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              // Profile header
              user.when(
                data: (userData) => _ProfileHeader(
                  name: userData?.fullName ?? 'User',
                  avatarUrl: userData?.avatarUrl,
                  memberSince: userData?.createdAt,
                ),
                loading: () => const _ProfileHeader(
                  name: 'Loading...',
                  avatarUrl: null,
                  memberSince: null,
                ),
                error: (_, __) => const _ProfileHeader(
                  name: 'Error',
                  avatarUrl: null,
                  memberSince: null,
                ),
              ),
              AppSpacing.verticalLG,

              // Stats row
              user.when(
                data: (userData) => Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        value: '${userData?.totalWorkouts ?? 0}',
                        label: 'Workouts',
                      ),
                    ),
                    AppSpacing.horizontalMD,
                    Expanded(
                      child: _StatCard(
                        value: '${userData?.streakCurrent ?? 0}',
                        label: 'Day Streak',
                        valueColor: AppColors.streak,
                      ),
                    ),
                    AppSpacing.horizontalMD,
                    Expanded(
                      child: _StatCard(
                        value: '${userData?.points ?? 0}',
                        label: 'Points',
                        valueColor: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                loading: () => Row(
                  children: [
                    Expanded(child: _StatCard(value: '-', label: 'Workouts')),
                    AppSpacing.horizontalMD,
                    Expanded(child: _StatCard(value: '-', label: 'Streak')),
                    AppSpacing.horizontalMD,
                    Expanded(child: _StatCard(value: '-', label: 'Points')),
                  ],
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
              AppSpacing.verticalLG,

              // Menu sections
              _MenuSection(
                title: 'Training',
                items: [
                  _MenuItem(
                    icon: Icons.fitness_center,
                    title: 'My Programs',
                    onTap: () => context.push(AppRoutes.programs),
                  ),
                  _MenuItem(
                    icon: Icons.history,
                    title: 'Workout History',
                    onTap: () => context.push(AppRoutes.workoutHistory),
                  ),
                  _MenuItem(
                    icon: Icons.emoji_events,
                    title: 'Personal Records',
                    onTap: () => context.push(AppRoutes.personalRecords),
                  ),
                  _MenuItem(
                    icon: Icons.trending_up,
                    title: 'Progress',
                    onTap: () => context.push(AppRoutes.progress),
                  ),
                ],
              ),
              AppSpacing.verticalMD,

              _MenuSection(
                title: 'Body & Measurements',
                items: [
                  _MenuItem(
                    icon: Icons.monitor_weight,
                    title: 'Bodyweight Log',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.straighten,
                    title: 'Measurements',
                    onTap: () {},
                  ),
                ],
              ),
              AppSpacing.verticalMD,

              _MenuSection(
                title: 'Settings',
                items: [
                  _MenuItem(
                    icon: Icons.person,
                    title: 'Account Settings',
                    onTap: () => context.push(AppRoutes.settings),
                  ),
                  _MenuItem(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.build,
                    title: 'Equipment',
                    onTap: () {},
                  ),
                ],
              ),
              AppSpacing.verticalMD,

              _MenuSection(
                title: 'Support',
                items: [
                  _MenuItem(
                    icon: Icons.help,
                    title: 'Help & FAQ',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.info,
                    title: 'About Coach Brian',
                    onTap: () {},
                  ),
                ],
              ),
              AppSpacing.verticalLG,

              // Sign out button
              TextButton(
                onPressed: () async {
                  final authService = ref.read(authServiceProvider);
                  await authService.signOut();
                },
                child: Text(
                  'Sign Out',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final DateTime? memberSince;

  const _ProfileHeader({
    required this.name,
    this.avatarUrl,
    this.memberSince,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: avatarUrl != null
                  ? ClipOval(
                      child: Image.network(
                        avatarUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 48,
                      color: AppColors.textMuted,
                    ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        AppSpacing.verticalMD,
        Text(name, style: AppTypography.headlineMedium),
        if (memberSince != null) ...[
          AppSpacing.verticalXS,
          Text(
            'Member since ${_formatDate(memberSince!)}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;

  const _StatCard({
    required this.value,
    required this.label,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.headlineLarge.copyWith(
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
          AppSpacing.verticalXS,
          Text(
            label,
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.verticalSM,
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: items
                .asMap()
                .entries
                .map((entry) => Column(
                      children: [
                        entry.value,
                        if (entry.key < items.length - 1)
                          const Divider(
                            height: 1,
                            color: AppColors.border,
                            indent: 56,
                          ),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title, style: AppTypography.bodyMedium),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textMuted,
      ),
      onTap: onTap,
    );
  }
}

