import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/exercise_assets.dart';
import '../../../data/providers/exercise_filter_provider.dart';
import '../../../shared/models/exercise_model.dart';

/// Exercise Library Browser Screen
/// Displays all exercises with search and filter capabilities
class ExerciseBrowserScreen extends ConsumerStatefulWidget {
  const ExerciseBrowserScreen({super.key});

  @override
  ConsumerState<ExerciseBrowserScreen> createState() => _ExerciseBrowserScreenState();
}

class _ExerciseBrowserScreenState extends ConsumerState<ExerciseBrowserScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Active filters
  String? _selectedMovementPattern;
  String? _selectedEquipment;
  String? _selectedMuscle;
  String? _selectedDifficulty;

  final List<String> _movementPatterns = [
    'squat', 'hinge', 'push_horizontal', 'push_vertical',
    'pull_horizontal', 'pull_vertical', 'lunge', 'carry', 'core', 'rotation'
  ];

  final List<String> _equipment = [
    'barbell', 'dumbbell', 'kettlebell', 'cable', 'body weight', 'machine'
  ];

  final List<String> _muscles = [
    'chest', 'back', 'shoulders', 'legs', 'arms', 'core'
  ];

  final List<String> _difficulties = ['beginner', 'intermediate', 'advanced'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _selectedMovementPattern = null;
      _selectedEquipment = null;
      _selectedMuscle = null;
      _selectedDifficulty = null;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  bool get _hasActiveFilters =>
      _selectedMovementPattern != null ||
      _selectedEquipment != null ||
      _selectedMuscle != null ||
      _selectedDifficulty != null ||
      _searchQuery.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exercisesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Exercise Library', style: AppTypography.headlineMedium),
        actions: [
          if (_hasActiveFilters)
            TextButton(
              onPressed: _clearFilters,
              child: Text(
                'Clear',
                style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _searchQuery = value.toLowerCase());
              },
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textMuted),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          
          AppSpacing.verticalMD,

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'Movement',
                  value: _selectedMovementPattern,
                  options: _movementPatterns,
                  onSelected: (v) => setState(() => _selectedMovementPattern = v),
                ),
                AppSpacing.horizontalSM,
                _buildFilterChip(
                  label: 'Equipment',
                  value: _selectedEquipment,
                  options: _equipment,
                  onSelected: (v) => setState(() => _selectedEquipment = v),
                ),
                AppSpacing.horizontalSM,
                _buildFilterChip(
                  label: 'Muscle',
                  value: _selectedMuscle,
                  options: _muscles,
                  onSelected: (v) => setState(() => _selectedMuscle = v),
                ),
                AppSpacing.horizontalSM,
                _buildFilterChip(
                  label: 'Difficulty',
                  value: _selectedDifficulty,
                  options: _difficulties,
                  onSelected: (v) => setState(() => _selectedDifficulty = v),
                ),
              ],
            ),
          ),

          AppSpacing.verticalMD,

          // Exercise grid
          Expanded(
            child: exercisesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: AppColors.error, size: 48),
                    AppSpacing.verticalMD,
                    Text(
                      'Failed to load exercises',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                    ),
                    AppSpacing.verticalSM,
                    TextButton(
                      onPressed: () => ref.invalidate(exercisesProvider),
                      child: Text('Retry', style: AppTypography.labelMedium.copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
              data: (exercises) {
                final filtered = _filterExercises(exercises);
                
                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fitness_center, color: AppColors.textMuted, size: 64),
                        AppSpacing.verticalMD,
                        Text(
                          'No exercises found',
                          style: AppTypography.headlineSmall.copyWith(color: AppColors.textMuted),
                        ),
                        AppSpacing.verticalSM,
                        Text(
                          'Try adjusting your filters',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final exercise = filtered[index];
                    return _ExerciseCard(
                      exercise: exercise,
                      onTap: () => context.push('/exercises/${exercise.id}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<ExerciseModel> _filterExercises(List<ExerciseModel> exercises) {
    return exercises.where((ex) {
      // Search query
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final nameMatch = ex.name.toLowerCase().contains(searchLower);
        final muscleMatch = ex.targetMuscle?.toLowerCase().contains(searchLower) ?? false;
        final equipmentMatch = ex.equipment?.toLowerCase().contains(searchLower) ?? false;
        if (!nameMatch && !muscleMatch && !equipmentMatch) return false;
      }

      // Movement pattern filter
      if (_selectedMovementPattern != null) {
        if (ex.movementPattern?.toLowerCase() != _selectedMovementPattern!.toLowerCase()) {
          return false;
        }
      }

      // Equipment filter
      if (_selectedEquipment != null) {
        final exEquipment = ex.equipment?.toLowerCase() ?? '';
        if (!exEquipment.contains(_selectedEquipment!.toLowerCase())) {
          return false;
        }
      }

      // Muscle filter
      if (_selectedMuscle != null) {
        final bodyPart = ex.bodyPart?.toLowerCase() ?? '';
        final targetMuscle = ex.targetMuscle?.toLowerCase() ?? '';
        final muscles = ex.primaryMuscles.map((m) => m.toLowerCase()).toList();
        
        final muscleFilter = _selectedMuscle!.toLowerCase();
        if (!bodyPart.contains(muscleFilter) && 
            !targetMuscle.contains(muscleFilter) &&
            !muscles.any((m) => m.contains(muscleFilter))) {
          return false;
        }
      }

      // Difficulty filter
      if (_selectedDifficulty != null) {
        if (ex.difficulty?.toLowerCase() != _selectedDifficulty!.toLowerCase()) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  Widget _buildFilterChip({
    required String label,
    required String? value,
    required List<String> options,
    required Function(String?) onSelected,
  }) {
    final isActive = value != null;
    
    return GestureDetector(
      onTap: () => _showFilterBottomSheet(label, value, options, onSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value != null ? _formatLabel(value) : label,
              style: AppTypography.labelSmall.copyWith(
                color: isActive ? AppColors.textOnPrimary : AppColors.textPrimary,
              ),
            ),
            AppSpacing.horizontalXS,
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: isActive ? AppColors.textOnPrimary : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(
    String title,
    String? currentValue,
    List<String> options,
    Function(String?) onSelected,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSpacing.verticalMD,
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AppSpacing.verticalMD,
              Text(title, style: AppTypography.headlineSmall),
              AppSpacing.verticalMD,
              // Clear option
              ListTile(
                title: Text(
                  'All $title',
                  style: AppTypography.bodyMedium.copyWith(
                    color: currentValue == null ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                trailing: currentValue == null
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  onSelected(null);
                  Navigator.pop(context);
                },
              ),
              ...options.map((option) {
                final isSelected = option == currentValue;
                return ListTile(
                  title: Text(
                    _formatLabel(option),
                    style: AppTypography.bodyMedium.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    onSelected(option);
                    Navigator.pop(context);
                  },
                );
              }),
              AppSpacing.verticalLG,
            ],
          ),
        );
      },
    );
  }

  String _formatLabel(String value) {
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }
}

/// Exercise card widget for the grid
class _ExerciseCard extends StatelessWidget {
  final ExerciseModel exercise;
  final VoidCallback onTap;

  const _ExerciseCard({
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // GIF/Image - prioritize local assets
            Expanded(
              flex: 3,
              child: Container(
                color: AppColors.surface,
                child: _buildExerciseImage(exercise),
              ),
            ),
            
            // Info section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exercise name
                    Text(
                      exercise.name,
                      style: AppTypography.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Primary muscle
                    Text(
                      exercise.primaryMuscleDisplay,
                      style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.verticalXS,
                    // Difficulty badge
                    _DifficultyBadge(difficulty: exercise.difficulty ?? 'intermediate'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildExerciseImage(ExerciseModel exercise) {
    // First, try to use a local asset
    final localAsset = ExerciseAssets.getLocalAsset(exercise.name);
    
    if (localAsset != null) {
      return Image.asset(
        localAsset,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) {
          return _buildPlaceholder();
        },
      );
    }
    
    // Fall back to network image
    final networkUrl = exercise.bestGifUrl;
    if (networkUrl != null && networkUrl.isNotEmpty) {
      return Image.network(
        networkUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          );
        },
        errorBuilder: (context, error, stack) {
          return _buildPlaceholder();
        },
      );
    }
    
    return _buildPlaceholder();
  }
  
  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            color: AppColors.textMuted,
            size: 40,
          ),
          const SizedBox(height: 4),
          Text(
            exercise.name,
            style: AppTypography.caption.copyWith(
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Difficulty badge widget
class _DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        color = AppColors.success;
        break;
      case 'intermediate':
        color = AppColors.warning;
        break;
      case 'advanced':
        color = AppColors.error;
        break;
      default:
        color = AppColors.textMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 9,
        ),
      ),
    );
  }
}

