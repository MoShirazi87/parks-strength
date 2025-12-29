import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../data/providers/progress_provider.dart';
import '../../../shared/widgets/app_card.dart';

/// Progress dashboard screen with real data
class ProgressDashboardScreen extends ConsumerStatefulWidget {
  const ProgressDashboardScreen({super.key});

  @override
  ConsumerState<ProgressDashboardScreen> createState() =>
      _ProgressDashboardScreenState();
}

class _ProgressDashboardScreenState extends ConsumerState<ProgressDashboardScreen> {
  String _selectedRange = '30 days';

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(progressStatsProvider);
    final weeklyVolumeAsync = ref.watch(weeklyVolumeProvider);
    final streakAsync = ref.watch(streakHistoryProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Progress'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(progressStatsProvider);
          ref.invalidate(weeklyVolumeProvider);
          ref.invalidate(streakHistoryProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date range selector
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['7 days', '30 days', '90 days', 'All Time']
                      .map((range) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRange = range;
                                });
                                // TODO: Refetch with new date range
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _selectedRange == range
                                      ? AppColors.primary
                                      : AppColors.surface,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  range,
                                  style: AppTypography.labelMedium.copyWith(
                                    color: _selectedRange == range
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              AppSpacing.verticalLG,

              // Stats cards with real data
              statsAsync.when(
                loading: () => _buildStatsLoading(),
                error: (e, _) => _buildStatsError(),
                data: (stats) => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatsCard(
                            title: 'Workouts',
                            value: stats.workoutsCompleted.toString(),
                            icon: Icons.fitness_center,
                            color: AppColors.primary,
                          ),
                        ),
                        AppSpacing.horizontalMD,
                        Expanded(
                          child: streakAsync.when(
                            loading: () => _StatsCard(
                              title: 'Streak',
                              value: '...',
                              icon: Icons.local_fire_department,
                              color: AppColors.streak,
                            ),
                            error: (_, __) => _StatsCard(
                              title: 'Streak',
                              value: '0',
                              icon: Icons.local_fire_department,
                              color: AppColors.streak,
                            ),
                            data: (streak) => _StreakCard(
                              currentStreak: streak.currentStreak,
                              longestStreak: streak.longestStreak,
                              isAtRisk: streak.isAtRisk,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.verticalMD,
                    Row(
                      children: [
                        Expanded(
                          child: _StatsCard(
                            title: 'Volume',
                            value: stats.formattedVolume,
                            icon: Icons.trending_up,
                            color: AppColors.success,
                          ),
                        ),
                        AppSpacing.horizontalMD,
                        Expanded(
                          child: _StatsCard(
                            title: 'PRs',
                            value: stats.personalRecords.toString(),
                            icon: Icons.emoji_events,
                            color: AppColors.pr,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalLG,

              // Weekly volume chart
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Weekly Volume', style: AppTypography.titleMedium),
                        Text(
                          'This Week',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.verticalMD,
                    SizedBox(
                      height: 200,
                      child: weeklyVolumeAsync.when(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => const Center(child: Text('Error loading data')),
                        data: (volumes) {
                          final maxVolume = volumes.reduce((a, b) => a > b ? a : b);
                          return BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: maxVolume > 0 ? maxVolume * 1.2 : 30000,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      '${(rod.toY / 1000).toStringAsFixed(1)}K lbs',
                                      AppTypography.caption.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                      final today = DateTime.now().weekday - 1;
                                      final isToday = value.toInt() == today;
                                      return Text(
                                        days[value.toInt()],
                                        style: AppTypography.caption.copyWith(
                                          color: isToday 
                                              ? AppColors.secondary 
                                              : AppColors.textMuted,
                                          fontWeight: isToday 
                                              ? FontWeight.bold 
                                              : FontWeight.normal,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: const FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              barGroups: volumes.asMap().entries.map((entry) {
                                final today = DateTime.now().weekday - 1;
                                final isToday = entry.key == today;
                                return _makeBarGroup(
                                  entry.key, 
                                  entry.value,
                                  isToday: isToday,
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalLG,

              // Points card
              statsAsync.whenData((stats) {
                return AppCard(
                  backgroundColor: AppColors.primary.withAlpha(15),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bolt,
                          color: AppColors.primary,
                        ),
                      ),
                      AppSpacing.horizontalMD,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${stats.points} Points',
                              style: AppTypography.titleLarge.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              'Keep training to earn more!',
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).value ?? const SizedBox(),
              AppSpacing.verticalLG,

              // Quick links
              _QuickLinkCard(
                icon: Icons.emoji_events,
                title: 'Personal Records',
                subtitle: statsAsync.whenData((s) => '${s.personalRecords} PRs achieved').value ?? 'View your PRs',
                onTap: () => context.push(AppRoutes.personalRecords),
              ),
              AppSpacing.verticalMD,
              _QuickLinkCard(
                icon: Icons.history,
                title: 'Workout History',
                subtitle: statsAsync.whenData((s) => '${s.workoutsCompleted} workouts logged').value ?? 'View history',
                onTap: () => context.push(AppRoutes.workoutHistory),
              ),
              AppSpacing.verticalMD,
              _QuickLinkCard(
                icon: Icons.show_chart,
                title: 'Strength Progress',
                subtitle: 'Track your lifts over time',
                onTap: () {
                  // TODO: Strength progress screen
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsLoading() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildLoadingCard()),
            AppSpacing.horizontalMD,
            Expanded(child: _buildLoadingCard()),
          ],
        ),
        AppSpacing.verticalMD,
        Row(
          children: [
            Expanded(child: _buildLoadingCard()),
            AppSpacing.horizontalMD,
            Expanded(child: _buildLoadingCard()),
          ],
        ),
      ],
    );
  }
  
  Widget _buildLoadingCard() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
  
  Widget _buildStatsError() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 32),
          AppSpacing.verticalMD,
          Text(
            'Error loading stats',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, {bool isToday = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: y > 0 
              ? (isToday ? AppColors.secondary : AppColors.primary) 
              : AppColors.surface,
          width: 24,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          AppSpacing.verticalMD,
          Text(value, style: AppTypography.headlineLarge),
          Text(title, style: AppTypography.caption),
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final bool isAtRisk;

  const _StreakCard({
    required this.currentStreak,
    required this.longestStreak,
    required this.isAtRisk,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: isAtRisk ? AppColors.warningBg : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: isAtRisk ? AppColors.warning : AppColors.streak,
                size: 24,
              ),
              if (isAtRisk) ...[
                AppSpacing.horizontalSM,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withAlpha(40),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'AT RISK',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                    ),
                  ),
                ),
              ],
            ],
          ),
          AppSpacing.verticalMD,
          Text(
            currentStreak.toString(),
            style: AppTypography.headlineLarge.copyWith(
              color: isAtRisk ? AppColors.warning : null,
            ),
          ),
          Text(
            'Streak ${longestStreak > currentStreak ? '(Best: $longestStreak)' : ''}',
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickLinkCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          AppSpacing.horizontalMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium),
                Text(subtitle, style: AppTypography.caption),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
