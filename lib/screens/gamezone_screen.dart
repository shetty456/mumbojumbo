import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mumbojumbo/common/models/common_models.dart';
import 'dart:math';

import 'package:mumbojumbo/common/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mumbojumbo/main.dart';
import 'package:mumbojumbo/screens/onboarding_screen.dart';

class GameZoneScreen extends HookWidget {
  const GameZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GoRouter.of(context).routerDelegate.currentConfiguration;
    final extra = state.extra;

    String username = 'Player';
    if (extra is Map<String, dynamic>) {
      username = extra['username'] as String? ?? 'Player';
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
    final progressValue = useState(1.0);

    // Initialize the audio player
    final audioPlayer = useState(AudioPlayer());

    useEffect(() {
      void listener() {
        isButtonEnabled.value = controller.text.isNotEmpty;
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    // Function to play ticking sound
    Future<void> playTickingSound() async {
      await audioPlayer.value
          .play(AssetSource('sounds/bg_music.mp3'), volume: 1.0);
      audioPlayer.value.setReleaseMode(ReleaseMode.loop); // Loop the sound
    }

    // Function to stop the ticking sound
    Future<void> stopTickingSound() async {
      await audioPlayer.value.stop();
    }

    String jumbleWord(String word) {
      List<String> characters = word.split('');
      characters.shuffle(Random());
      return characters.join();
    }

    void storeScore(String username, int score) async {
      try {
        await FirebaseFirestore.instance.collection('leaderboard').add({
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

      if (context.mounted) {
        context.go(AppRoutePaths.gameover, extra: {
          'score': score.value,
          'username': username,
          'correctAnswer': correctAnswer.value,
        });
      }
    }

    void startTimer() {
      timer.value?.cancel();
      timer.value = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        if (timeLeft.value > 0) {
          timeLeft.value--;
          progressValue.value = timeLeft.value / 30;
        } else {
          endGame();
        }
      });
    }

    Future<void> loadAnagrams() async {
      final String response =
          await rootBundle.loadString('lib/data/real_data.json');
      final List<dynamic> data = json.decode(response);

// Filter the data where 'originalWord' and 'hint' are not null, then convert to List
      final List<dynamic> validData = data
          .where((item) =>
              item['originalWord'] != null &&
              item['hint'] != null &&
              item['originalWord'].length < 10)
          .toList();

// Randomize the data
      validData.shuffle(Random()); // Shuffle the list

// Limit to 20 items and map to a list of JumbleWord objects
      anagrams.value =
          validData.take(20).map((item) => JumbleWord.fromJson(item)).toList();

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
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //   content: Text('Rightly Guessed'),
        //   duration: Duration(seconds: 2),
        // ));
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

    // Determine the color based on the remaining time (green for > 25%, red for <= 25%)
    Color getPieColor() {
      if (progressValue.value > 0.25) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 8.0),
            child: CustomPaint(
              size: const Size(60, 60), // Adjust the size of the pie chart
              painter: PieChartPainter(progressValue.value, getPieColor()),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Text(
              'Your Score: ${score.value}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Text(
                  currentHint.value,
                  style: const TextStyle(
                      fontSize: 28,
                      color: spcolor,
                      fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                vHeight(36),
                Text(
                  textAlign: TextAlign.center,
                  currentAnagram.value.toLowerCase(),
                  style: const TextStyle(
                      fontSize: 64, fontWeight: FontWeight.bold),
                ),
                vHeight(36),
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
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      submitAnswer(value);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please enter an answer.'),
                        duration: Duration(seconds: 2),
                      ));
                    }
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: isButtonEnabled.value
                      ? () => submitAnswer(controller.text)
                      : null,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void showCenterModal(
  //     BuildContext context, Function callback, String correctAnswer) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, // Prevent dismissal by tapping outside
  //     builder: (BuildContext context) {
  //       Future.delayed(const Duration(seconds: 3), () {
  //         if (context.mounted) {
  //           Navigator.of(context).pop();
  //         }
  //         callback();
  //       });

  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(
  //             8,
  //           ), // Adjust this value for rounded corners
  //         ),
  //         backgroundColor: spcolor,
  //         child: Padding(
  //           padding: const EdgeInsets.all(24.0),
  //           child: SizedBox(
  //             height: 100,
  //             width: double.infinity,
  //             child: Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   const Text(
  //                     'Wrong Answer',
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(fontSize: 24, color: Colors.white),
  //                   ),
  //                   Text(
  //                     'Correct answer is: $correctAnswer',
  //                     textAlign: TextAlign.center,
  //                     style: const TextStyle(fontSize: 18, color: Colors.white),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

// CustomPainter for the pie chart-like countdown effect
class PieChartPainter extends CustomPainter {
  final double
      progress; // Progress value for the pie chart (1.0 is full, 0.0 is empty)
  final Color pieColor; // Color for the pie based on the remaining time

  PieChartPainter(this.progress, this.pieColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = pieColor;

    double radius = min(size.width / 2, size.height / 2);
    Offset center = Offset(size.width / 2, size.height / 2);

    // Draw the pie chart's progress based on remaining time
    double sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start at the top (12 o'clock)
      sweepAngle,
      true,
      paint,
    );

    // Draw the background color for the remaining part
    Paint backgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey[300]!; // Color for empty part of the pie

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2 + sweepAngle, // Start after the progress arc
      2 * pi - sweepAngle, // Cover the remaining part
      true,
      backgroundPaint,
    );
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pieColor !=
            pieColor; // Repaint only when progress or color changes
  }
}
