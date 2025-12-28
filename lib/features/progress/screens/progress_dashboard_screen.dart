import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/app_card.dart';

/// Progress dashboard screen
class ProgressDashboardScreen extends StatefulWidget {
  const ProgressDashboardScreen({super.key});

  @override
  State<ProgressDashboardScreen> createState() =>
      _ProgressDashboardScreenState();
}

class _ProgressDashboardScreenState extends State<ProgressDashboardScreen> {
  String _selectedRange = '30 days';

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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

            // Stats cards
            Row(
              children: [
                Expanded(
                  child: _StatsCard(
                    title: 'Workouts',
                    value: '12',
                    icon: Icons.fitness_center,
                    color: AppColors.primary,
                  ),
                ),
                AppSpacing.horizontalMD,
                Expanded(
                  child: _StatsCard(
                    title: 'Streak',
                    value: '7',
                    icon: Icons.local_fire_department,
                    color: AppColors.streak,
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
                    value: '124K',
                    icon: Icons.trending_up,
                    color: AppColors.success,
                  ),
                ),
                AppSpacing.horizontalMD,
                Expanded(
                  child: _StatsCard(
                    title: 'PRs',
                    value: '5',
                    icon: Icons.emoji_events,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            AppSpacing.verticalLG,

            // Weekly volume chart
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Weekly Volume', style: AppTypography.titleMedium),
                  AppSpacing.verticalMD,
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 30000,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                return Text(
                                  days[value.toInt()],
                                  style: AppTypography.caption,
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
                        barGroups: [
                          _makeBarGroup(0, 18000),
                          _makeBarGroup(1, 22000),
                          _makeBarGroup(2, 0),
                          _makeBarGroup(3, 25000),
                          _makeBarGroup(4, 20000),
                          _makeBarGroup(5, 0),
                          _makeBarGroup(6, 15000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.verticalLG,

            // Quick links
            _QuickLinkCard(
              icon: Icons.emoji_events,
              title: 'Personal Records',
              subtitle: '5 PRs achieved',
              onTap: () => context.push(AppRoutes.personalRecords),
            ),
            AppSpacing.verticalMD,
            _QuickLinkCard(
              icon: Icons.history,
              title: 'Workout History',
              subtitle: '12 workouts logged',
              onTap: () => context.push(AppRoutes.workoutHistory),
            ),
            AppSpacing.verticalMD,
            _QuickLinkCard(
              icon: Icons.monitor_weight,
              title: 'Bodyweight Log',
              subtitle: 'Track your weight',
              onTap: () {},
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: y > 0 ? AppColors.primary : AppColors.surface,
          width: 20,
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
          Icon(icon, color: AppColors.textSecondary),
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

