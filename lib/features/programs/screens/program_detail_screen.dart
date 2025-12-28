import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/selection_chip.dart';

/// Program detail screen
class ProgramDetailScreen extends StatelessWidget {
  final String programId;

  const ProgramDetailScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back),
              ),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.programTitan.withOpacity(0.6),
                          AppColors.background,
                        ],
                      ),
                    ),
                  ),
                  // Content
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Program badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.programTitan.withOpacity(0.3),
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
                        AppSpacing.verticalMD,
                        Text(
                          'Foundation\nStrength',
                          style: AppTypography.displaySmall,
                        ),
                        AppSpacing.verticalSM,
                        Text(
                          'Coach Brian Parks',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick stats
                  Row(
                    children: [
                      _QuickStat(icon: Icons.calendar_today, label: '8 Weeks'),
                      _QuickStat(icon: Icons.fitness_center, label: '4x/week'),
                      _QuickStat(icon: Icons.timer, label: '45-60 min'),
                      _QuickStat(icon: Icons.trending_up, label: 'Intermediate'),
                    ],
                  ),
                  AppSpacing.verticalLG,

                  // Description
                  Text('About This Program', style: AppTypography.titleLarge),
                  AppSpacing.verticalMD,
                  Text(
                    'Build a solid foundation of functional strength with this comprehensive 8-week program. Perfect for those ready to take their training seriously and develop lasting strength.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  AppSpacing.verticalLG,

                  // Equipment section
                  _CollapsibleSection(
                    title: 'Equipment',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Barbell', 'Dumbbells', 'Pull-up Bar',
                        'Bench', 'Cable Machine'
                      ]
                          .map((e) => SelectionChip(
                                label: e,
                                isSelected: false,
                              ))
                          .toList(),
                    ),
                  ),
                  AppSpacing.verticalMD,

                  // Goals section
                  _CollapsibleSection(
                    title: 'Goals',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _GoalItem(text: 'Build foundational strength'),
                        _GoalItem(text: 'Improve movement quality'),
                        _GoalItem(text: 'Increase core stability'),
                        _GoalItem(text: 'Progressive overload mastery'),
                      ],
                    ),
                  ),
                  AppSpacing.verticalMD,

                  // Week structure
                  _CollapsibleSection(
                    title: 'Program Structure',
                    child: Column(
                      children: [
                        _WeekItem(week: 1, title: 'Movement Foundations'),
                        _WeekItem(week: 2, title: 'Building Strength'),
                        _WeekItem(week: 3, title: 'Progressive Loading'),
                        _WeekItem(week: 4, title: 'Deload Week'),
                        _WeekItem(week: 5, title: 'Strength Phase'),
                        _WeekItem(week: 6, title: 'Intensity Increase'),
                        _WeekItem(week: 7, title: 'Peak Week'),
                        _WeekItem(week: 8, title: 'Testing & Transition'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(
              color: AppColors.border.withOpacity(0.5),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: AppButton(
            text: 'Start Program',
            onPressed: () => context.go(AppRoutes.home),
          ),
        ),
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickStat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.textMuted),
          AppSpacing.verticalXS,
          Text(
            label,
            style: AppTypography.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CollapsibleSection extends StatefulWidget {
  final String title;
  final Widget child;

  const _CollapsibleSection({required this.title, required this.child});

  @override
  State<_CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<_CollapsibleSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: AppTypography.titleMedium),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            AppSpacing.verticalMD,
            widget.child,
          ],
        ],
      ),
    );
  }
}

class _GoalItem extends StatelessWidget {
  final String text;

  const _GoalItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: AppColors.success),
          AppSpacing.horizontalMD,
          Text(text, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}

class _WeekItem extends StatelessWidget {
  final int week;
  final String title;

  const _WeekItem({required this.week, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.inputFill,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                week.toString(),
                style: AppTypography.labelMedium,
              ),
            ),
          ),
          AppSpacing.horizontalMD,
          Expanded(
            child: Text(
              'Week $week: $title',
              style: AppTypography.bodyMedium,
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textMuted,
            size: 20,
          ),
        ],
      ),
    );
  }
}

