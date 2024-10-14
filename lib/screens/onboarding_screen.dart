import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mumbojumbo/common/router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Mumbo Jumbo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the Game!', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            const Text('Rules: Solve anagrams in 30 seconds!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoutePaths.gamezone),
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}
