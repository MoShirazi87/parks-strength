import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../data/providers/workout_provider.dart';
import '../../../data/providers/program_provider.dart';
import '../../auth/providers/auth_provider.dart';

/// Home screen - main dashboard with real data
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedDayIndex = DateTime.now().weekday; // 1 = Monday

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final todaysWorkout = ref.watch(todaysWorkoutProvider);
    final recentLogs = ref.watch(recentWorkoutLogsProvider);
    final activeEnrollment = ref.watch(activeEnrollmentProvider);
    final programs = ref.watch(programsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top bar with date and stats
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                  vertical: AppSpacing.md,
                ),
                child: _TopBar(
                  points: user.valueOrNull?.points ?? 0,
                  streak: user.valueOrNull?.currentStreak ?? 0,
                ),
              ),
            ),

            // Hero workout card
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                child: todaysWorkout.when(
                  loading: () => _buildHeroCardPlaceholder(),
                  error: (_, __) => _buildDefaultHeroCard(context, activeEnrollment.valueOrNull),
                  data: (workout) {
                    if (workout == null) {
                      return _buildDefaultHeroCard(context, activeEnrollment.valueOrNull);
                    }
                    
                    final programName = activeEnrollment.valueOrNull?['program']?['name'] ?? 'TITAN';
                    
                    return _HeroWorkoutCard(
                      programName: programName,
                      workoutTitle: workout.name,
                      duration: workout.estimatedDurationMinutes,
                      exerciseCount: workout.allExercises.length,
                      onTap: () => context.push('/workout/${workout.id}'),
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
                  },
                ),
              ),
            ),
            
            SliverToBoxAdapter(child: AppSpacing.verticalMD),

            // Weekly schedule tabs
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                child: _WeeklySchedule(
                  selectedIndex: _selectedDayIndex,
                  onDaySelected: (index) {
                    setState(() => _selectedDayIndex = index);
                  },
                ).animate().fadeIn(delay: 100.ms),
              ),
            ),
            
            SliverToBoxAdapter(child: AppSpacing.verticalLG),

            // Quick actions
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: AppSpacing.screenHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick Start', style: AppTypography.headlineSmall),
                    AppSpacing.verticalMD,
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          // Quick workout generators - intelligently filter by user equipment
                          _QuickActionCard(
                            icon: Icons.arrow_upward_rounded,
                            label: 'Push',
                            color: AppColors.primary,
                            onTap: () => context.push('/quick-workout/push'),
                          ),
                          _QuickActionCard(
                            icon: Icons.arrow_downward_rounded,
                            label: 'Pull',
                            color: AppColors.accent,
                            onTap: () => context.push('/quick-workout/pull'),
                          ),
                          _QuickActionCard(
                            icon: Icons.directions_run_rounded,
                            label: 'Legs',
                            color: AppColors.success,
                            onTap: () => context.push('/quick-workout/legs'),
                          ),
                          _QuickActionCard(
                            icon: Icons.circle_outlined,
                            label: 'Core',
                            color: AppColors.warning,
                            onTap: () => context.push('/quick-workout/core'),
                          ),
                          _QuickActionCard(
                            icon: Icons.person_rounded,
                            label: 'Full Body',
                            color: AppColors.tertiary,
                            onTap: () => context.push('/quick-workout/fullbody'),
                          ),
                          _QuickActionCard(
                            icon: Icons.fitness_center_rounded,
                            label: 'Programs',
                            color: AppColors.streak,
                            onTap: () => context.push(AppRoutes.programs),
                          ),
                          SizedBox(width: AppSpacing.screenHorizontal),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 200.ms),
              ),
            ),
            
            SliverToBoxAdapter(child: AppSpacing.verticalLG),

            // Programs section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Programs', style: AppTypography.headlineSmall),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.programs),
                      child: Text(
                        'View All',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: programs.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => _buildDefaultPrograms(context),
                  data: (programList) {
                    if (programList.isEmpty) {
                      return _buildDefaultPrograms(context);
                    }
                    
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenHorizontal,
                      ),
                      itemCount: programList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == programList.length) {
                          return SizedBox(width: AppSpacing.screenHorizontal);
                        }
                        
                        final program = programList[index];
                        Color color = AppColors.programTitan;
                        if (program.accentColor != null) {
                          try {
                            color = Color(int.parse(program.accentColor!.replaceFirst('#', '0xFF')));
                          } catch (_) {}
                        }
                        
                        return _ProgramCard(
                          name: program.name.toUpperCase(),
                          description: program.shortDescription ?? '${program.durationWeeks}-Week Program',
                          color: color,
                          imageUrl: _getProgramImage(program.slug ?? ''),
                          onTap: () => context.push('/programs/${program.id}'),
                        );
                      },
                    );
                  },
                ).animate().fadeIn(delay: 300.ms),
              ),
            ),
            
            SliverToBoxAdapter(child: AppSpacing.verticalLG),

            // Recent activity
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recent Activity', style: AppTypography.headlineSmall),
                    AppSpacing.verticalMD,
                    recentLogs.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => _buildEmptyActivity(),
                      data: (logs) {
                        if (logs.isEmpty) {
                          return _buildEmptyActivity();
                        }
                        
                        return Column(
                          children: logs.take(3).map((log) {
                            final workoutName = log['workout']?['name'] ?? 'Workout';
                            final completedAt = log['completed_at'] != null 
                                ? DateTime.parse(log['completed_at'] as String)
                                : DateTime.now();
                            final durationSeconds = log['duration_seconds'] as int? ?? 0;
                            final totalVolume = (log['total_volume'] as num?)?.toDouble() ?? 0;
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _RecentActivityCard(
                                title: workoutName,
                                date: completedAt,
                                duration: durationSeconds ~/ 60,
                                prCount: 0, // TODO: Count PRs from log
                                volume: totalVolume,
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ).animate().fadeIn(delay: 400.ms),
              ),
            ),

            // Bottom padding for nav bar
            SliverToBoxAdapter(
              child: SizedBox(height: AppConstants.bottomNavHeight + 20),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeroCardPlaceholder() {
    return Container(
      height: AppConstants.heroCardHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusHero),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
  
  Widget _buildDefaultHeroCard(BuildContext context, Map<String, dynamic>? enrollment) {
    final programName = enrollment?['program']?['name'] ?? 'TITAN';
    
    return _HeroWorkoutCard(
      programName: programName,
      workoutTitle: 'Push Day',
      duration: 45,
      exerciseCount: 6,
      onTap: () => context.push('/workout/demo'),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }
  
  Widget _buildDefaultPrograms(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      children: [
        _ProgramCard(
          name: 'TITAN',
          description: '12-Week Strength Builder',
          color: AppColors.programTitan,
          imageUrl: 'https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg?auto=compress&cs=tinysrgb&w=600',
          onTap: () => context.push(AppRoutes.programs),
        ),
        _ProgramCard(
          name: 'FORGE',
          description: '3-Day Full Body',
          color: AppColors.programBlaze,
          imageUrl: 'https://images.pexels.com/photos/841130/pexels-photo-841130.jpeg?auto=compress&cs=tinysrgb&w=600',
          onTap: () => context.push(AppRoutes.programs),
        ),
        _ProgramCard(
          name: 'NOMAD',
          description: 'Minimal Equipment',
          color: AppColors.programNomad,
          imageUrl: 'https://images.pexels.com/photos/2294361/pexels-photo-2294361.jpeg?auto=compress&cs=tinysrgb&w=600',
          onTap: () => context.push(AppRoutes.programs),
        ),
        SizedBox(width: AppSpacing.screenHorizontal),
      ],
    );
  }
  
  Widget _buildEmptyActivity() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          Icon(
            Icons.fitness_center_rounded,
            size: 48,
            color: AppColors.textMuted,
          ),
          AppSpacing.verticalMD,
          Text(
            'No workouts yet',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.verticalSM,
          Text(
            'Start a program to begin your journey',
            style: AppTypography.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  String _getProgramImage(String slug) {
    final images = {
      'titan': 'https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg?auto=compress&cs=tinysrgb&w=600',
      'forge': 'https://images.pexels.com/photos/841130/pexels-photo-841130.jpeg?auto=compress&cs=tinysrgb&w=600',
      'nomad': 'https://images.pexels.com/photos/2294361/pexels-photo-2294361.jpeg?auto=compress&cs=tinysrgb&w=600',
      'foundation-strength': 'https://images.pexels.com/photos/4164761/pexels-photo-4164761.jpeg?auto=compress&cs=tinysrgb&w=600',
    };
    return images[slug] ?? 'https://images.pexels.com/photos/4164761/pexels-photo-4164761.jpeg?auto=compress&cs=tinysrgb&w=600';
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TOP BAR WIDGET
// ═══════════════════════════════════════════════════════════════════════════

class _TopBar extends StatelessWidget {
  final int points;
  final int streak;

  const _TopBar({
    required this.points,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMM d');
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Date pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 14,
                color: AppColors.textSecondary,
              ),
              AppSpacing.horizontalSM,
              Text(
                dateFormat.format(now),
                style: AppTypography.labelMedium,
              ),
            ],
          ),
        ),

        // Stats badges
        Row(
          children: [
            // Points
            _StatBadge(
              icon: Icons.bolt_rounded,
              value: points.toString(),
              color: AppColors.points,
            ),
            AppSpacing.horizontalSM,
            // Streak
            _StatBadge(
              icon: Icons.local_fire_department_rounded,
              value: streak.toString(),
              color: AppColors.streak,
              isGlowing: streak >= 7,
            ),
          ],
        ),
      ],
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  final bool isGlowing;

  const _StatBadge({
    required this.icon,
    required this.value,
    required this.color,
    this.isGlowing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: isGlowing
            ? [
                BoxShadow(
                  color: color.withAlpha(80),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          AppSpacing.horizontalXS,
          Text(
            value,
            style: AppTypography.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HERO WORKOUT CARD
// ═══════════════════════════════════════════════════════════════════════════

class _HeroWorkoutCard extends StatelessWidget {
  final String programName;
  final String workoutTitle;
  final int duration;
  final int exerciseCount;
  final VoidCallback onTap;

  const _HeroWorkoutCard({
    required this.programName,
    required this.workoutTitle,
    required this.duration,
    required this.exerciseCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppConstants.heroCardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusHero),
          gradient: AppColors.cardGradient,
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Stack(
          children: [
            // Background image placeholder
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusHero),
                child: Image.network(
                  'https://images.pexels.com/photos/4164761/pexels-photo-4164761.jpeg?auto=compress&cs=tinysrgb&w=800',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withAlpha(30),
                          AppColors.tertiary.withAlpha(20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusHero),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background.withAlpha(180),
                      AppColors.background.withAlpha(240),
                    ],
                    stops: const [0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Program tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.programTitan.withAlpha(40),
                      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                      border: Border.all(
                        color: AppColors.programTitan.withAlpha(100),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.programTitan,
                            shape: BoxShape.circle,
                          ),
                        ),
                        AppSpacing.horizontalXS,
                        Text(
                          programName.toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.programTitan,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' / Coach Brian',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),

                  // Today's workout
                  Text(
                    'TODAY\'S WORKOUT',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 2,
                    ),
                  ),
                  AppSpacing.verticalXS,
                  
                  Text(
                    workoutTitle,
                    style: AppTypography.displaySmall.copyWith(
                      height: 1.1,
                    ),
                  ),
                  AppSpacing.verticalMD,

                  // Stats row
                  Row(
                    children: [
                      _WorkoutStat(
                        icon: Icons.timer_outlined,
                        label: '$duration min',
                      ),
                      AppSpacing.horizontalLG,
                      _WorkoutStat(
                        icon: Icons.fitness_center_rounded,
                        label: '$exerciseCount exercises',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Start button
            Positioned(
              right: 20,
              bottom: 20,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: AppConstants.shadowMd,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutStat extends StatelessWidget {
  final IconData icon;
  final String label;

  const _WorkoutStat({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.secondary),
        AppSpacing.horizontalXS,
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// WEEKLY SCHEDULE
// ═══════════════════════════════════════════════════════════════════════════

class _WeeklySchedule extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;

  const _WeeklySchedule({
    required this.selectedIndex,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    const days = ['Intro', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final today = DateTime.now().weekday;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(days.length, (index) {
          final isSelected = index == selectedIndex;
          final isToday = index == today;
          
          return GestureDetector(
            onTap: () => onDaySelected(index),
            child: AnimatedContainer(
              duration: AppConstants.animationFast,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppColors.primary.withAlpha(30)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    days[index],
                    style: AppTypography.labelSmall.copyWith(
                      color: isSelected 
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                      fontWeight: isSelected 
                          ? FontWeight.w600 
                          : FontWeight.normal,
                    ),
                  ),
                  if (isToday || isSelected) ...[
                    AppSpacing.verticalXS,
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isToday 
                            ? AppColors.secondary 
                            : AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// QUICK ACTION CARD
// ═══════════════════════════════════════════════════════════════════════════

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
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 70,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withAlpha(60),
                    width: 1.5,
                  ),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PROGRAM CARD
// ═══════════════════════════════════════════════════════════════════════════

class _ProgramCard extends StatelessWidget {
  final String name;
  final String description;
  final Color color;
  final String imageUrl;
  final VoidCallback onTap;

  const _ProgramCard({
    required this.name,
    required this.description,
    required this.color,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withAlpha(60), color.withAlpha(30)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              
              // Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background.withAlpha(220),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusFull,
                        ),
                      ),
                      child: Text(
                        name,
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AppSpacing.verticalXS,
                    Text(
                      description,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// RECENT ACTIVITY CARD
// ═══════════════════════════════════════════════════════════════════════════

class _RecentActivityCard extends StatelessWidget {
  final String title;
  final DateTime date;
  final int duration;
  final int prCount;
  final double volume;

  const _RecentActivityCard({
    required this.title,
    required this.date,
    required this.duration,
    required this.prCount,
    required this.volume,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d');
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: const Icon(
              Icons.fitness_center_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          AppSpacing.horizontalMD,
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium),
                AppSpacing.verticalXS,
                Row(
                  children: [
                    Text(
                      dateFormat.format(date),
                      style: AppTypography.caption,
                    ),
                    Text(
                      ' · ${duration}m',
                      style: AppTypography.caption,
                    ),
                    if (prCount > 0) ...[
                      Text(' · ', style: AppTypography.caption),
                      Icon(
                        Icons.emoji_events_rounded,
                        size: 12,
                        color: AppColors.pr,
                      ),
                      Text(
                        ' $prCount PR${prCount > 1 ? 's' : ''}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.pr,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Volume
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Text(
              '${_formatVolume(volume)} lbs',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatVolume(double volume) {
    if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}k';
    }
    return volume.toStringAsFixed(0);
  }
}
