import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mumbojumbo/common/providers/common_providers.dart';

class LeaderboardScreen extends HookConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboard = ref.watch(leaderboardControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50, // Adjust the height of the search bar
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search player...',
              filled: true,
              fillColor: Colors.grey[200], // Background color of search bar
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: (query) {
              // setState(() {
              //   searchQuery = query;
              // });
            },
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: leaderboard.entries.length,
        itemBuilder: (context, index) {
          final player = leaderboard.entries[index];
          return ListTile(
            leading: IconButton(
              onPressed: () {
                return;
              },
              icon: Text('#${index + 1}'),
            ),
            title: Text(player.userName),
            trailing: Text(player.score.toString()),
          );
        },
      ),
    );
  }
}
