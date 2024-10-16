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
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'GAME OVER',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50, // Large size for emphasis
                  fontWeight: FontWeight.bold, // Bold and dramatic
                  color: Colors
                      .redAccent, // Red is often used for failure or urgency
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black87, // Dark shadow for depth
                      offset: Offset(4, 4),
                    ),
                  ],
                  letterSpacing: 2.0, // Slight spacing to add intensity
                ),
              )
                  .animate()
                  .fadeIn(duration: 1.seconds) // Fade in animation
                  // Scale animation
                  .flip(duration: 1.2.seconds)
                  .scale(duration: 0.6.seconds, curve: Curves.easeOut),
              vHeight(36),
              ElevatedButton(
                onPressed: () => context.go(AppRoutePaths.onboarding),
                child: const Text('Start a New Game'),
              ),
              vHeight(8),
              // todo: this button should be placed somewhere else
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
