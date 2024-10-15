import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mumbojumbo/common/router.dart';

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNameController = useTextEditingController();

    void submitUserName(String username) {
      // todo: here we can call the provider to check
      print(username);
      context.push(AppRoutePaths.gamezone);
    }

    return Scaffold(
      // appBar: AppBar(title: const Text('Welcome to Mumbo Jumbo')),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(24),
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
              const Spacer(),
              TextField(
                controller: userNameController,
                decoration: InputDecoration(
                  hintText: 'Username',
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
                onSubmitted: submitUserName,
              ),
              vHeight(8),
              ElevatedButton(
                onPressed: () => submitUserName(userNameController.text),
                child: const Text('Start Game'),
              ),
              vHeight(8),
              // todo: this button should be placed somewhere else
              // ElevatedButton(
              //   onPressed: () => context.push(AppRoutePaths.leaderboard),
              //   child: const Text('Go to Leaderboard'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox vHeight(double height) => SizedBox(
        height: height,
      );
}
