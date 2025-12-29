import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/floating_bubbles.dart';
import '../../../shared/widgets/selection_chip.dart';
import '../../../shared/widgets/page_indicator.dart';
import '../../auth/providers/auth_provider.dart';

/// 8-step onboarding wizard
class OnboardingWizardScreen extends ConsumerStatefulWidget {
  const OnboardingWizardScreen({super.key});

  @override
  ConsumerState<OnboardingWizardScreen> createState() =>
      _OnboardingWizardScreenState();
}

class _OnboardingWizardScreenState
    extends ConsumerState<OnboardingWizardScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 8;

  // Form data
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String? _experienceLevel;
  List<String> _selectedGoals = [];
  List<String> _selectedExerciseTypes = [];
  String? _trainingLocation;
  List<String> _selectedEquipment = [];
  List<String> _selectedDays = [];
  String _reminderTime = '7:00 AM';
  List<String> _selectedInjuries = [];
  final _injuryNotesController = TextEditingController();
  bool _workoutReminders = true;
  bool _restDayCheckins = true;
  bool _coachUpdates = true;
  bool _weeklyProgress = true;

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _injuryNotesController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      final authService = ref.read(authServiceProvider);
      final success = await authService.updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        experienceLevel: _experienceLevel,
        goals: _selectedGoals,
        exercisePreferences: _selectedExerciseTypes,
        trainingLocation: _trainingLocation,
        preferredDays: _selectedDays,
        reminderTime: _reminderTime,
        injuries: _selectedInjuries,
        onboardingCompleted: true,
        notificationWorkoutReminders: _workoutReminders,
        notificationRestDayCheckins: _restDayCheckins,
        notificationCoachUpdates: _coachUpdates,
        notificationWeeklyProgress: _weeklyProgress,
      );
      
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        
        if (success) {
          context.go(AppRoutes.programRecommendation);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save preferences. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with back button and sign out option
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _previousStep,
                    )
                  else
                    // Sign out button on first step
                    TextButton.icon(
                      onPressed: () async {
                        await ref.read(authServiceProvider).signOut();
                        if (mounted) {
                          context.go(AppRoutes.welcome);
                        }
                      },
                      icon: const Icon(Icons.logout, size: 18, color: AppColors.textMuted),
                      label: Text(
                        'Sign Out',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  const Spacer(),
                  // Skip button (optional steps only)
                  if (_currentStep > 1)
                    TextButton(
                      onPressed: _nextStep,
                      child: Text(
                        'Skip',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: [
                  _buildStep1BasicInfo(),
                  _buildStep2Experience(),
                  _buildStep3Goals(),
                  _buildStep4ExerciseTypes(),
                  _buildStep5Equipment(),
                  _buildStep6Schedule(),
                  _buildStep7Injuries(),
                  _buildStep8Notifications(),
                ],
              ),
            ),

            // Progress dots and next button
            Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  ProgressDots(
                    totalSteps: _totalSteps,
                    currentStep: _currentStep,
                  ),
                  AppSpacing.verticalLG,
                  AppButton(
                    text: _currentStep == _totalSteps - 1
                        ? 'Complete Setup'
                        : 'NEXT →',
                    onPressed: _nextStep,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1BasicInfo() {
    return SingleChildScrollView(
      padding: AppSpacing.screenHorizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Let's Get to\nKnow You", style: AppTypography.displaySmall),
          AppSpacing.verticalXL,

          // Profile photo picker
          Center(
            child: GestureDetector(
              onTap: () {
                // TODO: Implement image picker
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 40,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
          AppSpacing.verticalLG,

          // Name fields
          AppTextField(
            label: 'First Name',
            hint: 'Enter your first name',
            controller: _firstNameController,
            textInputAction: TextInputAction.next,
          ),
          AppSpacing.verticalMD,
          AppTextField(
            label: 'Last Name',
            hint: 'Enter your last name',
            controller: _lastNameController,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Experience() {
    final levels = [
      {
        'id': 'beginner',
        'title': 'Beginner',
        'description': 'New to strength training (0-6 months)',
      },
      {
        'id': 'intermediate',
        'title': 'Intermediate',
        'description': 'Consistent training (1-3 years)',
      },
      {
        'id': 'advanced',
        'title': 'Advanced',
        'description': 'Experienced lifter (3+ years)',
      },
    ];

    return SingleChildScrollView(
      padding: AppSpacing.screenHorizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("What's Your\nTraining Experience?",
              style: AppTypography.displaySmall),
          AppSpacing.verticalXL,
          ...levels.map((level) {
            final isSelected = _experienceLevel == level['id'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _experienceLevel = level['id'];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              level['title']!,
                              style: AppTypography.titleLarge,
                            ),
                            AppSpacing.verticalXS,
                            Text(
                              level['description']!,
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStep3Goals() {
    return Padding(
      padding: AppSpacing.screenHorizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("What Are You\nTraining For?", style: AppTypography.displaySmall),
          AppSpacing.verticalSM,
          Text(
            'Select all that apply',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
          ),
          AppSpacing.verticalLG,
          Expanded(
            child: FloatingBubbles(
              items: goalBubbles,
              selectedIds: _selectedGoals,
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedGoals = selected;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4ExerciseTypes() {
    return Padding(
      padding: AppSpacing.screenHorizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Choose type of\nexercise", style: AppTypography.displaySmall),
          AppSpacing.verticalSM,
          Text(
            'What training styles interest you?',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
          ),
          AppSpacing.verticalLG,
          Expanded(
            child: FloatingBubbles(
              items: exerciseTypeBubbles,
              selectedIds: _selectedExerciseTypes,
              onSelectionChanged: (selected) {
                setState(() {
                  _selectedExerciseTypes = selected;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep5Equipment() {
    final equipmentOptions = [
      'Barbell', 'Dumbbells', 'Kettlebells', 'Cable Machine',
      'Resistance Bands', 'Pull-up Bar', 'Bench', 'Squat Rack',
      'Leg Press', 'Battle Ropes', 'Jump Ropes', 'Medicine Ball',
    ];

    return SingleChildScrollView(
      padding: AppSpacing.screenHorizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("What Equipment\nDo You Have?", style: AppTypography.displaySmall),
          AppSpacing.verticalSM,
          Text(
            "We'll customize your workouts",
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
          ),
          AppSpacing.verticalLG,

          // Training location
          Text('Training Location', style: AppTypography.titleMedium),
          AppSpacing.verticalMD,
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _trainingLocation = 'full_gym'),
                  child: _LocationCard(
                    title: 'Full Gym',
                    isSelected: _trainingLocation == 'full_gym',
                  ),
                ),
              ),
              AppSpacing.horizontalSM,
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _trainingLocation = 'home_gym'),
                  child: _LocationCard(
                    title: 'Home Gym',
                    isSelected: _trainingLocation == 'home_gym',
                  ),
                ),
              ),
              AppSpacing.horizontalSM,
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _trainingLocation = 'minimal'),
                  child: _LocationCard(
                    title: 'Minimal',
                    isSelected: _trainingLocation == 'minimal',
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalLG,

          // Equipment chips
          Text('Equipment Available', style: AppTypography.titleMedium),
          AppSpacing.verticalMD,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: equipmentOptions.map((equipment) {
              final isSelected = _selectedEquipment.contains(equipment);
              return SelectionChip(
                label: equipment,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedEquipment.remove(equipment);
                    } else {
                      _selectedEquipment.add(equipment);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep6Schedule() {
    return SingleChildScrollView(
      padding: AppSpacing.screenHorizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("When Do You\nLike to Train?", style: AppTypography.displaySmall),
          AppSpacing.verticalSM,
          Text(
            "We'll remind you on these days",
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
          ),
          AppSpacing.verticalXL,

          // Day selector
          DaySelector(
            selectedDays: _selectedDays,
            onSelectionChanged: (days) {
              setState(() {
                _selectedDays = days;
              });
            },
          ),
          AppSpacing.verticalMD,
          Text(
            'We recommend 3-4 days per week',
            style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalXL,

          // Reminder time
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Schedule Reminder time', style: AppTypography.bodyMedium),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_reminderTime, style: AppTypography.bodyMedium),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep7Injuries() {
    final injuryOptions = [
      'Lower Back', 'Shoulders', 'Knees', 'Hips',
      'Wrists/Elbows', 'Neck', 'Ankles', 'None',
    ];

    return SingleChildScrollView(
      padding: AppSpacing.screenHorizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Any Injuries We\nShould Know About?",
              style: AppTypography.displaySmall),
          AppSpacing.verticalSM,
          Text(
            "We'll suggest modifications",
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
          ),
          AppSpacing.verticalXL,

          // Injury chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: injuryOptions.map((injury) {
              final isSelected = _selectedInjuries.contains(injury);
              return SelectionChip(
                label: injury,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (injury == 'None') {
                      _selectedInjuries.clear();
                      _selectedInjuries.add('None');
                    } else {
                      _selectedInjuries.remove('None');
                      if (isSelected) {
                        _selectedInjuries.remove(injury);
                      } else {
                        _selectedInjuries.add(injury);
                      }
                    }
                  });
                },
              );
            }).toList(),
          ),
          AppSpacing.verticalLG,

          // Additional notes
          AppTextField(
            label: 'Anything else? (optional)',
            hint: 'Tell us more about any limitations...',
            controller: _injuryNotesController,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildStep8Notifications() {
    return SingleChildScrollView(
      padding: AppSpacing.screenHorizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Stay on Track", style: AppTypography.displaySmall),
          AppSpacing.verticalSM,
          Text(
            'Get reminders and updates from Coach Brian',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
          ),
          AppSpacing.verticalXL,

          _NotificationToggle(
            title: 'Workout Reminders',
            subtitle: 'Get reminded on your scheduled days',
            value: _workoutReminders,
            onChanged: (value) {
              setState(() {
                _workoutReminders = value;
              });
            },
          ),
          _NotificationToggle(
            title: 'Rest Day Check-ins',
            subtitle: 'Recovery tips and encouragement',
            value: _restDayCheckins,
            onChanged: (value) {
              setState(() {
                _restDayCheckins = value;
              });
            },
          ),
          _NotificationToggle(
            title: 'Coach Updates & Tips',
            subtitle: 'New content and training advice',
            value: _coachUpdates,
            onChanged: (value) {
              setState(() {
                _coachUpdates = value;
              });
            },
          ),
          _NotificationToggle(
            title: 'Weekly Progress Summary',
            subtitle: 'Review your achievements each week',
            value: _weeklyProgress,
            onChanged: (value) {
              setState(() {
                _weeklyProgress = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _LocationCard({
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _NotificationToggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium),
                AppSpacing.verticalXS,
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

