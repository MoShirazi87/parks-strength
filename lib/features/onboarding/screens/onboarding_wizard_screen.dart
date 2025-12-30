import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_progress_indicator.dart';
import '../widgets/floating_bubble_selector.dart';
import '../widgets/day_selector.dart';
import '../widgets/equipment_chip_selector.dart';
import '../widgets/body_part_selector.dart';

/// 8-step onboarding wizard
class OnboardingWizardScreen extends ConsumerStatefulWidget {
  const OnboardingWizardScreen({super.key});

  @override
  ConsumerState<OnboardingWizardScreen> createState() => _OnboardingWizardScreenState();
}

class _OnboardingWizardScreenState extends ConsumerState<OnboardingWizardScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // Controllers for text fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _injuryNotesController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _injuryNotesController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 7) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep++;
      });
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
      setState(() {
        _currentStep--;
      });
    }
  }

  void _skipStep() {
    _nextStep();
  }

  bool _canProceed() {
    final data = ref.read(onboardingProvider);
    switch (_currentStep) {
      case 0: // Profile
        return data.firstName.trim().isNotEmpty;
      case 1: // Experience
        return data.experienceLevel != null;
      case 2: // Goals
        return data.goals.isNotEmpty;
      case 3: // Exercise Types
        return data.exerciseTypes.isNotEmpty;
      case 4: // Equipment
        return data.trainingLocation != null && data.selectedEquipmentIds.isNotEmpty;
      case 5: // Schedule
        return data.preferredDays.isNotEmpty;
      case 6: // Injuries (optional)
        return true;
      case 7: // Notifications (optional)
        return true;
      default:
        return true;
    }
  }

  Future<void> _completeOnboarding() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await ref.read(onboardingProvider.notifier).saveOnboarding();
      
      if (success && mounted) {
        context.go(AppRoutes.home);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save your preferences. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(onboardingProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and skip
            _buildHeader(),
            
            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: OnboardingProgressIndicator(
                currentStep: _currentStep,
                totalSteps: 8,
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
                  _buildStep1Profile(data),
                  _buildStep2Experience(data),
                  _buildStep3Goals(data),
                  _buildStep4ExerciseTypes(data),
                  _buildStep5Equipment(data),
                  _buildStep6Schedule(data),
                  _buildStep7Injuries(data),
                  _buildStep8Notifications(data),
                ],
              ),
            ),
            
            // Next button
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          if (_currentStep > 0)
            IconButton(
              onPressed: _previousStep,
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            )
          else
            const SizedBox(width: 48),
          
          // Step indicator text
          Text(
            'Step ${_currentStep + 1} of 8',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          
          // Skip button (for optional steps)
          if (_currentStep >= 6)
            TextButton(
              onPressed: _skipStep,
              child: Text(
                'Skip',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isLoading || !_canProceed() ? null : _nextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentStep == 7 ? 'Complete Setup' : 'NEXT',
                      style: AppTypography.buttonMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_currentStep < 7) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 20),
                    ],
                  ],
                ),
        ),
      ),
    );
  }

  // ============================================
  // STEP 1: PROFILE SETUP
  // ============================================
  Widget _buildStep1Profile(OnboardingData data) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppSpacing.verticalLG,
          
          // Avatar placeholder
          GestureDetector(
            onTap: () {
              // TODO: Implement photo upload
            },
            child: Container(
              width: 100,
              height: 100,
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
          
          AppSpacing.verticalSM,
          Text(
            'Add Photo (Optional)',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          
          AppSpacing.verticalXL,
          
          // Title
          Text(
            'Tell us about yourself',
            style: AppTypography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          
          AppSpacing.verticalSM,
          Text(
            'Enter your name to personalize your experience',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          AppSpacing.verticalXL,
          
          // First name
          TextField(
            controller: _firstNameController,
            onChanged: (value) {
              ref.read(onboardingProvider.notifier).updateProfile(
                firstName: value,
                lastName: _lastNameController.text,
              );
            },
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              labelText: 'First Name *',
              labelStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          
          AppSpacing.verticalMD,
          
          // Last name
          TextField(
            controller: _lastNameController,
            onChanged: (value) {
              ref.read(onboardingProvider.notifier).updateProfile(
                firstName: _firstNameController.text,
                lastName: value,
              );
            },
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Last Name',
              labelStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // STEP 2: EXPERIENCE LEVEL
  // ============================================
  Widget _buildStep2Experience(OnboardingData data) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppSpacing.verticalLG,
          
          Text(
            'What\'s your experience level?',
            style: AppTypography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          
          AppSpacing.verticalSM,
          Text(
            'This helps us create the right program for you',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          AppSpacing.verticalXL,
          
          // Experience cards
          _buildExperienceCard(
            'beginner',
            'Beginner',
            'New to strength training (0-6 months)',
            Icons.emoji_people,
            data.experienceLevel == 'beginner',
          ),
          
          AppSpacing.verticalMD,
          
          _buildExperienceCard(
            'intermediate',
            'Intermediate',
            'Consistent training (1-3 years)',
            Icons.fitness_center,
            data.experienceLevel == 'intermediate',
          ),
          
          AppSpacing.verticalMD,
          
          _buildExperienceCard(
            'advanced',
            'Advanced',
            'Experienced lifter (3+ years)',
            Icons.military_tech,
            data.experienceLevel == 'advanced',
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(
    String level,
    String title,
    String description,
    IconData icon,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(onboardingProvider.notifier).updateExperienceLevel(level);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // STEP 3: TRAINING GOALS
  // ============================================
  Widget _buildStep3Goals(OnboardingData data) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppSpacing.verticalLG,
          
          Text(
            'What are your goals?',
            style: AppTypography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          
          AppSpacing.verticalSM,
          Text(
            'Select all that apply (minimum 1)',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          AppSpacing.verticalXL,
          
          FloatingBubbleSelector(
            options: availableGoals,
            selectedOptions: data.goals,
            onToggle: (goal) {
              ref.read(onboardingProvider.notifier).toggleGoal(goal);
            },
          ),
        ],
      ),
    );
  }

  // ============================================
  // STEP 4: EXERCISE TYPES
  // ============================================
  Widget _buildStep4ExerciseTypes(OnboardingData data) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppSpacing.verticalLG,
          
          Text(
            'What types of training?',
            style: AppTypography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          
          AppSpacing.verticalSM,
          Text(
            'Select your preferred exercise types',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          AppSpacing.verticalXL,
          
          FloatingBubbleSelector(
            options: availableExerciseTypes,
            selectedOptions: data.exerciseTypes,
            onToggle: (type) {
              ref.read(onboardingProvider.notifier).toggleExerciseType(type);
            },
          ),
        ],
      ),
    );
  }

  // ============================================
  // STEP 5: EQUIPMENT
  // ============================================
  Widget _buildStep5Equipment(OnboardingData data) {
    final equipmentAsync = ref.watch(equipmentCatalogProvider);
    
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppSpacing.verticalLG,
          
          Text(
            'Where do you train?',
            style: AppTypography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          
          AppSpacing.verticalXL,
          
          // Location cards
          Row(
            children: [
              Expanded(
                child: _buildLocationCard(
                  'full_gym',
                  'Full Gym',
                  Icons.fitness_center,
                  data.trainingLocation == 'full_gym',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildLocationCard(
                  'home_gym',
                  'Home Gym',
                  Icons.home,
                  data.trainingLocation == 'home_gym',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildLocationCard(
                  'minimal',
                  'Minimal',
                  Icons.self_improvement,
                  data.trainingLocation == 'minimal',
                ),
              ),
            ],
          ),
          
          AppSpacing.verticalXL,
          
          if (data.trainingLocation != null) ...[
            Text(
              'What equipment do you have?',
              style: AppTypography.titleMedium,
              textAlign: TextAlign.center,
            ),
            
            AppSpacing.verticalMD,
            
            equipmentAsync.when(
              data: (equipment) => EquipmentChipSelector(
                equipment: equipment,
                selectedIds: data.selectedEquipmentIds,
                onToggle: (id) {
                  ref.read(onboardingProvider.notifier).toggleEquipment(id);
                },
                trainingLocation: data.trainingLocation,
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (_, __) => Text(
                'Failed to load equipment',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationCard(
    String location,
    String title,
    IconData icon,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(onboardingProvider.notifier).updateTrainingLocation(location);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // STEP 6: SCHEDULE
  // ============================================
  Widget _buildStep6Schedule(OnboardingData data) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppSpacing.verticalLG,
          
          Text(
            'When do you want to train?',
            style: AppTypography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          
          AppSpacing.verticalSM,
          Text(
            'We recommend 3-4 days per week',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          AppSpacing.verticalXL,
          
          Text(
            'Select your training days',
            style: AppTypography.titleMedium,
          ),
          
          AppSpacing.verticalMD,
          
          DaySelector(
            selectedDays: data.preferredDays,
            onToggle: (day) {
              ref.read(onboardingProvider.notifier).toggleDay(day);
            },
          ),
          
          AppSpacing.verticalXL,
          
          Text(
            'Reminder time',
            style: AppTypography.titleMedium,
          ),
          
          AppSpacing.verticalMD,
          
          GestureDetector(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: data.reminderTime,
              );
              if (picked != null) {
                ref.read(onboardingProvider.notifier).updateReminderTime(picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    data.reminderTime.format(context),
                    style: AppTypography.headlineSmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // STEP 7: INJURIES
  // ============================================
  Widget _buildStep7Injuries(OnboardingData data) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppSpacing.verticalLG,
          
          Text(
            'Any injuries or limitations?',
            style: AppTypography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          
          AppSpacing.verticalSM,
          Text(
            'This helps us customize your workouts (optional)',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          AppSpacing.verticalXL,
          
          BodyPartSelector(
            bodyParts: availableInjuryAreas,
            selectedParts: data.injuries,
            onToggle: (part) {
              ref.read(onboardingProvider.notifier).toggleInjury(part);
            },
          ),
          
          AppSpacing.verticalXL,
          
          if (!data.injuries.contains('None') && data.injuries.isNotEmpty) ...[
            Text(
              'Tell us more (optional)',
              style: AppTypography.titleMedium,
            ),
            
            AppSpacing.verticalMD,
            
            TextField(
              controller: _injuryNotesController,
              onChanged: (value) {
                ref.read(onboardingProvider.notifier).updateInjuryNotes(value);
              },
              maxLines: 4,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Describe any limitations or things we should know...',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================
  // STEP 8: NOTIFICATIONS
  // ============================================
  Widget _buildStep8Notifications(OnboardingData data) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppSpacing.verticalLG,
          
          Text(
            'Stay on track',
            style: AppTypography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          
          AppSpacing.verticalSM,
          Text(
            'Choose which notifications you\'d like to receive',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          AppSpacing.verticalXL,
          
          _buildNotificationToggle(
            'Workout Reminders',
            'Get reminded on your scheduled days',
            Icons.notifications_active,
            data.workoutReminders,
            (value) {
              ref.read(onboardingProvider.notifier).updateNotifications(
                workoutReminders: value,
              );
            },
          ),
          
          AppSpacing.verticalMD,
          
          _buildNotificationToggle(
            'Rest Day Check-ins',
            'Recovery tips and encouragement',
            Icons.self_improvement,
            data.restDayCheckins,
            (value) {
              ref.read(onboardingProvider.notifier).updateNotifications(
                restDayCheckins: value,
              );
            },
          ),
          
          AppSpacing.verticalMD,
          
          _buildNotificationToggle(
            'Coach Updates & Tips',
            'New content and training advice',
            Icons.school,
            data.coachTips,
            (value) {
              ref.read(onboardingProvider.notifier).updateNotifications(
                coachTips: value,
              );
            },
          ),
          
          AppSpacing.verticalMD,
          
          _buildNotificationToggle(
            'Weekly Progress Summary',
            'Review your achievements each week',
            Icons.trending_up,
            data.weeklySummary,
            (value) {
              ref.read(onboardingProvider.notifier).updateNotifications(
                weeklySummary: value,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
