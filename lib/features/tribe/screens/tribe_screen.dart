import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';

/// Tribe community screen
class TribeScreen extends StatefulWidget {
  const TribeScreen({super.key});

  @override
  State<TribeScreen> createState() => _TribeScreenState();
}

class _TribeScreenState extends State<TribeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: AppSpacing.screenHorizontalPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title dropdown
                  Row(
                    children: [
                      Text(
                        'TITAN',
                        style: AppTypography.headlineMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  // Stats badges
                  Row(
                    children: [
                      _StatsBadge(
                        icon: Icons.bolt,
                        iconColor: AppColors.points,
                        value: '527',
                      ),
                      AppSpacing.horizontalSM,
                      _StatsBadge(
                        icon: Icons.local_fire_department,
                        iconColor: AppColors.streak,
                        value: '43',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.verticalMD,

            // Tab bar
            Padding(
              padding: AppSpacing.screenHorizontalPadding,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelColor: AppColors.textPrimary,
                  unselectedLabelColor: AppColors.textMuted,
                  tabs: const [
                    Tab(text: 'Community'),
                    Tab(text: 'Trainers'),
                  ],
                ),
              ),
            ),
            AppSpacing.verticalMD,

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _CommunityTab(),
                  _TrainersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;

  const _StatsBadge({
    required this.icon,
    required this.iconColor,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          AppSpacing.horizontalXS,
          Text(value, style: AppTypography.labelSmall),
        ],
      ),
    );
  }
}

class _CommunityTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenHorizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chat messages
          _ChatMessage(
            name: 'Lizzie R',
            message:
                'YOOO 🔥 That\'s massive! What was your warm-up set like?',
            timestamp: '10:12',
            isCoach: false,
          ),
          _ChatMessage(
            name: 'Alkid Shuli',
            message:
                '@Lizzie R I always forget to warm up properly... might be why I plateaued 😅',
            timestamp: '10:15',
            isCoach: false,
            isReply: true,
          ),
          AppSpacing.verticalMD,

          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.textMuted,
                ),
                AppSpacing.horizontalMD,
                Expanded(
                  child: Text(
                    'Message Titan Chat',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.programTitan,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.verticalLG,

          // Leaderboard
          Text('Top members', style: AppTypography.titleLarge),
          AppSpacing.verticalMD,
          _LeaderboardItem(rank: 1, name: 'Matt S', points: 3768),
          _LeaderboardItem(rank: 2, name: 'Tara L', points: 3377),
          _LeaderboardItem(rank: 3, name: 'Amy P', points: 2821),
          _LeaderboardItem(rank: 4, name: 'Collin H', points: 2799),
          _LeaderboardItem(
            rank: 35,
            name: 'Alkid Shuli',
            points: 527,
            isCurrentUser: true,
          ),
          AppSpacing.verticalMD,
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                'View all',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.programTitan,
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _ChatMessage extends StatelessWidget {
  final String name;
  final String message;
  final String timestamp;
  final bool isCoach;
  final bool isReply;

  const _ChatMessage({
    required this.name,
    required this.message,
    required this.timestamp,
    this.isCoach = false,
    this.isReply = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 12,
        left: isReply ? 40 : 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: isCoach
                  ? Border.all(color: AppColors.programTitan, width: 2)
                  : null,
            ),
            child: const Icon(
              Icons.person,
              size: 20,
              color: AppColors.textMuted,
            ),
          ),
          AppSpacing.horizontalMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: AppTypography.labelMedium.copyWith(
                        color: isCoach
                            ? AppColors.programTitan
                            : AppColors.textSecondary,
                      ),
                    ),
                    if (isCoach) ...[
                      AppSpacing.horizontalXS,
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    AppSpacing.horizontalSM,
                    Text(
                      timestamp,
                      style: AppTypography.caption,
                    ),
                  ],
                ),
                AppSpacing.verticalXS,
                Text(
                  message,
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final bool isCurrentUser;

  const _LeaderboardItem({
    required this.rank,
    required this.name,
    required this.points,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.programTitan : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              rank.toString(),
              style: AppTypography.labelMedium.copyWith(
                color: isCurrentUser ? Colors.white : AppColors.textMuted,
              ),
            ),
          ),
          AppSpacing.horizontalMD,
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 18,
              color: AppColors.textMuted,
            ),
          ),
          AppSpacing.horizontalMD,
          Expanded(
            child: Text(
              name,
              style: AppTypography.bodyMedium.copyWith(
                color: isCurrentUser ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
          Icon(
            Icons.bolt,
            size: 14,
            color: isCurrentUser ? Colors.white : AppColors.points,
          ),
          AppSpacing.horizontalXS,
          Text(
            points.toString(),
            style: AppTypography.labelMedium.copyWith(
              color: isCurrentUser ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Coach content coming soon',
        style: TextStyle(color: AppColors.textMuted),
      ),
    );
  }
}

