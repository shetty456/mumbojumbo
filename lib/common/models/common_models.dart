import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_models.freezed.dart';
part 'common_models.g.dart';


// Model representing a user in the game
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// Model representing a jumbled word
@freezed
class JumbleWord with _$JumbleWord {
  const factory JumbleWord({
    required String originalWord,
    String? hint,
  }) = _JumbleWord;

  factory JumbleWord.fromJson(Map<String, dynamic> json) => _$JumbleWordFromJson(json);
}

// Model for game
@freezed
class GameState with _$GameState {
  const factory GameState({
    required User player,
    required int score,
    required List<JumbleWord> questions,
    required int currentQuestionIndex,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) => _$GameStateFromJson(json);
}

// Model representing a leaderboard entry
@freezed
class LeaderboardEntry with _$LeaderboardEntry {
  const factory LeaderboardEntry({
    required String userId,
    required String userName,
    required int score,
  }) = _LeaderboardEntry;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) => _$LeaderboardEntryFromJson(json);
}

// Model representing the leaderboard
@freezed
class Leaderboard with _$Leaderboard {
  const factory Leaderboard({
    required List<LeaderboardEntry> entries,
  }) = _Leaderboard;

  factory Leaderboard.fromJson(Map<String, dynamic> json) => _$LeaderboardFromJson(json);
}