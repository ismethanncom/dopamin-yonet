import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/addiction_selection_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/library/presentation/pages/library_page.dart';
import '../../features/community/presentation/pages/community_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/ai_coach/presentation/pages/ai_coach_page.dart';
import '../../features/deep_work/presentation/pages/deep_work_page.dart';
import '../../features/dopamine_journal/presentation/pages/journal_page.dart';
import '../../features/urge_management/presentation/pages/urge_page.dart';
import '../../features/life_tree/presentation/pages/life_tree_page.dart';
import '../widgets/main_scaffold.dart';

/// Uygulama yönlendirme yapılandırması
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/onboarding',
    debugLogDiagnostics: true,
    routes: [
      // Onboarding Routes
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/addiction-selection',
        builder: (context, state) => const AddictionSelectionPage(),
      ),

      // Main Shell Route with Bottom Navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: '/analytics',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AnalyticsPage(),
            ),
          ),
          GoRoute(
            path: '/library',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: LibraryPage(),
            ),
          ),
          GoRoute(
            path: '/community',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CommunityPage(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
        ],
      ),

      // Feature Routes (Full Screen)
      GoRoute(
        path: '/ai-coach',
        builder: (context, state) => const AiCoachPage(),
      ),
      GoRoute(
        path: '/deep-work',
        builder: (context, state) => const DeepWorkPage(),
      ),
      GoRoute(
        path: '/journal',
        builder: (context, state) => const JournalPage(),
      ),
      GoRoute(
        path: '/urge',
        builder: (context, state) => const UrgePage(),
      ),
      GoRoute(
        path: '/life-tree',
        builder: (context, state) => const LifeTreePage(),
      ),
    ],
  );
}
