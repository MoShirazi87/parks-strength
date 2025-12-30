import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../providers/onboarding_provider.dart';

/// Multi-select chips for equipment selection
class EquipmentChipSelector extends StatelessWidget {
  final List<EquipmentItem> equipment;
  final List<String> selectedIds;
  final Function(String) onToggle;
  final String? trainingLocation;

  const EquipmentChipSelector({
    super.key,
    required this.equipment,
    required this.selectedIds,
    required this.onToggle,
    this.trainingLocation,
  });

  @override
  Widget build(BuildContext context) {
    // Filter equipment based on training location
    final filteredEquipment = equipment.where((item) {
      if (trainingLocation == 'minimal') {
        return item.isHomeFriendly;
      }
      if (trainingLocation == 'home_gym') {
        return item.isHomeFriendly;
      }
      return true; // Full gym shows all equipment
    }).toList();

    if (filteredEquipment.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Loading equipment...',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filteredEquipment.map((item) {
        final isSelected = selectedIds.contains(item.id);
        
        return GestureDetector(
          onTap: () => onToggle(item.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getEquipmentIcon(item.name),
                  size: 18,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  item.name,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getEquipmentIcon(String name) {
    switch (name.toLowerCase()) {
      case 'barbell':
        return Icons.fitness_center;
      case 'dumbbells':
        return Icons.fitness_center;
      case 'kettlebells':
        return Icons.sports_gymnastics;
      case 'cable machine':
        return Icons.cable;
      case 'resistance bands':
        return Icons.linear_scale;
      case 'pull-up bar':
        return Icons.horizontal_rule;
      case 'bench':
        return Icons.weekend;
      case 'squat rack':
        return Icons.grid_4x4;
      case 'leg press':
        return Icons.directions_walk;
      case 'battle ropes':
        return Icons.waves;
      case 'jump rope':
        return Icons.sports;
      case 'medicine ball':
        return Icons.sports_baseball;
      default:
        return Icons.fitness_center;
    }
  }
}

