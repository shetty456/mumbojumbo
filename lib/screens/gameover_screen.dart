import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mumbojumbo/common/router.dart';
import 'package:mumbojumbo/screens/onboarding_screen.dart';

class GameoverScreen extends HookConsumerWidget {
  const GameoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   final state = GoRouter.of(context).routerDelegate.currentConfiguration;
    final int finalScore = state.extra as int? ?? 0;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'GAME OVER',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black87,
                      offset: Offset(4, 4),
                    ),
                  ],
                  letterSpacing: 2.0,
                ),
              )
                  .animate()
                  .fadeIn(duration: 1.seconds)
                  .flip(duration: 1.2.seconds)
                  .scale(duration: 0.6.seconds, curve: Curves.easeOut),
              vHeight(36),
              // Display the final score
              Text(
                'Your Score: $finalScore',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              vHeight(36),
              ElevatedButton(
                onPressed: () => context.go(AppRoutePaths.onboarding),
                child: const Text('Start a New Game'),
              ),
              vHeight(8),
              OutlinedButton(
                onPressed: () => context.push(AppRoutePaths.leaderboard),
                child: const Text('Go to Leaderboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

