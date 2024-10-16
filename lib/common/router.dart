import 'package:go_router/go_router.dart';
import 'package:mumbojumbo/screens/gameover_screen.dart';
import 'package:mumbojumbo/screens/gamezone_screen.dart';
import 'package:mumbojumbo/screens/leaderboard_screen.dart';
import 'package:mumbojumbo/screens/onboarding_screen.dart';
import 'package:mumbojumbo/screens/username_screen.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutePaths.onboarding,
  routes: [
    GoRoute(
      path: AppRoutePaths.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.leaderboard,
      builder: (context, state) => const LeaderboardScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.gamezone,
      builder: (context, state) => const GameZoneScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.username,
      builder: (context, state) => const UsernameScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.gameover,
      builder: (context, state) => const GameoverScreen(),
    ),
  ],
);

abstract class AppRoutePaths {
  static const onboarding = "/onboarding";
  static const leaderboard = "/leaderboard";
  static const gamezone = "/gamezone";
  static const username = "/username";
  static const gameover = "/gameover";
}
