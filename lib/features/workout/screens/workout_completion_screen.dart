import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/algorithms/progressive_overload.dart';
import '../../../core/router/app_router.dart';
import '../../../main.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../auth/providers/auth_provider.dart';

/// Provider for workout log data
final workoutLogProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, logId) async {
  if (logId.isEmpty) return null;
  
  try {
    final response = await supabase
        .from('workout_logs')
        .select('''
          *,
          workout:workouts (name),
          exercise_logs (
            *,
            exercise:exercises (name),
            set_logs (*)
          )
        ''')
        .eq('id', logId)
        .maybeSingle();
    
    return response;
  } catch (e) {
    print('Error fetching workout log: $e');
    return null;
  }
});

/// Workout completion celebration screen with real data
class WorkoutCompletionScreen extends ConsumerStatefulWidget {
  final String workoutLogId;

  const WorkoutCompletionScreen({super.key, required this.workoutLogId});

  @override
  ConsumerState<WorkoutCompletionScreen> createState() =>
      _WorkoutCompletionScreenState();
}

class _WorkoutCompletionScreenState extends ConsumerState<WorkoutCompletionScreen> {
  late ConfettiController _confettiController;
  int _rating = 0;
  List<Map<String, dynamic>> _prs = [];
  List<String> _progressionSuggestions = [];

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
  
  void _analyzeWorkout(Map<String, dynamic> logData) {
    final exerciseLogs = logData['exercise_logs'] as List<dynamic>? ?? [];
    
    for (final exerciseLog in exerciseLogs) {
      final exerciseName = exerciseLog['exercise']?['name'] ?? 'Unknown';
      final setLogs = exerciseLog['set_logs'] as List<dynamic>? ?? [];
      
      for (final setLog in setLogs) {
        final weight = (setLog['weight'] as num?)?.toDouble() ?? 0;
        final reps = setLog['reps'] as int? ?? 0;
        final isPR = setLog['is_pr'] as bool? ?? false;
        
        if (isPR && weight > 0) {
          _prs.add({
            'exercise': exerciseName,
            'weight': weight,
            'reps': reps,
          });
        }
        
        // Check for progression opportunities based on reps achieved
        if (weight > 0 && reps > 0) {
          if (reps >= 12) {
            _progressionSuggestions.add(
              'Consider increasing weight on $exerciseName next session',
            );
          }
        }
      }
    }
  }

