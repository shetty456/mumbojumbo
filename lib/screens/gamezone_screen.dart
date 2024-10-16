import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mumbojumbo/common/models/common_models.dart';
import 'dart:math';

import 'package:mumbojumbo/common/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameZoneScreen extends HookWidget {
  const GameZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GoRouter.of(context).routerDelegate.currentConfiguration;
    final extra = state.extra;

    String username = 'Player';
    if (extra is Map<String, dynamic>) {
      username = extra['username'] as String? ?? 'Player';
      print('username: $username');
    }

    final anagrams = useState<List<JumbleWord>>([]);
    final currentAnagram = useState<String>('');
    final correctAnswer = useState<String>('');
    final currentHint = useState<String>('');
    final score = useState<int>(0); // Score state
    final questionIndex = useState<int>(0);
    final timer = useState<Timer?>(null);
    final timeLeft = useState<int>(30);
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    final isButtonEnabled = useState<bool>(false);

    useEffect(() {
      void listener() {
        isButtonEnabled.value = controller.text.isNotEmpty;
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    final animationController = useAnimationController(
      duration: const Duration(seconds: 5),
    );

    final animation = useMemoized(() {
      return Tween<double>(begin: 1.0, end: 0.0).animate(animationController);
    }, [animationController]);

    String jumbleWord(String word) {
      List<String> characters = word.split('');
      characters.shuffle(Random());
      return characters.join();
    }

    void storeScore(String username, int score) async {
      try {
        await FirebaseFirestore.instance.collection('scores').add({
          'username': username,
          'score': score,
          'timestamp': FieldValue.serverTimestamp(),
        });

        print('Score stored successfully for $username');
      } catch (e) {
        print('Failed to store score: $e');
      }
    }

    void endGame() {
      timer.value?.cancel();
      controller.clear();
      timeLeft.value = 30;
      storeScore(username, score.value);
      context.go(AppRoutePaths.gameover, extra: {
        'score': score.value,
        'username': username,
      });
    }

    void startTimer() {
      timer.value?.cancel();
      timer.value = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        if (timeLeft.value > 0) {
          timeLeft.value--;
        } else {
          endGame();
        }
      });
    }

    Future<void> loadAnagrams() async {
      final String response =
          await rootBundle.loadString('lib/data/words.json');
      final List<dynamic> data = json.decode(response);

      final validData = data.where(
          (item) => item['originalWord'] != null && item['hint'] != null);

      anagrams.value =
          validData.map((item) => JumbleWord.fromJson(item)).toList();

      if (anagrams.value.isNotEmpty) {
        currentHint.value =
            anagrams.value[questionIndex.value].hint ?? 'No hint available';
        correctAnswer.value = anagrams.value[questionIndex.value].originalWord;
        currentAnagram.value = jumbleWord(correctAnswer.value);

        startTimer();
      }
    }

    useEffect(() {
      loadAnagrams();
    }, []);

    void nextQuestion() {
      if (questionIndex.value + 1 < anagrams.value.length) {
        questionIndex.value++;
        currentHint.value = anagrams.value[questionIndex.value].hint ?? '';
        correctAnswer.value = anagrams.value[questionIndex.value].originalWord;
        currentAnagram.value = jumbleWord(correctAnswer.value);
        timeLeft.value = 30;
        controller.clear();
        focusNode.requestFocus();
        startTimer();
      } else {
        endGame();
      }
    }

    int calculateScore(int timeTakenInSeconds) {
      if (timeTakenInSeconds <= 3) {
        return 10;
      } else if (timeTakenInSeconds <= 6) {
        return 9;
      } else if (timeTakenInSeconds <= 9) {
        return 8;
      } else if (timeTakenInSeconds <= 12) {
        return 7;
      } else if (timeTakenInSeconds <= 15) {
        return 6;
      } else if (timeTakenInSeconds <= 18) {
        return 5;
      } else if (timeTakenInSeconds <= 21) {
        return 4;
      } else if (timeTakenInSeconds <= 24) {
        return 3;
      } else if (timeTakenInSeconds <= 27) {
        return 2;
      } else if (timeTakenInSeconds <= 30) {
        return 1;
      } else {
        return 0;
      }
    }

    void submitAnswer(String answer) {
      if (answer.toLowerCase() == correctAnswer.value.toLowerCase()) {
        // Calculate score based on time left
        final int points = calculateScore(30 - timeLeft.value);
        score.value += points; // Add points to total score
        nextQuestion();
      } else {
        endGame();
      }
    }

    String formatTime(int seconds) {
      return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Displaying the score in the top right corner
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(), // Empty widget to keep score aligned to the right
                  Text(
                    'Score: ${score.value}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: animation.value,
                      color: Colors.green,
                      backgroundColor: Colors.grey,
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),
              Text(
                formatTime(timeLeft.value),
                style: const TextStyle(
                    fontSize: 32,
                    color: Colors.red,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xff34C759),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    currentHint.value,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff34C759),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Text(
                textAlign: TextAlign.center,
                currentAnagram.value,
                style:
                    const TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 60),
              TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'Type your answer',
                  hintStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xffD9D9D9),
                      width: 1.0,
                    ),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                onSubmitted: submitAnswer,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => submitAnswer(controller.text),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
