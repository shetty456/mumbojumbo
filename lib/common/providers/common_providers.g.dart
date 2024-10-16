// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchJumbledWordsHash() => r'abf6f2b9e3248e274a78d47ad682c9d8f0c23594';

/// See also [fetchJumbledWords].
@ProviderFor(fetchJumbledWords)
final fetchJumbledWordsProvider =
    AutoDisposeFutureProvider<List<JumbleWord>>.internal(
  fetchJumbledWords,
  name: r'fetchJumbledWordsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchJumbledWordsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchJumbledWordsRef = AutoDisposeFutureProviderRef<List<JumbleWord>>;
String _$gameControllerHash() => r'18b6f7cd06a22e42d67f33d7c926433a88e9ba65';

/// See also [GameController].
@ProviderFor(GameController)
final gameControllerProvider =
    AutoDisposeNotifierProvider<GameController, GameState>.internal(
  GameController.new,
  name: r'gameControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gameControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GameController = AutoDisposeNotifier<GameState>;
String _$leaderboardControllerHash() =>
    r'16bee3ba9b22b44dee295d25625df2bfc17b48bf';

/// See also [LeaderboardController].
@ProviderFor(LeaderboardController)
final leaderboardControllerProvider =
    AutoDisposeNotifierProvider<LeaderboardController, Leaderboard>.internal(
  LeaderboardController.new,
  name: r'leaderboardControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$leaderboardControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LeaderboardController = AutoDisposeNotifier<Leaderboard>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
