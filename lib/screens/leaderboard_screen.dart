import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mumbojumbo/common/providers/common_providers.dart';

class LeaderboardScreen extends HookConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final isSearchTriggered = useState(false);
    final leaderboardAsyncValue = ref.watch(
      leaderboardControllerProvider(searchController.text.trim()),
    );

    Future<void> refreshLeaderboard() async {
      ref.refresh(leaderboardControllerProvider(searchController.text.trim()));
    }

    void performSearch() {
      isSearchTriggered.value = true; 
    }

    useEffect(() {
      if (isSearchTriggered.value) {
        ref.refresh(leaderboardControllerProvider(searchController.text.trim()));
        isSearchTriggered.value = false;
      }
      return null;
    }, [isSearchTriggered.value]);

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search player...',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: performSearch,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshLeaderboard,
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
