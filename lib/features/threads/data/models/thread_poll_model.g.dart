// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_poll_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ThreadPollModelCWProxy {
  ThreadPollModel id(int? id);

  ThreadPollModel isPublic(bool? isPublic);

  ThreadPollModel question(String? question);

  ThreadPollModel endDate(dynamic endDate);

  ThreadPollModel createdAt(DateTime? createdAt);

  ThreadPollModel updatedAt(DateTime? updatedAt);

  ThreadPollModel options(List<ThreadPollOptionModel>? options);

  ThreadPollModel totalVotes(int? totalVotes);

  ThreadPollModel voters(List<UserModel>? voters);

  ThreadPollModel vote(ThreadPollVoteModel? vote);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThreadPollModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThreadPollModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ThreadPollModel call({
    int? id,
    bool? isPublic,
    String? question,
    dynamic endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ThreadPollOptionModel>? options,
    int? totalVotes,
    List<UserModel>? voters,
    ThreadPollVoteModel? vote,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfThreadPollModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfThreadPollModel.copyWith.fieldName(...)`
class _$ThreadPollModelCWProxyImpl implements _$ThreadPollModelCWProxy {
  const _$ThreadPollModelCWProxyImpl(this._value);

  final ThreadPollModel _value;

  @override
  ThreadPollModel id(int? id) => this(id: id);

  @override
  ThreadPollModel isPublic(bool? isPublic) => this(isPublic: isPublic);

  @override
  ThreadPollModel question(String? question) => this(question: question);

  @override
  ThreadPollModel endDate(dynamic endDate) => this(endDate: endDate);

  @override
  ThreadPollModel createdAt(DateTime? createdAt) => this(createdAt: createdAt);

  @override
  ThreadPollModel updatedAt(DateTime? updatedAt) => this(updatedAt: updatedAt);

  @override
  ThreadPollModel options(List<ThreadPollOptionModel>? options) =>
      this(options: options);

  @override
  ThreadPollModel totalVotes(int? totalVotes) => this(totalVotes: totalVotes);

  @override
  ThreadPollModel voters(List<UserModel>? voters) => this(voters: voters);

  @override
  ThreadPollModel vote(ThreadPollVoteModel? vote) => this(vote: vote);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThreadPollModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThreadPollModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ThreadPollModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? isPublic = const $CopyWithPlaceholder(),
    Object? question = const $CopyWithPlaceholder(),
    Object? endDate = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? options = const $CopyWithPlaceholder(),
    Object? totalVotes = const $CopyWithPlaceholder(),
    Object? voters = const $CopyWithPlaceholder(),
    Object? vote = const $CopyWithPlaceholder(),
  }) {
    return ThreadPollModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      isPublic: isPublic == const $CopyWithPlaceholder()
          ? _value.isPublic
          // ignore: cast_nullable_to_non_nullable
          : isPublic as bool?,
      question: question == const $CopyWithPlaceholder()
          ? _value.question
          // ignore: cast_nullable_to_non_nullable
          : question as String?,
      endDate: endDate == const $CopyWithPlaceholder() || endDate == null
          ? _value.endDate
          // ignore: cast_nullable_to_non_nullable
          : endDate as dynamic,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
      options: options == const $CopyWithPlaceholder()
          ? _value.options
          // ignore: cast_nullable_to_non_nullable
          : options as List<ThreadPollOptionModel>?,
      totalVotes: totalVotes == const $CopyWithPlaceholder()
          ? _value.totalVotes
          // ignore: cast_nullable_to_non_nullable
          : totalVotes as int?,
      voters: voters == const $CopyWithPlaceholder()
          ? _value.voters
          // ignore: cast_nullable_to_non_nullable
          : voters as List<UserModel>?,
      vote: vote == const $CopyWithPlaceholder()
          ? _value.vote
          // ignore: cast_nullable_to_non_nullable
          : vote as ThreadPollVoteModel?,
    );
  }
}

extension $ThreadPollModelCopyWith on ThreadPollModel {
  /// Returns a callable class that can be used as follows: `instanceOfThreadPollModel.copyWith(...)` or like so:`instanceOfThreadPollModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ThreadPollModelCWProxy get copyWith => _$ThreadPollModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadPollModel _$ThreadPollModelFromJson(Map<String, dynamic> json) =>
    ThreadPollModel(
      id: json['id'] as int?,
      isPublic: json['isPublic'] as bool?,
      question: json['question'] as String?,
      endDate: json['endDate'],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      options: (json['options'] as List<dynamic>?)
          ?.map(
              (e) => ThreadPollOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalVotes: json['totalVotes'] as int?,
      voters: (json['voters'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      vote: json['vote'] == null
          ? null
          : ThreadPollVoteModel.fromJson(json['vote'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ThreadPollModelToJson(ThreadPollModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('isPublic', instance.isPublic);
  writeNotNull('question', instance.question);
  writeNotNull('endDate', instance.endDate);
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  writeNotNull('updatedAt', instance.updatedAt?.toIso8601String());
  writeNotNull('options', instance.options?.map((e) => e.toJson()).toList());
  writeNotNull('totalVotes', instance.totalVotes);
  writeNotNull('voters', instance.voters?.map((e) => e.toJson()).toList());
  writeNotNull('vote', instance.vote?.toJson());
  return val;
}
