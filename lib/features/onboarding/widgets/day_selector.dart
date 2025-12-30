import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

/// Circular day selector for choosing training days
class DaySelector extends StatelessWidget {
  final List<String> selectedDays;
  final Function(String) onToggle;

  const DaySelector({
    super.key,
    required this.selectedDays,
    required this.onToggle,
  });

  static const List<Map<String, String>> _days = [
    {'key': 'mon', 'label': 'M'},
    {'key': 'tue', 'label': 'T'},
    {'key': 'wed', 'label': 'W'},
    {'key': 'thu', 'label': 'T'},
    {'key': 'fri', 'label': 'F'},
    {'key': 'sat', 'label': 'S'},
    {'key': 'sun', 'label': 'S'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _days.map((day) {
        final isSelected = selectedDays.contains(day['key']);
        
        return GestureDetector(
          onTap: () => onToggle(day['key']!),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.primary : AppColors.surface,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                day['label']!,
                style: AppTypography.bodyLarge.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

