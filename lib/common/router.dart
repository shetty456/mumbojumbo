import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/', routes: []);

abstract class AppRoutePaths {
  static const onboarding = "/onboarding";
  static const leaderboard = "/leaderboard";
  static const gamezone = "/gamezone";
}
