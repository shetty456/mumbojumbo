import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mumbojumbo/common/router.dart';
import 'package:mumbojumbo/main.dart';
import 'package:mumbojumbo/screens/onboarding_screen.dart';

class GameoverScreen extends HookConsumerWidget {
  const GameoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = GoRouter.of(context).routerDelegate.currentConfiguration;
    final confettiController = useMemoized(() {
      return ConfettiController(duration: const Duration(seconds: 5));
    }, []);

    useEffect(() {
      confettiController.play();
    }, []);

    final extra = state.extra;

    int finalScore = 0;
    String username = 'Player';
    String correctAnswer = 'Correct Answer';

    if (extra is Map<String, dynamic>) {
      finalScore = extra['score'] as int? ?? 0;
      username = extra['username'] as String? ?? 'Player';
      correctAnswer = extra['correctAnswer'] as String? ?? 'Correct Answer';
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality:
                  BlastDirectionality.explosive, // Blast in all directions
              shouldLoop: true, // Confetti plays once
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // Colors of confetti
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
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
                  CircleAvatar(
                    maxRadius: 80,
                    child: Image.network(
                      'https://api.dicebear.com/9.x/big-smile/png?seed=$username',
                    ),
                  ),
                  // Display the username
                  Text(
                    'Player: $username',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  vHeight(16),

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
                       Text(
                    'Correct Answer was : $correctAnswer',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: spcolor,
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
          ],
        ),
      ),
    );
  }
}
