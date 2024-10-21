// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_poll_vote_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ThreadPollVoteModelCWProxy {
  ThreadPollVoteModel userId(int? userId);

  ThreadPollVoteModel optionId(int? optionId);

  ThreadPollVoteModel pollId(int? pollId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThreadPollVoteModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThreadPollVoteModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ThreadPollVoteModel call({
    int? userId,
    int? optionId,
    int? pollId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfThreadPollVoteModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfThreadPollVoteModel.copyWith.fieldName(...)`
class _$ThreadPollVoteModelCWProxyImpl implements _$ThreadPollVoteModelCWProxy {
  const _$ThreadPollVoteModelCWProxyImpl(this._value);

  final ThreadPollVoteModel _value;

  @override
  ThreadPollVoteModel userId(int? userId) => this(userId: userId);

  @override
  ThreadPollVoteModel optionId(int? optionId) => this(optionId: optionId);

  @override
  ThreadPollVoteModel pollId(int? pollId) => this(pollId: pollId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThreadPollVoteModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThreadPollVoteModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ThreadPollVoteModel call({
    Object? userId = const $CopyWithPlaceholder(),
    Object? optionId = const $CopyWithPlaceholder(),
    Object? pollId = const $CopyWithPlaceholder(),
  }) {
    return ThreadPollVoteModel(
      userId: userId == const $CopyWithPlaceholder()
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as int?,
      optionId: optionId == const $CopyWithPlaceholder()
          ? _value.optionId
          // ignore: cast_nullable_to_non_nullable
          : optionId as int?,
      pollId: pollId == const $CopyWithPlaceholder()
          ? _value.pollId
          // ignore: cast_nullable_to_non_nullable
          : pollId as int?,
    );
  }
}

extension $ThreadPollVoteModelCopyWith on ThreadPollVoteModel {
  /// Returns a callable class that can be used as follows: `instanceOfThreadPollVoteModel.copyWith(...)` or like so:`instanceOfThreadPollVoteModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ThreadPollVoteModelCWProxy get copyWith =>
      _$ThreadPollVoteModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadPollVoteModel _$ThreadPollVoteModelFromJson(Map<String, dynamic> json) =>
    ThreadPollVoteModel(
      userId: json['userId'] as int?,
      optionId: json['optionId'] as int?,
      pollId: json['pollId'] as int?,
    );

Map<String, dynamic> _$ThreadPollVoteModelToJson(
        ThreadPollVoteModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'optionId': instance.optionId,
      'pollId': instance.pollId,
    };
