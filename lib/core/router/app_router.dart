import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/sign_in_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/onboarding/screens/onboarding_wizard_screen.dart';
import '../../features/onboarding/screens/program_recommendation_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/main_shell.dart';
import '../../features/tribe/screens/tribe_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/programs/screens/program_browser_screen.dart';
import '../../features/programs/screens/program_detail_screen.dart';
import '../../features/workout/screens/workout_overview_screen.dart';
import '../../features/workout/screens/active_workout_screen.dart';
import '../../features/workout/screens/workout_completion_screen.dart';
import '../../features/workout/screens/quick_workout_screen.dart';
import '../../features/workout/screens/active_quick_workout_screen.dart';
import '../../data/services/workout_generator.dart';
import '../../features/progress/screens/progress_dashboard_screen.dart';
import '../../features/progress/screens/personal_records_screen.dart';
import '../../features/progress/screens/workout_history_screen.dart';
import '../../features/profile/screens/settings_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../constants/app_colors.dart';
import 'splash_screen.dart';

// Route names
class AppRoutes {
  AppRoutes._();

  // Auth routes
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';

  // Onboarding routes
  static const String onboarding = '/onboarding';
  static const String programRecommendation = '/program-recommendation';
  static const String paywall = '/paywall';

  // Main app routes
  static const String home = '/home';
  static const String tribe = '/tribe';
  static const String profile = '/profile';

  // Program routes
  static const String programs = '/programs';
  static const String programDetail = '/programs/:id';

  // Workout routes
  static const String workout = '/workout/:id';
  static const String activeWorkout = '/workout/:id/active';
  static const String workoutComplete = '/workout-complete';
  static const String quickWorkout = '/quick-workout/:type';

  // Progress routes
  static const String progress = '/progress';
  static const String personalRecords = '/personal-records';
  static const String workoutHistory = '/workout-history';

  // Settings routes
  static const String settings = '/settings';
  static const String accountSettings = '/settings/account';
  static const String notificationSettings = '/settings/notifications';
  static const String equipmentSettings = '/settings/equipment';
  static const String subscription = '/settings/subscription';
}

// Navigation keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// Router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  // Watch auth state to trigger router refresh on auth changes
  ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,

    // Fixed redirect logic - check Supabase session directly
    redirect: (context, state) {
      final currentPath = state.matchedLocation;
      
      // STEP 1: Check authentication using direct Supabase session
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      
      print('Router: path=$currentPath, session=${session != null ? "exists" : "null"}');
      
      // Never redirect from splash - it handles its own navigation
      if (currentPath == AppRoutes.splash) {
        return null;
      }

      // Define public routes (accessible without login)
      final publicRoutes = [
        AppRoutes.welcome,
        AppRoutes.signIn,
        AppRoutes.signUp,
        AppRoutes.forgotPassword,
      ];
      final isPublicRoute = publicRoutes.contains(currentPath);

      // STEP 2: Handle unauthenticated users
      if (!isLoggedIn) {
        // Allow access to public routes
        if (isPublicRoute) {
          return null;
        }
        // Redirect all protected routes to welcome
        print('Router: Not logged in, redirecting to welcome');
        return AppRoutes.welcome;
      }

      // STEP 3: User is logged in
      // If on public route, redirect to splash (which checks onboarding status)
      if (isPublicRoute) {
        print('Router: Logged in on public route, redirecting to splash for onboarding check');
        return AppRoutes.splash;
      }

      // Allow access to onboarding and all other routes for logged in users
      return null;
    },

    routes: [
      // Splash screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth routes
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Onboarding routes
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingWizardScreen(),
      ),
      GoRoute(
        path: AppRoutes.programRecommendation,
        builder: (context, state) => const ProgramRecommendationScreen(),
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.tribe,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TribeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),

      // Program routes
      GoRoute(
        path: AppRoutes.programs,
        builder: (context, state) => const ProgramBrowserScreen(),
      ),
      GoRoute(
        path: AppRoutes.programDetail,
        builder: (context, state) {
          final programId = state.pathParameters['id']!;
          return ProgramDetailScreen(programId: programId);
        },
      ),

      // Workout routes
      GoRoute(
        path: AppRoutes.workout,
        builder: (context, state) {
          final workoutId = state.pathParameters['id']!;
          return WorkoutOverviewScreen(workoutId: workoutId);
        },
      ),
      GoRoute(
        path: AppRoutes.activeWorkout,
        builder: (context, state) {
          final workoutId = state.pathParameters['id']!;
          return ActiveWorkoutScreen(workoutId: workoutId);
        },
      ),
      GoRoute(
        path: AppRoutes.workoutComplete,
        builder: (context, state) {
          final workoutLogId = state.extra as String?;
          return WorkoutCompletionScreen(workoutLogId: workoutLogId ?? '');
        },
      ),
      GoRoute(
        path: AppRoutes.quickWorkout,
        builder: (context, state) {
          final workoutType = state.pathParameters['type'] ?? 'fullbody';
          return QuickWorkoutScreen(workoutType: workoutType);
        },
      ),
      GoRoute(
        path: '/active-quick-workout',
        builder: (context, state) {
          final workout = state.extra as GeneratedWorkout;
          return ActiveQuickWorkoutScreen(workout: workout);
        },
      ),

      // Progress routes
      GoRoute(
        path: AppRoutes.progress,
        builder: (context, state) => const ProgressDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.personalRecords,
        builder: (context, state) => const PersonalRecordsScreen(),
      ),
      GoRoute(
        path: AppRoutes.workoutHistory,
        builder: (context, state) => const WorkoutHistoryScreen(),
      ),

      // Settings routes
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.message ?? 'Unknown error',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
