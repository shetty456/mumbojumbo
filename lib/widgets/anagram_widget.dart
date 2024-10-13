import 'package:flutter/material.dart';

class AnagramWidget extends StatelessWidget {
  final String anagram;

  const AnagramWidget({super.key, required this.anagram});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        anagram,
        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );
  }
}
