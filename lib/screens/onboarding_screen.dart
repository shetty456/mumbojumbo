import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mumbojumbo/common/router.dart';

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Welcome to Mumbo Jumbo')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                vHeight(24),
                const Text(
                  'MUMBO JUMBO',
                  style: TextStyle(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                vHeight(24),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                vHeight(24),
                const Text(
                  'A game of Grace, Luck and competence, without which you’ll not be successful',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                vHeight(36),
                const Text(
                  'Rules of the Game',
                  style: TextStyle(fontSize: 22),
                ),
                vHeight(24),
                const InstructionItem(
                    text:
                        'Guess the anagram names related to our ashram or spiritual themes.'),
                const InstructionItem(
                    text: 'Players have 30 seconds to type the right answer.'),
                const InstructionItem(
                    text:
                        'Correct guesses earn points and proceed to the next round.'),
                const InstructionItem(
                    text:
                        'If no one guesses correctly within 30 seconds, the game ends.'),
                const InstructionItem(
                    text: 'One can attempt a maximum of 20 questions only.'),
                vHeight(36),
                ElevatedButton(
                  onPressed: () => context.push(AppRoutePaths.username),
                  child: const Text('Start the Game'),
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
      ),
    );
  }
}

SizedBox vHeight(double height) => SizedBox(
      height: height,
    );

class InstructionItem extends StatelessWidget {
  final String text;

  const InstructionItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.circle, size: 8, color: Colors.black), // Bullet point
        const SizedBox(width: 8), // Space between bullet and text
        Expanded(
          // To ensure text wraps correctly in smaller screens
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
