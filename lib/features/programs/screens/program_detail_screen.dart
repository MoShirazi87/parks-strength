import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../data/providers/program_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/selection_chip.dart';

/// Program detail screen with real data
class ProgramDetailScreen extends ConsumerStatefulWidget {
  final String programId;

  const ProgramDetailScreen({super.key, required this.programId});

  @override
  ConsumerState<ProgramDetailScreen> createState() => _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends ConsumerState<ProgramDetailScreen> {
  bool _isEnrolling = false;

  Future<void> _startProgram() async {
    setState(() => _isEnrolling = true);
    
    try {
      final programRepo = ProgramRepository();
      
      // First, get first workout of the program (even before enrolling)
      final firstWorkoutId = await programRepo.getFirstWorkoutId(widget.programId);
      
      // Enroll user in program
      final enrolled = await programRepo.enrollInProgram(widget.programId);
      
      if (!enrolled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not enroll. Check your connection and try again.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        // Still try to navigate to workout even if enrollment fails
        if (firstWorkoutId != null && mounted) {
          context.push('/workout/$firstWorkoutId');
          return;
        }
        return;
      }
      
      if (mounted) {
        if (firstWorkoutId != null) {
          // Navigate to the first workout
          context.push('/workout/$firstWorkoutId');
        } else {
          // No workouts yet - start demo workout
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Program enrolled! Starting demo workout.'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to demo workout with the program's first workout pattern
          context.push('/workout/demo-${widget.programId}/active');
        }
      }
    } catch (e) {
      print('Start program error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString().split(':').last.trim()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isEnrolling = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final programAsync = ref.watch(programProvider(widget.programId));
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: programAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (program) {
          if (program == null) {
            return const Center(child: Text('Program not found'));
          }
          
          // Parse accent color
          Color accentColor = AppColors.programTitan;
          if (program.accentColor != null) {
            try {
              accentColor = Color(int.parse(program.accentColor!.replaceFirst('#', '0xFF')));
            } catch (_) {}
          }
          
          return CustomScrollView(
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
                              accentColor.withOpacity(0.6),
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
                                color: accentColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: accentColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  AppSpacing.horizontalSM,
                                  Text(
                                    program.difficulty.toUpperCase(),
                                    style: AppTypography.caption.copyWith(
                                      color: accentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppSpacing.verticalMD,
                            Text(
                              program.name,
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
                          _QuickStat(
                            icon: Icons.calendar_today, 
                            label: '${program.durationWeeks} Weeks',
                          ),
                          _QuickStat(
                            icon: Icons.fitness_center, 
                            label: '${program.daysPerWeek}x/week',
                          ),
                          const _QuickStat(
                            icon: Icons.timer, 
                            label: '45-60 min',
                          ),
                          _QuickStat(
                            icon: Icons.trending_up, 
                            label: program.difficulty.capitalize(),
                          ),
                        ],
                      ),
                      AppSpacing.verticalLG,

                      // Description
                      Text('About This Program', style: AppTypography.titleLarge),
                      AppSpacing.verticalMD,
                      Text(
                        program.description ?? program.shortDescription ?? 
                            'Build functional strength with this comprehensive program.',
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
                      if (program.goals.isNotEmpty)
                        _CollapsibleSection(
                          title: 'Goals',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: program.goals
                                .map((g) => _GoalItem(text: _formatGoal(g)))
                                .toList(),
                          ),
                        )
                      else
                        _CollapsibleSection(
                          title: 'Goals',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
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
                          children: List.generate(
                            program.durationWeeks,
                            (i) => _WeekItem(
                              week: i + 1, 
                              title: _getWeekTitle(i + 1, program.durationWeeks),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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
            text: _isEnrolling ? 'Starting...' : 'Start Program',
            onPressed: _isEnrolling ? null : _startProgram,
            isLoading: _isEnrolling,
          ),
        ),
      ),
    );
  }
  
  String _formatGoal(String goal) {
    return goal.replaceAll('_', ' ').split(' ').map((w) => 
      w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : ''
    ).join(' ');
  }
  
  String _getWeekTitle(int week, int totalWeeks) {
    if (week == 1) return 'Movement Foundations';
    if (week == 2) return 'Building Strength';
    if (week == totalWeeks ~/ 2) return 'Deload Week';
    if (week == totalWeeks - 1) return 'Peak Week';
    if (week == totalWeeks) return 'Testing & Transition';
    return 'Progressive Loading';
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

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