  Future<void> _saveRating() async {
    if (_rating > 0 && widget.workoutLogId.isNotEmpty) {
      try {
        await supabase.from('workout_logs').update({
          'rating': _rating,
        }).eq('id', widget.workoutLogId);
      } catch (e) {
        print('Error saving rating: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final logAsync = ref.watch(workoutLogProvider(widget.workoutLogId));
    final user = ref.watch(currentUserProvider);
    
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
            child: logAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _buildDefaultContent(user.valueOrNull?.currentStreak ?? 0),
              data: (logData) {
                if (logData == null) {
                  return _buildDefaultContent(user.valueOrNull?.currentStreak ?? 0);
                }
                
                // Analyze workout for PRs and suggestions
                if (_prs.isEmpty && _progressionSuggestions.isEmpty) {
                  _analyzeWorkout(logData);
                }
                
                return _buildContent(logData, user.valueOrNull?.currentStreak ?? 0);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContent(Map<String, dynamic> logData, int streak) {
    final workoutName = logData['workout']?['name'] ?? 'Workout';
    final completedAt = logData['completed_at'] != null 
        ? DateTime.parse(logData['completed_at'] as String)
        : DateTime.now();
    final durationSeconds = logData['duration_seconds'] as int? ?? 0;
    final totalVolume = (logData['total_volume'] as num?)?.toDouble() ?? 0;
    final totalSets = logData['total_sets'] as int? ?? 0;
    final pointsEarned = logData['points_earned'] as int? ?? 0;
    
    final dateFormat = DateFormat('MMMM d, yyyy');
    final durationMinutes = durationSeconds ~/ 60;
    
    return SingleChildScrollView(
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
            _getMotivationalQuote(),
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
                Text(workoutName, style: AppTypography.titleLarge),
                AppSpacing.verticalXS,
                Text(
                  dateFormat.format(completedAt),
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
                      value: '$durationMinutes',
                      label: 'min',
                    ),
                    _SummaryItem(
                      icon: Icons.fitness_center,
                      value: _formatVolume(totalVolume),
                      label: 'lbs volume',
                    ),
                    _SummaryItem(
                      icon: Icons.check_circle,
                      value: '$totalSets',
                      label: 'sets',
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.verticalMD,

          // Points earned
          if (pointsEarned > 0)
            AppCard(
              backgroundColor: AppColors.points.withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(
                    Icons.bolt,
                    color: AppColors.points,
                    size: 32,
                  ),
                  AppSpacing.horizontalMD,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '+$pointsEarned Points',
                          style: AppTypography.titleLarge.copyWith(
                            color: AppColors.points,
                          ),
                        ),
                        Text(
                          'Keep earning to unlock rewards!',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (pointsEarned > 0) AppSpacing.verticalMD,

          // PR highlight (if any)
          if (_prs.isNotEmpty)
            ..._prs.map((pr) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                backgroundColor: AppColors.pr.withOpacity(0.1),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: AppColors.pr,
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
                              color: AppColors.pr,
                            ),
                          ),
                          Text(
                            '${pr['exercise']}: ${pr['weight']} lbs × ${pr['reps']}',
                            style: AppTypography.bodyMedium,
                          ),
                          Text(
                            'Est. 1RM: ${ProgressiveOverloadEngine.estimateOneRepMax(pr['weight'], pr['reps']).toStringAsFixed(0)} lbs',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.pr,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
          
          // Progressive Overload Suggestions
          if (_progressionSuggestions.isNotEmpty) ...[
            AppCard(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.trending_up, color: AppColors.primary, size: 24),
                      AppSpacing.horizontalSM,
                      Text(
                        'Next Session Tips',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.verticalMD,
                  ..._progressionSuggestions.take(3).map((suggestion) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.arrow_right, color: AppColors.primary, size: 20),
                        AppSpacing.horizontalXS,
                        Expanded(
                          child: Text(
                            suggestion,
                            style: AppTypography.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            AppSpacing.verticalMD,
          ],

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
          if (streak > 0)
            AppCard(
              child: Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: streak >= 7 ? AppColors.streak : AppColors.warning,
                    size: 40,
                  ),
                  AppSpacing.horizontalMD,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$streak Day Streak!',
                        style: AppTypography.titleLarge.copyWith(
                          color: streak >= 7 ? AppColors.streak : AppColors.warning,
                        ),
                      ),
                      Text(
                        streak >= 7 ? "You're on fire! 🔥" : 'Keep it going!',
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
            onPressed: () {
              _saveRating();
              context.go(AppRoutes.home);
            },
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
    );
  }
  
  Widget _buildDefaultContent(int streak) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          AppSpacing.verticalXL,

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

          Text(
            'Workout Complete!',
            style: AppTypography.displaySmall,
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalSM,
          Text(
            _getMotivationalQuote(),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
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

          if (streak > 0)
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
                        '$streak Day Streak!',
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

          AppButton(
            text: 'Done',
            onPressed: () {
              _saveRating();
              context.go(AppRoutes.home);
            },
          ),
          AppSpacing.verticalXL,
        ],
      ),
    );
  }
  
  String _getMotivationalQuote() {
    final quotes = [
      '"Great work! Every rep counts."',
      '"Strength is built one day at a time."',
      '"You showed up. That\'s what matters."',
      '"The only bad workout is the one that didn\'t happen."',
      '"Progress, not perfection."',
      '"You\'re stronger than you think."',
    ];
    return quotes[DateTime.now().millisecond % quotes.length];
  }
  
  String _formatVolume(double volume) {
    if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}k';
    }
    return volume.toStringAsFixed(0);
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
