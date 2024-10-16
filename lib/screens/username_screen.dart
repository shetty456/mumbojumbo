import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mumbojumbo/common/router.dart';
import 'package:mumbojumbo/screens/onboarding_screen.dart';

class UsernameScreen extends HookConsumerWidget {
  const UsernameScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNameController = useTextEditingController();

    void submitUserName(String username) {
      // todo: here we can call the provider to check
      context.go(AppRoutePaths.gamezone, extra: {"username": userNameController.text});
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Mumbo Jumbo')),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Please input a random username so that we can identify you when you win the game. Please make sure that it is unique...',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            vHeight(16),
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
            vHeight(16),
            ElevatedButton(
              onPressed: () => submitUserName(userNameController.text),
              child: const Text('Enter Gamezone'),
            ),
            vHeight(32),
            Image.asset('assets/images/game.png')
          ],
        ),
      )),
    );
  }
}
