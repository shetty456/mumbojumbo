import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mumbojumbo/common/providers/common_providers.dart';

class LeaderboardScreen extends HookConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_result
    ref.refresh(leaderboardControllerProvider);
    
    final leaderboardAsyncValue = ref.watch(leaderboardControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search player...',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: (query) {
              // Handle search logic here if needed
            },
          ),
        ),
      ),
      body: leaderboardAsyncValue.when(
        data: (leaderboard) => ListView.builder(
          itemCount: leaderboard.length,
          itemBuilder: (context, index) {
            final leaderboardEntry = leaderboard[index]; 
            return ListTile(
              leading: Text('#${index + 1}'),
              title: Text(leaderboardEntry.userName), 
              trailing: Text(leaderboardEntry.score.toString()), 
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()), 
        error: (error, stack) => Center(child: Text('Error: $error')), 
      ),
    );
  }
}
