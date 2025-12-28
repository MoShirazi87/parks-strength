import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_constants.dart';

/// Selection chip for multi-select options
class SelectionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;

  const SelectionChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusS),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.check,
                size: 16,
                color: AppColors.textPrimary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Wrap of selection chips
class SelectionChipGroup extends StatelessWidget {
  final List<String> options;
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onSelectionChanged;
  final bool allowMultiple;
  final double spacing;
  final double runSpacing;

  const SelectionChipGroup({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onSelectionChanged,
    this.allowMultiple = true,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  void _toggleOption(String option) {
    final newSelection = List<String>.from(selectedOptions);

    if (newSelection.contains(option)) {
      newSelection.remove(option);
    } else {
      if (allowMultiple) {
        newSelection.add(option);
      } else {
        newSelection.clear();
        newSelection.add(option);
      }
    }

    onSelectionChanged(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: options.map((option) {
        return SelectionChip(
          label: option,
          isSelected: selectedOptions.contains(option),
          onTap: () => _toggleOption(option),
        );
      }).toList(),
    );
  }
}

/// Day selector for schedule preferences
class DaySelector extends StatelessWidget {
  final List<String> selectedDays;
  final ValueChanged<List<String>> onSelectionChanged;

  static const List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const List<String> dayAbbreviations = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  const DaySelector({
    super.key,
    required this.selectedDays,
    required this.onSelectionChanged,
  });

  void _toggleDay(String day) {
    final newSelection = List<String>.from(selectedDays);

    if (newSelection.contains(day)) {
      newSelection.remove(day);
    } else {
      newSelection.add(day);
    }

    onSelectionChanged(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(days.length, (index) {
        final day = days[index];
        final isSelected = selectedDays.contains(day);

        return GestureDetector(
          onTap: () => _toggleDay(day),
          child: AnimatedContainer(
            duration: AppConstants.animationFast,
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.primary : Colors.transparent,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                dayAbbreviations[index],
                style: AppTypography.labelMedium.copyWith(
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textMuted,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

