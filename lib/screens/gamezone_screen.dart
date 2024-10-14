import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class GameZoneScreen extends HookWidget {
  const GameZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final anagrams = useState<List<Map<String, String>>>([]);
    final currentAnagram = useState<String>('');
    final correctAnswer = useState<String>('');
    final score = useState<int>(0);
    final questionIndex = useState<int>(0);
    final timer = useState<Timer?>(null);
    final timeLeft = useState<int>(30);
    final controller = useTextEditingController();
    final focusNode = useFocusNode();

    Future<void> loadAnagrams() async {
      final String response = await rootBundle.loadString('lib/data/anagrams.json');
      final List<dynamic> data = json.decode(response);
      anagrams.value = data.map((item) {
        return {
          'anagram': item['anagram'] as String,
          'answer': item['answer'] as String,
        };
      }).toList();

      if (anagrams.value.isNotEmpty) {
        currentAnagram.value = anagrams.value[questionIndex.value]['anagram']!;
        correctAnswer.value = anagrams.value[questionIndex.value]['answer']!;
      }
    }

    useEffect(() {
      loadAnagrams();
    }, []);

    void endGame() {
      timer.value?.cancel();
      controller.clear();
      timeLeft.value = 30;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your score: ${score.value}'),
          actions: [
            TextButton(
              onPressed: () {
                score.value = 0;
                questionIndex.value = 0;
                loadAnagrams();
                Navigator.of(context).pop();
              },
              child: const Text('Restart'),
            ),
          ],
        ),
      );
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

    void nextQuestion() {
      if (questionIndex.value + 1 < anagrams.value.length) {
        questionIndex.value++;
        currentAnagram.value = anagrams.value[questionIndex.value]['anagram']!;
        correctAnswer.value = anagrams.value[questionIndex.value]['answer']!;
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

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text('Jumbled Word Game'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Time Left: ${timeLeft.value}',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Score: ${score.value}',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 40),
            Text(
              currentAnagram.value,
              style: const TextStyle(fontSize: 40, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'Type your answer',
                  hintStyle: const TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                onSubmitted: submitAnswer,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => submitAnswer(controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
