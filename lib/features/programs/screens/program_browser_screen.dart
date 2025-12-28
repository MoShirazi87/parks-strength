import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/selection_chip.dart';

/// Program browser screen
class ProgramBrowserScreen extends StatefulWidget {
  const ProgramBrowserScreen({super.key});

  @override
  State<ProgramBrowserScreen> createState() => _ProgramBrowserScreenState();
}

class _ProgramBrowserScreenState extends State<ProgramBrowserScreen> {
  String _selectedFilter = 'All';
  final _filters = ['All', 'Beginner', 'Intermediate', 'Advanced', 'Functional'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Programs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SelectionChip(
                      label: filter,
                      isSelected: _selectedFilter == filter,
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            AppSpacing.verticalLG,

            // Featured programs
            Padding(
              padding: AppSpacing.screenHorizontalPadding,
              child: Text('Featured', style: AppTypography.titleLarge),
            ),
            AppSpacing.verticalMD,
            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _FeaturedProgramCard(
                    name: 'TITAN',
                    subtitle: 'Strength Focus',
                    color: AppColors.programTitan,
                    onTap: () => context.push('/programs/titan'),
                  ),
                  _FeaturedProgramCard(
                    name: 'BLAZE',
                    subtitle: 'HIIT & Cardio',
                    color: AppColors.programBlaze,
                    onTap: () => context.push('/programs/blaze'),
                  ),
                  _FeaturedProgramCard(
                    name: 'AURA',
                    subtitle: 'Mobility & Flow',
                    color: AppColors.programAura,
                    onTap: () => context.push('/programs/aura'),
                  ),
                  _FeaturedProgramCard(
                    name: 'NOMAD',
                    subtitle: 'Anywhere Workouts',
                    color: AppColors.programNomad,
                    onTap: () => context.push('/programs/nomad'),
                  ),
                ],
              ),
            ),
            AppSpacing.verticalLG,

            // All programs
            Padding(
              padding: AppSpacing.screenHorizontalPadding,
              child: Text('All Programs', style: AppTypography.titleLarge),
            ),
            AppSpacing.verticalMD,
            Padding(
              padding: AppSpacing.screenHorizontalPadding,
              child: Column(
                children: [
                  _ProgramListItem(
                    name: 'Foundation Strength',
                    duration: '8 Weeks',
                    frequency: '4x/week',
                    difficulty: 'Beginner',
                    onTap: () => context.push('/programs/foundation'),
                  ),
                  _ProgramListItem(
                    name: 'Power Building',
                    duration: '12 Weeks',
                    frequency: '5x/week',
                    difficulty: 'Intermediate',
                    onTap: () => context.push('/programs/power'),
                  ),
                  _ProgramListItem(
                    name: 'Functional Athlete',
                    duration: '10 Weeks',
                    frequency: '4x/week',
                    difficulty: 'Advanced',
                    onTap: () => context.push('/programs/athlete'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _FeaturedProgramCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _FeaturedProgramCard({
    required this.name,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.8),
              color.withOpacity(0.4),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background illustration would go here
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramListItem extends StatelessWidget {
  final String name;
  final String duration;
  final String frequency;
  final String difficulty;
  final VoidCallback onTap;

  const _ProgramListItem({
    required this.name,
    required this.duration,
    required this.frequency,
    required this.difficulty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            // Thumbnail placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.fitness_center,
                color: AppColors.primary,
              ),
            ),
            AppSpacing.horizontalMD,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTypography.titleMedium),
                  AppSpacing.verticalXS,
                  Text(
                    '$duration • $frequency • $difficulty',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

