import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mumbojumbo/common/router.dart';

class UsernameScreen extends HookConsumerWidget {
  const UsernameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNameController = useTextEditingController();
    final isUsernameTaken = useState(false);
    final isChecking = useState(false);

    Future<bool> checkUsernameExists(String username) async {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('leaderboard')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();
      return result.docs.isNotEmpty;
    }

    void submitUserName(String username) async {
      isChecking.value = true;

      final usernameExists = await checkUsernameExists(username);
      isChecking.value = false;

      if (context.mounted) {
        if (usernameExists) {
          isUsernameTaken.value = true;
        } else {
          isUsernameTaken.value = false;
          context.go(AppRoutePaths.gamezone, extra: {"username": userNameController.text});
        }
      }
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
              const SizedBox(height: 16),
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
                  errorText: isUsernameTaken.value ? 'Username is already taken' : null,
                ),
                style: const TextStyle(color: Colors.black),
                onSubmitted: submitUserName,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isChecking.value
                    ? null
                    : () => submitUserName(userNameController.text),
                child: isChecking.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Enter Gamezone'),
              ),
              const SizedBox(height: 32),
              Image.asset('assets/images/game.png'),
            ],
          ),
        ),
      ),
    );
  }
}
