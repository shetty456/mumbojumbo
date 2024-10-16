import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mumbojumbo/common/models/common_models.dart';
import 'dart:math';

import 'package:mumbojumbo/common/router.dart';
import 'package:mumbojumbo/screens/onboarding_screen.dart';

class GameZoneScreen extends HookWidget {
  const GameZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final anagrams = useState<List<JumbleWord>>([]);

    final currentAnagram = useState<String>('');
    final correctAnswer = useState<String>('');
    final currentHint = useState<String>('');
    final score = useState<int>(0);
    final questionIndex = useState<int>(0);
    final timer = useState<Timer?>(null);
    final timeLeft = useState<int>(30);
    final controller = useTextEditingController();
    final focusNode = useFocusNode();

    // Using useAnimationController hook to create an AnimationController
    final animationController = useAnimationController(
      duration: const Duration(seconds: 5), // Set animation duration
    ); // Start animation from 1.0 (100%) and reverse

    // Map the controller's value range (0.0 - 1.0) to a range of 0.2 to 0.0 (20% to 0%)
    final animation = useMemoized(() {
      return Tween<double>(begin: 1.0, end: 0.0).animate(animationController);
    }, [animationController]);

    String jumbleWord(String word) {
      List<String> characters = word.split('');
      characters.shuffle(Random());
      return characters.join();
    }

    void endGame() {
      timer.value?.cancel();
      controller.clear();
      timeLeft.value = 30;
      context.go(AppRoutePaths.gameover);
      // showDialog(
      //   context: context,
      //   builder: (_) => AlertDialog(
      //     title: const Text('Game Over'),
      //     content: Text('Your score: ${score.value}'),
      //     actions: [
      //       TextButton(
      //         onPressed: () {
      //           context.go(AppRoutePaths.onboarding);
      //         },
      //         child: const Text('Go Home'),
      //       ),
      //     ],
      //   ),
      // );
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

    void submitAnswer(String answer) {
      if (answer.toLowerCase() == correctAnswer.value.toLowerCase()) {
        score.value++;
        nextQuestion();
      } else {
        endGame();
      }
    }

    String formatTime(int seconds) {
      return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Mumbo Jumbo'),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: animation
                          .value, // Animating progress value from 0.2 to 0.0
                      color: Colors.green,
                      backgroundColor: Colors.grey,
                    );
                  },
                ),
              ),

              vHeight(32),
              Text(
                formatTime(timeLeft.value),
                style: const TextStyle(
                    fontSize: 32,
                    color: Colors.red,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              vHeight(32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xff34C759),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
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
              vHeight(60),
              // Text(
              //   'Score: ${score.value}',
              //   style: const TextStyle(
              //     fontSize: 20,
              //   ),
              // ),
              Text(
                textAlign: TextAlign.center,
                currentAnagram.value,
                style:
                    const TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
              ),
              vHeight(60),
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
              vHeight(16),
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
