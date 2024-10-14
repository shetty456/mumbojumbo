import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy leaderboard data for now
    final leaderboard = [
      {'name': 'Player 1', 'score': 100},
      {'name': 'Player 2', 'score': 90},
      {'name': 'Player 3', 'score': 80},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Leaderboard')),
      body: ListView.builder(
        itemCount: leaderboard.length,
        itemBuilder: (context, index) {
          final player = leaderboard[index];
          return ListTile(
            leading: Icon(
              index == 0
                  ? Icons.emoji_events
                  : Icons.person, // Gold for first, person for others
              color: index == 0
                  ? Colors.amber
                  : index == 1
                      ? Colors.grey
                      : index == 2
                          ? Colors.orange
                          : null,
            ),
            title: Text(player['name'].toString()),
            trailing: Text(player['score'].toString()),
          );
        },
      ),
    );
  }
}
