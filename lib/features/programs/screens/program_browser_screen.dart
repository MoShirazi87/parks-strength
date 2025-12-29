import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../data/providers/program_provider.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/selection_chip.dart';

/// Program browser screen with real data
class ProgramBrowserScreen extends ConsumerStatefulWidget {
  const ProgramBrowserScreen({super.key});

  @override
  ConsumerState<ProgramBrowserScreen> createState() => _ProgramBrowserScreenState();
}

class _ProgramBrowserScreenState extends ConsumerState<ProgramBrowserScreen> {
  String _selectedFilter = 'All';
  final _filters = ['All', 'Beginner', 'Intermediate', 'Advanced', 'Functional'];

  @override
  Widget build(BuildContext context) {
    final programsAsync = ref.watch(programsProvider);
    
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
      body: programsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildDefaultContent(context),
        data: (programs) {
          if (programs.isEmpty) {
            return _buildDefaultContent(context);
          }
          
          // Filter programs
          final filteredPrograms = _selectedFilter == 'All'
              ? programs
              : programs.where((p) {
                  if (_selectedFilter == 'Functional') {
                    return p.focusAreas.contains('functional');
                  }
                  return p.difficulty.toLowerCase() == _selectedFilter.toLowerCase();
                }).toList();
          
          return SingleChildScrollView(
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
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: programs.length,
                    itemBuilder: (context, index) {
                      final program = programs[index];
                      Color color = AppColors.programTitan;
                      if (program.accentColor != null) {
                        try {
                          color = Color(int.parse(program.accentColor!.replaceFirst('#', '0xFF')));
                        } catch (_) {}
                      }
                      
                      return _FeaturedProgramCard(
                        name: program.name.toUpperCase(),
                        subtitle: program.shortDescription ?? '${program.durationWeeks}-Week Program',
                        color: color,
                        onTap: () => context.push('/programs/${program.id}'),
                      );
                    },
                  ),
                ),
                AppSpacing.verticalLG,

                // All programs
                Padding(
                  padding: AppSpacing.screenHorizontalPadding,
                  child: Text(
                    _selectedFilter == 'All' ? 'All Programs' : '$_selectedFilter Programs',
                    style: AppTypography.titleLarge,
                  ),
                ),
                AppSpacing.verticalMD,
                Padding(
                  padding: AppSpacing.screenHorizontalPadding,
                  child: Column(
                    children: filteredPrograms.map((program) {
                      return _ProgramListItem(
                        name: program.name,
                        duration: '${program.durationWeeks} Weeks',
                        frequency: '${program.daysPerWeek}x/week',
                        difficulty: program.difficulty.capitalize(),
                        onTap: () => context.push('/programs/${program.id}'),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildDefaultContent(BuildContext context) {
    return SingleChildScrollView(
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
                  subtitle: '12-Week Strength',
                  color: AppColors.programTitan,
                  onTap: () => context.push('/programs/titan'),
                ),
                _FeaturedProgramCard(
                  name: 'FORGE',
                  subtitle: '3-Day Full Body',
                  color: AppColors.programBlaze,
                  onTap: () => context.push('/programs/forge'),
                ),
                _FeaturedProgramCard(
                  name: 'NOMAD',
                  subtitle: 'Minimal Equipment',
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
                  onTap: () => context.push('/programs/foundation-strength'),
                ),
                _ProgramListItem(
                  name: 'TITAN',
                  duration: '12 Weeks',
                  frequency: '4x/week',
                  difficulty: 'Intermediate',
                  onTap: () => context.push('/programs/titan'),
                ),
                _ProgramListItem(
                  name: 'FORGE',
                  duration: '8 Weeks',
                  frequency: '3x/week',
                  difficulty: 'Beginner',
                  onTap: () => context.push('/programs/forge'),
                ),
                _ProgramListItem(
                  name: 'NOMAD',
                  duration: '6 Weeks',
                  frequency: '4x/week',
                  difficulty: 'Beginner',
                  onTap: () => context.push('/programs/nomad'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
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
            // Icon background
            Positioned(
              top: 16,
              right: 16,
              child: Icon(
                Icons.fitness_center,
                size: 48,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            // Content
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
                      color: Colors.white,
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

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
