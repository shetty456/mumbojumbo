import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mumbojumbo/common/router.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to Mumbo Jumbo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Game!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('Rules: Solve anagrams in 30 seconds!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoutePaths.gamezone),
              child: Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}
