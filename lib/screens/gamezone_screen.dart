import 'package:flutter/material.dart';
import 'package:mumbojumbo/common/router.dart';
import '../widgets/anagram_widget.dart';
import '../widgets/timer_widget.dart';
import 'package:go_router/go_router.dart';

class GameZoneScreen extends StatefulWidget {
  @override
  _GameZoneScreenState createState() => _GameZoneScreenState();
}

class _GameZoneScreenState extends State<GameZoneScreen> {
  String currentAnagram = 'yoga'; // This would be dynamically generated
  String correctAnswer = 'yoga'; // Corresponding correct answer
  int score = 0;

  void onSubmit(String answer) {
    if (answer.toLowerCase() == correctAnswer) {
      setState(() {
        score++;
        // Update the anagram and correct answer
        currentAnagram = 'peace'; // Update with new data
        correctAnswer = 'peace'; // Update with new answer
      });
    } else {
      _endGame();
    }
  }

  void _endGame() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Your score: $score'),
        actions: [
          TextButton(
            onPressed: () => context.go(AppRoutePaths.leaderboard),
            child: Text('Leaderboard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Zone')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimerWidget(onTimeout: _endGame),
          AnagramWidget(anagram: currentAnagram),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(hintText: 'Type your answer'),
              onSubmitted: onSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
