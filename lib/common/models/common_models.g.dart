// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

_$JumbleWordImpl _$$JumbleWordImplFromJson(Map<String, dynamic> json) =>
    _$JumbleWordImpl(
      originalWord: json['originalWord'] as String,
      hint: json['hint'] as String?,
    );

Map<String, dynamic> _$$JumbleWordImplToJson(_$JumbleWordImpl instance) =>
    <String, dynamic>{
      'originalWord': instance.originalWord,
      'hint': instance.hint,
    };

_$GameStateImpl _$$GameStateImplFromJson(Map<String, dynamic> json) =>
    _$GameStateImpl(
      player: User.fromJson(json['player'] as Map<String, dynamic>),
      score: (json['score'] as num).toInt(),
      questions: (json['questions'] as List<dynamic>)
          .map((e) => JumbleWord.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentQuestionIndex: (json['currentQuestionIndex'] as num).toInt(),
    );

Map<String, dynamic> _$$GameStateImplToJson(_$GameStateImpl instance) =>
    <String, dynamic>{
      'player': instance.player,
      'score': instance.score,
      'questions': instance.questions,
      'currentQuestionIndex': instance.currentQuestionIndex,
    };

_$LeaderboardEntryImpl _$$LeaderboardEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$LeaderboardEntryImpl(
      userName: json['userName'] as String,
      score: (json['score'] as num).toInt(),
    );

Map<String, dynamic> _$$LeaderboardEntryImplToJson(
        _$LeaderboardEntryImpl instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'score': instance.score,
    };

_$LeaderboardImpl _$$LeaderboardImplFromJson(Map<String, dynamic> json) =>
    _$LeaderboardImpl(
      entries: (json['entries'] as List<dynamic>)
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LeaderboardImplToJson(_$LeaderboardImpl instance) =>
    <String, dynamic>{
      'entries': instance.entries,
    };
