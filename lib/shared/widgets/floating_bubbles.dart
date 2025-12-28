import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

/// Floating bubble selection widget for onboarding
/// Creates an organic, non-grid arrangement of selectable bubbles
class FloatingBubbles extends StatefulWidget {
  final List<BubbleItem> items;
  final List<String> selectedIds;
  final ValueChanged<List<String>> onSelectionChanged;
  final bool allowMultiple;

  const FloatingBubbles({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onSelectionChanged,
    this.allowMultiple = true,
  });

  @override
  State<FloatingBubbles> createState() => _FloatingBubblesState();
}

class _FloatingBubblesState extends State<FloatingBubbles>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _controllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800 + _random.nextInt(400)),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    // Stagger the animations
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleSelection(String id) {
    final newSelection = List<String>.from(widget.selectedIds);
    
    if (newSelection.contains(id)) {
      newSelection.remove(id);
    } else {
      if (widget.allowMultiple) {
        newSelection.add(id);
      } else {
        newSelection.clear();
        newSelection.add(id);
      }
    }
    
    widget.onSelectionChanged(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final positions = _calculatePositions(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        return Stack(
          children: List.generate(widget.items.length, (index) {
            final item = widget.items[index];
            final position = positions[index];
            final isSelected = widget.selectedIds.contains(item.id);

            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Positioned(
                  left: position.dx,
                  top: position.dy,
                  child: Transform.scale(
                    scale: _animations[index].value,
                    child: _Bubble(
                      item: item,
                      isSelected: isSelected,
                      onTap: () => _toggleSelection(item.id),
                    ),
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }

  List<Offset> _calculatePositions(double width, double height) {
    final positions = <Offset>[];
    final bubbleSizes = widget.items.map((e) => e.size).toList();
    
    // Simple physics-based positioning
    for (int i = 0; i < widget.items.length; i++) {
      final size = bubbleSizes[i];
      double x, y;
      bool overlapping;
      int attempts = 0;

      do {
        overlapping = false;
        x = _random.nextDouble() * (width - size);
        y = _random.nextDouble() * (height - size);

        // Check for overlaps with existing bubbles
        for (int j = 0; j < positions.length; j++) {
          final otherSize = bubbleSizes[j];
          final dx = (x + size / 2) - (positions[j].dx + otherSize / 2);
          final dy = (y + size / 2) - (positions[j].dy + otherSize / 2);
          final distance = sqrt(dx * dx + dy * dy);
          final minDistance = (size + otherSize) / 2 + 10;

          if (distance < minDistance) {
            overlapping = true;
            break;
          }
        }
        attempts++;
      } while (overlapping && attempts < 50);

      positions.add(Offset(x, y));
    }

    return positions;
  }
}

class _Bubble extends StatelessWidget {
  final BubbleItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _Bubble({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: item.size * (isSelected ? 1.1 : 1.0),
        height: item.size * (isSelected ? 1.1 : 1.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? AppColors.primary
              : AppColors.surface,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.border,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              item.label,
              textAlign: TextAlign.center,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontSize: item.size > 80 ? 14 : 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Model for a bubble item
class BubbleItem {
  final String id;
  final String label;
  final double size;

  const BubbleItem({
    required this.id,
    required this.label,
    this.size = 80,
  });
}

/// Predefined bubble configurations for onboarding

/// Goals bubbles
List<BubbleItem> get goalBubbles => const [
  BubbleItem(id: 'build_strength', label: 'Build\nStrength', size: 95),
  BubbleItem(id: 'build_muscle', label: 'Build\nMuscle', size: 90),
  BubbleItem(id: 'lose_fat', label: 'Lose\nFat', size: 75),
  BubbleItem(id: 'improve_mobility', label: 'Improve\nMobility', size: 85),
  BubbleItem(id: 'athletic_performance', label: 'Athletic\nPerformance', size: 100),
  BubbleItem(id: 'general_fitness', label: 'General\nFitness', size: 90),
  BubbleItem(id: 'functional_movement', label: 'Functional\nMovement', size: 95),
  BubbleItem(id: 'rehabilitation', label: 'Rehab', size: 70),
  BubbleItem(id: 'core_strength', label: 'Core\nStrength', size: 80),
  BubbleItem(id: 'longevity', label: 'Longevity', size: 75),
];

/// Exercise type bubbles
List<BubbleItem> get exerciseTypeBubbles => const [
  BubbleItem(id: 'strength_training', label: 'Strength\nTraining', size: 100),
  BubbleItem(id: 'functional_training', label: 'Functional\nTraining', size: 95),
  BubbleItem(id: 'muscular_strength', label: 'Muscular\nStrength', size: 90),
  BubbleItem(id: 'circuit_training', label: 'Circuit\nTraining', size: 85),
  BubbleItem(id: 'hiit', label: 'HIIT', size: 65),
  BubbleItem(id: 'mobility_work', label: 'Mobility\nWork', size: 80),
  BubbleItem(id: 'core_training', label: 'Core\nTraining', size: 80),
  BubbleItem(id: 'bodyweight', label: 'Bodyweight', size: 85),
  BubbleItem(id: 'barbell_training', label: 'Barbell\nTraining', size: 90),
  BubbleItem(id: 'kettlebell_training', label: 'Kettlebell', size: 75),
];

