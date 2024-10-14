// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchJumbledWordsHash() => r'48080d8a10b882d1122f4980348f6658609d198b';

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
String _$gameControllerHash() => r'0286bc2a359ccdba530b7067e3914a8e8112b3b6';

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
    r'066773feca09a7352cbc79c5b24f700c13917d08';

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
