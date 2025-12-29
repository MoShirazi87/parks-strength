import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';

/// Welcome carousel screen with premium onboarding experience
/// Inspired by Onemor fitness app design
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> 
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoScrollTimer;
  late AnimationController _pulseController;

  final List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      title: 'FUNCTIONAL\nSTRENGTH',
      subtitle: 'That Transfers to Life',
      description: 'Train smarter with Coach Brian Parks. Build strength that works in the real world.',
      gradientColors: [const Color(0xFF0A0A0A), const Color(0xFF1A1A2E)],
      accentColor: AppColors.primary,
      imageUrl: 'https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    ),
    _OnboardingSlide(
      title: 'PROGRESSIVE\nOVERLOAD',
      subtitle: 'Built Into Every Session',
      description: 'Smart algorithms track your progress and suggest when to increase weight.',
      gradientColors: [const Color(0xFF0A0A0A), const Color(0xFF1E1E3F)],
      accentColor: AppColors.tertiary,
      imageUrl: 'https://images.pexels.com/photos/841130/pexels-photo-841130.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    ),
    _OnboardingSlide(
      title: 'VIDEO\nDEMOS',
      subtitle: 'Perfect Form Every Rep',
      description: '1,300+ exercises with animated demonstrations. Never question your technique.',
      gradientColors: [const Color(0xFF0A0A0A), const Color(0xFF2D1F4B)],
      accentColor: AppColors.secondary,
      imageUrl: 'https://images.pexels.com/photos/4164761/pexels-photo-4164761.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    ),
    _OnboardingSlide(
      title: 'YOUR COACH\nIN YOUR POCKET',
      subtitle: 'Train Anywhere. Anytime.',
      description: 'Structured programs. Workout logging. Progress tracking. Community support.',
      gradientColors: [const Color(0xFF0A0A0A), const Color(0xFF16213E)],
      accentColor: AppColors.streak,
      imageUrl: 'https://images.pexels.com/photos/2294361/pexels-photo-2294361.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    // Auto-scroll carousel
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < _slides.length - 1) {
        _pageController.nextPage(
          duration: AppConstants.animationSlow,
          curve: Curves.easeInOutCubic,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: AppConstants.animationSlow,
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background page view
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              // Reset auto-scroll timer on manual swipe
              _autoScrollTimer?.cancel();
              _startAutoScroll();
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return _SlideContent(
                slide: _slides[index],
                isActive: index == _currentPage,
              );
            },
          ),

          // Top bar with logo and sign in
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo with animated glow
                  Row(
                    children: [
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(
                                    (80 * _pulseController.value).round() + 40,
                                  ),
                                  blurRadius: 16 + (8 * _pulseController.value),
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'P',
                                style: AppTypography.headlineLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      AppSpacing.horizontalSM,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'PARKS',
                            style: AppTypography.programName.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              letterSpacing: 3,
                            ),
                          ),
                          Text(
                            'STRENGTH',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
                  
                  // Sign in button
                  TextButton(
                    onPressed: () => context.push(AppRoutes.signIn),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.glassBg,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                        side: BorderSide(color: AppColors.glassStroke),
                      ),
                    ),
                    child: Text(
                      'SIGN IN',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textPrimary,
                        letterSpacing: 1,
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.2),
                ],
              ),
            ),
          ),

          // Bottom content
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withAlpha(200),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.screenHorizontal),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Page indicator
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: _slides.length,
                        effect: ExpandingDotsEffect(
                          dotHeight: 6,
                          dotWidth: 6,
                          activeDotColor: _slides[_currentPage].accentColor,
                          dotColor: AppColors.textMuted.withAlpha(80),
                          expansionFactor: 4,
                          spacing: 8,
                        ),
                      ).animate().fadeIn(delay: 400.ms),
                      AppSpacing.verticalLG,

                      // Primary CTA - Sign up button with gradient
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                          gradient: AppColors.primaryGradient,
                          boxShadow: AppConstants.glowShadow(AppColors.primary),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => context.push(AppRoutes.signUp),
                            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              child: Center(
                                child: Text(
                                  'START FREE TRIAL',
                                  style: AppTypography.buttonLarge.copyWith(
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),
                      AppSpacing.verticalMD,

                      // Secondary option - Sign In for existing users
                      TextButton(
                        onPressed: () => context.push(AppRoutes.signIn),
                        child: RichText(
                          text: TextSpan(
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              const TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Sign In',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 600.ms),
                      AppSpacing.verticalSM,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide {
  final String title;
  final String subtitle;
  final String description;
  final List<Color> gradientColors;
  final Color accentColor;
  final String? imageUrl;

  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.gradientColors,
    required this.accentColor,
    this.imageUrl,
  });
}

class _SlideContent extends StatelessWidget {
  final _OnboardingSlide slide;
  final bool isActive;

  const _SlideContent({
    required this.slide,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: slide.gradientColors,
            ),
          ),
        ),

        // Background image with overlay
        if (slide.imageUrl != null)
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withAlpha(100),
                  Colors.black.withAlpha(200),
                  Colors.black,
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ).createShader(bounds),
              blendMode: BlendMode.darken,
              child: Image.network(
                slide.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),

        // Accent color overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  slide.accentColor.withAlpha(30),
                  Colors.transparent,
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
          ),
        ),

        // Content
        Positioned(
          left: AppSpacing.screenHorizontal,
          right: AppSpacing.screenHorizontal,
          bottom: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Accent subtitle
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: slide.accentColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  border: Border.all(
                    color: slide.accentColor.withAlpha(100),
                    width: 1,
                  ),
                ),
                child: Text(
                  slide.subtitle.toUpperCase(),
                  style: AppTypography.caption.copyWith(
                    color: slide.accentColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ).animate(target: isActive ? 1 : 0)
                .fadeIn(duration: 400.ms)
                .slideX(begin: -0.2),
              
              AppSpacing.verticalMD,
              
              // Main title
              Text(
                slide.title,
                style: AppTypography.displayLarge.copyWith(
                  height: 1.0,
                  letterSpacing: -1,
                ),
              ).animate(target: isActive ? 1 : 0)
                .fadeIn(duration: 500.ms, delay: 100.ms)
                .slideX(begin: -0.15),
              
              AppSpacing.verticalMD,
              
              // Description
              Text(
                slide.description,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ).animate(target: isActive ? 1 : 0)
                .fadeIn(duration: 500.ms, delay: 200.ms)
                .slideX(begin: -0.1),
            ],
          ),
        ),

        // Decorative elements
        Positioned(
          right: -50,
          top: 150,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  slide.accentColor.withAlpha(30),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
