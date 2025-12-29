import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/app_colors.dart';
import 'app_router.dart';

/// Splash screen shown on app launch
/// Handles initial auth state check and navigation
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // Check auth state and navigate after animation
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for animation to complete
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    // Check if there's actually a logged in user session
    final supabaseUser = Supabase.instance.client.auth.currentUser;
    
    print('Splash: Checking auth state...');
    print('Splash: Current user = ${supabaseUser?.id ?? "null"}');
    
    if (supabaseUser == null) {
      // No user logged in - go to welcome screen for login/signup
      print('Splash: No user session, going to welcome');
      if (mounted) {
        context.go(AppRoutes.welcome);
      }
      return;
    }
    
    // User is logged in - check if profile exists and onboarding status
    try {
      final userProfile = await Supabase.instance.client
          .from('users')
          .select('id, onboarding_completed')
          .eq('id', supabaseUser.id)
          .maybeSingle();
      
      if (!mounted) return;
      
      print('Splash: User profile = $userProfile');
      
      if (userProfile == null) {
        // User profile doesn't exist - this means they signed up but profile wasn't created
        // Go to onboarding to create profile
        print('Splash: No profile found, going to onboarding');
        context.go(AppRoutes.onboarding);
        return;
      }
      
      final hasCompleted = userProfile['onboarding_completed'] == true;
      print('Splash: Onboarding completed = $hasCompleted');
      
      if (hasCompleted) {
        context.go(AppRoutes.home);
      } else {
        context.go(AppRoutes.onboarding);
      }
    } catch (e) {
      print('Splash: Error checking profile: $e');
      // On error, go to welcome screen to let user re-authenticate
      if (mounted) {
        context.go(AppRoutes.welcome);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          'PS',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // App name
                    const Text(
                      'PARKS',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 8,
                      ),
                    ),
                    const Text(
                      'STRENGTH',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        letterSpacing: 6,
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Loading indicator
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

