import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mumbojumbo/common/providers/common_providers.dart';

class LeaderboardScreen extends HookConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState('');

    final leaderboardAsyncValue = ref.watch(leaderboardControllerProvider(searchQuery.value.trim())); 

    Future<void> _refreshLeaderboard() async {
      ref.refresh(leaderboardControllerProvider(searchQuery.value.trim()));
    }

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
              searchQuery.value = query.trim();
              ref.refresh(leaderboardControllerProvider(searchQuery.value));
            },
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshLeaderboard,
        child: leaderboardAsyncValue.when(
          data: (leaderboard) {
            if (leaderboard.isEmpty) {
              return const Center(
                child: Text('No user found'),
              );
            }
            return ListView.builder(
              itemCount: leaderboard.length,
              itemBuilder: (context, index) {
                final leaderboardEntry = leaderboard[index];
                return ListTile(
                  leading: Text('#${leaderboardEntry.rank}'),
                  title: Text(leaderboardEntry.userName),
                  trailing: Text(leaderboardEntry.score.toString()),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
