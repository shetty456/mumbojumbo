import 'dart:convert';
import 'package:mumbojumbo/common/models/common_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'common_providers.g.dart';

// Provider for the game state
@riverpod
class GameController extends _$GameController {
  @override
  GameState build() {
    return GameState(
      player: User(id: '', name: ''),
      score: 0,
      questions: [],
      currentQuestionIndex: 0,
    );
  }

  // Initialize game with a random user and fetched questions
  Future<void> initializeGame(List<JumbleWord> questions) async {
    final userId = _generateRandomUserId();
    final userName = _generateRandomUserName();
    
    state = state.copyWith(
      player: User(id: userId, name: userName),
      questions: questions,
    );
  }

  // Submit the answer
  void submitAnswer(String answer) {
    final currentQuestion = state.questions[state.currentQuestionIndex];
    if (currentQuestion.originalWord == answer) {
      state = state.copyWith(score: state.score + 1);
    }
    if (state.currentQuestionIndex < state.questions.length - 1) {
      state = state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1);
    } else {
      // Game over, handle game completion
    }
  }

  // Helper methods
  String _generateRandomUserId() => DateTime.now().millisecondsSinceEpoch.toString();
  String _generateRandomUserName() => 'Player${DateTime.now().millisecondsSinceEpoch}';
}

// Provider to fetch jumbled words from a remote source (e.g., Firebase or a JSON API)
@riverpod
Future<List<JumbleWord>> fetchJumbledWords(FetchJumbledWordsRef ref) async {
  // Here we would fetch data from local storage, Firebase, or a JSON endpoint
  // For example:
  // final response = await http.get(Uri.parse('https://your-api-url.com/words'));
  // if (response.statusCode == 200) {
  //   final List<dynamic> jsonData = json.decode(response.body);
  //   return jsonData.map((json) => JumbleWord.fromJson(json)).toList();
  // } else {
  //   throw Exception('Failed to load words');
  // }
  return [
    JumbleWord(originalWord: 'meditation', hint: 'It helps in calming the mind'),
    JumbleWord(originalWord: 'spirituality', hint: 'Inner search for truth'),
  ];
}

// Provider for managing the leaderboard
@riverpod
class LeaderboardController extends _$LeaderboardController {
  @override
  Leaderboard build() {
    return Leaderboard(entries: []);
  }

  // Add an entry to the leaderboard
  Future<void> addEntry(User player, int score) async {
    final newEntry = LeaderboardEntry(userId: player.id, userName: player.name, score: score);
    final updatedEntries = List<LeaderboardEntry>.from(state.entries)..add(newEntry);

    state = state.copyWith(entries: updatedEntries);

    // Optionally save to local storage or Firebase
    await _saveLeaderboardToLocal(updatedEntries);
  }

  Future<void> _saveLeaderboardToLocal(List<LeaderboardEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonEntries = entries.map((e) => e.toJson()).toList();
    await prefs.setString('leaderboard', jsonEncode(jsonEntries));
  }

  Future<void> loadLeaderboardFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('leaderboard');
    if (jsonString != null) {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      final loadedEntries = jsonList.map((json) => LeaderboardEntry.fromJson(json)).toList();
      state = state.copyWith(entries: loadedEntries);
    }
  }
}
