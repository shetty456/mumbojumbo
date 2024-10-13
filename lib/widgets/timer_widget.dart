import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import audioplayers package

class TimerWidget extends StatefulWidget {
  final VoidCallback onTimeout;

  TimerWidget({required this.onTimeout});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _remainingTime = 30;
  late Timer _timer;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize AudioPlayer

  @override
  void initState() {
    super.initState();
    _startTimer();
    _playBackgroundMusic(); // Start the background music when the timer starts
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopBackgroundMusic(); // Stop music when widget is disposed
    super.dispose();
  }

  // Function to start the background music
  void _playBackgroundMusic() async {
    await _audioPlayer.play(AssetSource('sounds/bg_music.mp3'), volume: 0.5); // Playing the asset
  }

  // Function to stop the background music
  void _stopBackgroundMusic() async {
    await _audioPlayer.stop(); // Stop the music
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          widget.onTimeout(); // Notify parent when time runs out
          _timer.cancel();
          _stopBackgroundMusic(); // Stop the music when time runs out
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Time: $_remainingTime seconds',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
