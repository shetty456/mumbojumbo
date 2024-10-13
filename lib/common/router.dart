import 'package:go_router/go_router.dart';
import 'package:mumbojumbo/screens/gamezone_screen.dart';
import 'package:mumbojumbo/screens/leaderboard_screen.dart';
import 'package:mumbojumbo/screens/onboarding_screen.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutePaths.onboarding,
  routes: [
    GoRoute(
      path: AppRoutePaths.onboarding,
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.leaderboard,
      builder: (context, state) => LeaderboardScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.gamezone,
      builder: (context, state) => GameZoneScreen(),
    ),
  ],
);

abstract class AppRoutePaths {
  static const onboarding = "/onboarding";
  static const leaderboard = "/leaderboard";
  static const gamezone = "/gamezone";
}
